package ${table.pkgName};

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Min;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import ${basePkgName}.vo.${table.javaClassName}VO;

/**
 * ${table.comments}查询条件
 *
 * @author ${table.author!''}
 */
@ApiModel("${table.comments}查询条件")
public class ${table.javaClassName}QueryVO extends ${table.javaClassName}VO {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "页码", dataType = "Integer", required = false, example = "1")
    @NotNull(message = "页码为空")
    @Min(value = 1, message = "页码必须大于或等于1")
    private Integer pageNo = 1;

    @ApiModelProperty(value = "分页大小", dataType = "Integer", required = false, example = "10")
    @NotNull(message = "分页大小为空")
    @Min(value = 1, message = "分页大小必须大于或等于1")
    private Integer pageSize = 10;

    @ApiModelProperty(value = "排序字段名", dataType = "String", required = false)
    private String orderBy;

    @ApiModelProperty(value = "排序方向: asc或desc", dataType = "String", required = false, example = "desc")
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