package com.foobar.generator.generator;

import com.foobar.generator.config.GeneratorConfig;
import com.foobar.generator.constant.DaoType;
import com.foobar.generator.constant.DatabaseType;
import com.foobar.generator.constant.GeneratorConst;
import com.foobar.generator.db.AbstractDbUtil;
import com.foobar.generator.info.*;
import com.foobar.generator.util.StringUtils;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.apache.commons.text.WordUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.awt.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 数据表代码生成器
 *
 * @author yin
 */
public class TableCodeGenerator {
    private static final Logger logger = LoggerFactory.getLogger(TableCodeGenerator.class);

    /**
     * 数据库类型
     */
    private final String dbType;

    /**
     * DAO层中间件类型
     */
    private DaoType daoType;

    /**
     * 线程池
     */
    private ExecutorService threadPool;

    /**
     * 模板缓存
     */
    private final Map<String, Template> TEMPLATE_MAP = new HashMap<>();

    /**
     * 数据库SCHEMA名称
     */
    private final String schemaName;

    /**
     * 模板配置
     */
    private final Configuration conf;

    /**
     * 所有表名
     */
    private final List<String> allTableNamesList;

    /**
     * 表字段缓存
     */
    private final Map<String, List<ColumnInfo>> columnsMap = new HashMap<>();

    /**
     * 当前用户名
     */
    private String currentUser;

    /**
     * java包名
     */
    private String pkgName;

    /**
     * 数据库操作工具
     */
    private final AbstractDbUtil dbUtil;

    /**
     * 是否生成所有
     */
    private boolean generateAll = true;

    /**
     * 是否生成Dubbo Service
     */
    private boolean useDubboService = false;

    /**
     * 基础输出路径
     */
    private String baseOutputPath;

    /**
     * 待删除的表名前缀(全局)
     */
    private String globalTableNamePrefixToRemove;

    /**
     * 是否启用swagger
     */
    private boolean useSwagger = true;

    /**
     * 基础实体类名
     */
    private String baseEntityClass;

    /**
     * 返回结果类路径
     */
    private String resultClass;

    /**
     * 类名生成函数
     */
    private Function<String, String> classNameGenerator;

    /**
     * 是否生成所有代码
     * 当数据表字段发生变化后需要重新生成代码时，可设置为false，只生成实体类、XML等核心代码
     *
     * @param generateAll 是否生成所有代码
     */
    public void setGenerateAll(boolean generateAll) {
        this.generateAll = generateAll;
    }

    /**
     * 默认使用 Spring 的 @Service 注解
     * 如果需要换成 Dubbo 的 @Service 注解，请设置该值为true
     *
     * @param useDubboService 是否使用Dubbo 的 @Service 注解
     */
    public void setUseDubboService(boolean useDubboService) {
        this.useDubboService = useDubboService;
    }

    /**
     * 设置全局的待删除表名前缀
     *
     * @param prefixToRemove 全局待删除表名前缀
     */
    public void setGlobalTableNamePrefixToRemove(String prefixToRemove) {
        this.globalTableNamePrefixToRemove = StringUtils.trim(prefixToRemove);
    }

    /**
     * 是否启用Swagger
     *
     * @param useSwagger
     */
    public void setUseSwagger(boolean useSwagger) {
        this.useSwagger = useSwagger;
    }

    /**
     * 配置DAO层中间件类型
     *
     * @param daoType
     */
    public void setDaoType(DaoType daoType) {
        this.daoType = daoType;
    }

    /**
     * 配置自定义的类名生成函数
     *
     * @param classNameGenerator
     */
    public void setClassNameGenerator(Function<String, String> classNameGenerator) {
        this.classNameGenerator = classNameGenerator;
    }

