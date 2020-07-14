package ${table.pkgName};

import java.io.Serializable;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
<#list table.imports as imp>
import ${imp};
</#list>

/**
 * ${table.comments}DTO对象
 *
 * @author ${table.author!''}
 */
public class ${table.javaClassName}DTO implements Serializable {
    private static final long serialVersionUID = 1L;

<#list table.columns as column>
    /**
     * ${column.columnComment!''}
     */<#if column.nullable == 0><#if column.isChar == 1>
    @NotBlank(message = "${column.columnComment!''}${column.columnCamelNameLower}为空")<#else>
    @NotNull(message = "${column.columnComment!''}${column.columnCamelNameLower}为空")</#if></#if><#if column.isChar == 1>
    @Length(max = ${column.columnLength}, message = "${column.columnComment!''}${column.columnCamelNameLower}长度不能超过${column.columnLength}")</#if>
    private ${column.columnJavaType} ${column.columnCamelNameLower};

</#list>

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.SHORT_PREFIX_STYLE);
    }

<#list table.columns as column>

    public ${column.columnJavaType} get${column.columnCamelNameUpper}() {
        return this.${column.columnCamelNameLower};
    }

    public void set${column.columnCamelNameUpper}(${column.columnJavaType} ${column.columnCamelNameLower}) {
        this.${column.columnCamelNameLower} = ${column.columnCamelNameLower};
    }
</#list>
}