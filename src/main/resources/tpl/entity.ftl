package ${table.pkgName};

import java.io.Serializable;
<#list table.imports as imp>
import ${imp};
</#list>

/**
 * ${table.comments}实体类
 * (该文件自动生成，请勿修改)
 *
 * @author ${table.author!''}
 */
public class ${table.javaClassName}DO implements Serializable {
<#include "./public/serialVersionUID.ftl"/>

<#list table.columns as column>
    /**
     * ${column.columnComment!''}
     */
    private ${column.columnJavaType} ${column.columnCamelNameLower};

</#list>
<#include "./public/getterAndSetter.ftl"/>
}