    /**
     * 构造函数
     *
     * @param jdbcInfo JDBC参数
     */
    public TableCodeGenerator(JdbcInfo jdbcInfo) throws Exception {
        if (jdbcInfo == null) {
            throw new Exception("JDBC参数为null");
        }
        if (jdbcInfo.getDbType() == null) {
            throw new Exception("数据库类型为空");
        }
        dbType = jdbcInfo.getDbType().toLowerCase();
        DbUtilInfo dbUtilInfo = GeneratorConfig.dbUtilMap.get(dbType);
        if (dbUtilInfo == null) {
            throw new Exception("暂不支持该数据库类型");
        }
        dbUtil = (AbstractDbUtil) Class.forName(dbUtilInfo.getClassName()).newInstance();
        try {
            dbUtil.init(jdbcInfo);
        } catch (Exception e) {
            logger.error("初始化数据库连接时发生异常", e);
            throw new Exception("初始化数据库连接时发生异常");
        }
        if (daoType == null) {
            daoType = DaoType.MyBatis;
        }
        this.schemaName = jdbcInfo.getSchema();
        allTableNamesList = getAllTableNames(schemaName);
        if (allTableNamesList == null || allTableNamesList.isEmpty()) {
            throw new Exception("该数据库没有表");
        }
        logger.info("数据库中有 {} 张表", allTableNamesList.size());
        //初始化模板
        conf = new Configuration(Configuration.VERSION_2_3_28);
        conf.setClassForTemplateLoading(this.getClass(), "/");
        conf.setNumberFormat("#");

        //获取当前用户名
        currentUser = System.getenv().get("USERNAME");
    }

    /**
     * 生成文件
     *
     * @param runParam 运行参数
     */
    public void run(RunParam runParam) throws Exception {
        if (runParam == null) {
            throw new IllegalArgumentException("运行参数为空");
        }
        long begin = System.currentTimeMillis();
        checkDir(runParam.getOutputPath());
        this.pkgName = StringUtils.trim(runParam.getBasePkgName());
        if (StringUtils.isBlank(this.pkgName)) {
            this.pkgName = GeneratorConst.DEFAULT_PKG_NAME;
            logger.warn("将使用默认的包名: {}", this.pkgName);
        }
        if (StringUtils.isNotBlank(runParam.getAuthor())) {
            this.currentUser = runParam.getAuthor();
        }
        if (StringUtils.isNotBlank(runParam.getBaseEntityClass())) {
            this.baseEntityClass = StringUtils.trim(runParam.getBaseEntityClass());
        }
        if (StringUtils.isNotBlank(runParam.getResultClass())) {
            this.resultClass = StringUtils.trim(runParam.getResultClass());
        }
        List<TableContext> tablesToSubmit = findTablesToSubmit(runParam.getTableContexts());
        logger.info("本次将生成 {} 张表的代码", tablesToSubmit.size());

        //线程数不超过CPU核心数
        int cpus = Runtime.getRuntime().availableProcessors();
        threadPool = Executors.newFixedThreadPool(Math.min(tablesToSubmit.size(), cpus));

        prepareColumnsCache(tablesToSubmit);
        dbUtil.clean();
        tablesToSubmit.forEach(t -> threadPool.execute(() -> generateTableCodeFiles(t)));
        threadPool.shutdown();
        while (!threadPool.awaitTermination(500, TimeUnit.MILLISECONDS)) {
            logger.debug("等待线程池关闭");
        }
        logger.info("代码已生成到 {}, 耗时 {} 毫秒, 总计 {} 张表", runParam.getOutputPath(), System.currentTimeMillis() - begin, tablesToSubmit.size());
        //代码生成完毕后自动打开相应的目录
        Desktop.getDesktop().open(new File(this.baseOutputPath));
    }

    /**
     * 获取所有表名
     *
     * @param schemaName SCHEMA名称
     * @return SCHEMA下面所有表名
     */
    private List<String> getAllTableNames(String schemaName) {
        return this.dbUtil.getAllTableNames(schemaName);
    }

