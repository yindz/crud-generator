package ${table.pkgName};

import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.cglib.beans.BeanCopier;
import org.springframework.util.ReflectionUtils;
import org.springframework.beans.BeanUtils;

import com.github.pagehelper.PageInfo;
import com.google.common.base.CaseFormat;

/**
 * 通用对象转换工具
 *
 * @author ${table.author!''}
 */
public class CommonConverter {

    private static final Map<String, BeanCopier> beanCopierMap = new ConcurrentHashMap<>();
    private static final Map<String, Field> fieldMap = new ConcurrentHashMap<>();
    private static final Map<String, String> fieldToColumnMap = new ConcurrentHashMap<>();

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
            return null;
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
            return null;
         }
         List<T> list = new ArrayList<>();
         if (src.getList() != null && !src.getList().isEmpty()) {
            src.getList().forEach(e -> {
                if (e == null) {
                    return;
                }
                list.add(convert(e, target));
            });
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
         b.setList(list);
         return b;
    }

    /**
     * 获取排序字段名
     *
     * @param target    类
     * @param fieldName 排序属性名
     * @return 排序字段名
     */
    public static String getOrderColumn(Class target, String fieldName) {
         if (target == null || fieldName == null) {
             return null;
         }
         Field field = findField(target, fieldName);
         if (field == null) {
            return null;
         }
         return fieldToColumnMap.computeIfAbsent(target.getName() + "/" + fieldName, k -> CaseFormat.LOWER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, k));
    }

    /**
     * 获取类属性
     *
     * @param target  类
     * @param name    属性名
     * @return 类属性
     */
    public static Field findField(Class target, String name) {
        if (target == null || name == null) {
            return null;
        }
        return fieldMap.computeIfAbsent(target.getName() + "/" + name, k-> ReflectionUtils.findField(target, k));
    }

    /**
     * 判断类属性是否存在
     *
     * @param target  类
     * @param name    属性名
     * @return 类属性是否存在
     */
    public static boolean isFieldExists(Class target, String name) {
         return findField(target, name) != null;
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
        return beanCopierMap.computeIfAbsent(source.getName() + "/" + target.getName(), k -> BeanCopier.create(source, target, false));
    }
}