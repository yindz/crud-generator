package ${table.pkgName};

import com.github.pagehelper.PageInfo;

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