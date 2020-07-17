package ${table.pkgName};

import com.github.pagehelper.PageInfo;
import ${basePkgName}.vo.${table.javaClassName}VO;

import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * ${table.comments}-FeignClient
 *
 * @author ${table.author!''}
 */
@FeignClient("${table.kebabCaseName}-service")
public interface ${table.javaClassName}Client {

    /**
     * 分页查询${table.comments}数据
     *
     * @param query           查询条件
     * @param pageNo          页码
     * @param pageSize        分页大小
     * @param orderBy         排序字段名(驼峰形式)
     * @param orderDirection  排序方向(ASC/DESC)
     * @return 分页查询结果
     */
    @RequestMapping(value = "/get${table.javaClassName}List", method = RequestMethod.GET)
    PageInfo<${table.javaClassName}VO> get${table.javaClassName}List(${table.javaClassName}VO query, @RequestParam("pageNo") int pageNo
        , @RequestParam("pageSize") int pageSize, @RequestParam("orderBy") String orderBy, @RequestParam("orderDirection") String orderDirection);

    /**
     * 插入${table.comments}记录
     *
     * @param vo    待插入的数据
     * @return 是否成功
     */
    @RequestMapping(value = "/insert", method = RequestMethod.POST)
    boolean insert(@Valid ${table.javaClassName}VO vo);

    /**
     * 更新${table.comments}记录
     *
     * @param vo    待更新的数据
     * @return 是否成功
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    boolean update(${table.javaClassName}VO vo);

    /**
     * 删除${table.comments}记录
     *
     * @param vo    待删除的数据
     * @return 是否成功
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    boolean delete(${table.javaClassName}VO vo);
}