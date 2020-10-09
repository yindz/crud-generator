package ${table.pkgName};

import java.util.Map;
import java.util.HashMap;
import java.util.List;

import com.google.common.base.CaseFormat;
import com.google.common.collect.Sets;
import com.github.pagehelper.PageHelper;
<#include "./public/logger.ftl"/>

<#include "./public/serviceCommonImports.ftl"/>
<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>

/**
 * ${table.comments}服务接口实现
 *
 * @author ${table.author!''}
 */
<#if useDubboServiceAnnotation = 1><#include "./public/dubboServiceAnnotation.ftl"/>
<#else>@Service
</#if>
public class ${table.javaClassName}ServiceImpl implements I${table.javaClassName}Service {
    <#include "./public/serviceHeader.ftl"/>

    /**
     * 分页查询
     *
     * @param query           查询条件
     * @return 分页查询结果
     */
    @Override
    public PageInfo<${table.javaClassName}DTO> getRecordList(${table.javaClassName}QueryDTO query) {
        <#include "./public/checkQueryArguments.ftl"/>

        Map<String, Object> queryMap = new HashMap<>();
        if (!${table.javaClassName}Converter.isFieldExists(${table.javaClassName}DO.class, query.getOrderBy())) {
            //默认使用主键(唯一索引字段)排序
    <#if pk??>        query.setOrderBy("${pk.columnCamelNameLower}");</#if>
        } else {
            query.setOrderBy(${table.javaClassName}Converter.getOrderColumn(${table.javaClassName}DO.class, query.getOrderBy()));
        }
        query.setOrderDirection(${table.javaClassName}Converter.getOrderDirection(query.getOrderDirection()));
        ${table.javaClassName}Converter.valuesToMap(query, queryMap, Sets.newHashSet("pageNo", "pageSize"));
        PageHelper.startPage(query.getPageNo(), query.getPageSize());
        PageInfo<${table.javaClassName}DO> pageInfo = new PageInfo<>(${table.javaClassNameLower}Mapper.getRecordList(queryMap));
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
    public ${table.javaClassName}DTO getRecord(${pk.columnJavaType} ${pk.columnCamelNameLower}) {
        if (${pk.columnCamelNameLower} == null) {
            throw new IllegalArgumentException("${pk.columnCamelNameLower}为空!");
        }
        ${table.javaClassName}DO record = ${table.javaClassNameLower}Mapper.getRecordBy${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
        if (record != null) {
            return ${table.javaClassName}Converter.domainToDTO(record);
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
        Preconditions.checkArgument(record != null, "待插入的数据为空");
        int inserted = ${table.javaClassNameLower}Mapper.insert(${table.javaClassName}Converter.dtoToDomain(record));
        if (inserted != 0) {
            logger.info("${table.name}数据插入成功! {}", record);
            return true;
        } else {
            logger.error("${table.name}数据插入失败! {}", record);
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
         //说明: 因为Oracle不允许超过1000个参数，所以此处逐条插入
         for (${table.javaClassName}DTO record : recordList) {
             if (record == null) {
                 continue;
             }
             if (${table.javaClassNameLower}Mapper.insert(${table.javaClassName}Converter.dtoToDomain(record)) == 0) {
                 throw new RuntimeException("插入${table.comments}数据失败!");
             }
         }
         logger.info("本次总共插入{}条${table.name}数据", recordList.size());
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
        int updated = ${table.javaClassNameLower}Mapper.update(${table.javaClassName}Converter.dtoToDomain(record));
        if (updated != 0) {
            logger.info("${table.name}数据更新成功! {}", record);
            return true;
        } else {
            logger.error("${table.name}数据更新失败! {}", record);
            return false;
        }
    }

<#if pk??>
    /**
     * 删除记录
     *
     * @param ${pk.columnCamelNameLower}    待删除的数据主键值
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean delete(${pk.columnJavaType} ${pk.columnCamelNameLower}) {
        Preconditions.checkArgument(${pk.columnCamelNameLower} != null, "待删除的数据${pk.columnCamelNameLower}为空");
        ${table.javaClassName}DO cond = new ${table.javaClassName}DO();
        cond.set${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
        if (${table.javaClassNameLower}Mapper.delete(cond) != 0) {
            logger.info("${table.name}数据删除成功! ${pk.columnCamelNameLower}={}", ${pk.columnCamelNameLower});
            return true;
        } else {
            logger.error("${table.name}数据删除失败! ${pk.columnCamelNameLower}={}", ${pk.columnCamelNameLower});
            return false;
        }
    }

    /**
     * 批量删除记录
     *
     * @param ${pk.columnCamelNameLower}List    待删除的数据主键值列表
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteAll(List<${pk.columnJavaType}> ${pk.columnCamelNameLower}List) {
        Preconditions.checkArgument(${pk.columnCamelNameLower}List != null && !${pk.columnCamelNameLower}List.isEmpty(), "待删除的${table.comments}数据${pk.columnComment}列表为空");
        for (${pk.columnJavaType} ${pk.columnCamelNameLower} : ${pk.columnCamelNameLower}List) {
            if (${pk.columnCamelNameLower} == null) {
                continue;
            }
            ${table.javaClassName}DO cond = new ${table.javaClassName}DO();
            cond.set${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
            if (${table.javaClassNameLower}Mapper.delete(cond) == 0) {
                logger.error("删除${table.name}数据失败! ${pk.columnCamelNameLower}={}", ${pk.columnCamelNameLower});
                throw new RuntimeException("删除${table.comments}数据失败!");
            }
        }
        logger.info("本次总共删除{}条${table.name}表数据! ${pk.columnCamelNameLower}List={}", ${pk.columnCamelNameLower}List.size(), ${pk.columnCamelNameLower}List);
        return true;
    }</#if>
}