package ${table.pkgName};

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ${basePkgName}.vo.${table.javaClassName}VO;
import ${basePkgName}.vo.${table.javaClassName}QueryVO;
import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.dto.${table.javaClassName}QueryDTO;
import ${basePkgName}.service.I${table.javaClassName}Service;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * ${table.comments}API接口
 *
 * @author ${table.author!''}
 */
@Api(tags = {"${table.comments}API"})
@RequestMapping("/${table.javaClassNameLower}")
@RestController
public class ${table.javaClassName}Controller {
    private static final Logger logger = LoggerFactory.getLogger(${table.javaClassName}Controller.class);

    @Autowired
    private I${table.javaClassName}Service ${table.javaClassNameLower}Service;

    /**
     * 分页查询${table.comments}数据
     *
     * @param query           查询条件
     * @return 分页查询结果
     */
    @ApiOperation(value = "分页查询${table.comments}数据", httpMethod = "GET",tags = {"分页查询${table.comments}数据"})
    @GetMapping(value = "/get${table.javaClassName}List")
    public PageInfo<${table.javaClassName}VO> get${table.javaClassName}List(${table.javaClassName}QueryVO query) {
        PageInfo<${table.javaClassName}DTO> pageInfo = ${table.javaClassNameLower}Service.get${table.javaClassName}List(convertTo${table.javaClassName}QueryDTO(query));
        PageInfo<${table.javaClassName}VO> result = new PageInfo<>();
        List<${table.javaClassName}VO> rowList = new ArrayList<>();
        if (pageInfo.getList() != null && !pageInfo.getList().isEmpty()) {
            pageInfo.getList().forEach(e->{
                if (e == null) {
                   return;
                }
                ${table.javaClassName}VO row = new ${table.javaClassName}VO();
                BeanUtils.copyProperties(e, row);
                rowList.add(row);
            });
        }
        BeanUtils.copyProperties(pageInfo, result);
        result.setList(rowList);
        return result;
    }

    /**
     * 插入${table.comments}记录
     *
     * @param vo    待插入的数据
     * @return 是否成功
     */
    @ApiOperation(value = "插入${table.comments}记录", httpMethod = "POST",tags = {"插入${table.comments}记录"})
    @PostMapping(value = "/insert")
    public boolean insert(@RequestBody @Valid ${table.javaClassName}VO vo) {
        return ${table.javaClassNameLower}Service.insert(convertTo${table.javaClassName}DTO(vo));
    }

    /**
     * 更新${table.comments}记录
     *
     * @param vo    待更新的数据
     * @return 是否成功
    */
    @ApiOperation(value = "更新${table.comments}记录", httpMethod = "POST", tags = {"更新${table.comments}记录"})
    @PostMapping(value = "/update")
    public boolean update(@RequestBody ${table.javaClassName}VO vo) {
        return ${table.javaClassNameLower}Service.update(convertTo${table.javaClassName}DTO(vo));
    }

    /**
     * 删除${table.comments}记录
     *
     * @param vo    待删除的数据
     * @return 是否成功
     */
    @ApiOperation(value = "删除${table.comments}记录", httpMethod = "POST", tags = {"删除${table.comments}记录"})
    @PostMapping(value = "/delete")
    public boolean delete(@RequestBody ${table.javaClassName}VO vo) {
        return ${table.javaClassNameLower}Service.delete(convertTo${table.javaClassName}DTO(vo));
    }


    private ${table.javaClassName}QueryDTO convertTo${table.javaClassName}QueryDTO(${table.javaClassName}QueryVO vo) {
        if (vo == null) {
            return null;
        }
        ${table.javaClassName}QueryDTO dto = new ${table.javaClassName}QueryDTO();
        BeanUtils.copyProperties(vo, dto);
        return dto;
    }

    private ${table.javaClassName}DTO convertTo${table.javaClassName}DTO(${table.javaClassName}VO vo) {
         if (vo == null) {
             return null;
         }
         ${table.javaClassName}DTO dto = new ${table.javaClassName}DTO();
         BeanUtils.copyProperties(vo, dto);
         return dto;
    }
}