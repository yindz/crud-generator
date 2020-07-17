package com.foobar.generator;

import com.foobar.generator.constant.GeneratorConst;
import com.foobar.generator.generator.TableCodeGenerator;
import com.foobar.generator.info.JdbcInfo;
import com.foobar.generator.info.RunParam;
import com.foobar.generator.info.TableContext;

/**
 * 入口类
 */
public class App {

    public static void main(String[] args) throws Exception {
        //指定数据库类型
        String dbType = GeneratorConst.MYSQL;

        //数据库主机名或IP
        String host = "localhost";

        //数据库端口号
        String port = "3306";

        //schema名称(oracle填写Schema名称，mysql则填写数据库名称)
        String schema = "bizdb";

        //数据库用户名
        String username = "root";

        //数据库用户密码
        String password = "123456";

        //数据库实例名(oracle填写实例名，mysql留空)
        String serviceName = "";

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

        RunParam rp = new RunParam();
        //java基础包名
        rp.setBasePkgName("com.foobar.bizapp");
        //输出目录的绝对路径(留空则生成到当前用户主目录)
        rp.setOutputPath("E:\\tmp\\generated");

        //表名
        TableContext table = TableContext.withName("t_article_attachment");
        //需去掉的表名前缀(留空不去掉任何前缀)
        table.setTableNamePrefixToRemove("t_");
        rp.addTable(table);

        //generator.setGlobalTableNamePrefixToRemove("t_");

        //默认使用 Spring 的 @Service 注解。如果需要使用 Dubbo 的@Service注解，请设置该值为true
        generator.setUseDubboService(true);

        //生成
        generator.run(rp);
    }
}
