package com.foobar.generator.db;

import com.foobar.generator.info.ColumnInfo;
import com.foobar.generator.info.JdbcInfo;
import com.foobar.generator.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.*;

/**
 * Oracle数据库工具
 *
 * @author yin
 */
public class OracleUtil extends AbstractDbUtil {
    private static final Logger logger = LoggerFactory.getLogger(OracleUtil.class);

    private static final String ORACLE_URL = "jdbc:oracle:thin:@%s:%s:%s";

    /**
     * 初始化
     *
     * @return
     */
    @Override
    public void init(JdbcInfo jdbcInfo) throws Exception {
        Class.forName("oracle.jdbc.OracleDriver");
        String url = String.format(ORACLE_URL, jdbcInfo.getHost(), jdbcInfo.getPort(), jdbcInfo.getServiceName());
        logger.info("JDBC URL: {}", url);
        connection = DriverManager.getConnection(url, jdbcInfo.getUsername(), jdbcInfo.getPassword());
        logger.info("已成功连接数据库!");
        this.schemaName = jdbcInfo.getSchema().toUpperCase();
        StringUtils.loadSqlFile("/sql_oracle.xml", SQL_MAP);
        logger.info("已加载 {} 条SQL语句", SQL_MAP.size());
    }

    /**
     * 获取所有表名
     *
     * @param schemaName
     * @return
     */
    @Override
    public List<String> getAllTableNames(String schemaName) {
        if (schemaName == null) {
            return null;
        }
        List<String> resultList = new ArrayList<>();
        String sql = String.format(SQL_MAP.get("QUERY_TABLE_NAMES"), schemaName.toUpperCase());
        try (Statement st = this.connection.prepareStatement(sql)) {
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
     * 获取字段信息
     *
     * @param tableName
     * @return
     */
    @Override
    public List<ColumnInfo> getColumnInfo(String tableName) {
        List<ColumnInfo> resultList = new ArrayList<>();
        String uniqueColumnName = findUniqueColumnName(tableName);
        String sql = String.format(SQL_MAP.get("QUERY_TABLE_COLUMNS"), tableName);
        try (Statement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery(sql);
            if (rs == null) {
                return null;
            }
            while (rs.next()) {
                ColumnInfo col = new ColumnInfo();
                col.setTableName(rs.getString(1));
                col.setTableComment(rs.getString(2));
                col.setColumnName(rs.getString(3));
                col.setColumnType(rs.getString(4));
                if (StringUtils.isNotEmpty(col.getColumnType())) {
                    col.setColumnType(col.getColumnType().toUpperCase());
                }
                col.setColumnLength(StringUtils.parseInt(rs.getString(5)));
                col.setColumnPrecision(StringUtils.parseInt(rs.getString(6)));
                col.setColumnScale(StringUtils.parseInt(rs.getString(7)));
                col.setNullable("N".equalsIgnoreCase(rs.getString(8)) ? 0 : 1);
                String charLength = rs.getString(9);
                col.setCharLength(StringUtils.isNotEmpty(charLength) ? Integer.parseInt(charLength) : 0);
                col.setDefaultValue(rs.getString(10));
                if (col.getDefaultValue() != null) {
                    col.setDefaultValue(col.getDefaultValue().trim());
                    if ("null".equalsIgnoreCase(col.getDefaultValue()) || col.getDefaultValue().length() == 0) {
                        col.setDefaultValue(null);
                    }
                }
                col.setColumnComment(rs.getString(11));
                if (StringUtils.isNotEmpty(col.getColumnType()) && col.getColumnType().contains("CHAR")) {
                    if (col.getDefaultValue() != null) {
                        col.setDefaultValue("'" + col.getDefaultValue().trim() + "'");
                    }
                    col.setIsChar(1);
                }
                if (col.getColumnPrecision() != 0) {
                    col.setIsNumber(1);
                }
                resultList.add(col);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (!resultList.isEmpty() && StringUtils.isNotEmpty(uniqueColumnName)) {
            for (ColumnInfo ci : resultList) {
                if (ci == null || StringUtils.isEmpty(ci.getColumnName())) {
                    continue;
                }
                if (uniqueColumnName.equalsIgnoreCase(ci.getColumnName())) {
                    ci.setIsPrimaryKey(1);
                    break;
                }
            }
        }
        return resultList;
    }

    /**
     * 统一设置表名大小写
     *
     * @param t 原始表名
     * @return
     */
    @Override
    public String setTableNameCase(String t) {
        if (StringUtils.isEmpty(t)) {
            return t;
        }
        return t.toUpperCase();
    }

    /**
     * 获取唯一索引字段名
     *
     * @param tableName 表名
     * @return
     */
    private String findUniqueIndexColumnName(String tableName) {
        return selectOne(String.format(SQL_MAP.get("QUERY_UNIQUE_COLUMN"), this.schemaName, tableName));
    }

    /**
     * 获取主键字段名
     *
     * @param tableName 表名
     * @return
     */
    private String findPrimaryKeyColumnName(String tableName) {
        return selectOne(String.format(SQL_MAP.get("QUERY_PRIMARY_KEY").replaceAll("\n", ""), tableName));
    }

    /**
     * 查找唯一字段名
     *
     * @param tableName 表名
     * @return
     */
    private String findUniqueColumnName(String tableName) {
        //优先找主键字段
        String columnName = findPrimaryKeyColumnName(tableName);
        if (StringUtils.isNotEmpty(columnName)) {
            return columnName;
        } else {
            //无主键，则找唯一索引字段
            return findUniqueIndexColumnName(tableName);
        }
    }

    private String selectOne(String sql) {
        if (StringUtils.isEmpty(sql)) {
            return null;
        }
        String result = "";
        try (Statement st = connection.prepareStatement(sql)) {
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
}
