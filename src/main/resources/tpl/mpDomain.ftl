package ${table.pkgName};

<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
import java.io.Serializable;

<#if pk??>
import com.baomidou.mybatisplus.annotation.TableId;
</#if>
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
<#if table.versionColumn??>
import com.baomidou.mybatisplus.annotation.Version;
</#if>
<#if table.dbType == 'oracle'>
import com.baomidou.mybatisplus.annotation.KeySequence;
</#if>

<#list table.imports as imp>
import ${imp};
</#list>

/**
 * ${table.comments}实体类
 * (适用于MybatisPlus;该文件自动生成，请勿修改)
 *
 * @author ${table.author!''}
 */
@TableName("${table.name}")<#if pk??><#if table.dbType == 'oracle'>
@KeySequence(value = "<#if table.sequenceName??>${table.sequenceName}<#else>SEQ_${table.name}</#if>")</#if></#if>
public class ${table.javaClassName}DO <#if baseEntityClass??>extends ${baseEntityClass}<#else>implements Serializable</#if> {
<#include "./public/serialVersionUID.ftl"/>

<#list table.columns as column>
    /**
     * ${column.columnComment!''}
     */
    <#if column.isPrimaryKey == 1>@TableId(value = "${column.columnName}"<#if table.dbType == 'oracle'>, type = IdType.INPUT</#if><#if table.dbType == 'mysql'>, type = IdType.AUTO</#if><#if table.dbType == 'sqlserver'>, type = IdType.AUTO</#if><#if table.dbType == 'postgresql'>, type = IdType.AUTO</#if>)<#else>@TableField("${column.columnName}")<#if table.versionColumn??><#if table.versionColumn == column.columnName>
    @Version</#if></#if></#if>
    private ${column.columnJavaType} ${column.columnCamelNameLower};

</#list>
<#include "./public/getterAndSetter.ftl"/>
}