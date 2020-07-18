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
    }
}
