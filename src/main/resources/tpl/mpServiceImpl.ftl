package ${table.pkgName};

import java.util.Map;
import java.util.LinkedHashMap;
import java.util.List;

import com.google.common.collect.Sets;
<#include "./public/logger.ftl"/>

<#include "./public/serviceCommonImports.ftl"/>
<#if resultClass??>import ${resultClass};</#if>
<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
<#if table.versionColumn??><#list table.columns as column><#if table.versionColumn == column.columnName><#assign versionColumn = column></#if></#list></#if>
<#if table.logicDeleteColumn??><#list table.columns as column><#if table.logicDeleteColumn == column.columnName><#assign logicDeleteColumn = column></#if></#list></#if>

/**
 * ${table.comments}服务接口实现
 * 适用于MybatisPlus
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
    public <#if resultClassName??>${resultClassName}<</#if>PageInfo<${table.javaClassName}DTO><#if resultClassName??>></#if> getRecordList(${table.javaClassName}QueryDTO query) {
        <#include "./public/checkQueryArguments.ftl"/>

        QueryWrapper<${table.javaClassName}DO> wrapper = new QueryWrapper<>();
        LambdaQueryWrapper<${table.javaClassName}DO> lambdaQueryWrapper = wrapper.lambda();
        <#list table.columns as column>
        if (query.get${column.columnCamelNameUpper}() != null<#if column.isChar == 1> && StringUtils.isNotBlank(query.get${column.columnCamelNameUpper}())</#if>) {
            lambdaQueryWrapper.eq(${table.javaClassName}DO::get${column.columnCamelNameUpper}, <#if column.isChar == 1>StringUtils.trim(</#if>query.get${column.columnCamelNameUpper}()<#if column.isChar == 1>)</#if>);
        }
        <#if column.enableLike == 1>
        if (query.get${column.columnCamelNameUpper}Like() != null<#if column.isChar == 1> && StringUtils.isNotBlank(query.get${column.columnCamelNameUpper}Like())</#if>) {
            lambdaQueryWrapper.like(${table.javaClassName}DO::get${column.columnCamelNameUpper}, "%" + StringUtils.trim(query.get${column.columnCamelNameUpper}Like()) + "%");
        }
        </#if>
        <#if column.enableRange == 1>
        if (query.get${column.columnCamelNameUpper}Min() != null) {
            lambdaQueryWrapper.ge(${table.javaClassName}DO::get${column.columnCamelNameUpper}, query.get${column.columnCamelNameUpper}Min());
        }
        if (query.get${column.columnCamelNameUpper}Max() != null) {
            lambdaQueryWrapper.le(${table.javaClassName}DO::get${column.columnCamelNameUpper}, query.get${column.columnCamelNameUpper}Max());
        }
        </#if>
        <#if column.enableIn == 1>
        if (query.get${column.columnCamelNameUpper}In() != null && !query.get${column.columnCamelNameUpper}In().isEmpty()) {
            lambdaQueryWrapper.in(${table.javaClassName}DO::get${column.columnCamelNameUpper}, query.get${column.columnCamelNameUpper}In());
        }
        </#if>
        </#list>
<#if logicDeleteColumn??>        lambdaQueryWrapper.eq("${logicDeleteColumn.columnCamelNameLower}", <#if logicDeleteColumn.isNumber == 1>0<#else>"0"</#if>);</#if>
        if (!${table.javaClassName}Converter.isFieldExists(query.getOrderBy())) {
            //默认使用主键(唯一索引字段)排序
        <#if pk??>    query.setOrderBy("${pk.columnCamelNameLower}");</#if>
        }
        if (${table.javaClassName}Converter.ASC.equalsIgnoreCase(query.getOrderDirection())) {
            wrapper.orderByAsc(query.getOrderBy());
        } else {
            wrapper.orderByDesc(query.getOrderBy());
        }
        Page<${table.javaClassName}DO> page = new Page<>(query.getPageNo(), query.getPageSize());
        IPage<${table.javaClassName}DO> p = ${table.javaClassNameLower}Mapper.selectPage(page, wrapper);
        if (p == null) {
            return null;
        }
        PageInfo<${table.javaClassName}DTO> b = new PageInfo<>();
        b.setTotal((int) p.getTotal());
        b.setPageNum((int) p.getCurrent());
        b.setPageSize((int) p.getSize());
        b.setPages((int) p.getPages());
        if (p.getRecords() != null && !p.getRecords().isEmpty()) {
            List<${table.javaClassName}DTO> list = new ArrayList();
            p.getRecords().forEach(e -> {
               list.add(${table.javaClassName}Converter.domainToDTO(e));
            });
            b.setList(list);
        }
        return <#if resultClassName??>new ${resultClassName}(</#if>b<#if resultClassName??>)</#if>;
    }

    <#if pk??>
    /**
     * 根据主键查询
     *
     * @param ${pk.columnCamelNameLower}    主键值
     * @return 查询结果
     */
    @Override
    public <#if resultClassName??>${resultClassName}<</#if>${table.javaClassName}DTO<#if resultClassName??>></#if> getRecord(${pk.columnJavaType} ${pk.columnCamelNameLower}) {
        Preconditions.checkArgument(<#if logicDeleteColumn.isChar == 1>StringUtils.isNotBlank(${pk.columnCamelNameLower})<#else>${pk.columnCamelNameLower} != null</#if>, "${pk.columnCamelNameLower}为空!");
        ${table.javaClassName}DO cond = new ${table.javaClassName}DO();
        cond.set${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
        ${table.javaClassName}DO obj = ${table.javaClassNameLower}Mapper.selectById(cond);
        if (obj != null<#if logicDeleteColumn??> && Objects.equals(<#if logicDeleteColumn.isNumber == 1>0,<#else>"0",</#if> obj.get${logicDeleteColumn.columnCamelNameUpper}())</#if>) {
            return <#if resultClassName??>new ${resultClassName}(</#if>${table.javaClassName}Converter.domainToDTO(obj)<#if resultClassName??>)</#if>;
        } else {
            return <#if resultClassName??>new ${resultClassName}(</#if>null<#if resultClassName??>)</#if>;
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
    public <#if resultClassName??>${resultClassName}<</#if>Boolean<#if resultClassName??>></#if> insert(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待插入的数据为空"); <#if versionColumn??>
        record.set${versionColumn.columnCamelNameUpper}(1L);</#if>
        ${table.javaClassName}DO domain = ${table.javaClassName}Converter.dtoToDomain(record);
        checkInsertObject(domain);
        int inserted = ${table.javaClassNameLower}Mapper.insert(domain);
        if (inserted != 0) {
            logger.info("${table.name}数据插入成功! {}", record);
            return <#if resultClassName??>new ${resultClassName}(</#if>true<#if resultClassName??>)</#if>;
        } else {
            logger.error("${table.name}数据插入失败! {}", record);
            return <#if resultClassName??>new ${resultClassName}(</#if>false<#if resultClassName??>)</#if>;
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
     public <#if resultClassName??>${resultClassName}<</#if>Boolean<#if resultClassName??>></#if> insertAll(List<${table.javaClassName}DTO> recordList) {
         Preconditions.checkArgument(recordList != null && !recordList.isEmpty(), "待插入的数据为空");
         int success = 0;
         for (${table.javaClassName}DTO record : recordList) {
             if (record == null) {
                continue;
             }
            <#if versionColumn??>
             record.set${versionColumn.columnCamelNameUpper}(1L);</#if>
             ${table.javaClassName}DO domain = ${table.javaClassName}Converter.dtoToDomain(record);
             checkInsertObject(domain);
             if (${table.javaClassNameLower}Mapper.insert(domain) == 0) {
                 throw new RuntimeException("插入${table.comments}数据失败!");
             }
             success++;
         }
         logger.info("本次总共插入{}条${table.name}数据", success);
         return <#if resultClassName??>new ${resultClassName}(</#if>true<#if resultClassName??>)</#if>;
    }

    /**
     * 更新记录
     *
     * @param record    待更新的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public <#if resultClassName??>${resultClassName}<</#if>Boolean<#if resultClassName??>></#if> update(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待更新的数据为空");
        <#if pk??>Preconditions.checkArgument(record.get${pk.columnCamelNameUpper}() != null, "待更新的数据${pk.columnCamelNameLower}为空");</#if>
        ${table.javaClassName}DO cond = ${table.javaClassName}Converter.dtoToDomain(record);
        int updated = ${table.javaClassNameLower}Mapper.updateById(cond);
        if (updated != 0) {
            logger.info("${table.name}数据更新成功! {}", record);
            return <#if resultClassName??>new ${resultClassName}(</#if>true<#if resultClassName??>)</#if>;
        } else {
            logger.error("${table.name}数据更新失败! {}", record);
            return <#if resultClassName??>new ${resultClassName}(</#if>false<#if resultClassName??>)</#if>;
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
    public <#if resultClassName??>${resultClassName}<</#if>Boolean<#if resultClassName??>></#if> delete(${pk.columnJavaType} ${pk.columnCamelNameLower}) {
        Preconditions.checkArgument(<#if logicDeleteColumn.isChar == 1>StringUtils.isNotBlank(${pk.columnCamelNameLower})<#else>${pk.columnCamelNameLower} != null</#if>, "${pk.columnCamelNameLower}为空!");
        ${table.javaClassName}DO cond = new ${table.javaClassName}DO();
        cond.set${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
<#if logicDeleteColumn??>        cond.set${logicDeleteColumn.columnCamelNameUpper}(<#if logicDeleteColumn.isNumber == 1>1<#else>"1"</#if>);
        int rowCount = ${table.javaClassNameLower}Mapper.updateById(cond);<#else>
        int rowCount = ${table.javaClassNameLower}Mapper.deleteById(cond);</#if>
        if(rowCount != 0) {
            logger.info("${table.name}数据删除成功! ${pk.columnCamelNameLower}={}", ${pk.columnCamelNameLower});
            return <#if resultClassName??>new ${resultClassName}(</#if>true<#if resultClassName??>)</#if>;
        } else {
            logger.error("${table.name}数据删除失败! ${pk.columnCamelNameLower}={}", ${pk.columnCamelNameLower});
            return <#if resultClassName??>new ${resultClassName}(</#if>false<#if resultClassName??>)</#if>;
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
    public <#if resultClassName??>${resultClassName}<</#if>Boolean<#if resultClassName??>></#if> deleteAll(List<${pk.columnJavaType}> ${pk.columnCamelNameLower}List) {
        Preconditions.checkArgument(${pk.columnCamelNameLower}List != null && !${pk.columnCamelNameLower}List.isEmpty(), "待删除的${table.comments}数据${pk.columnComment}列表为空");
        int success = 0;
        ${table.javaClassName}DO cond = new ${table.javaClassName}DO();
        for (${pk.columnJavaType} ${pk.columnCamelNameLower} : ${pk.columnCamelNameLower}List) {
            if (${pk.columnCamelNameLower} == null) {
                continue;
            }
            cond.set${pk.columnCamelNameUpper}(${pk.columnCamelNameLower});
    <#if logicDeleteColumn??>        cond.set${logicDeleteColumn.columnCamelNameUpper}(<#if logicDeleteColumn.isNumber == 1>1<#else>"1"</#if>);
            int rowCount = ${table.javaClassNameLower}Mapper.updateById(cond);<#else>
            int rowCount = ${table.javaClassNameLower}Mapper.deleteById(cond);</#if>
            if (rowCount == 0) {
                logger.error("删除${table.name}数据失败! ${pk.columnCamelNameLower}={}", ${pk.columnCamelNameLower});
                throw new RuntimeException("删除${table.comments}数据失败!");
            }
            success++;
        }
        logger.info("本次总共删除{}条${table.name}表数据! ${pk.columnCamelNameLower}List={}", success, ${pk.columnCamelNameLower}List);
        return <#if resultClassName??>new ${resultClassName}(</#if>true<#if resultClassName??>)</#if>;
    }</#if>

<#include "./public/insertObjectCheck.ftl"/>
}