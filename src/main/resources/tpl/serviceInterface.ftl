package ${table.pkgName};

import com.github.pagehelper.PageInfo;
import ${basePkgName}.dto.${table.javaClassName}DTO;

/**
 * ${table.comments}服务接口
 *
 * @author ${table.author!''}
 */
public interface I${table.javaClassName}Service {

    /**
     * 分页查询
     *
     * @param query           查询条件
     * @param pageNo          页码
     * @param pageSize        分页大小
     * @param orderBy         排序字段名(驼峰形式)
     * @param orderDirection  排序方向(ASC/DESC)
     * @return 分页查询结果
     */
    PageInfo<${table.javaClassName}DTO> get${table.javaClassName}List(${table.javaClassName}DTO query, int pageNo, int pageSize, String orderBy, String orderDirection);

    /**
     * 插入记录
     *
     * @param record    待插入的数据
     * @return 是否成功
     */
    boolean insert(${table.javaClassName}DTO record);

    /**
     * 批量插入记录
     *
     * @param recordList    待插入的数据列表
     * @return 是否成功
     */
    boolean insertAll(List<${table.javaClassName}DTO> recordList);

    /**
     * 更新记录
     *
     * @param record    待更新的数据
     * @return 是否成功
     */
    boolean update(${table.javaClassName}DTO record);

    /**
     * 删除记录
     *
     * @param record    待删除的数据
     * @return 是否成功
     */
    boolean delete(${table.javaClassName}DTO record);
}