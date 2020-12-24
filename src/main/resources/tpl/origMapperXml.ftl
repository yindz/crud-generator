<#include "./public/mybatisXmlHeader.ftl"/>
<#if table.logicDeleteColumn??><#list table.columns as column><#if table.logicDeleteColumn == column.columnName><#assign logicDeleteColumn = column></#if></#list></#if>
<#if table.dbType == 'mysql'><#assign isMySql = 1></#if>
<mapper namespace="${table.pkgName}.${table.javaClassName}Mapper">
    <#list table.columns as column><#if column.isPrimaryKey == 1><#assign pk = column></#if></#list>
    <!--结果字段映射-->
    <resultMap id="queryResultMap" type="${basePkgName}.domain.${table.javaClassName}DO">
        <#list table.columns as column>
        <result column="${column.columnName}" property="${column.columnCamelNameLower}" jdbcType="${column.columnMyBatisType}" />
        </#list>
    </resultMap>

    <!--表名-->
    <sql id="TABLE_NAME"><#if table.schemaName??>${table.schemaName}.</#if><#if isMySql??>`</#if>${table.name}<#if isMySql??>`</#if></sql>

    <!--所有字段-->
    <sql id="ALL_COLUMNS">
        <#list table.columns as column>
            a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if><#if column?has_next>,</#if>
        </#list>
    </sql>

    <!--各种查询条件-->
    <sql id="QUERY_CONDITIONS">
        <#list table.columns as column>
        <if test="${column.columnCamelNameLower} != null<#if column.isChar == 1> and ${column.columnCamelNameLower} != ''</#if>">
            and a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}
        </if>
        <#if column.enableLike == 1>
        <if test="${column.columnCamelNameLower}Like != null<#if column.isChar == 1> and ${column.columnCamelNameLower}Like != ''</#if>">
            and a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> like <#if table.dbType == 'oracle'>'%'||${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}}||'%'</#if><#if table.dbType == 'mysql'>concat('%', ${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}}, '%')</#if><#if table.dbType == 'sqlserver'>'%'+${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}}+'%'</#if><#if table.dbType == 'postgresql'>concat('%',${r"#{"}${column.columnCamelNameLower}Like, jdbcType=${column.columnMyBatisType}},'%')</#if>
        </if></#if>
        <#if column.enableRange == 1>
        <if test="${column.columnCamelNameLower}Min != null">
            <![CDATA[
            and a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> >= ${r"#{"}${column.columnCamelNameLower}Min, jdbcType=${column.columnMyBatisType}}
            ]]>
        </if>
        <if test="${column.columnCamelNameLower}Max != null">
            <![CDATA[
            and a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> <= ${r"#{"}${column.columnCamelNameLower}Max, jdbcType=${column.columnMyBatisType}}
            ]]>
        </if>
        </#if>
        <#if column.enableIn == 1>
        <if test="${column.columnCamelNameLower}In != null and ${column.columnCamelNameLower}In.size() &gt; 0">
           and a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> in
           <foreach collection="${column.columnCamelNameLower}In" item="${column.columnCamelNameLower}Value" open="(" close=")" separator=",">
               ${r"#{"}${column.columnCamelNameLower}Value, jdbcType=${column.columnMyBatisType}}
           </foreach>
        </if>
        </#if>
        <#if column.enableNotIn == 1>
        <if test="${column.columnCamelNameLower}NotIn != null and ${column.columnCamelNameLower}NotIn.size() &gt; 0">
           and a.<#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> not in
           <foreach collection="${column.columnCamelNameLower}NotIn" item="${column.columnCamelNameLower}Neq" open="(" close=")" separator=",">
                ${r"#{"}${column.columnCamelNameLower}Neq, jdbcType=${column.columnMyBatisType}}
           </foreach>
        </if>

        </#if>
        </#list>
    </sql>

    <!--主键条件-->
    <sql id="PK_CONDITION"><#if pk??>where <#if isMySql??>`</#if>${pk.columnName}<#if isMySql??>`</#if> = ${r"#{"}${pk.columnCamelNameLower}, jdbcType=${pk.columnMyBatisType}}</#if></sql>

    <!--查询-->
    <select id="getRecordList" parameterType="map" resultMap="queryResultMap">
        select <include refid="ALL_COLUMNS"/> from <include refid="TABLE_NAME"/> a
        <where>
            <include refid="QUERY_CONDITIONS"/>
        </where>
        order by a.<choose><when test="orderBy != null and orderBy != ''"><#if isMySql??>`</#if>${r"${"}orderBy}<#if isMySql??>`</#if></when><otherwise><#if isMySql??>`</#if>${pk.columnName}<#if isMySql??>`</#if></otherwise></choose> <choose><when test="orderDirection != null and orderDirection != ''">${r"${"}orderDirection}</when><otherwise>desc</otherwise></choose>
    </select>

    <#if pk??>
    <!--根据主键查询-->
    <select id="getRecordBy${pk.columnCamelNameUpper}" resultMap="queryResultMap">
        select <include refid="ALL_COLUMNS"/> from <include refid="TABLE_NAME"/>
        <include refid="PK_CONDITION"/><#if logicDeleteColumn??> and <#if isMySql??>`</#if>${logicDeleteColumn.columnName}<#if isMySql??>`</#if> = <#if logicDeleteColumn.isNumber == 1>0<#else>'0'</#if></#if>
    </select>
    </#if>

    <!--查询数量-->
    <select id="getRecordCount" parameterType="map" resultType="java.lang.Integer">
        select count(*) from <include refid="TABLE_NAME"/> a
        <where>
            <include refid="QUERY_CONDITIONS"/>
        </where>
    </select>

    <!--插入-->
    <insert id="insert" parameterType="${basePkgName}.domain.${table.javaClassName}DO"<#if pk??> useGeneratedKeys="true" keyColumn="${pk.columnName}" keyProperty="${pk.columnCamelNameLower}"</#if>>
        <#if pk??><#if table.dbType == 'oracle'><selectKey keyProperty="${pk.columnCamelNameLower}" resultType="${pk.columnJavaType}" order="BEFORE">
            select <#if table.schemaName??>${table.schemaName}.</#if><#if table.sequenceName??>${table.sequenceName}<#else>SEQ_${table.name}</#if>.nextval from dual
        </selectKey></#if>
        </#if>insert into <include refid="TABLE_NAME"/> (<#list table.columns as column><#if table.dbType == 'mysql' && column.isPrimaryKey == 1><#else>
            <#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if><#if column?has_next>,</#if></#if></#list>
        )
        values (<#list table.columns as column><#if table.dbType == 'mysql' && column.isPrimaryKey == 1><#else>
            ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}}<#if column?has_next>,</#if></#if></#list>
        )
    </insert>

    <!--更新-->
    <update id="update" parameterType="${basePkgName}.domain.${table.javaClassName}DO">
        update <include refid="TABLE_NAME"/>
        <set>
            <#list table.columns as column>
                <#if column.isPrimaryKey == 0>
            <if test="${column.columnCamelNameLower} != null<#if column.isChar == 1> and ${column.columnCamelNameLower} != ''</#if>"><#if isMySql??>`</#if>${column.columnName}<#if isMySql??>`</#if> = ${r"#{"}${column.columnCamelNameLower}, jdbcType=${column.columnMyBatisType}},</if>
                </#if>
            </#list>
        </set>
        <include refid="PK_CONDITION"/>
    </update>

    <!--删除-->
    <delete id="delete" parameterType="${basePkgName}.domain.${table.javaClassName}DO">
        delete from <include refid="TABLE_NAME"/> <include refid="PK_CONDITION"/>
    </delete>
</mapper>