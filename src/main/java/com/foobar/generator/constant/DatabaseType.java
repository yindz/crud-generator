package com.foobar.generator.constant;

/**
 * 数据库类型
 *
 * @author yin
 */
public enum DatabaseType {

    MYSQL("mysql"),
    ORACLE("oracle"),
    SQLSERVER("sqlserver"),
    POSTGRESQL("postgresql");

    private String code;

    private DatabaseType(String code) {
        this.code = code;
    }

    public String getCode() {
        return this.code;
    }
}
