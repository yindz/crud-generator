package com.foobar.generator.info;

/**
 * 模板信息
 *
 * @author yin
 */
public class TemplateInfo {

    /**
     * 模板文件名(不含路径)
     */
    private String templateName;

    /**
     * 期待生成的目标文件名(不含路径)
     */
    private String targetFileName;

    /**
     * 期待生成的目标java文件子包名(不含基础路径)
     */
    private String targetPkgName;

    public String getTemplateName() {
        return templateName;
    }

    public void setTemplateName(String templateName) {
        this.templateName = templateName;
    }

    public String getTargetFileName() {
        return targetFileName;
    }

    public void setTargetFileName(String targetFileName) {
        this.targetFileName = targetFileName;
    }

    public String getTargetPkgName() {
        return targetPkgName;
    }

    public void setTargetPkgName(String targetPkgName) {
        this.targetPkgName = targetPkgName;
    }
}
