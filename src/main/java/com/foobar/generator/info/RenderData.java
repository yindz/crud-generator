package com.foobar.generator.info;

import freemarker.template.TemplateMethodModelEx;

/**
 * 待渲染数据
 *
 * @author yin
 */
public class RenderData {

    /**
     * 基础包名
     */
    private String basePkgName;

    /**
     * 表信息
     */
    private TableInfo table;

    /**
     * 随机UUID
     */
    private TemplateMethodModelEx uuid;

    public String getBasePkgName() {
        return basePkgName;
    }

    public void setBasePkgName(String basePkgName) {
        this.basePkgName = basePkgName;
    }

    public TableInfo getTable() {
        return table;
    }

    public void setTable(TableInfo table) {
        this.table = table;
    }

    public TemplateMethodModelEx getUuid() {
        return uuid;
    }

    public void setUuid(TemplateMethodModelEx uuid) {
        this.uuid = uuid;
    }
}
