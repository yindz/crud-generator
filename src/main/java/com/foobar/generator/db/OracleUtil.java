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
import java.util.stream.Collectors;

/**
 * Oracle数据库工具
 *
 * @author yin
 */
public class OracleUtil extends AbstractDbUtil {
    private static final Logger logger = LoggerFactory.getLogger(OracleUtil.class);

    /**
     * 准备连接
     *
     * @param jdbcInfo JDBC参数
     * @throws Exception
     */
    @Override
    public void prepareConnection(JdbcInfo jdbcInfo) throws Exception {
        this.dbType = DatabaseType.ORACLE.getCode();
        this.schemaName = jdbcInfo.getSchema().toUpperCase();
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
        String sql = String.format(SQL_MAP.get(GeneratorConst.QUERY_TABLE_NAMES), schemaName.toUpperCase());
        List<String> resultList = this.selectList(sql);
        if (resultList != null && !resultList.isEmpty()) {
            return resultList.stream().map(String::toUpperCase).collect(Collectors.toList());
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
        String uniqueColumnName = findUniqueColumnName(tableName);
        String sql = String.format(SQL_MAP.get(GeneratorConst.QUERY_TABLE_COLUMNS), tableName);
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
                if (StringUtils.isNotBlank(col.getColumnType())) {
                    col.setColumnType(col.getColumnType().toUpperCase());
                }
                col.setColumnLength(StringUtils.parseInt(rs.getString(5)));
                col.setColumnPrecision(StringUtils.parseInt(rs.getString(6)));
                col.setColumnScale(StringUtils.parseInt(rs.getString(7)));
                col.setNullable("N".equalsIgnoreCase(rs.getString(8)) ? 0 : 1);
                String charLength = rs.getString(9);
                col.setCharLength(StringUtils.isNotBlank(charLength) ? Integer.parseInt(charLength) : 0);
                col.setDefaultValue(rs.getString(10));
                if (col.getDefaultValue() != null) {
                    col.setDefaultValue(col.getDefaultValue().trim());
                    if ("null".equalsIgnoreCase(col.getDefaultValue()) || col.getDefaultValue().length() == 0) {
                        col.setDefaultValue(null);
                    }
                }
                col.setColumnComment(rs.getString(11));
                if (StringUtils.isNotBlank(col.getColumnType()) && col.getColumnType().contains("CHAR")) {
                    if (col.getDefaultValue() != null) {
                        col.setDefaultValue("'" + col.getDefaultValue().trim() + "'");
                    }
                    col.setIsChar(GeneratorConst.YES);
                }
                if (col.getColumnPrecision() != GeneratorConst.NO || "number".equalsIgnoreCase(col.getColumnType())) {
                    col.setIsNumber(GeneratorConst.YES);
                }
                resultList.add(col);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (!resultList.isEmpty() && StringUtils.isNotBlank(uniqueColumnName)) {
            for (ColumnInfo ci : resultList) {
                if (ci == null || StringUtils.isBlank(ci.getColumnName())) {
                    continue;
                }
                if (uniqueColumnName.equalsIgnoreCase(ci.getColumnName())) {
                    ci.setIsPrimaryKey(GeneratorConst.YES);
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
        if (StringUtils.isBlank(t)) {
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
        if (StringUtils.isNotBlank(columnName)) {
            return columnName;
        } else {
            //无主键，则找唯一索引字段
            return findUniqueIndexColumnName(tableName);
        }
    }

    private String selectOne(String sql) {
        return this.selectLastOne(sql);
    }
}
