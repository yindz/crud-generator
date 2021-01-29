package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import tk.mybatis.mapper.common.Mapper;

/**
 * ${table.comments}通用Mapper
 * 说明：
 * 1.适用于Mybatis通用Mapper
 *
 * @author ${table.author!''}
 */
public interface ${table.javaClassName}Mapper extends Mapper<${table.javaClassName}DO> {

}