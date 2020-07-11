package ${table.pkgName};

import java.io.Serializable;
<#list table.imports as imp>
import ${imp};
</#list>

/**
 * ${table.comments}实体类
 *
 * @author ${table.author!''}
 */
public class ${table.javaClassName} implements Serializable {
    private static final long serialVersionUID = 1L;

<#list table.columns as column>
    /**
     * ${column.columnComment!''}
     */
    private ${column.columnJavaType} ${column.columnCamelNameLower};

</#list>
<#list table.columns as column>

    public ${column.columnJavaType} get${column.columnCamelNameUpper}() {
        return this.${column.columnCamelNameLower};
    }

    public void set${column.columnCamelNameUpper}(${column.columnJavaType} ${column.columnCamelNameLower}) {
        this.${column.columnCamelNameLower} = ${column.columnCamelNameLower};
    }
</#list>
}