# CRUD代码生成器

<!-- TOC -->
- [概述](#概述)
- [文件说明](#文件说明)
- [主键字段检测规则](#主键字段检测规则)
- [使用范例](#使用范例)
- [最佳实践](#最佳实践)
  - [当数据表字段发生变化时](#当数据表字段发生变化时)
  - [使用建议](#使用建议)
- [扩展](#扩展)
  - [适配更多数据库](#适配更多数据库)
  - [更多代码模板](#更多代码模板)
- [附录](#附录)
  - [Hibernate Validator分组校验说明](#hibernate-validator分组校验说明)
  - [处理Hibernate Validator校验异常](#处理Hibernate Validator校验异常)
  - [SwaggerUI配置参考](#SwaggerUI配置参考)
  - [第三方依赖](#第三方依赖)
  - [数据库版本](#数据库版本)

<!-- /TOC -->

## 概述
- 基于数据表结构定义，自动生成 CRUD 代码，省时省力
- 自动检测数据表字段类型、字段长度、数值精度、主键字段、唯一索引字段
- 支持 Oracle、MySQL(Percona/MariaDB)、Microsoft SQLServer、PostgreSQL 等四种类型数据库
- 支持生成原版 Mybatis 以及 [Mybatis通用Mapper](https://github.com/abel533/Mapper) 相关代码
- 支持生成 Mybatis 分页代码(基于 [Mybatis-PageHelper](https://github.com/pagehelper/Mybatis-PageHelper))
- 支持生成基于 [Spring Data JPA](https://spring.io/projects/spring-data-jpa) 的实体类和DAO层接口代码
- 支持生成基于 [Hibernate Validator](https://hibernate.org/validator/documentation/) 的参数校验注解
- 支持生成基于 [Spring Cloud OpenFeign](https://cloud.spring.io/spring-cloud-openfeign/reference/html/) 的服务消费端代码
- 支持生成基于 [Swagger](https://swagger.io/docs/) 的API接口及参数注解
- 支持生成 [Postman](https://www.postman.com/) 可导入的API接口JSON定义文件

## 文件说明
| 文件名 | 含义 | 路径 | 备注 | 当数据表字段发生变化时是否需要重新生成 | 
|  ----  | ---- |---- |---- | ---- |
| XXXVO.java | VO类| java/vo/ |  用于接收/输出数据  | 是 |
| XXXQueryVO.java | 查询条件 | java/vo/ | 用于接收查询条件 | 该文件只需生成1次 |
| XXXController.java | 控制器代码 | java/controller/ | 对外暴露HTTP接口 | 该文件只需生成1次 |
| XXXDO.java | 实体类 | java/entity/ |  适用于原版mybatis | 是 |
| XXXMapper.java | Mapper接口 | java/dao/ | 适用于原版mybatis | 该文件只需生成1次 |
| XXXMapper.xml | Mapper XML | resources/ | 适用于原版mybatis  | 是 |
| TkXXXDO.java | Domain实体类定义 | java/domain/| 适用于mybatis通用Mapper  | 是 |
| JpaXXXDO.java | Domain实体类定义 | java/domain/| 适用于JPA  | 是 |
| XXXDao.java | DAO接口 | java/dao/ |  适用于JPA | 该文件只需生成1次 |
| XXXCommonMapper.java | Mapper接口 | java/dao/ |  适用于mybatis通用Mapper | 该文件只需生成1次 |
| XXXCommonMapper.xml | Mapper XML | resources/ | 适用于mybatis通用Mapper | 该文件只需生成1次 |
| XXXDTO.java | DTO类 | java/dto/ | 适用于service层 | 是 |
| XXXQueryDTO.java | 查询条件 | java/dto/ | 适用于service层 | 该文件只需生成1次 |
| IXXXService.java | 服务接口定义 | java/service/ |  | 该文件只需生成1次 |
| XXXServiceImpl.java | 服务接口实现 | java/service/ |  适用于原版mybatis | 该文件只需生成1次 |
| TkXXXServiceImpl.java | 服务接口实现 | java/service/ |  适用于mybatis通用Mapper | 该文件只需生成1次 |
| XXXClient.java | FeignClient服务接口 | java/feign/ |  适用于Spring Cloud消费者端  | 该文件只需生成1次 |
| CommonConverter.java | 通用对象转换工具 | java/util/ |  用于VO/DTO/DO等对象之间的转换 | 该文件只需生成1次 |
| XXXConverter.java | 对象转换工具类 | java/util/ |  用于VO/DTO/DO等对象之间的转换 | 该文件只需生成1次 |
| InsertGroup.java | 校验分组(插入) | java/validator/ |  用于Hibernate Validator分组校验 | 该文件只需生成1次 |
| UpdateGroup.java | 校验分组(更新) | java/validator/ |  用于Hibernate Validator分组校验 | 该文件只需生成1次 |
| XXX.postman_collection.json | Postman接口定义 | json/ | 使用方法：Postman>Import | 是 |
| XXX.postman_environment.json | Postman环境变量定义 | json/ | 使用方法：Postman>Manage Environment>Import | 该文件只需生成1次 |

## 主键字段检测规则
1. 数据表有主键字段时，程序将直接使用该字段
2. 数据表无主键字段时，程序将使用最后一个具有唯一索引的字段
3. 数据表既无主键字段也无唯一索引字段时，程序将使用 TableContext 对象中 primaryKeyColumn 参数所指定的字段

## 使用范例
```java
public class App {

    public static void main(String[] args) throws Exception {
        JdbcInfo param = new JdbcInfo();
        
        //指定数据库类型
        param.setDbType(GeneratorConst.ORACLE);
        
        //数据库主机名或IP
        param.setHost("192.168.2.102");
        
        //数据库端口号
        param.setPort("1521");
        
        //schema名称(oracle和PostgreSQL填写Schema名称，mysql或sqlserver则填写数据库名称)
        param.setSchema("sys_biz");
        
        //数据库用户名
        param.setUsername("biz_manager");
        
        //数据库用户密码
        param.setPassword("123456");
        
        //数据库实例名(oracle填写实例名，PostgreSQL填写数据库名称，mysql或sqlserver留空)
        param.setServiceName("newbizdb");
    
        TableCodeGenerator generator = new TableCodeGenerator(param);    
        RunParam rp = new RunParam();
        
        //可以自行指定生成的javadoc注释中author的名称；如留空或不设置，则程序将使用当前操作系统的用户名
        //rp.setAuthor("张三");
    
        //java基础包名(留空则默认使用com.example.myapp)
        rp.setBasePkgName("com.foobar.bizapp");
        
        //输出目录的绝对路径(留空则生成到当前用户主目录)
        rp.setOutputPath("E:\\tmp\\generated");
        
        //表名
        TableContext table = TableContext.withName("T_ORDER_INFO");
        
        //需去掉的表名前缀(留空不去掉任何前缀)
        table.setTableNamePrefixToRemove("T_");
        
        //手动指定主键字段名(不区分大小写); 如果程序无法自动检测到主键字段，则在此参数指定；适用于无主键且无唯一索引的表
        //table.setPrimaryKeyColumn("code");
        
        //如果该表有乐观锁，可在此设置其字段名，默认值为 version (不区分大小写)
        //table.setVersionColumn("total");
    
        //默认分页大小为10，如需修改，可在此设置一个大于0的整数
        table.setPageSize(20);
    
        //针对Oracle数据库，可以指定序列名称; 如果不指定，则默认使用 SEQ_表名 作为序列名称
        table.setSequenceName("SEQ_ORDER");
        
        rp.addTable(table);
    
        //如果VO/DO/DTO等类需要继承某个基础类，可以在此指定基础类的完整路径
        //rp.setBaseEntityClass("com.foobar.common.BaseEntity");
        
        //如果需要去掉的表名前缀均相同，则可以全局配置它，不再需要在 TableContext 中逐个配置前缀
        //generator.setGlobalTableNamePrefixToRemove("t_");
        
        //默认使用 Spring 的 @Service 注解。如果需要使用 Dubbo 的@Service注解，请设置该值为true
        //generator.setUseDubboService(true);
        
        //是否生成所有代码(默认true; 当数据表字段发生变化后需要重新生成代码时，可设置为false，只生成实体类、XML等核心代码)
        //generator.setGenerateAll(false);
        
        //如果不希望生成swagger注解，可设置该值为false; 默认true
        //generator.setUseSwagger(false);
        
        //生成
        generator.run(rp);
}
```

## 最佳实践
### 当数据表字段发生变化时
- 如果您采用原版 mybatis，则需要重新生成以下文件: 
```
java/vo/XXXVO.java
java/dto/XXXDTO.java
java/entity/XXXDO.java
resources/XXXMapper.xml
```
- 如果您采用 mybatis 通用Mapper，则需要重新生成以下文件: 
```
java/vo/XXXVO.java
java/dto/XXXDTO.java
java/domain/XXXDO.java
```

- 如果您采用JPA，则需要重新生成以下文件: 
```
java/vo/XXXVO.java
java/dto/XXXDTO.java
java/domain/JpaXXXDO.java
```

### 使用建议
- 如果您采用原版 mybatis，不应在 resources/XXXMapper.xml 中编写自己的业务逻辑；建议自行继承 XXXMapper，然后在新的xml文件中编写自己的逻辑
- 如果您采用 mybatis通用Mapper，可以在 resources/XXXCommonMapper.xml 中编写自己的业务逻辑
- 如果数据表字段变化比较频繁，建议采用 mybatis通用Mapper

### 扩展
#### 适配更多数据库
1. 编写自定义的SQL语句(用于查询数据库中的表名、表注释、字段名、字段注释、字段类型、字段长度、主键、唯一索引等)，约定保存路径为 resources/sql_XXX.xml
2. 编写您自定义的DbUtil类继承 AbstractDbUtil 抽象类，如数据库有特殊逻辑，也可在该类中编写
3. 在 dbutils-config.json 文件中配置您自定义的DbUtil类映射及驱动名称等信息
4. 不要忘记在 pom.xml 中加入相应的 jdbc 驱动

#### 更多代码模板
代码模板基于 [Freemarker模板引擎](https://freemarker.apache.org/docs/index.html) 编写，因此您可以遵循该模板的语法自行实现新的代码模板。提供的上下文变量包括：

| 变量 | 含义| 变量类型 |
|  ----  | ----  |----  |
| ${basePkgName} | 基础包名| String |
| ${baseEntityClass} | 基础实体类的完整路径| String |
| ${timeZone} | 时区名称| String |
| ${useDubboServiceAnnotation} | 是否启用Dubbo服务(0否/1是) | int |
| ${useSwagger} | 是否启用SwaggerUI(0否/1是) | int |
| ${table} | 数据表根对象| Object |
| ${table.name} | 数据表原始名称| String |
| ${table.kebabCaseName} | kebabCase形式的表名 | String |
| ${table.dbType} | 数据库类型(oracle/mysql/sqlserver/postgresql，小写形式)| String |
| ${table.subPkgName} | 子包名 | String |
| ${table.javaClassName} | Java类名称(首字母大写) |String |
| ${table.javaClassNameLower} | Java类名称(首字母小写) | String |
| ${table.comments} | 数据表注释| String |
| ${table.imports} | Java类中需要import的类名集合| Set |
| ${table.author} | 生成的javadoc注释中author的名称 | String |
| ${table.pageSize} | 默认分页大小 | int |
| ${table.versionColumn} | 乐观锁版本号字段名 | String |
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

## 附录
### Hibernate Validator分组校验说明
- 针对数据插入操作，根据 InsertGroup 分组进行校验；
- 针对数据更新操作，根据 UpdateGroup 分组进行校验；
- 其它的共有校验规则(如字段长度限制等)，根据 Default 分组进行校验；

### 处理Hibernate Validator校验异常
通过 @ExceptionHandler 捕获 MethodArgumentNotValidException 和 BindException 异常即可。

区别：
- 如果使用表单对象(Form)形式接收参数(如查询操作)，则出现 BindException 异常
- 如果使用 @RequestBody 形式接收参数(如插入操作)，则出现 MethodArgumentNotValidException 异常

参考代码：
```java
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    @ResponseBody
    public String errorHandler(Exception ex) {
        if (ex instanceof MethodArgumentNotValidException) {
            MethodArgumentNotValidException me = (MethodArgumentNotValidException) ex;
            return getFieldErrors(me.getBindingResult().getFieldErrors());
        } else if (ex instanceof BindException) {
            BindException be = (BindException) ex;
            return getFieldErrors(be.getBindingResult().getFieldErrors());
        } else {
            return ex.getMessage();
        }
    }

    private String getFieldErrors(List<FieldError> fieldErrors) {
        String msg = "error";
        if (!fieldErrors.isEmpty()) {
            List<String> errorMsgs = fieldErrors.stream().map(FieldError::getDefaultMessage).distinct().collect(Collectors.toList());
            msg = String.join(";", errorMsgs);
        }
        return msg;
    }
}
```
默认情况下 Hibernate Validator 使用普通模式：校验器会校验完所有的属性，然后返回所有的验证错误信息。

如果希望使用 Fail-fast(快速失败) 模式，则需要增加额外配置：
```java
@Configuration
public class HibernateValidatorConfig {
    public HibernateValidatorConfig() {
    }

    @Bean
    public Validator myValidatorFactory() {
        ValidatorFactory validatorFactory = Validation.byProvider(HibernateValidator.class).configure().failFast(true).buildValidatorFactory();
        return validatorFactory.getValidator();
    }
}
```
使用该模式之后，当校验器遇到第1个不满足条件的参数时就立即结束校验工作，只返回这一个参数对应的错误信息。

### SwaggerUI配置参考
```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build();
    }
}
```

### 第三方依赖
自动生成的代码中用到了一些第三方开源组件，它们的maven坐标如下(版本号请自行匹配)：
```xml
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

### 数据库版本
实际单元测试中用到的数据库版本：
- Oracle 11g
- MySQL 5.5/5.6/5.7/5.8
- MariaDB 10.2.x/10.3.x/10.4.x
- Microsoft SQL Server 2008 R2
- PostgreSQL 12.3
- Percona Server(未实际测试，理论上也兼容)