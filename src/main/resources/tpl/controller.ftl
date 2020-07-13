package ${table.pkgName};

import com.foobar.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import ${basePkgName}.vo.${table.javaClassName}VO;
import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.service.I${table.javaClassName}Service;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * ${table.comments}服务API接口
 *
 * @author ${table.author!''}
 */
@Api(tags = {"${table.comments}服务API"})
@RequestMapping("/${table.javaClassNameLower}")
@RestController
public class ${table.javaClassName}Api {
    private static final Logger logger = LoggerFactory.getLogger(${table.javaClassName}Api.class);

    @Autowired
    private I${table.javaClassName}Service ${table.javaClassNameLower}Service;

    /**
     * 分页查询${table.comments}数据
     *
     * @param query    查询条件
     * @param pageNo   页码
     * @param pageSize 分页大小
     * @return 分页查询结果
     */
    @ApiOperation(value = "分页查询${table.comments}数据", httpMethod = "GET",tags = {"分页查询${table.comments}数据"})
    @GetMapping(value = "/get${table.javaClassName}List")
    public PageInfo<${table.javaClassName}DTO> get${table.javaClassName}List(${table.javaClassName}VO query, int pageNo, int pageSize) {
        return ${table.javaClassNameLower}Service.get${table.javaClassName}List(convertTo${table.javaClassName}DTO(query), pageNo, pageSize, null, null);
    }

    /**
     * 插入${table.comments}记录
     *
     * @param vo    待插入的数据
     * @return 是否成功
     */
    @ApiOperation(value = "插入${table.comments}记录", httpMethod = "POST",tags = {"插入${table.comments}记录"})
    @PostMapping(value = "/insert")
    public boolean insert(${table.javaClassName}VO vo) {
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
    public boolean update(${table.javaClassName}VO vo) {
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
    public boolean delete(${table.javaClassName}VO vo) {
        return ${table.javaClassNameLower}Service.delete(convertTo${table.javaClassName}DTO(vo));
    }

    /**
     * 转换
     *
     * @param vo   待转换数据
     * @return 转换结果
     */
    private ${table.javaClassName}DTO convertTo${table.javaClassName}DTO(${table.javaClassName}VO vo) {
        if (vo == null) {
            return null;
        }
        ${table.javaClassName}DTO dto = new ${table.javaClassName}DTO();
        BeanUtils.copyProperties(vo, dto);
        return dto;
    }
}