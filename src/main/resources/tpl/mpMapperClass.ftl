package ${table.pkgName};

import ${basePkgName}.domain.${table.javaClassName}DO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * ${table.comments}Mapper
 * 说明：
 * (适用于MybatisPlus;该文件自动生成，请勿修改)
 *
 * @author ${table.author!''}
 */
@Mapper
public interface ${table.javaClassName}Mapper extends BaseMapper<${table.javaClassName}DO> {
    //TODO 可在此编写自己的代码
}