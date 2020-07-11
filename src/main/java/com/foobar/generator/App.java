package com.foobar.generator;

import com.foobar.generator.constant.GeneratorConst;
import com.foobar.generator.generator.TableCodeGenerator;
import com.foobar.generator.info.JdbcInfo;

/**
 * 入口类
 */
public class App {

    public static void main(String[] args) throws Exception {
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
    }
}