    /**
     * 获取字段信息
     *
     * @param table 表
     * @return 表所有字段
     */
    private List<ColumnInfo> getColumnInfo(TableContext table) {
        List<ColumnInfo> resultList = dbUtil.getColumnInfo(table.getTableName());
        if (resultList != null && !resultList.isEmpty()) {
            Set<String> likeColumns = StringUtils.splitToSet(table.getLikeColumns(), ",");
            Set<String> rangeColumns = StringUtils.splitToSet(table.getRangeColumns(), ",");
            Set<String> inColumns = StringUtils.splitToSet(table.getInColumns(), ",");
            boolean hasPrimaryKey = resultList.stream().anyMatch(r -> GeneratorConst.YES == r.getIsPrimaryKey());
            if (!hasPrimaryKey && StringUtils.isEmpty(table.getPrimaryKeyColumn())) {
                throw new IllegalArgumentException("数据表 " + table.getTableName() + " 无主键及唯一索引字段，请手动指定primaryKeyColumn参数值");
            }
            resultList.forEach(c -> {
                if (c == null) {
                    return;
                }
                c.setColumnCamelNameLower(StringUtils.underlineToCamel(c.getColumnName(), false));
                c.setColumnCamelNameUpper(StringUtils.underlineToCamel(c.getColumnName(), true));
                c.setColumnJavaType(GeneratorConst.javaBoxTypeMap.get(c.getColumnType().toLowerCase()));
                if (StringUtils.isEmpty(c.getColumnJavaType())) {
                    throw new RuntimeException("数据库字段类型 " + c.getColumnType() + " 无法映射到Java类型");
                }
                if ("Date".equalsIgnoreCase(c.getColumnJavaType())) {
                    c.setIsDateTime(GeneratorConst.YES);
                }
                c.setColumnMyBatisType(GeneratorConst.mybatisTypeMap.get(c.getColumnType().toLowerCase()));
                if (StringUtils.isEmpty(c.getColumnMyBatisType())) {
                    throw new RuntimeException("数据库字段类型 " + c.getColumnType() + " 无法映射到MyBatis JdbcType");
                }
                if (c.getIsNumber() == GeneratorConst.YES) {
                    if (c.getColumnScale() > 0) {
                        //有小数的时候：Java类中统一使用BigDecimal类型，MybatisXML中jdbcType统一使用DECIMAL类型
                        c.setColumnJavaType("BigDecimal");
                        c.setColumnMyBatisType("DECIMAL");
                    }
                }
                if (StringUtils.isEmpty(c.getColumnComment())) {
                    c.setColumnComment(c.getColumnName());
                }
                if (!hasPrimaryKey) {
                    //如果无法自动检测到任何主键字段，则使用上下文指定的主键字段
                    if (c.getColumnName().equalsIgnoreCase(table.getPrimaryKeyColumn())) {
                        c.setIsPrimaryKey(GeneratorConst.YES);
                    }
                }
                if (!likeColumns.isEmpty() && likeColumns.contains(c.getColumnName()) && c.getIsChar() == GeneratorConst.YES) {
                    c.setEnableLike(GeneratorConst.YES);
                }
                if (!rangeColumns.isEmpty() && rangeColumns.contains(c.getColumnName())) {
                    //仅时间类型和数字类型支持按范围查询
                    if (c.getIsDateTime() == GeneratorConst.YES || c.getIsNumber() == GeneratorConst.YES) {
                        c.setEnableRange(GeneratorConst.YES);
                    }
                }
                if (inColumns.contains(c.getColumnName())) {
                    c.setEnableIn(GeneratorConst.YES);
                }
            });
            logger.info("数据表 {} 包含 {} 个字段", table.getTableName(), resultList.size());
        }
        return resultList;
    }

    /**
     * 检查目录
     *
     * @param outputPath 输出路径
     */
    private void checkDir(String outputPath) {
        if (outputPath == null) {
            throw new IllegalArgumentException("输出路径为空");
        }
        if (!outputPath.endsWith(File.separator)) {
            outputPath += File.separator;
        }
        File outputDir = new File(outputPath);
        if (outputDir.exists()) {
            if (!outputDir.isDirectory()) {
                throw new RuntimeException("路径" + outputPath + "不是一个目录");
            }
        } else {
            if (!outputDir.mkdirs()) {
                throw new RuntimeException("创建目录" + outputPath + "失败");
            }
        }
        this.baseOutputPath = outputPath;
        //初始化各个目录
        GeneratorConfig.coreTemplateList.forEach(this::checkSubDir);
        if (this.generateAll) {
            GeneratorConfig.otherTemplateList.forEach(this::checkSubDir);
        }
    }

    /**
     * 检查子目录
     *
     * @param ti 模板
     */
    private void checkSubDir(TemplateInfo ti) {
        if (ti == null || StringUtils.isEmpty(ti.getTargetBaseDirName())) {
            return;
        }
        String realPath = ti.toRealPath(this.baseOutputPath);
        Path path = Paths.get(realPath);
        if (!path.toFile().exists()) {
            try {
                Files.createDirectories(path);
            } catch (IOException e) {
                logger.error("无法创建目录{}", realPath, e);
                throw new RuntimeException("创建目录" + realPath + "失败");
            }
        }
    }

    /**
     * 返回需要处理的表
     *
     * @param tableContexts 操作者传入的表
     * @return 需要处理的表
     */
    private List<TableContext> findTablesToSubmit(Set<TableContext> tableContexts) {
        if (tableContexts == null || tableContexts.isEmpty()) {
            //空则返回全部
            List<TableContext> allTableContextList = new ArrayList<>();
            allTableNamesList.forEach(a -> {
                if (StringUtils.isEmpty(a)) {
                    return;
                }
                TableContext tc = new TableContext();
                tc.setTableName(a);
                allTableContextList.add(tc);
            });
            return allTableContextList;
        }
        List<TableContext> currentTableContextList = new ArrayList<>();
        tableContexts.forEach(t -> {
            if (t == null) {
                return;
            }
            if (allTableNamesList.contains(t.getTableName())) {
                currentTableContextList.add(t);
            }
        });
        return currentTableContextList;
    }

