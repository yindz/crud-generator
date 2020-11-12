package com.foobar.generator.info;

import com.foobar.generator.constant.GeneratorConst;
import com.foobar.generator.util.StringUtils;

import java.io.File;

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

    /**
     * 目标文件基础目录名(不含路径)
     */
    private String targetBaseDirName;

    /**
     * 是否为核心模板
     */
    private int isCore;

    /**
     * 是否覆盖已存在的同名文件
     */
    private int overwriteExistingFile = GeneratorConst.YES;

    /**
     * 备注
     */
    private String remark;

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

    public String getTargetBaseDirName() {
        return targetBaseDirName;
    }

    public void setTargetBaseDirName(String targetBaseDirName) {
        this.targetBaseDirName = targetBaseDirName;
    }

    public int getIsCore() {
        return isCore;
    }

    public void setIsCore(int isCore) {
        this.isCore = isCore;
    }

    public int getOverwriteExistingFile() {
        return overwriteExistingFile;
    }

    public void setOverwriteExistingFile(int overwriteExistingFile) {
        this.overwriteExistingFile = overwriteExistingFile;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String toRealPath(String basePath) {
        StringBuilder sb = new StringBuilder(basePath);
        sb.append(this.targetBaseDirName);
        if (StringUtils.isNotEmpty(this.targetPkgName)) {
            sb.append(File.separator).append(this.targetPkgName);
        }
        return sb.toString();
    }
}
