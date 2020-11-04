
    /**
     * 检查待插入的数据各个非空字段值
     *
     * @param obj 待插入数据
     */
    private void checkInsertObject(${table.javaClassName}DO obj) {
        Preconditions.checkArgument(obj != null, "待插入的数据为空");<#list table.columns as column><#if column.nullable == 0>
        Preconditions.checkArgument(obj.get${column.columnCamelNameUpper}() != null<#if column.isChar == 1> && StringUtils.isNotBlank(obj.get${column.columnCamelNameUpper}())</#if>, "待插入的数据${column.columnComment}为空");</#if></#list>
    }
