package com.foobar.generator.info;

import com.foobar.generator.util.StringUtils;

/**
 * JDBC参数
 *
 * @author yin
 */
public class JdbcInfo {

    /**
     * 数据库类型:mysql/oracle/sqlserver/postgresql，不区分大小写
     */
    private String dbType;

    /**
     * 主机名或IP
     */
    private String host;

    /**
     * 端口
     */
    private String port;

    /**
     * 数据库实例名(oracle填写实例名，mysql留空)
     */
    private String serviceName;

    /**
     * SCHEMA名称(oracle填写Schema名称，mysql则填写数据库名称)
     */
    private String schema;

    /**
     * 用户名
     */
    private String username;

    /**
     * 密码
     */
    private String password;

    public String getDbType() {
        return dbType;
    }

    public void setDbType(String dbType) {
        this.dbType = dbType;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = StringUtils.deleteWhitespace(host);
    }

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = StringUtils.deleteWhitespace(port);
    }

    public String getSchema() {
        return schema;
    }

    public void setSchema(String schema) {
        this.schema = StringUtils.deleteWhitespace(schema);
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = StringUtils.deleteWhitespace(username);
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = StringUtils.deleteWhitespace(serviceName);
    }
}
