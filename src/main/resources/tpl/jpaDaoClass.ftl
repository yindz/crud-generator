package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * ${table.comments}DAO
 * 说明：
 * 1.适用于JPA
 *
 * @author ${table.author!''}
 */
@Repository
public interface ${table.javaClassName}Dao extends JpaRepository<${table.javaClassName}DO<#list table.columns as column><#if column.isPrimaryKey == 1>, ${column.columnJavaType}</#if></#list>> {

}