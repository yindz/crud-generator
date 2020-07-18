package ${table.pkgName};

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.google.common.base.Preconditions;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.BeanUtils;
import org.springframework.util.ReflectionUtils;
<#if useDubboServiceAnnotation = 1>import org.apache.dubbo.config.annotation.Service;<#else>import org.springframework.stereotype.Service;</#if>

import tk.mybatis.mapper.entity.Example;

import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.dto.${table.javaClassName}QueryDTO;
import ${basePkgName}.domain.${table.javaClassName}DO;
import ${basePkgName}.service.I${table.javaClassName}Service;
import ${basePkgName}.dao.${table.javaClassName}CommonMapper;
import ${basePkgName}.util.${table.javaClassName}Converter;
<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>

/**
 * ${table.comments}服务接口实现
 * 使用mybatis通用mapper
 *
 * @author ${table.author!''}
 */
<#if useDubboServiceAnnotation = 1>@Service(
    version = "${r"${"}dubbo.service.version}",
    application = "${r"${"}dubbo.application.id}",
    protocol = "${r"${"}dubbo.protocol.id}",
    registry = "${r"${"}dubbo.registry.id}",
    provider = "${r"${"}dubbo.provider.id}"
)
<#else>@Service
</#if>
public class ${table.javaClassName}ServiceImpl implements I${table.javaClassName}Service {
    private static final Logger logger = LoggerFactory.getLogger(${table.javaClassName}ServiceImpl.class);

    private static final Map<String, Field> fieldMap = new ConcurrentHashMap<>();

    @Autowired
    private ${table.javaClassName}CommonMapper ${table.javaClassNameLower}Mapper;

    /**
    * 分页查询
    *
    * @param query           查询条件
    * @return 分页查询结果
    */
    @Override
    public PageInfo<${table.javaClassName}DTO> get${table.javaClassName}List(${table.javaClassName}QueryDTO query) {
        Preconditions.checkArgument(query != null, "查询条件为空");
        Preconditions.checkArgument(query.getPageNo() != null && query.getPageNo() > 0, "页码必须大于0");
        Preconditions.checkArgument(query.getPageSize() != null && query.getPageSize() > 0, "分页大小必须大于0");

        Example example = new Example(${table.javaClassName}DO.class);
        Example.Criteria criteria = example.createCriteria();
    <#list table.columns as column>
        if (query.get${column.columnCamelNameUpper}() != null) {
            criteria.andEqualTo("${column.columnCamelNameLower}", query.get${column.columnCamelNameUpper}());
        }
    </#list>
        Field orderField = findField(query.getOrderBy());
        if (orderField == null) {
            //默认使用主键(唯一索引字段)排序
        <#if pk??>    query.setOrderBy("${pk.columnCamelNameLower}");</#if>
        }
        if ("asc".equalsIgnoreCase(query.getOrderDirection())) {
            example.orderBy(query.getOrderBy()).asc();
        } else {
            example.orderBy(query.getOrderBy()).desc();
        }

        PageHelper.startPage(query.getPageNo(), query.getPageSize());
        PageInfo<${table.javaClassName}DO> pageInfo = new PageInfo<>(${table.javaClassNameLower}Mapper.selectByExample(example));
        PageInfo<${table.javaClassName}DTO> result = new PageInfo<>();
        List<${table.javaClassName}DTO> dtoList = new ArrayList<>();
        if (pageInfo.getList() != null && !pageInfo.getList().isEmpty()) {
            pageInfo.getList().forEach(e -> {
                if (e == null) {
                    return;
                }
                dtoList.add(${table.javaClassName}Converter.domainToDTO(e));
            });
        }
        BeanUtils.copyProperties(pageInfo, result);
        result.setList(dtoList);
        return result;
    }

    /**
     * 插入记录
     *
     * @param record    待插入的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insert(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待插入的数据为空");
        ${table.javaClassName}DO cond = ${table.javaClassName}Converter.dtoToDomain(record);
        return ${table.javaClassNameLower}Mapper.insertSelective(cond) > 0;
    }

    /**
     * 批量插入记录
     *
     * @param recordList    待插入的数据列表
     * @return 是否成功
     */
     @Override
     @Transactional(rollbackFor = Exception.class)
     public boolean insertAll(List<${table.javaClassName}DTO> recordList) {
         Preconditions.checkArgument(recordList != null && !recordList.isEmpty(), "待插入的数据为空");
         int success = 0;
         for (${table.javaClassName}DTO record : recordList) {
             if (record == null) {
                continue;
             }
             if (${table.javaClassNameLower}Mapper.insertSelective(${table.javaClassName}Converter.dtoToDomain(record)) == 0) {
                 throw new RuntimeException("插入${table.comments}数据失败!");
             }
             success++;
         }
         logger.info("本次总共提交{}条${table.comments}数据，已成功插入{}条", recordList.size(), success);
         return true;
    }

    /**
     * 更新记录
     *
     * @param record    待更新的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待更新的数据为空");
        <#if pk??>Preconditions.checkArgument(record.get${pk.columnCamelNameUpper}() != null, "待更新的数据${pk.columnCamelNameLower}为空");</#if>
        ${table.javaClassName}DO cond = ${table.javaClassName}Converter.dtoToDomain(record);
        return ${table.javaClassNameLower}Mapper.updateByPrimaryKeySelective(cond) > 0;
    }

    /**
     * 删除记录
     *
     * @param record    待删除的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean delete(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待删除的数据为空");
        <#if pk??>Preconditions.checkArgument(record.get${pk.columnCamelNameUpper}() != null, "待删除的数据${pk.columnCamelNameLower}为空");</#if>
        ${table.javaClassName}DO cond = ${table.javaClassName}Converter.dtoToDomain(record);
        return ${table.javaClassNameLower}Mapper.deleteByPrimaryKey(cond) > 0;
    }

    private Field findField(String name){
        if (name == null) {
           return null;
        }
        return fieldMap.computeIfAbsent(name, k-> ReflectionUtils.findField(${table.javaClassName}DO.class, k));
    }
}