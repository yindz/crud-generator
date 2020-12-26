package com.foobar.generator.info;

import com.foobar.generator.util.StringUtils;

import java.util.List;
import java.util.SortedSet;

/**
 * 数据表信息
 *
 * @author yin
 */
public class TableInfo {

    /**
     * 数据库类型(oracle/mysql)
     */
    private String dbType;

    /**
     * 数据库schema名称
     */
    private String schemaName;

    /**
     * 数据表原始名称
     */
    private String name;

    /**
     * kebabCase形式的表名
     */
    private String kebabCaseName;

    /**
     * 数据表注释
     */
    private String comments;

    /**
     * Java类名称(首字母大写)
     */
    private String javaClassName;

    /**
     * Java类名称(首字母小写)
     */
    private String javaClassNameLower;

    /**
     * 子包名
     */
    private String pkgName;

    /**
     * Java类注释中的作者
     */
    private String author;

    /**
     * Java类中需要import的类名集合
     */
    private SortedSet<String> imports;

    /**
     * 数据表中的所有字段信息列表
     */
    private List<ColumnInfo> columns;

    /**
     * 版本号字段名(用于乐观锁)
     */
    private String versionColumn;

    /**
     * 逻辑删除标识字段名(用于逻辑删除)
     */
    private String logicDeleteColumn;

    /**
     * 序列名称
     */
    private String sequenceName;

    /**
     * 默认分页大小
     */
    private Integer pageSize;

    public String getDbType() {
        return dbType;
    }

    public void setDbType(String dbType) {
        this.dbType = dbType;
    }

    public String getSchemaName() {
        return schemaName;
    }

    public void setSchemaName(String schemaName) {
        this.schemaName = schemaName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getKebabCaseName() {
        return kebabCaseName;
    }

    public void setKebabCaseName(String kebabCaseName) {
        this.kebabCaseName = kebabCaseName;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = StringUtils.trim(comments);
    }

    public String getJavaClassName() {
        return javaClassName;
    }

    public void setJavaClassName(String javaClassName) {
        this.javaClassName = javaClassName;
    }

    public String getJavaClassNameLower() {
        return javaClassNameLower;
    }

    public void setJavaClassNameLower(String javaClassNameLower) {
        this.javaClassNameLower = javaClassNameLower;
    }

    public String getPkgName() {
        return pkgName;
    }

    public void setPkgName(String pkgName) {
        this.pkgName = pkgName;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public SortedSet<String> getImports() {
        return imports;
    }

    public void setImports(SortedSet<String> imports) {
        this.imports = imports;
    }

    public List<ColumnInfo> getColumns() {
        return columns;
    }

    public void setColumns(List<ColumnInfo> columns) {
        this.columns = columns;
    }

    public String getVersionColumn() {
        return versionColumn;
    }

    public void setVersionColumn(String versionColumn) {
        this.versionColumn = versionColumn;
    }

    public String getLogicDeleteColumn() {
        return logicDeleteColumn;
    }

    public void setLogicDeleteColumn(String logicDeleteColumn) {
        this.logicDeleteColumn = logicDeleteColumn;
    }

    public String getSequenceName() {
        return sequenceName;
    }

    public void setSequenceName(String sequenceName) {
        this.sequenceName = sequenceName;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }
}
