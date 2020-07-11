package ${table.pkgName};

import com.google.common.base.Preconditions;
import com.foobar.pagehelper.PageInfo;
import com.foobar.pagehelper.PageHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ${basePkgName}.entity.${table.javaClassName};
import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.service.I${table.javaClassName}Service;

/**
 * ${table.comments}服务接口实现
 *
 * @author ${table.author!''}
 */
@Service
public class ${table.javaClassName}ServiceImpl implements I${table.javaClassName}Service {
    private static final Logger logger = LoggerFactory.getLogger(${table.javaClassName}ServiceImpl.class);

    @Autowired
    private ${table.javaClassName}Mapper ${table.javaClassNameLower}Mapper;

    /**
     * 分页查询
     *
     * @param query    查询条件
     * @param pageNo   页码
     * @param pageSize 分页大小
     * @return 分页查询结果
     */
    @Override
    public PageInfo<${table.javaClassName}DTO> get${table.javaClassName}List(${table.javaClassName}DTO query, int pageNo, int pageSize) {
        Preconditions.checkArgument(query != null, "查询条件为空");
        Preconditions.checkArgument(pageNo > 0, "页码必须大于0");
        Preconditions.checkArgument(pageSize > 0, "分页大小必须大于0");
        PageHelper.startPage(pageNo, pageSize);
        PageInfo<${table.javaClassName}> pageInfo = new PageInfo<>(${table.javaClassNameLower}Mapper.get${table.javaClassName}List(convertTo${table.javaClassName}(query)));
        PageInfo<${table.javaClassName}DTO> result = new PageInfo<>();
        List<${table.javaClassName}DTO> rowList = new ArrayList<>();
        if (pageInfo.getList() != null && !pageInfo.getList().isEmpty()) {
            pageInfo.getList().forEach(e->{
                if (e == null) {
                    return;
                }
                ${table.javaClassName}DTO row = new ${table.javaClassName}DTO();
                BeanUtils.copyProperties(e, row);
                rowList.add(row);
            });
        }
        BeanUtils.copyProperties(pageInfo, result);
        result.setList(rowList);
        return result;
    }

    /**
     * 插入记录
     *
     * @param record    待插入的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insert(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待插入的数据为空");
        return ${table.javaClassNameLower}Mapper.insert(convertTo${table.javaClassName}(record)) > 0;
    }

    /**
     * 更新记录
     *
     * @param record    待更新的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待更新的数据为空");
        return ${table.javaClassNameLower}Mapper.update(convertTo${table.javaClassName}(record)) > 0;
    }

    /**
     * 删除记录
     *
     * @param record    待删除的数据
     * @return 是否成功
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean delete(${table.javaClassName}DTO record) {
        Preconditions.checkArgument(record != null, "待删除的数据为空");
        return ${table.javaClassNameLower}Mapper.delete(convertTo${table.javaClassName}(record)) > 0;
    }

    /**
     * 转换
     *
     * @param record   待转换数据
     * @return 转换结果
     */
    private ${table.javaClassName} convertTo${table.javaClassName}(${table.javaClassName}DTO record) {
        if (record == null) {
            return null;
        }
        ${table.javaClassName} cond = new ${table.javaClassName}();
        BeanUtils.copyProperties(record, cond);
        return cond;
    }
}