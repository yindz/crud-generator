package com.foobar.generator.db;

import com.foobar.generator.info.ColumnInfo;
import com.foobar.generator.info.JdbcInfo;
import com.foobar.generator.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * MySQL数据库工具
 *
 * @author yin
 */
public class MySQLUtil extends AbstractDbUtil {
    private static final Logger logger = LoggerFactory.getLogger(MySQLUtil.class);

    private static final String MYSQL_URL = "jdbc:mysql://%s:%s/%s?useUnicode=true&autoReconnect=true&characterEncoding=utf8";

    /**
     * 创建连接URL
     *
     * @return
     */
    @Override
    public void init(JdbcInfo jdbcInfo) throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        String url = String.format(MYSQL_URL, jdbcInfo.getHost(), jdbcInfo.getPort(), jdbcInfo.getSchema());
        logger.info("JDBC URL: {}", url);
        connection = DriverManager.getConnection(url, jdbcInfo.getUsername(), jdbcInfo.getPassword());
        logger.info("已成功连接数据库!");
        this.schemaName = jdbcInfo.getSchema();
        StringUtils.loadSqlFile("/sql_mysql.xml", SQL_MAP);
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
        String sql = String.format(SQL_MAP.get("QUERY_TABLE_NAMES"), schemaName.toLowerCase());
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
        boolean hasPrimaryKey = false;
        String uniqueIndexColumn = "";
        String sql = String.format(SQL_MAP.get("QUERY_TABLE_COLUMNS"), schemaName, tableName);
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
                col.setColumnComment(rs.getString(4));
                col.setColumnType(rs.getString(5));
                if (StringUtils.isNotEmpty(col.getColumnType())) {
                    col.setColumnType(col.getColumnType().toLowerCase());
                }
                col.setDefaultValue(rs.getString(10));
                if (col.getDefaultValue() != null) {
                    col.setDefaultValue(col.getDefaultValue().trim());
                    if ("null".equalsIgnoreCase(col.getDefaultValue()) || col.getDefaultValue().length() == 0) {
                        col.setDefaultValue(null);
                    }
                }
                if ("bigint".equalsIgnoreCase(col.getColumnType())
                        || "int".equalsIgnoreCase(col.getColumnType())
                        || "smallint".equalsIgnoreCase(col.getColumnType())
                        || "mediumint".equalsIgnoreCase(col.getColumnType())
                        || "tinyint".equalsIgnoreCase(col.getColumnType())
                        || "float".equalsIgnoreCase(col.getColumnType())
                        || "double".equalsIgnoreCase(col.getColumnType())
                        || "decimal".equalsIgnoreCase(col.getColumnType())) {
                    //数字类型
                    col.setIsNumber(1);
                    col.setColumnPrecision(StringUtils.parseInt(rs.getString(6)));
                    col.setColumnScale(StringUtils.parseInt(rs.getString(7)));
                    col.setColumnLength(col.getColumnPrecision());
                } else if (StringUtils.isNotEmpty(col.getColumnType()) && (col.getColumnType().contains("char")
                        || col.getColumnType().contains("text"))) {
                    //字符型
                    col.setCharLength(StringUtils.parseInt(rs.getString(8)));
                    col.setColumnLength(col.getCharLength());
                    col.setIsChar(1);
                } else {
                    col.setColumnLength(StringUtils.parseInt(rs.getString(9)));
                }
                col.setNullable("YES".equalsIgnoreCase(rs.getString(11)) ? 1 : 0);
                String columnKey = rs.getString(12);
                if ("PRI".equalsIgnoreCase(columnKey)) {
                    hasPrimaryKey = true;
                    col.setIsPrimaryKey(1);
                } else {
                    col.setIsPrimaryKey(0);
                }
                if ("UNI".equalsIgnoreCase(columnKey)) {
                    uniqueIndexColumn = col.getColumnName();
                }
                resultList.add(col);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (!hasPrimaryKey && StringUtils.isNotEmpty(uniqueIndexColumn)) {
            for (ColumnInfo ci : resultList) {
                if (ci == null || StringUtils.isEmpty(ci.getColumnName())) {
                    continue;
                }
                //若无主键字段，则将最后1个唯一索引字段作为主键使用
                if (uniqueIndexColumn.equalsIgnoreCase(ci.getColumnName())) {
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
        return t.toLowerCase();
    }
}
