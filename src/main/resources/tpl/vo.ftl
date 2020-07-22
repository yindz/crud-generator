package ${table.pkgName};

import java.io.Serializable;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.hibernate.validator.constraints.Length;
import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
<#list table.imports as imp>
import ${imp};
</#list>

/**
 * ${table.comments}VO对象
 *
 * @author ${table.author!''}
 */
@ApiModel("${table.comments}VO对象")
public class ${table.javaClassName}VO implements Serializable {
    <#include "./public/serialVersionUID.ftl"/>

<#list table.columns as column>
    /**
     * ${column.columnComment!''}
     */
    @ApiModelProperty(value = "${column.columnComment!''}", dataType = "${column.columnJavaType}", required = <#if column.nullable == 0>true<#else>false</#if><#if column.isNumber == 1>, example = "1"</#if>)<#if column.nullable == 0><#if column.isChar == 1>
    @NotBlank(message = "${column.columnComment!''} ${column.columnCamelNameLower} 为空")<#else>
    @NotNull(message = "${column.columnComment!''} ${column.columnCamelNameLower} 为空")</#if></#if><#if column.isChar == 1>
    @Length(max = ${column.columnLength}, message = "${column.columnComment!''} ${column.columnCamelNameLower} 长度不能超过${column.columnLength}")</#if><#if column.isDateTime == 1>
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "${timeZone}")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")</#if>
    private ${column.columnJavaType} ${column.columnCamelNameLower};

</#list>

<#include "./public/toString.ftl"/>

<#include "./public/getterAndSetter.ftl"/>
}