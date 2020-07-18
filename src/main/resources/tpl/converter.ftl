package ${table.pkgName};

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.cglib.beans.BeanCopier;

import com.github.pagehelper.PageInfo;

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

    //VO转DTO
    public static ${table.javaClassName}QueryDTO voToQueryDTO(${table.javaClassName}QueryVO src) {
        if(src == null) {
            return null;
        }
        BeanCopier bc = getBeanCopier(${table.javaClassName}QueryVO.class, ${table.javaClassName}QueryDTO.class);
        ${table.javaClassName}QueryDTO result = new ${table.javaClassName}QueryDTO();
        bc.copy(src, result, null);
        return result;
    }

    //VO转DTO
    public static ${table.javaClassName}DTO voToDTO(${table.javaClassName}VO src) {
        if(src == null) {
            return null;
        }
        BeanCopier bc = getBeanCopier(${table.javaClassName}VO.class, ${table.javaClassName}DTO.class);
        ${table.javaClassName}DTO result = new ${table.javaClassName}DTO();
        bc.copy(src, result, null);
        return result;
    }

    //DTO转VO
    public static ${table.javaClassName}VO dtoToVO(${table.javaClassName}DTO src) {
        if(src == null) {
            return null;
        }
        BeanCopier bc = getBeanCopier(${table.javaClassName}DTO.class, ${table.javaClassName}VO.class);
        ${table.javaClassName}VO result = new ${table.javaClassName}VO();
        bc.copy(src, result, null);
        return result;
    }

    //PageInfo转换
    public static PageInfo<${table.javaClassName}VO> convertPageInfo(PageInfo<${table.javaClassName}DTO> pageInfo) {
        PageInfo<${table.javaClassName}VO> result = new PageInfo<>();
        getBeanCopier(PageInfo.class, PageInfo.class).copy(pageInfo, result, null);
        List<${table.javaClassName}VO> voList = new ArrayList<>();
        if (pageInfo != null && pageInfo.getList() != null && !pageInfo.getList().isEmpty()) {
            pageInfo.getList().forEach(e -> {
                if (e == null) {
                    return;
                }
                voList.add(dtoToVO(e));
            });
        }
        result.setList(voList);
        return result;
    }

    //DTO转DO
    public static ${table.javaClassName}DO dtoToDomain(${table.javaClassName}DTO src) {
        if(src == null) {
            return null;
        }
        BeanCopier bc = getBeanCopier(${table.javaClassName}DTO.class, ${table.javaClassName}DO.class);
        ${table.javaClassName}DO result = new ${table.javaClassName}DO();
        bc.copy(src, result, null);
        return result;
    }

    //DO转DTO
    public static ${table.javaClassName}DTO domainToDTO(${table.javaClassName}DO src) {
        if(src == null) {
            return null;
        }
        BeanCopier bc = getBeanCopier(${table.javaClassName}DO.class, ${table.javaClassName}DTO.class);
        ${table.javaClassName}DTO result = new ${table.javaClassName}DTO();
        bc.copy(src, result, null);
        return result;
    }

    private static BeanCopier getBeanCopier(Class source, Class target) {
        return beanCopierMap.computeIfAbsent(source.getName() + "/" + target.getName(), k -> BeanCopier.create(source, target, false));
    }
}