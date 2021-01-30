<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
curl -v -X DELETE -d http://localhost:8080/${table.javaClassNameLower}/delete/<#if pk.isChar == 1>${randomString(column.charLength)}<#elseif pk.isDateTime == 1>${randomTimestamp()}<#else >${randomNumber()}</#if>