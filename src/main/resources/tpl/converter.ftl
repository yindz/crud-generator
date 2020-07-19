package ${table.pkgName};

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.cglib.beans.BeanCopier;
import org.springframework.util.ReflectionUtils;

import com.github.pagehelper.PageInfo;
import com.google.common.base.CaseFormat;

import ${basePkgName}.vo.${table.javaClassName}VO;
import ${basePkgName}.vo.${table.javaClassName}QueryVO;
import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.dto.${table.javaClassName}QueryDTO;
import ${basePkgName}.domain.${table.javaClassName}DO;

/**
 * ${table.comments}对象转换工具
 *
 * @author ${table.author!''}
 */
public class ${table.javaClassName}Converter {

    private static final Map<String, BeanCopier> beanCopierMap = new ConcurrentHashMap<>();
    private static final Map<String, Field> fieldMap = new ConcurrentHashMap<>();
    private static final Map<String, String> fieldToColumnMap = new ConcurrentHashMap<>();

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

    //VO转DTO
    public static ${table.javaClassName}QueryDTO voToQueryDTO(${table.javaClassName}QueryVO src) {
        return convert(src, ${table.javaClassName}QueryDTO.class);
    }

    //VO转DTO
    public static ${table.javaClassName}DTO voToDTO(${table.javaClassName}VO src) {
        return convert(src, ${table.javaClassName}DTO.class);
    }

    //DTO转VO
    public static ${table.javaClassName}VO dtoToVO(${table.javaClassName}DTO src) {
        return convert(src, ${table.javaClassName}VO.class);
    }

    //PageInfo转换
    public static PageInfo<${table.javaClassName}VO> toVOPageInfo(PageInfo<${table.javaClassName}DTO> pageInfo) {
        return convertPageInfo(pageInfo, ${table.javaClassName}VO.class);
    }

    //PageInfo转换
    public static PageInfo<${table.javaClassName}DTO> toDTOPageInfo(PageInfo<${table.javaClassName}DO> pageInfo) {
         return convertPageInfo(pageInfo, ${table.javaClassName}DTO.class);
    }

    public static <S, T> PageInfo<T> convertPageInfo(PageInfo<S> src, Class<T> target) {
         if (src == null || target == null) {
            return null;
         }
         PageInfo<T> result = new PageInfo<>();
         List<T> list = new ArrayList<>();
         if (src.getList() != null && !src.getList().isEmpty()) {
            src.getList().forEach(e -> {
                if (e == null) {
                    return;
                }
                list.add(convert(e, target));
            });
         }
         getBeanCopier(PageInfo.class, PageInfo.class).copy(src, result, null);
         result.setList(list);
         return result;
    }

    //DTO转DO
    public static ${table.javaClassName}DO dtoToDomain(${table.javaClassName}DTO src) {
        return convert(src, ${table.javaClassName}DO.class);
    }

    //DO转DTO
    public static ${table.javaClassName}DTO domainToDTO(${table.javaClassName}DO src) {
        return convert(src, ${table.javaClassName}DTO.class);
    }

    //获取排序字段名
    public static String getOrderColumn(String fieldName) {
         if (fieldName == null) {
             return null;
         }
         Field field = findField(fieldName);
         if (field == null) {
            return null;
         }
         return fieldToColumnMap.computeIfAbsent(fieldName, k -> CaseFormat.LOWER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, k));
    }

    //获取属性
    public static Field findField(String name) {
        if (name == null) {
            return null;
        }
        return fieldMap.computeIfAbsent(name, k-> ReflectionUtils.findField(${table.javaClassName}DO.class, k));
    }

    //判断属性是否存在
    public static boolean isFieldExists(String name) {
         return findField(name) != null;
    }

    private static BeanCopier getBeanCopier(Class source, Class target) {
        return beanCopierMap.computeIfAbsent(source.getName() + "/" + target.getName(), k -> BeanCopier.create(source, target, false));
    }
}