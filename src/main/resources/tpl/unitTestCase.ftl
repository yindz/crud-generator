package ${table.pkgName}.test;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.dto.${table.javaClassName}QueryDTO;
<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>

/**
 * ${table.comments}单元测试用例
 *
 * @author ${table.author!''}
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class ${table.javaClassName}Tests {

    @Autowired
    private I${table.javaClassName}Service ${table.javaClassNameLower}Service;

    /**
     * 测试分页查询${table.comments}数据
     */
    @Test
    public void testSelect${table.javaClassName}List() {
        ${table.javaClassName}QueryDTO query = new ${table.javaClassName}QueryDTO();
        query.setPageNo(1);
        query.setPageSize(10);
        Assert.assertTrue(Objects.nonNull(${table.javaClassNameLower}Service.getRecordList(query)));
    }

    /**
     * 测试插入1条${table.comments}数据
     */
    @Test
    public void testInsert${table.javaClassName}() {
        ${table.javaClassName}DTO record = newRecord();
        Assert.assertTrue(<#if resultClassName??>Objects.nonNull(${table.javaClassNameLower}Service.insert(record))<#else >Objects.equals(true, ${table.javaClassNameLower}Service.insert(record))</#if>);
    }

    /**
     * 测试插入多条${table.comments}数据
     */
    @Test
    public void testInsert${table.javaClassName}List() {
        List<${table.javaClassName}DTO> recordList = new ArrayList();
        for (int i = 0; i < 10; i++) {
            recordList.add(newRecord());
        }
        Assert.assertTrue(<#if resultClassName??>Objects.nonNull(${table.javaClassNameLower}Service.insertAll(recordList))<#else >Objects.equals(true, ${table.javaClassNameLower}Service.insertAll(recordList))</#if>);
    }

    <#if pk??>
    /**
     * 测试查询${table.comments}数据
     */
     @Test
     public void testSelect${table.javaClassName}() {
        ${pk.columnJavaType} ${pk.columnCamelNameLower} = <#if pk.isChar == 1>"1"</#if><#if pk.isNumber == 1><#if pk.columnJavaType == 'BigDecimal'>new BigDecimal("1")<#else>1<#if pk.columnJavaType == 'Long'>L</#if><#if pk.columnJavaType == 'Double'>D</#if><#if pk.columnJavaType == 'Float'>F</#if></#if></#if>;
        Assert.assertTrue(Objects.nonNull(${table.javaClassNameLower}Service.getRecord(${pk.columnCamelNameLower})));
    }

    /**
     * 测试更新${table.comments}数据
     */
    @Test
    public void testUpdate${table.javaClassName}() {
        ${table.javaClassName}DTO record = newRecord();
        record.set${pk.columnCamelNameUpper}(<#if pk.isChar == 1>"1"</#if><#if pk.isNumber == 1><#if pk.columnJavaType == 'BigDecimal'>new BigDecimal("1")<#else>1<#if pk.columnJavaType == 'Long'>L</#if><#if pk.columnJavaType == 'Double'>D</#if><#if pk.columnJavaType == 'Float'>F</#if></#if></#if>);
        Assert.assertTrue(<#if resultClassName??>Objects.nonNull(${table.javaClassNameLower}Service.update(record))<#else >Objects.equals(true, ${table.javaClassNameLower}Service.update(record))</#if>);
    }

    /**
     * 测试删除${table.comments}数据
     */
     @Test
     public void testDelete${table.javaClassName}() {
        ${pk.columnJavaType} ${pk.columnCamelNameLower} = <#if pk.isChar == 1>"1"</#if><#if pk.isNumber == 1><#if pk.columnJavaType == 'BigDecimal'>new BigDecimal("1")<#else>1<#if pk.columnJavaType == 'Long'>L</#if><#if pk.columnJavaType == 'Double'>D</#if><#if pk.columnJavaType == 'Float'>F</#if></#if></#if>;
        Assert.assertTrue(<#if resultClassName??>Objects.nonNull(${table.javaClassNameLower}Service.delete(record))<#else >Objects.equals(true, ${table.javaClassNameLower}Service.delete(${pk.columnCamelNameLower}))</#if>);
    }</#if>

    /**
     * 构造新测试数据
     *
     * @return 测试数据
     */
    private ${table.javaClassName}DTO newRecord() {
        ${table.javaClassName}DTO record = new ${table.javaClassName}DTO();
<#list table.columns as column><#if column.isPrimaryKey == 1><#continue ></#if>
        record.set${column.columnCamelNameUpper}(<#if column.isChar == 1>"${randomString(column.charLength)}"</#if><#if column.isDateTime == 1>new Date()</#if><#if column.isNumber == 1><#if column.columnJavaType == 'BigDecimal'>new BigDecimal("${randomNumber()}")<#else>${randomNumber()}<#if column.columnJavaType == 'Long'>L</#if><#if column.columnJavaType == 'Double'>D</#if><#if column.columnJavaType == 'Float'>F</#if></#if></#if>);
</#list>
        return record;
    }
}