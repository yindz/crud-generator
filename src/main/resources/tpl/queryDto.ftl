package ${table.pkgName};

import ${basePkgName}.dto.${table.javaClassName}DTO;

/**
 * ${table.comments}查询条件
 *
 * @author ${table.author!''}
 */
public class ${table.javaClassName}QueryDTO extends ${table.javaClassName}DTO {
<#include "./public/serialVersionUID.ftl"/>

    /**
     * 页码
     */
    private Integer pageNo = 1;

    /**
     * 分页大小
     */
    private Integer pageSize = 10;

    /**
     * 排序属性名称
     */
    private String orderBy;

    /**
     * 排序方向: asc或desc
     */
    private String orderDirection = "desc";

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
}