<form id="${table.javaClassName}-form" name="${table.javaClassName}-form" method="post" enctype="application/x-www-form-urlencoded" action="">
<#list table.columns as column>
    <#if column.isPrimaryKey == 0>
    <div class="">
        <label for="${column.columnCamelNameLower}">${column.columnComment!''}</label>
        <input type="<#if column.isNumber == 1>number<#else>text</#if>" class="" id="${column.columnCamelNameLower}" name="${column.columnCamelNameLower}" placeholder="">
    </div><#if column?has_next>

    </#if><#else>
    <input type="hidden" id="${column.columnCamelNameLower}" name="${column.columnCamelNameLower}" value="">
    </#if>
</#list>

    <button type="submit" class="">Submit</button>
    <button type="reset" class="">Reset</button>
</form>