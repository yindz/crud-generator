package com.foobar.generator.db;

import com.foobar.generator.config.GeneratorConfig;
import com.foobar.generator.constant.DatabaseType;
import com.foobar.generator.constant.GeneratorConst;
import com.foobar.generator.info.ColumnInfo;
import com.foobar.generator.info.DbUtilInfo;
import com.foobar.generator.info.JdbcInfo;
import com.foobar.generator.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * PostgreSQL数据库工具
 *
 * @author yin
 */
public class PostgreSQLUtil extends AbstractDbUtil {
    private static final Logger logger = LoggerFactory.getLogger(PostgreSQLUtil.class);

    private static final Pattern numeric = Pattern.compile("numeric\\((\\d+),(\\d+)\\)");

    /**
     * 准备连接
     *
     * @param jdbcInfo JDBC参数
     * @throws Exception
     */
    @Override
    public void prepareConnection(JdbcInfo jdbcInfo) throws Exception {
        this.dbType = DatabaseType.POSTGRESQL.getCode();
        this.schemaName = jdbcInfo.getSchema();
        DbUtilInfo dbUtilInfo = GeneratorConfig.dbUtilMap.get(this.dbType);
        Class.forName(dbUtilInfo.getClassName());
        this.jdbcUrl = String.format(dbUtilInfo.getJdbcUrl(), jdbcInfo.getHost(), jdbcInfo.getPort(), jdbcInfo.getServiceName());
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
        String sql = String.format(SQL_MAP.get(GeneratorConst.QUERY_TABLE_NAMES), schemaName.toLowerCase());
        List<String> resultList = this.selectList(sql);
        if (resultList != null && !resultList.isEmpty()) {
            return resultList.stream().map(String::toLowerCase).collect(Collectors.toList());
        } else {
            return resultList;
        }
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
        String uniqueColumnName = findPrimaryKeyColumnName(tableName);
        String sql = String.format(SQL_MAP.get(GeneratorConst.QUERY_TABLE_COLUMNS), tableName);
        try (Statement st = connection.createStatement()) {
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
                String columnTypeStr = rs.getString(6);
                //定长
                String fixedLength = rs.getString(7);
                //变长
                String variableLength = rs.getString(8);
                if (!"-1".equals(fixedLength)) {
                    col.setColumnLength(StringUtils.parseInt(fixedLength));
                } else {
                    col.setColumnLength(StringUtils.parseInt(variableLength));
                }
                if ("bigint".equalsIgnoreCase(col.getColumnType())
                        || "int".equalsIgnoreCase(col.getColumnType())
                        || "smallint".equalsIgnoreCase(col.getColumnType())
                        || "mediumint".equalsIgnoreCase(col.getColumnType())
                        || "tinyint".equalsIgnoreCase(col.getColumnType())
                        || "int4".equalsIgnoreCase(col.getColumnType())
                        || "int8".equalsIgnoreCase(col.getColumnType())
                        || "float".equalsIgnoreCase(col.getColumnType())
                        || "double".equalsIgnoreCase(col.getColumnType())
                        || "decimal".equalsIgnoreCase(col.getColumnType())) {
                    //数字类型
                    col.setIsNumber(GeneratorConst.YES);
                    //解析数字精度
                    if (columnTypeStr != null && columnTypeStr.startsWith("numeric")) {
                        Matcher matcher = numeric.matcher(columnTypeStr);
                        if (matcher.find()) {
                            col.setColumnPrecision(StringUtils.parseInt(matcher.group(1)));
                            col.setColumnScale(StringUtils.parseInt(matcher.group(2)));
                        }
                    }
                } else if (StringUtils.isNotEmpty(col.getColumnType()) && (col.getColumnType().contains("char")
                        || col.getColumnType().contains("text"))) {
                    //字符型
                    col.setCharLength(col.getColumnLength());
                    col.setIsChar(GeneratorConst.YES);
                }
                col.setNullable("f".equalsIgnoreCase(rs.getString(9)) ? GeneratorConst.YES : GeneratorConst.NO);
                if (StringUtils.isNotEmpty(uniqueColumnName) && uniqueColumnName.equalsIgnoreCase(col.getColumnName())) {
                    col.setIsPrimaryKey(GeneratorConst.YES);
                } else {
                    col.setIsPrimaryKey(GeneratorConst.NO);
                }
                resultList.add(col);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
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

    /**
     * 获取主键字段名
     *
     * @param tableName 表名
     * @return
     */
    private String findPrimaryKeyColumnName(String tableName) {
        return selectOne(String.format(SQL_MAP.get("QUERY_PRIMARY_KEY").replaceAll("\n", ""), tableName));
    }

    private String selectOne(String sql) {
        return this.selectLastOne(sql);
    }
}
