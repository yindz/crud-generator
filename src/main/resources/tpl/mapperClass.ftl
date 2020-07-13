package ${table.pkgName};

import ${basePkgName}.entity.${table.javaClassName};
import java.util.Map;

/**
 * ${table.comments}Mapper
 * 说明：
 * 1.当表字段发生变化时，无需重新生成本接口代码
 * 2.如有自定义SQL逻辑，不要直接在本接口中编写，而应该重新编写一个接口来继承本接口
 *
 * @author ${table.author!''}
 */
public interface ${table.javaClassName}Mapper {

    /**
     * 查询
     *
     * @param query 查询条件
     * @return 查询结果
     */
    List<${table.javaClassName}> get${table.javaClassName}List(Map<String, Object> query);

    /**
     * 查询数量
     *
     * @param query 查询条件
     * @return 查询结果
     */
    int get${table.javaClassName}Count(Map<String, Object> query);

    /**
     * 插入
     *
     * @param record 待插入数据
     * @return 插入行数
     */
    int insert(${table.javaClassName} record);

    /**
     * 更新
     *
     * @param record 待更新数据
     * @return 更新行数
     */
    int update(${table.javaClassName} record);

    /**
     * 删除
     *
     * @param record 待删除数据
     * @return 删除行数
     */
    int delete(${table.javaClassName} record);
}