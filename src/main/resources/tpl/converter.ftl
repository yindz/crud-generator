package ${table.pkgName};

import java.util.Map;
import java.util.HashMap;

import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;

import ${basePkgName}.util.CommonConverter;
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
public class ${table.javaClassName}Converter extends CommonConverter {

    //属性名->字段名
    private static final Map<String, String> fieldNameMap = new HashMap<>();
    static {
<#list table.columns as column>
        fieldNameMap.put("${column.columnCamelNameLower}", "${column.columnName}");
</#list>
    }

    /**
     * 判断属性名是否存在
     *
     * @param fieldName 属性名
     * @return 是否存在
     */
    public static boolean isFieldExists(String fieldName) {
        if (StringUtils.isBlank(fieldName)) {
            return false;
        }
        return fieldNameMap.containsKey(fieldName);
    }

    /**
     * 获取排序字段名
     *
     * @param fieldName 排序属性名
     * @return 排序字段名
     */
    public static String getOrderColumn(String fieldName) {
        if (!isFieldExists(fieldName)) {
            return null;
        }
        return fieldNameMap.get(fieldName);
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

    //DTO转DO
    public static ${table.javaClassName}DO dtoToDomain(${table.javaClassName}DTO src) {
        return convert(src, ${table.javaClassName}DO.class);
    }

    //DO转DTO
    public static ${table.javaClassName}DTO domainToDTO(${table.javaClassName}DO src) {
        return convert(src, ${table.javaClassName}DTO.class);
    }
}