package ${table.pkgName};

import java.io.Serializable;
import javax.persistence.*;
<#list table.imports as imp>
import ${imp};
</#list>

/**
 * ${table.comments}实体类
 * 适用于JPA
 * @author ${table.author!''}
 */
@Entity
@Table(name = "${table.name}")
public class ${table.javaClassName}DO implements Serializable {
<#include "./public/serialVersionUID.ftl"/>

<#list table.columns as column>
    /**
     * ${column.columnComment!''}
     */<#if column.isPrimaryKey == 1>
    @Id</#if>
    @Column(name = "${column.columnName}",<#if column.isChar == 1> length = ${column.charLength},</#if><#if column.isNumber == 1> precision = ${column.columnPrecision},<#if column.columnScale != 0> scale = ${column.columnScale},</#if></#if> nullable = <#if column.nullable == 1>true<#else>false</#if>)
    private ${column.columnJavaType} ${column.columnCamelNameLower};

</#list>
<#include "./public/getterAndSetter.ftl"/>
}