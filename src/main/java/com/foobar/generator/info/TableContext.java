package com.foobar.generator.info;

/**
 * 数据表上下文信息
 *
 * @author yin
 */
public class TableContext {

    /**
     * 表名
     */
    private String tableName;

    /**
     * 待删除的表名前缀
     */
    private String tableNamePrefixToRemove;

    /**
     * 表主键字段名(如果程序无法自动检测到主键字段，则在此参数指定；不区分大小写)
     */
    private String primaryKeyColumn;

    /**
     * 版本号字段名(用于乐观锁，默认version)
     */
    private String versionColumn = "version";

    /**
     * 默认分页大小
     */
    private Integer pageSize = 10;

    public static TableContext withName(String name) {
        TableContext tc = new TableContext();
        tc.setTableName(name);
        return tc;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        return this.tableName != null && this.tableName.equalsIgnoreCase(((TableContext) obj).getTableName());
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getTableNamePrefixToRemove() {
        return tableNamePrefixToRemove;
    }

    public void setTableNamePrefixToRemove(String tableNamePrefixToRemove) {
        this.tableNamePrefixToRemove = tableNamePrefixToRemove;
    }

    public String getPrimaryKeyColumn() {
        return primaryKeyColumn;
    }

    public void setPrimaryKeyColumn(String primaryKeyColumn) {
        this.primaryKeyColumn = primaryKeyColumn;
    }

    public String getVersionColumn() {
        return versionColumn;
    }

    public void setVersionColumn(String versionColumn) {
        this.versionColumn = versionColumn;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }
}
