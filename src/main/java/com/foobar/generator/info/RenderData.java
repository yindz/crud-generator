package com.foobar.generator.info;

import com.foobar.generator.config.GeneratorConfig;
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

    /**
     * 时区
     */
    private String timeZone = GeneratorConfig.DEFAULT_TIME_ZONE;

    /**
     * 是否启用Dubbo服务
     */
    private int useDubboServiceAnnotation = 0;

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

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    public int getUseDubboServiceAnnotation() {
        return useDubboServiceAnnotation;
    }

    public void setUseDubboServiceAnnotation(int useDubboServiceAnnotation) {
        this.useDubboServiceAnnotation = useDubboServiceAnnotation;
    }
}
