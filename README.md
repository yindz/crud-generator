# CRUD代码生成器
- 基于数据表结构定义，自动生成 CRUD 代码，省时省力
- 自动检测数据表字段类型、字段长度、数值精度、主键字段、唯一索引字段
- 支持 Oracle 和 MySQL(Percona/MariaDB) 数据库
- 支持生成原版 mybatis 以及 [mybatis通用Mapper](https://github.com/abel533/Mapper) 相关代码
- 支持生成 mybatis 分页代码(基于 [Mybatis-PageHelper](https://github.com/pagehelper/Mybatis-PageHelper))
- 支持生成基于 [Spring Data JPA](https://spring.io/projects/spring-data-jpa) 的实体类和DAO层接口代码
- 支持生成基于 [Hibernate Validator](https://hibernate.org/validator/documentation/) 的参数校验注解
- 支持生成基于 [Swagger](https://swagger.io/docs/) 的API接口及参数注解
- 支持生成 [Postman](https://www.postman.com/) 可导入的API接口JSON定义文件

## 文件说明
| 文件名 | 含义 | 路径 | 备注 | 
|  ----  | ---- |---- |---- |
| XXXVO.java | VO类| java/vo/ |   | 
| XXXApi.java | 控制器代码 | java/controller/ |   | 
| XXX.java | 实体类 | java/entity/ |  适用于原版mybatis | 
| XXXMapper.java | Mapper接口 | java/dao/ | 适用于原版mybatis  | 
| XXXMapper.xml | Mapper XML | resources/ | 适用于原版mybatis  | 
| XXXDO.java | Domain实体类定义 | java/domain/| 适用于mybatis通用Mapper  | 
| JpaXXXDO.java | Domain实体类定义 | java/domain/| 适用于JPA  | 
| XXXDao.java | DAO接口 | java/dao/ |  适用于JPA | 
| XXXCommonMapper.java | Mapper接口 | java/dao/ |  适用于mybatis通用Mapper | 
| XXXCommonMapper.xml | Mapper XML | resources/ | 适用于mybatis通用Mapper  | 
| XXXDTO.java | DTO类 | java/dto/ |   | 
| IXXXService.java | 服务接口定义 | java/service/ |   | 
| XXXServiceImpl.java | 服务接口实现 | java/service/ |  适用于原版mybatis | 
| TkXXXServiceImpl.java | 服务接口实现 | java/service/ |  适用于mybatis通用Mapper | 
| XXX.postman_collection.json | Postman接口JSON定义文件 | json/ | 使用方法：Postman>Import | 
| XXX.postman_environment.json | Postman环境变量定义文件 | json/ | 使用方法：Postman>Manage Environment>Import | 

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
- 如果您采用原版 mybatis，则不应在 resources/XXXMapper.xml 中编写自己的业务逻辑，因为该文件可能会被重新生成；建议自行继承 XXXMapper，然后在新的xml文件中编写自己的逻辑
- 如果您采用 mybatis通用Mapper，可以在 resources/XXXCommonMapper.xml 中编写自己的业务逻辑，因为该文件不会被重新生成
- 如果数据表字段变化比较频繁，建议采用 mybatis通用Mapper

## 使用范例
```
    //指定数据库类型
    String dbType = GeneratorConst.ORACLE;

    //数据库主机名或IP
    String host = "192.168.2.101";

    //数据库端口号
    String port = "1521";

    //schema名称(oracle填写Schema名称，mysql则填写数据库名称)
    String schema = "BIZ_ORDER";

    //数据库用户名
    String username = "BIZ_ORDER_USER";

    //数据库用户密码
    String password = "123456";

    //数据库实例名(oracle填写实例名，mysql留空)
    String serviceName = "bizorderdb";

    //输出目录的绝对路径(留空则生成到当前用户主目录)
    String outPath = "E:\\tmp\\generated";

    //java包名
    String pkgName = "com.foobar.myapp";

    //表名(多个以逗号隔开,留空为全部)
    String tables = "T_ORDER_INFO,T_ORDER_DETAIL,T_ORDER_REPORT";

    //需去掉的表名前缀(留空不去掉任何前缀)
    String prefixToRemove = "T_";

    JdbcInfo param = new JdbcInfo();
    param.setDbType(dbType);
    param.setHost(host);
    param.setPort(port);
    param.setSchema(schema);
    param.setUsername(username);
    param.setPassword(password);
    param.setServiceName(serviceName);
    TableCodeGenerator generator = new TableCodeGenerator(param);

    //是否生成所有代码(默认true; 当数据表字段发生变化后需要重新生成代码时，可设置为false，只生成实体类、XML等核心代码)
    //generator.setGenerateAll(false);

    //生成
    generator.run(outPath, tables, pkgName, prefixToRemove);
```

### 扩展
#### 适配更多数据库
自行继承 AbstractDbUtil 抽象类即可。不要忘记加入相应的 jdbc 驱动。

#### 更多代码模板
代码模板基于 [Freemarker模板引擎](https://freemarker.apache.org/docs/index.html) 编写，因此您可以遵循该模板的语法自行实现新的代码模板。提供的变量上下文包括：

| 变量 | 含义| 变量类型 |
|  ----  | ----  |----  |
| ${basePkgName} | 基础包名| String |
| ${table} | 数据表根对象| Object |
| ${table.name} | 数据表原始名称| String |
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

编写完模板文件之后，在 GeneratorConfig.java 类中配置该模板的相关信息即可。

### 额外说明
自动生成的代码中用到了一些第三方开源组件，它们的maven坐标如下(版本号请自行匹配)：
```
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
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
```