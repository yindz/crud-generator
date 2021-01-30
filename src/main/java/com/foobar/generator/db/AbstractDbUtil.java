package com.foobar.generator.db;

import com.foobar.generator.info.ColumnInfo;
import com.foobar.generator.info.JdbcInfo;
import com.foobar.generator.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据库操作工具
 *
 * @author yin
 */
public abstract class AbstractDbUtil {
    private static final Logger logger = LoggerFactory.getLogger(AbstractDbUtil.class);

    protected static final Map<String, String> SQL_MAP = new HashMap<>();

    protected String dbType;

    protected Connection connection;

    protected String schemaName;

    protected String jdbcUrl;

    /**
     * 准备连接
     *
     * @param jdbcInfo JDBC参数
     * @throws Exception
     */
    protected abstract void prepareConnection(JdbcInfo jdbcInfo) throws Exception;

    /**
     * 初始化
     *
     * @param jdbcInfo JDBC参数
     * @throws Exception
     */
    public void init(JdbcInfo jdbcInfo) throws Exception {
        this.prepareConnection(jdbcInfo);
        logger.info("数据库类型:{}, JDBC URL: {}", this.dbType, this.jdbcUrl);
        connection = DriverManager.getConnection(this.jdbcUrl, jdbcInfo.getUsername(), jdbcInfo.getPassword());
        logger.info("已成功连接数据库! ");
        String sqlXml = "/sql_" + this.dbType + ".xml";
        StringUtils.loadSqlFile(sqlXml, SQL_MAP);
        logger.info("已从 {} 加载 {} 条SQL语句", sqlXml, SQL_MAP.size());
    }

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
     * 查询并获得最后一条数据
     *
     * @param sql
     * @return
     */
    protected String selectLastOne(String sql) {
        if (StringUtils.isBlank(sql)) {
            return null;
        }
        String result = "";
        try (Statement st = this.connection.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs == null) {
                return "";
            }
            while (rs.next()) {
                result = rs.getString(1);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 查询并获得全部数据
     *
     * @param sql
     * @return
     */
    protected List<String> selectList(String sql) {
        if (StringUtils.isBlank(sql)) {
            return null;
        }
        List<String> resultList = new ArrayList<>();
        try (Statement st = this.connection.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs == null) {
                return null;
            }
            while (rs.next()) {
                resultList.add(setTableNameCase(rs.getString(1)));
            }
            rs.close();
            return resultList;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

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
