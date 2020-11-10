package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import tk.mybatis.mapper.common.Mapper;

/**
 * ${table.comments}通用Mapper
 * 说明：
 * 1.适用于Mybatis通用Mapper
 * 2.如有自定义SQL逻辑，不要直接在本接口中编写，而应该重新编写一个接口来继承本接口
 *
 * @author ${table.author!''}
 */
public interface ${table.javaClassName}Mapper extends Mapper<${table.javaClassName}DO> {

}