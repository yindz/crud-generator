<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${table.pkgName}.${table.javaClassName}Mapper">
    <resultMap id="queryResultMap" type="${basePkgName}.entity.${table.javaClassName}">
        <#list table.columns as column>
        <result column="${column.columnName}" property="${column.columnCamelNameLower}" jdbcType="${column.columnMyBatisType}" />
        </#list>
    </resultMap>

    <sql id="${table.name}_where">
        <#list table.columns as column>
        <if test="${column.columnCamelNameLower} != null<#if column.isChar == 1> and ${column.columnCamelNameLower} != ''</#if>">
            and a.${column.columnName} = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}
        </if>
        </#list>
    </sql>

    <select id="get${table.javaClassName}List" parameterType="map" resultMap="queryResultMap">
        select a.*
        from ${table.name} a
        where 1=1
        <where>
            <include refid="${table.name}_where"/>
        </where>
        <if test="orderBy != null and orderBy != null">order by a.${r"${"}orderBy}</if>
        <if test="orderDirection != null and orderDirection != null"> ${r"${"}orderDirection}</if>
    </select>

    <select id="get${table.javaClassName}Count" parameterType="map" resultType="java.lang.Integer">
        select count(a.*) from ${table.name} a
        <where>
            <include refid="${table.name}_where"/>
        </where>
    </select>

    <insert id="insert" parameterType="${basePkgName}.entity.${table.javaClassName}" useGeneratedKeys="true"<#list table.columns as column><#if column.isPrimaryKey == 1> keyColumn="${column.columnName}" keyProperty="${column.columnCamelNameLower}"</#if></#list>>
        <#if table.dbType == 'oracle'><#list table.columns as column><#if column.isPrimaryKey == 1>
        <selectKey keyProperty="${column.columnCamelNameLower}" resultType="${column.columnJavaType}" order="BEFORE">
            select SEQ_${table.name}.nextval from dual
        </selectKey></#if></#list></#if>
        insert into ${table.name} (
            <#list table.columns as column>
            ${column.columnName}<#if column?has_next>,</#if>
            </#list>
        )
        values (
            <#list table.columns as column>
            ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}<#if column?has_next>,</#if>
            </#list>
        )
    </insert>

    <update id="update" parameterType="${basePkgName}.entity.${table.javaClassName}">
        update ${table.name}
        <set>
            <#list table.columns as column>
                <#if column.isPrimaryKey == 0>
            <if test="${column.columnCamelNameLower} != null<#if column.isChar == 1> and ${column.columnCamelNameLower} != ''</#if>">${column.columnName} = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}},</if>
                </#if>
            </#list>
        </set>
        <#list table.columns as column><#if column.isPrimaryKey == 1>where ${column.columnName} = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}</#if></#list>
    </update>

    <delete id="delete" parameterType="${basePkgName}.entity.${table.javaClassName}">
        delete from ${table.name}
        <#list table.columns as column><#if column.isPrimaryKey == 1>where ${column.columnName} = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}</#if></#list>
    </delete>
</mapper>