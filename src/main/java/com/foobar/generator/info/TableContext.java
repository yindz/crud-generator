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
     * 逻辑删除标识字段名(用于逻辑删除，默认del_flag)
     */
    private String logicDeleteColumn;

    /**
     * 序列名称
     */
    private String sequenceName;

    /**
     * 默认分页大小
     */
    private Integer pageSize = 10;

    /**
     * 允许模糊查询的字段名，多个以逗号隔开
     */
    private String likeColumns;

    /**
     * 允许按范围查询的字段
     */
    private String rangeColumns;

    /**
     * 允许按in查询的字段
     */
    private String inColumns;

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

    public String getLikeColumns() {
        return likeColumns;
    }

    public void setLikeColumns(String likeColumns) {
        this.likeColumns = likeColumns;
    }

    public String getRangeColumns() {
        return rangeColumns;
    }

    public void setRangeColumns(String rangeColumns) {
        this.rangeColumns = rangeColumns;
    }

    public String getInColumns() {
        return inColumns;
    }

    public void setInColumns(String inColumns) {
        this.inColumns = inColumns;
    }
}
