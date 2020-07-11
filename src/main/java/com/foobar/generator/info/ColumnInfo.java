package com.foobar.generator.info;

/**
 * 列基本属性
 *
 * @author yin
 */
public class ColumnInfo {

    /**
     * 所在表名称
     */
    private String tableName;

    /**
     * 所在表注释
     */
    private String tableComment;

    /**
     * 列名
     */
    private String columnName;

    /**
     * 驼峰形式列名(首字母小写)
     */
    private String columnCamelNameLower;

    /**
     * 驼峰形式列名(首字母大写)
     */
    private String columnCamelNameUpper;

    /**
     * 列注释
     */
    private String columnComment;

    /**
     * 列类型
     */
    private String columnType;

    /**
     * 列类型对应的Java类型
     */
    private String columnJavaType;

    /**
     * 列类型对应的mybatis jdbc类型
     */
    private String columnMyBatisType;

    /**
     * 列长度
     */
    private int columnLength;

    /**
     * 列精度
     */
    private int columnPrecision;

    /**
     * 列小数位数
     */
    private int columnScale;

    /**
     * 是否可空 0/1
     */
    private int nullable;

    /**
     * 字符类型长度
     */
    private int charLength;

    /**
     * 默认值
     */
    private String defaultValue;

    /**
     * 是否为数字
     */
    private int isNumber = 0;

    /**
     * 是否为字符
     */
    private int isChar = 0;

    /**
     * 是否为主键
     */
    private int isPrimaryKey = 0;

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getTableComment() {
        return tableComment;
    }

    public void setTableComment(String tableComment) {
        this.tableComment = tableComment;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getColumnCamelNameLower() {
        return columnCamelNameLower;
    }

    public void setColumnCamelNameLower(String columnCamelNameLower) {
        this.columnCamelNameLower = columnCamelNameLower;
    }

    public String getColumnCamelNameUpper() {
        return columnCamelNameUpper;
    }

    public void setColumnCamelNameUpper(String columnCamelNameUpper) {
        this.columnCamelNameUpper = columnCamelNameUpper;
    }

    public String getColumnComment() {
        return columnComment;
    }

    public void setColumnComment(String columnComment) {
        this.columnComment = columnComment;
    }

    public String getColumnType() {
        return columnType;
    }

    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }

    public String getColumnJavaType() {
        return columnJavaType;
    }

    public void setColumnJavaType(String columnJavaType) {
        this.columnJavaType = columnJavaType;
    }

    public String getColumnMyBatisType() {
        return columnMyBatisType;
    }

    public void setColumnMyBatisType(String columnMyBatisType) {
        this.columnMyBatisType = columnMyBatisType;
    }

    public int getColumnLength() {
        return columnLength;
    }

    public void setColumnLength(int columnLength) {
        this.columnLength = columnLength;
    }

    public int getColumnPrecision() {
        return columnPrecision;
    }

    public void setColumnPrecision(int columnPrecision) {
        this.columnPrecision = columnPrecision;
    }

    public int getColumnScale() {
        return columnScale;
    }

    public void setColumnScale(int columnScale) {
        this.columnScale = columnScale;
    }

    public int getNullable() {
        return nullable;
    }

    public void setNullable(int nullable) {
        this.nullable = nullable;
    }

    public int getCharLength() {
        return charLength;
    }

    public void setCharLength(int charLength) {
        this.charLength = charLength;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public int getIsNumber() {
        return isNumber;
    }

    public void setIsNumber(int isNumber) {
        this.isNumber = isNumber;
    }

    public int getIsChar() {
        return isChar;
    }

    public void setIsChar(int isChar) {
        this.isChar = isChar;
    }

    public int getIsPrimaryKey() {
        return isPrimaryKey;
    }

    public void setIsPrimaryKey(int isPrimaryKey) {
        this.isPrimaryKey = isPrimaryKey;
    }
}
