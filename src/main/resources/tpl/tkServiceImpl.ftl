package ${table.pkgName};

import java.util.List;

import com.google.common.base.Preconditions;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import org.apache.commons.lang3.StringUtils;

<#if useDubboServiceAnnotation = 1>import org.apache.dubbo.config.annotation.Service;<#else>import org.springframework.stereotype.Service;</#if>

import tk.mybatis.mapper.entity.Example;

import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.dto.${table.javaClassName}QueryDTO;
import ${basePkgName}.domain.${table.javaClassName}DO;
import ${basePkgName}.service.I${table.javaClassName}Service;
import ${basePkgName}.dao.${table.javaClassName}CommonMapper;
import ${basePkgName}.util.${table.javaClassName}Converter;
<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
<#if table.versionColumn??><#list table.columns as column><#if table.versionColumn == column.columnName><#assign versionColumn = column></#if></#list></#if>

/**
 * ${table.comments}服务接口实现
 * 使用mybatis通用mapper
 *
 * @author ${table.author!''}
 */
<#if useDubboServiceAnnotation = 1><#include "./public/dubboServiceAnnotation.ftl"/>
<#else>@Service
</#if>
public class ${table.javaClassName}ServiceImpl implements I${table.javaClassName}Service {
    private static final Logger logger = LoggerFactory.getLogger(${table.javaClassName}ServiceImpl.class);

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
        if (<#if column.isChar == 1>StringUtils.isNotEmpty(query.get${column.columnCamelNameUpper}())<#else >query.get${column.columnCamelNameUpper}() != null</#if>) {
            criteria.andEqualTo("${column.columnCamelNameLower}", query.get${column.columnCamelNameUpper}());
        }
    </#list>
        if (!${table.javaClassName}Converter.isFieldExists(${table.javaClassName}DO.class, query.getOrderBy())) {
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
        return ${table.javaClassName}Converter.toDTOPageInfo(pageInfo);
    }

    <#if pk??>
    /**
     * 根据主键查询
     *
     * @param ${pk.columnCamelNameLower}    主键值
     * @return 查询结果
     */
    @Override
    public ${table.javaClassName}DTO get${table.javaClassName}(${pk.columnJavaType} ${pk.columnCamelNameLower}) {
        if (${pk.columnCamelNameLower} == null) {
            throw new IllegalArgumentException("${pk.columnCamelNameLower}为空!");
        }
        ${table.javaClassName}DO cond = new ${table.javaClassName}DO();
        cond.set${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
        List<${table.javaClassName}DO> list = ${table.javaClassNameLower}Mapper.selectByPrimaryKey(cond);
        if (list != null && !list.isEmpty()) {
            return ${table.javaClassName}Converter.domainToDTO(list.get(0));
        } else {
            return null;
        }
    }</#if>

    /**
     * 插入记录
     *
     * @param record    待插入的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insert(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待插入的数据为空"); <#if versionColumn??>
        record.set${versionColumn.columnCamelNameUpper}(1L);</#if>
        ${table.javaClassName}DO cond = ${table.javaClassName}Converter.dtoToDomain(record);
        int inserted = ${table.javaClassNameLower}Mapper.insertSelective(cond);
        if (inserted != 0) {
            logger.info("${table.name}数据插入成功! {}", record);
            return true;
        } else {
            logger.warn("${table.name}数据插入失败! {}", record);
            return false;
        }
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
            <#if versionColumn??>
             record.set${versionColumn.columnCamelNameUpper}(1L);</#if>
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
        int updated = ${table.javaClassNameLower}Mapper.updateByPrimaryKeySelective(cond);
        if (updated != 0) {
            logger.info("${table.name}数据更新成功! {}", record);
            return true;
        } else {
            logger.warn("${table.name}数据更新失败! {}", record);
            return false;
        }
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
        int deleted = ${table.javaClassNameLower}Mapper.deleteByPrimaryKey(cond);
        if(deleted != 0) {
            logger.info("${table.name}数据删除成功! ${pk.columnCamelNameLower}={}", cond.get${pk.columnCamelNameUpper}());
            return true;
        } else {
            logger.warn("${table.name}数据删除失败! ${pk.columnCamelNameLower}={}", cond.get${pk.columnCamelNameUpper}());
            return false;
        }
    }
}