    /**
     * 准备好字段信息缓存
     *
     * @param tablesToSubmit 待处理的表
     */
    private void prepareColumnsCache(List<TableContext> tablesToSubmit) {
        if (tablesToSubmit == null || tablesToSubmit.isEmpty()) {
            return;
        }
        tablesToSubmit.forEach(t -> {
            if (t == null) {
                return;
            }
            List<ColumnInfo> columnInfoList = getColumnInfo(t);
            if (columnInfoList == null || columnInfoList.isEmpty()) {
                return;
            }
            columnsMap.put(t.getTableName(), columnInfoList);
        });
    }

    /**
     * 生成数据表的所有代码文件
     *
     * @param table 表
     */
    private void generateTableCodeFiles(TableContext table) {
        if (table == null || StringUtils.isEmpty(table.getTableName())) {
            return;
        }
        List<ColumnInfo> columnInfoList = columnsMap.get(table.getTableName());
        if (columnInfoList == null || columnInfoList.isEmpty()) {
            logger.warn("数据表 {} 无字段, 跳过!", table.getTableName());
            return;
        }
        String simpleTableName = table.getTableName();
        //优先使用该表的前缀
        String prefixToRemove = StringUtils.trim(table.getTableNamePrefixToRemove());
        if (StringUtils.isEmpty(prefixToRemove) && StringUtils.isNotEmpty(globalTableNamePrefixToRemove)) {
            //再使用全局的表前缀
            prefixToRemove = globalTableNamePrefixToRemove;
        }
        if (StringUtils.isNotEmpty(prefixToRemove) && table.getTableName().startsWith(prefixToRemove)) {
            //去掉前缀后的表名
            simpleTableName = StringUtils.removeStart(table.getTableName(), prefixToRemove);
        }
        String javaClassName;
        if (this.classNameGenerator != null) {
            //使用自定义的类名生成函数
            javaClassName = this.classNameGenerator.apply(simpleTableName);
        } else {
            //默认:下划线转驼峰且首字母大写
            javaClassName = StringUtils.underlineToCamel(simpleTableName, true);
        }

        //表基本信息
        TableInfo tableInfo = new TableInfo();
        tableInfo.setDbType(dbType);
        //表名
        tableInfo.setName(table.getTableName());
        tableInfo.setKebabCaseName(simpleTableName.replaceAll("_", "-").toLowerCase());
        if (DatabaseType.ORACLE.getCode().equals(dbType)) {
            tableInfo.setSchemaName(schemaName);
        }

        //表注释
        tableInfo.setComments(StringUtils.trim(columnInfoList.get(0).getTableComment()));
        if (StringUtils.isBlank(tableInfo.getComments())) {
            tableInfo.setComments(tableInfo.getName());
        }
        //所有字段
        tableInfo.setColumns(columnInfoList);
        //java类名
        tableInfo.setJavaClassName(javaClassName);
        //java类名(首字母小写)
        tableInfo.setJavaClassNameLower(WordUtils.uncapitalize(javaClassName));

        //others
        tableInfo.setImports(generateImports(columnInfoList));
        tableInfo.setAuthor(currentUser);
        tableInfo.setVersionColumn(dbUtil.setTableNameCase(table.getVersionColumn()));
        tableInfo.setLogicDeleteColumn(dbUtil.setTableNameCase(table.getLogicDeleteColumn()));
        tableInfo.setPageSize(table.getPageSize());
        tableInfo.setSequenceName(table.getSequenceName());

        RenderData data = new RenderData();
        data.setBasePkgName(pkgName);
        data.setBaseEntityClass(baseEntityClass);
        data.setResultClass(resultClass);
        if (StringUtils.isNotBlank(resultClass)) {
            String[] tmp = resultClass.split("\\.");
            if (tmp.length > 0) {
                //截取类路径最后一段作为类名
                data.setResultClassName(tmp[tmp.length - 1]);
            }
        }
        data.setTable(tableInfo);
        data.setUuid((list) -> UUID.randomUUID());
        data.setUseDubboServiceAnnotation(this.useDubboService ? GeneratorConst.YES : GeneratorConst.NO);
        data.setUseSwagger(this.useSwagger ? GeneratorConst.YES : GeneratorConst.NO);

        //dao模板
        List<TemplateInfo> daoTemplateList;
        if (DaoType.TkMyBatis.equals(daoType)) {
            //MyBatis通用Mapper
            daoTemplateList = GeneratorConfig.coreTemplateList.stream().filter(x -> x.getTemplateName().startsWith(GeneratorConst.TK)).collect(Collectors.toList());
        } else if (DaoType.MyBatisPlus.equals(daoType)) {
            //MyBatisPlus
            daoTemplateList = GeneratorConfig.coreTemplateList.stream().filter(x -> x.getTemplateName().startsWith(GeneratorConst.MP)).collect(Collectors.toList());
        } else {
            //原版MyBatis
            daoTemplateList = GeneratorConfig.coreTemplateList.stream().filter(x -> x.getTemplateName().startsWith(GeneratorConst.ORIG)).collect(Collectors.toList());
        }

        //除dao以外的其它核心模板
        List<TemplateInfo> coreTemplateList = GeneratorConfig.coreTemplateList.stream().filter(x -> !x.getTemplateName().startsWith(GeneratorConst.ORIG)
                && !x.getTemplateName().startsWith(GeneratorConst.TK) && !x.getTemplateName().startsWith(GeneratorConst.MP)).collect(Collectors.toList());
        render(coreTemplateList, data, javaClassName);
        render(daoTemplateList, data, javaClassName);
        if (this.generateAll) {
            //非核心模板
            render(GeneratorConfig.otherTemplateList, data, javaClassName);
        }
        logger.info("数据表 {} 的代码已生成完毕", table.getTableName());
    }

