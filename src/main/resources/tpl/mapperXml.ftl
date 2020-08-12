<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${table.pkgName}.${table.javaClassName}Mapper">
    <#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
    <resultMap id="queryResultMap" type="${basePkgName}.domain.${table.javaClassName}DO">
        <#list table.columns as column>
        <result column="${column.columnName}" property="${column.columnCamelNameLower}" jdbcType="${column.columnMyBatisType}" />
        </#list>
    </resultMap>

    <sql id="${table.name}_where">
        <#list table.columns as column>
        <if test="${column.columnCamelNameLower} != null<#if column.isChar == 1> and ${column.columnCamelNameLower} != ''</#if>">
            and a.${column.columnName} = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}
        </if>
        <#if column.enableLike == 1>
        <if test="${column.columnCamelNameLower}Like != null<#if column.isChar == 1> and ${column.columnCamelNameLower}Like != ''</#if>">
            and a.${column.columnName} like <#if table.dbType == 'oracle'>'%'||${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}}||'%'</#if><#if table.dbType == 'mysql'>concat('%',${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}},'%')</#if><#if table.dbType == 'sqlserver'>'%'+${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}}+'%'</#if><#if table.dbType == 'postgresql'>concat('%',${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}},'%')</#if>
        </if></#if>
        </#list>
    </sql>

    <select id="get${table.javaClassName}List" parameterType="map" resultMap="queryResultMap">
        select a.*
        from ${table.name} a
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

    <insert id="insert" parameterType="${basePkgName}.domain.${table.javaClassName}DO" useGeneratedKeys="true"<#if pk??> keyColumn="${pk.columnName}" keyProperty="${pk.columnCamelNameLower}"</#if>>
        <#if table.dbType == 'oracle'><#if pk??>
        <selectKey keyProperty="${pk.columnCamelNameLower}" resultType="${pk.columnJavaType}" order="BEFORE">
            select <#if table.sequenceName??>${table.sequenceName}<#else>SEQ_${table.name}</#if>.nextval from dual
        </selectKey></#if></#if>
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

    <update id="update" parameterType="${basePkgName}.domain.${table.javaClassName}DO">
        update ${table.name}
        <set>
            <#list table.columns as column>
                <#if column.isPrimaryKey == 0>
            <if test="${column.columnCamelNameLower} != null<#if column.isChar == 1> and ${column.columnCamelNameLower} != ''</#if>">${column.columnName} = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}},</if>
                </#if>
            </#list>
        </set>
        <#if pk??>where ${pk.columnName} = ${r"#{"}${pk.columnCamelNameLower}, jdbcType=${pk.columnMyBatisType}}</#if>
    </update>

    <delete id="delete" parameterType="${basePkgName}.domain.${table.javaClassName}DO">
        delete from ${table.name}
        <#if pk??>where ${pk.columnName} = ${r"#{"}${pk.columnCamelNameLower}, jdbcType=${pk.columnMyBatisType}}</#if>
    </delete>
</mapper>