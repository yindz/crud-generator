package com.foobar.generator.db;

import com.foobar.generator.info.ColumnInfo;
import com.foobar.generator.info.JdbcInfo;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据库操作工具
 *
 * @author yin
 */
public abstract class AbstractDbUtil {
    protected static final Map<String, String> SQL_MAP = new HashMap<>();

    protected Connection connection;

    protected String schemaName;

    /**
     * 初始化
     *
     * @return
     */
    public abstract void init(JdbcInfo jdbcInfo) throws Exception;

    /**
     * 获取所有表名
     *
     * @param schemaName
     * @return
     */
    public abstract List<String> getAllTableNames(String schemaName);

    /**
     * 获取字段信息
     *
     * @param tableName
     * @return
     */
    public abstract List<ColumnInfo> getColumnInfo(String tableName);

    /**
     * 统一设置表名大小写
     *
     * @param t 原始表名
     * @return
     */
    public abstract String setTableNameCase(String t);

    /**
     * 清理资源
     */
    public void clean() {
        if (this.connection == null) {
            return;
        }
        try {
            this.connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