    /**
     * 渲染
     *
     * @param templateInfoList
     * @param data
     * @param javaClassName
     */
    private void render(List<TemplateInfo> templateInfoList, RenderData data, String javaClassName) {
        if (templateInfoList == null || templateInfoList.isEmpty()) {
            return;
        }

        for (TemplateInfo ti : templateInfoList) {
            if (ti == null) {
                continue;
            }
            File dir = new File(ti.toRealPath(baseOutputPath));
            if (!dir.isDirectory()) {
                throw new RuntimeException("路径" + dir.getAbsolutePath() + "不是目录");
            }
            String out = dir.getAbsolutePath() + File.separator + ti.getTargetFileName().replace(GeneratorConst.PLACEHOLDER, javaClassName);
            if (ti.getOverwriteExistingFile() == GeneratorConst.NO) {
                File file = new File(out);
                if (file.exists()) {
                    logger.info("模板 {} 对应的目标输出文件 {} 已存在，因此不再重新生成该文件", ti.getTemplateName(), out);
                    continue;
                }
            }
            data.getTable().setPkgName(data.getBasePkgName() + "." + ti.getTargetPkgName());
            renderFile(getTemplate("tpl/" + ti.getTemplateName()), data, out);
        }
    }

    /**
     * 渲染文件
     *
     * @param tpl     模板
     * @param data    数据
     * @param outPath 输出路径
     * @throws Exception
     */
    private void renderFile(Template tpl, RenderData data, String outPath) {
        if (tpl == null || data == null || StringUtils.isEmpty(outPath)) {
            return;
        }
        Writer out;
        try {
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outPath)));
            tpl.process(data, out);
            logger.info("已生成代码文件 {}", outPath);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 生成Java类中import内容
     *
     * @param columnInfoList 字段信息列表
     * @return
     */
    private SortedSet<String> generateImports(List<ColumnInfo> columnInfoList) {
        SortedSet<String> imports = new TreeSet<>();
        if (columnInfoList == null || columnInfoList.isEmpty()) {
            return imports;
        }
        columnInfoList.forEach(c -> {
            if (c == null) {
                return;
            }
            String importStr = GeneratorConst.importsTypeMap.get(c.getColumnJavaType());
            if (StringUtils.isNotEmpty(importStr)) {
                imports.add(importStr);
            }
        });
        return imports;
    }

    /**
     * 获取模板
     *
     * @param name 模板文件名
     * @return
     */
    private Template getTemplate(String name) {
        return TEMPLATE_MAP.computeIfAbsent(name, k -> {
            try {
                return conf.getTemplate(k);
            } catch (IOException e) {
                logger.error("无法读取模板{}", name, e);
                throw new RuntimeException("无法读取模板");
            }
        });
    }
}
