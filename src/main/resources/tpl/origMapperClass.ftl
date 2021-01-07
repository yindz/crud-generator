package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import java.util.List;
import java.util.Map;
<#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
<#if pk??>
import org.apache.ibatis.annotations.Param;</#if>
import org.apache.ibatis.annotations.Mapper;

/**
 * ${table.comments}Mapper
 * 说明：
 * 1.适用于原版Mybatis
 * 2.如有自定义SQL逻辑，不要直接在本接口中编写，而应该重新编写一个接口来继承本接口
 *
 * @author ${table.author!''}
 */
@Mapper
public interface ${table.javaClassName}Mapper {

    /**
     * 查询
     *
     * @param query 查询条件
     * @return 查询结果
     */
    List<${table.javaClassName}DO> getRecordList(Map<String, Object> query);

    <#if pk??>
    /**
     * 根据主键查询
     *
     * @param ${pk.columnCamelNameLower} 主键值
     * @return 查询结果
     */
    ${table.javaClassName}DO getRecordBy${pk.columnCamelNameUpper}(@Param("${pk.columnCamelNameLower}") ${pk.columnJavaType} ${pk.columnCamelNameLower});</#if>

    /**
     * 查询数量
     *
     * @param query 查询条件
     * @return 查询结果
     */
    long getRecordCount(Map<String, Object> query);

    /**
     * 插入
     *
     * @param record 待插入数据
     * @return 插入行数
     */
    int insert(${table.javaClassName}DO record);

    /**
     * 更新
     *
     * @param record 待更新数据
     * @return 更新行数
     */
    int update(${table.javaClassName}DO record);

    /**
     * 删除
     *
     * @param record 待删除数据
     * @return 删除行数
     */
    int delete(${table.javaClassName}DO record);
}