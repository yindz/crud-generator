# CRUD代码生成器
- 基于数据表结构定义，自动生成 CRUD 代码，省时省力
- 自动检测数据表字段类型、字段长度、数值精度、主键字段、唯一索引字段
- 支持 Oracle、MySQL(Percona/MariaDB)、Microsoft SqlServer 三种类型数据库
- 支持生成原版 mybatis 以及 [mybatis通用Mapper](https://github.com/abel533/Mapper) 相关代码
- 支持生成 mybatis 分页代码(基于 [Mybatis-PageHelper](https://github.com/pagehelper/Mybatis-PageHelper))
- 支持生成基于 [Spring Data JPA](https://spring.io/projects/spring-data-jpa) 的实体类和DAO层接口代码
- 支持生成基于 [Hibernate Validator](https://hibernate.org/validator/documentation/) 的参数校验注解
- 支持生成基于 [Spring Cloud OpenFeign](https://cloud.spring.io/spring-cloud-openfeign/reference/html/) 的服务消费端代码
- 支持生成基于 [Swagger](https://swagger.io/docs/) 的API接口及参数注解
- 支持生成 [Postman](https://www.postman.com/) 可导入的API接口JSON定义文件

## 文件说明
| 文件名 | 含义 | 路径 | 备注 | 
|  ----  | ---- |---- |---- |
| XXXVO.java | VO类| java/vo/ |   | 
| XXXQueryVO.java | 查询条件 | java/vo/ | | 
| XXXApi.java | 控制器代码 | java/controller/ |   | 
| XXX.java | 实体类 | java/entity/ |  适用于原版mybatis | 
| XXXMapper.java | Mapper接口 | java/dao/ | 适用于原版mybatis  | 
| XXXMapper.xml | Mapper XML | resources/ | 适用于原版mybatis  | 
| XXXDO.java | Domain实体类定义 | java/domain/| 适用于mybatis通用Mapper  | 
| JpaXXXDO.java | Domain实体类定义 | java/domain/| 适用于JPA  | 
| XXXDao.java | DAO接口 | java/dao/ |  适用于JPA | 
| XXXCommonMapper.java | Mapper接口 | java/dao/ |  适用于mybatis通用Mapper | 
| XXXCommonMapper.xml | Mapper XML | resources/ | 适用于mybatis通用Mapper  | 
| XXXDTO.java | DTO类 | java/dto/ | 适用于service层 | 
| XXXQueryDTO.java | 查询条件 | java/dto/ | 适用于service层  | 
| IXXXService.java | 服务接口定义 | java/service/ |   | 
| XXXServiceImpl.java | 服务接口实现 | java/service/ |  适用于原版mybatis | 
| TkXXXServiceImpl.java | 服务接口实现 | java/service/ |  适用于mybatis通用Mapper | 
| XXXClient.java | FeignClient服务接口 | java/feign/ |  适用于Spring Cloud消费者端 | 
| XXX.postman_collection.json | Postman接口JSON定义文件 | json/ | 使用方法：Postman>Import | 
| XXX.postman_environment.json | Postman环境变量定义文件 | json/ | 使用方法：Postman>Manage Environment>Import | 

## 主键字段检测规则
1. 数据表有主键字段时，程序将直接使用该字段
2. 数据表无主键字段时，程序将使用最后一个具有唯一索引的字段
3. 数据表既无主键字段也无唯一索引字段时，程序将使用 TableContext 对象中 primaryKeyColumn 参数所指定的字段

## 最佳实践
### 当数据表字段发生变化时
- 如果您采用原版 mybatis，则需要重新生成以下文件: 
```
java/vo/XXXVO.java
java/dto/XXXDTO.java
java/entity/XXX.java
java/service/XXXServiceImpl.java
resources/XXXMapper.xml
```
- 如果您采用 mybatis 通用Mapper，则需要重新生成以下文件: 
```
java/vo/XXXVO.java
java/dto/XXXDTO.java
java/domain/XXXDO.java
java/service/TkXXXServiceImpl.java
```

- 如果您采用JPA，则需要重新生成以下文件: 
```
java/vo/XXXVO.java
java/dto/XXXDTO.java
java/domain/JpaXXXDO.java
```

### 使用建议
- 如果您采用原版 mybatis，不应在 resources/XXXMapper.xml 和 XXXServiceImpl.java 中编写自己的业务逻辑；建议自行继承 XXXMapper，然后在新的xml文件中编写自己的逻辑
- 如果您采用 mybatis通用Mapper，不应在 TkXXXServiceImpl.java 中编写自己的业务逻辑；但可以在 resources/XXXCommonMapper.xml 中编写自己的业务逻辑
- 如果数据表字段变化比较频繁，建议采用 mybatis通用Mapper

## 使用范例
```
    JdbcInfo param = new JdbcInfo();
    
    //指定数据库类型
    param.setDbType(GeneratorConst.SQLSERVER);
    
    //数据库主机名或IP
    param.setHost("192.168.75.131");
    
    //数据库端口号
    param.setPort("1646");
    
    //schema名称(oracle填写Schema名称，mysql或sqlserver则填写数据库名称)
    param.setSchema("newdb");
    
    //数据库用户名
    param.setUsername("sa");
    
    //数据库用户密码
    param.setPassword("123456");
    
    //数据库实例名(oracle填写实例名，mysql或sqlserver留空)
    param.setServiceName("");

    TableCodeGenerator generator = new TableCodeGenerator(param);    
    RunParam rp = new RunParam();

    //java基础包名(留空则默认使用com.example.myapp)
    rp.setBasePkgName("com.foobar.bizapp");
    
    //输出目录的绝对路径(留空则生成到当前用户主目录)
    rp.setOutputPath("E:\\tmp\\generated");
    
    //表名
    TableContext table = TableContext.withName("t_product");
    
    //需去掉的表名前缀(留空不去掉任何前缀)
    table.setTableNamePrefixToRemove("t_");
    
    //手动指定主键字段名(不区分大小写); 如果程序无法自动检测到主键字段，则在此参数指定；适用于无主键且无唯一索引的表
    //table.setPrimaryKeyColumn("code");
    
    //如果该表有乐观锁，可在此设置其字段名，默认值为 version (不区分大小写)
    //table.setVersionColumn("total");
    
    rp.addTable(table);
    
    //如果需要去掉的表名前缀均相同，则可以全局配置它，不再需要在 TableContext 中逐个配置前缀
    //generator.setGlobalTableNamePrefixToRemove("t_");
    
    //默认使用 Spring 的 @Service 注解。如果需要使用 Dubbo 的@Service注解，请设置该值为true
    //generator.setUseDubboService(true);
    
    //是否生成所有代码(默认true; 当数据表字段发生变化后需要重新生成代码时，可设置为false，只生成实体类、XML等核心代码)
    //generator.setGenerateAll(false);
    
    //生成
    generator.run(rp);
```

### 扩展
#### 适配更多数据库
1. 编写自定义的SQL语句(用于查询数据库中的表名、表注释、字段名、字段注释、字段类型、字段长度、主键、唯一索引等)，约定保存路径为 resources/sql_XXX.xml
2. 编写您自定义的DbUtil类继承 AbstractDbUtil 抽象类，如数据库有特殊逻辑，也可在该类中编写
3. 在 dbutils-config.json 文件中配置您自定义的DbUtil类映射及驱动名称等信息
4. 不要忘记在 pom.xml 中加入相应的 jdbc 驱动

#### 更多代码模板
代码模板基于 [Freemarker模板引擎](https://freemarker.apache.org/docs/index.html) 编写，因此您可以遵循该模板的语法自行实现新的代码模板。提供的变量上下文包括：

| 变量 | 含义| 变量类型 |
|  ----  | ----  |----  |
| ${basePkgName} | 基础包名| String |
| ${table} | 数据表根对象| Object |
| ${table.name} | 数据表原始名称| String |
| ${table.kebabCaseName} | kebabCase形式的表名 | String |
| ${table.dbType} | 数据库类型(oracle/mysql)| String |
| ${table.subPkgName} | 子包名 | String |
| ${table.javaClassName} | Java类名称(首字母大写) |String |
| ${table.javaClassNameLower} | Java类名称(首字母小写) | String |
| ${table.comments} | 数据表注释| String |
| ${table.imports} | Java类中需要import的类名集合| Set |
| ${table.author} | Java类注释中的作者(操作系统的当前用户名) | String |
| ${table.columns} | 数据表中的所有字段信息列表| List |

字段信息包括：

| 变量 | 含义| 变量类型 |
|  ----  | ----  |----  |
| ${column.columnName} | 原始列名| String |
| ${column.columnCamelNameLower} | 驼峰形式列名(首字母小写)|String |
| ${column.columnCamelNameUpper} | 驼峰形式列名(首字母大写) | String |
| ${column.columnComment} | 列注释| String |
| ${column.columnType} | 列类型(数据库中的类型 |String |
| ${column.columnJavaType} | 列类型对应的Java类型| String |
| ${column.columnMyBatisType} | 列类型对应的mybatis jdbcType| String |
| ${column.columnLength} | 列长度| int |
| ${column.columnPrecision} | 列精度(针对数字列) | int |
| ${column.columnScale} | 列小数位数(针对数字列) |int |
| ${column.nullable} | 是否可空(0否/1是) |int |
| ${column.charLength} | 列长度(针对字符列) |int |
| ${column.defaultValue} | 列默认值| String |
| ${column.isNumber} | 是否为数字列(0否/1是) |int |
| ${column.isChar} | 是否为字符列(0否/1是) | int |
| ${column.isPrimaryKey} | 是否为主键(0否/1是) |int |

编写完模板文件之后，在 template-config.json 文件中配置该模板的相关信息即可。

### 额外说明
自动生成的代码中用到了一些第三方开源组件，它们的maven坐标如下(版本号请自行匹配)：
```
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
    <version>X.X.X</version>
</dependency>

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
    <version>X.X.X</version>
</dependency>

<dependency>
   <groupId>org.apache.commons</groupId>
   <artifactId>commons-lang3</artifactId>
   <version>X.X.X</version>
</dependency>

<dependency>
   <groupId>io.springfox</groupId>
   <artifactId>springfox-swagger2</artifactId>
   <version>X.X.X</version>
</dependency>

<dependency>
   <groupId>io.springfox</groupId>
   <artifactId>springfox-swagger-ui</artifactId>
   <version>X.X.X</version>
</dependency>

<dependency>
   <groupId>com.google.guava</groupId>
   <artifactId>guava</artifactId>
   <version>X.X.X</version>
</dependency>

<dependency>
   <groupId>org.mybatis.spring.boot</groupId>
   <artifactId>mybatis-spring-boot-starter</artifactId>
   <version>X.X.X</version>
</dependency>

<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper-spring-boot-starter</artifactId>
    <version>X.X.X</version>
</dependency>

<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper-spring-boot-starter</artifactId>
    <version>X.X.X</version>
</dependency>

<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-spring-boot-starter</artifactId>
    <version>X.X.X</version>
</dependency>
```