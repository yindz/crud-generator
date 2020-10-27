package ${table.pkgName};

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.cglib.beans.BeanCopier;
import org.springframework.beans.BeanUtils;

import com.github.pagehelper.PageInfo;

/**
 * 通用对象转换工具
 *
 * @author ${table.author!''}
 */
public class CommonConverter {

    private static final Map<String, BeanCopier> beanCopierMap = new ConcurrentHashMap<>();

    public static final String ASC = "ASC";
    public static final String DESC = "DESC";

    /**
     * 对象转换
     *
     * @param src     源对象
     * @param target  目标类
     * @param <S>     源类泛型
     * @param <T>     目标类泛型
     * @return  转换后对象
     */
    public static <S, T> T convert(S src, Class<T> target){
        if(src == null || target == null) {
            throw new IllegalArgumentException("待转换的类型为空");
        }
        BeanCopier bc = getBeanCopier(src.getClass(), target);
        try {
            T result = target.newInstance();
            bc.copy(src, result, null);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    /**
     * PageInfo对象转换
     *
     * @param src     源对象
     * @param target  目标类
     * @param <S>     源类泛型
     * @param <T>     目标类泛型
     * @return  转换后PageInfo对象
     */
    public static <S, T> PageInfo<T> convertPageInfo(PageInfo<S> src, Class<T> target) {
         if (src == null || target == null) {
             throw new IllegalArgumentException("待转换的类型为空");
         }
         PageInfo<T> b = new PageInfo<>();
         b.setTotal(src.getTotal());
         b.setPageNum(src.getPageNum());
         b.setPageSize(src.getPageSize());
         b.setPages(src.getPages());
         b.setSize(src.getSize());
         b.setStartRow(src.getStartRow());
         b.setEndRow(src.getEndRow());
         b.setIsFirstPage(src.isIsFirstPage());
         b.setIsLastPage(src.isIsLastPage());
         b.setHasNextPage(src.isHasNextPage());
         b.setHasPreviousPage(src.isHasPreviousPage());
         b.setPrePage(src.getPrePage());
         b.setNextPage(src.getNextPage());
         b.setNavigateFirstPage(src.getNavigateFirstPage());
         b.setNavigateLastPage(src.getNavigateLastPage());
         b.setNavigatepageNums(src.getNavigatepageNums());
         b.setNavigatePages(src.getNavigatePages());
         if (src.getList() != null && !src.getList().isEmpty()) {
             List<T> list = new ArrayList<>();
             src.getList().forEach(e -> {
                 if (e == null) {
                     return;
                 }
                 list.add(convert(e, target));
             });
             b.setList(list);
         }
         return b;
    }

    /**
     * 获取排序方向
     *
     * @param orderDirection 调用者传入的排序方向
     * @return 排序方向(ASC/DESC)
     */
    public static String getOrderDirection(String orderDirection) {
        return ASC.equalsIgnoreCase(orderDirection) ? ASC : DESC;
    }

    /**
     * 读取JavaBean属性值填充到map
     *
     * @param bean             待转换的JavaBean
     * @param map              待填充的map
     * @param ignoreFields     需忽略的字段名
     * @return
    */
    public static void valuesToMap(Object bean, Map<String, Object> map, Set<String> ignoreFields) {
        if (bean == null || map == null) {
            return;
        }
        PropertyDescriptor[] ps = BeanUtils.getPropertyDescriptors(bean.getClass());
        Arrays.stream(ps).forEach(p -> {
            if (p == null) {
                return;
            }
            String key = p.getName();
            if (!"class".equals(key)) {
                Method getter = p.getReadMethod();
                Object value;
                try {
                    value = getter.invoke(bean);
                    if (ignoreFields != null && !ignoreFields.contains(key)) {
                        if (value != null) {
                            map.put(key, value);
                        }
                    }
                } catch (IllegalAccessException | InvocationTargetException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private static BeanCopier getBeanCopier(Class source, Class target) {
        if (source == null || target == null) {
            throw new IllegalArgumentException("待转换的类型为空");
        }
        return beanCopierMap.computeIfAbsent(source.getName() + "/" + target.getName(), k -> BeanCopier.create(source, target, false));
    }
}