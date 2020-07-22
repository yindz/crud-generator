<#list table.columns as column>
    public ${column.columnJavaType} get${column.columnCamelNameUpper}() {
        return this.${column.columnCamelNameLower};
    }

    public void set${column.columnCamelNameUpper}(${column.columnJavaType} ${column.columnCamelNameLower}) {
        this.${column.columnCamelNameLower} = ${column.columnCamelNameLower};
    }

</#list>