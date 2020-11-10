package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * ${table.comments}Mapper
 * 说明：
 * 1.适用于MybatisPlus
 * 2.如有自定义SQL逻辑，不要直接在本接口中编写，而应该重新编写一个接口来继承本接口
 *
 * @author ${table.author!''}
 */
@Mapper
public interface ${table.javaClassName}Mapper extends BaseMapper<${table.javaClassName}DO> {

}