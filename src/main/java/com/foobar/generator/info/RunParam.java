package com.foobar.generator.info;

import com.foobar.generator.util.StringUtils;

import java.util.HashSet;
import java.util.Set;

/**
 * 运行参数
 *
 * @author yin
 */
public class RunParam {

    /**
     * 输出路径(留空则将输出到当前用户主目录)
     */
    private String outputPath;

    /**
     * 基础包名
     */
    private String basePkgName;

    /**
     * 基础实体类名
     */
    private String baseEntityClass;

    /**
     * 作者
     */
    private String author;

    /**
     * 返回结果类路径
     */
    private String resultClass;

    /**
     * 需要生成的表信息
     */
    private Set<TableContext> tableContexts;

    public void addTable(TableContext tc) {
        if (this.tableContexts == null) {
            this.tableContexts = new HashSet<>();
        }
        if (tc != null) {
            this.tableContexts.add(tc);
        }
    }

    public String getOutputPath() {
        return outputPath;
    }

    public void setOutputPath(String outputPath) {
        this.outputPath = StringUtils.trim(outputPath);
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Set<TableContext> getTableContexts() {
        return tableContexts;
    }

    public void setTableContexts(Set<TableContext> tableContexts) {
        this.tableContexts = tableContexts;
    }

    public String getBasePkgName() {
        return basePkgName;
    }

    public void setBasePkgName(String basePkgName) {
        this.basePkgName = StringUtils.deleteWhitespace(basePkgName);
    }

    public String getBaseEntityClass() {
        return baseEntityClass;
    }

    public void setBaseEntityClass(String baseEntityClass) {
        this.baseEntityClass = StringUtils.deleteWhitespace(baseEntityClass);
    }

    public String getResultClass() {
        return resultClass;
    }

    public void setResultClass(String resultClass) {
        this.resultClass = StringUtils.deleteWhitespace(resultClass);
    }
}
