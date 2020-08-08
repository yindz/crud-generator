package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import tk.mybatis.mapper.common.Mapper;

/**
 * ${table.comments}通用Mapper
 * 说明：
 * 1.当表字段发生变化时，无需重新生成本接口代码
 * 2.如有自定义SQL逻辑，可直接在本接口中编写
 *
 * @author ${table.author!''}
 */
public interface ${table.javaClassName}Mapper extends Mapper<${table.javaClassName}DO> {
    //TODO 可在此编写自己的代码
}