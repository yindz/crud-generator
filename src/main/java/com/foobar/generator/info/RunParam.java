package com.foobar.generator.info;

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
        this.outputPath = outputPath;
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
        this.basePkgName = basePkgName;
    }
}
