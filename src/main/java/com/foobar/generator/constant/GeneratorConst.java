package com.foobar.generator.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * 常量
 *
 * @author yin
 */
public final class GeneratorConst {

    public static final int YES = 1;
    public static final int NO = 0;

    public static final String TK = "tk";
    public static final String MP = "mp";
    public static final String ORIG = "orig";
    public static final String PLACEHOLDER = "#";
    public static final String DEFAULT_PKG_NAME = "com.example.myapp";
    public static final String QUERY_TABLE_NAMES = "QUERY_TABLE_NAMES";
    public static final String QUERY_TABLE_COLUMNS = "QUERY_TABLE_COLUMNS";

    public final static Map<String, String> javaBoxTypeMap = new HashMap<>();
    public final static Map<String, String> mybatisTypeMap = new HashMap<>();
    public final static Map<String, String> importsTypeMap = new HashMap<>();

    static {
        javaBoxTypeMap.put("bigint", "Long");
        javaBoxTypeMap.put("binary", "Byte[]");
        javaBoxTypeMap.put("bit", "Boolean");
        javaBoxTypeMap.put("blob", "Byte[]");
        javaBoxTypeMap.put("mediumblob", "Byte[]");
        javaBoxTypeMap.put("longblob", "Byte[]");
        javaBoxTypeMap.put("char", "String");
        javaBoxTypeMap.put("date", "Date");
        javaBoxTypeMap.put("datetime", "Date");
        javaBoxTypeMap.put("decimal", "BigDecimal");
        javaBoxTypeMap.put("double", "Double");
        javaBoxTypeMap.put("float", "Float");
        javaBoxTypeMap.put("int", "Integer");
        javaBoxTypeMap.put("int4", "Integer");
        javaBoxTypeMap.put("int8", "Long");
        javaBoxTypeMap.put("image", "Byte[]");
        javaBoxTypeMap.put("money", "BigDecimal");
        javaBoxTypeMap.put("nchar", "String");
        javaBoxTypeMap.put("ntext", "String");
        javaBoxTypeMap.put("numeric", "BigDecimal");
        javaBoxTypeMap.put("nvarchar", "String");
        javaBoxTypeMap.put("nvarchar2", "String");
        javaBoxTypeMap.put("real", "Float");
        javaBoxTypeMap.put("smalldatetime", "Date");
        javaBoxTypeMap.put("smallint", "Integer");
        javaBoxTypeMap.put("smallmoney", "BigDecimal");
        javaBoxTypeMap.put("sql_variant", "String");
        javaBoxTypeMap.put("text", "String");
        javaBoxTypeMap.put("tinyint", "Integer");
        javaBoxTypeMap.put("uniqueidentifier", "String");
        javaBoxTypeMap.put("varbinary", "Byte[]");
        javaBoxTypeMap.put("varchar", "String");
        javaBoxTypeMap.put("varchar2", "String");
        javaBoxTypeMap.put("number", "Long");
        javaBoxTypeMap.put("timestamp", "Date");
        javaBoxTypeMap.put("timestamp(6)", "Date");

        mybatisTypeMap.put("bigint", "BIGINT");
        mybatisTypeMap.put("binary", "BLOB");
        mybatisTypeMap.put("bit", "BOOLEAN");
        mybatisTypeMap.put("blob", "BLOB");
        mybatisTypeMap.put("mediumblob", "BLOB");
        mybatisTypeMap.put("longblob", "BLOB");
        mybatisTypeMap.put("char", "CHAR");
        mybatisTypeMap.put("date", "TIMESTAMP");
        mybatisTypeMap.put("datetime", "TIMESTAMP");
        mybatisTypeMap.put("decimal", "DECIMAL");
        mybatisTypeMap.put("double", "DOUBLE");
        mybatisTypeMap.put("float", "FLOAT");
        mybatisTypeMap.put("int", "INTEGER");
        mybatisTypeMap.put("int4", "INTEGER");
        mybatisTypeMap.put("int8", "BIGINT");
        mybatisTypeMap.put("image", "BLOB");
        mybatisTypeMap.put("money", "DECIMAL");
        mybatisTypeMap.put("nchar", "NCHAR");
        mybatisTypeMap.put("ntext", "VARCHAR");
        mybatisTypeMap.put("numeric", "DECIMAL");
        mybatisTypeMap.put("nvarchar", "NVARCHAR");
        mybatisTypeMap.put("nvarchar2", "NVARCHAR");
        mybatisTypeMap.put("real", "FLOAT");
        mybatisTypeMap.put("smalldatetime", "TIMESTAMP");
        mybatisTypeMap.put("smallint", "INTEGER");
        mybatisTypeMap.put("smallmoney", "DECIMAL");
        mybatisTypeMap.put("sql_variant", "VARCHAR");
        mybatisTypeMap.put("text", "VARCHAR");
        mybatisTypeMap.put("tinyint", "TINYINT");
        mybatisTypeMap.put("uniqueidentifier", "VARCHAR");
        mybatisTypeMap.put("varbinary", "BLOB");
        mybatisTypeMap.put("varchar", "VARCHAR");
        mybatisTypeMap.put("varchar2", "VARCHAR");
        mybatisTypeMap.put("number", "BIGINT");
        mybatisTypeMap.put("timestamp", "TIMESTAMP");
        mybatisTypeMap.put("timestamp(6)", "TIMESTAMP");

        importsTypeMap.put("Date", "java.util.Date");
        importsTypeMap.put("BigDecimal", "java.math.BigDecimal");
    }
}
