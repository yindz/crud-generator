package ${table.pkgName};

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.groups.Default;
<#if useSwagger == 1>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
import ${basePkgName}.vo.${table.javaClassName}VO;

/**
 * ${table.comments}查询条件
 *
 * @author ${table.author!''}
 */<#if useSwagger == 1>
@ApiModel("${table.comments}查询条件")</#if>
public class ${table.javaClassName}QueryVO extends ${table.javaClassName}VO {
<#include "./public/serialVersionUID.ftl"/>

<#if useSwagger == 1>
    @ApiModelProperty(value = "页码", dataType = "Integer", required = false, example = "1")</#if>
    @NotNull(message = "页码为空", groups = {Default.class})
    @Min(value = 1, message = "页码必须大于或等于{value}", groups = {Default.class})
    @Max(value = 2147483646, message = "页码不能大于{value}", groups = {Default.class})
    private Integer pageNo = 1;

<#if useSwagger == 1>
    @ApiModelProperty(value = "分页大小", dataType = "Integer", required = false, example = "10")</#if>
    @NotNull(message = "分页大小为空", groups = {Default.class})
    @Min(value = 1, message = "分页大小必须大于或等于{value}", groups = {Default.class})
    @Max(value = 2147483646, message = "分页大小不能大于{value}", groups = {Default.class})
    private Integer pageSize = ${table.pageSize};

<#if useSwagger == 1>
    @ApiModelProperty(value = "排序字段名", dataType = "String", required = false)</#if>
    @Pattern(regexp = "^[a-zA-Z][a-zA-Z0-9_]*$", message = "排序字段名无效", groups = {Default.class})
    private String orderBy;

<#if useSwagger == 1>
    @ApiModelProperty(value = "排序方向: asc或desc", dataType = "String", required = false, example = "desc")</#if>
    @Pattern(regexp = "(?i)asc|desc", message = "排序方向必须是asc或desc", groups = {Default.class})
    private String orderDirection = "desc";
<#list table.columns as column><#if column.enableLike == 1>

    @ApiModelProperty(value = "${column.columnComment!''}模糊匹配值", dataType = "String", required = false, example = "abc")
    private ${column.columnJavaType} ${column.columnCamelNameLower}Like;
</#if></#list>

    public Integer getPageNo() {
        return pageNo;
    }

    public void setPageNo(Integer pageNo) {
        this.pageNo = pageNo;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public String getOrderDirection() {
        return orderDirection;
    }

    public void setOrderDirection(String orderDirection) {
        this.orderDirection = orderDirection;
    }
<#list table.columns as column><#if column.enableLike == 1>

    public ${column.columnJavaType} get${column.columnCamelNameUpper}Like() {
        return this.${column.columnCamelNameLower}Like;
    }

    public void set${column.columnCamelNameUpper}Like(${column.columnJavaType} ${column.columnCamelNameLower}Like) {
        this.${column.columnCamelNameLower}Like = ${column.columnCamelNameLower}Like;
    }</#if></#list>
}