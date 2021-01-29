package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * ${table.comments}Mapper
 * 说明：
 * 1.适用于MybatisPlus
 *
 * @author ${table.author!''}
 */
@Mapper
public interface ${table.javaClassName}Mapper extends BaseMapper<${table.javaClassName}DO> {

}