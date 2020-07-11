package com.foobar.generator.config;

import com.foobar.generator.constant.GeneratorConst;
import com.foobar.generator.info.TemplateInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * 配置
 *
 * @author yin
 */
public class GeneratorConfig {

    /**
     * 核心模板
     */
    public final static List<TemplateInfo> coreTemplateList = new ArrayList<>();

    /**
     * 其它模板
     */
    public final static List<TemplateInfo> otherTemplateList = new ArrayList<>();

    static {
        //适用于原版mybatis的实体类定义
        TemplateInfo entity = new TemplateInfo();
        entity.setTemplateName("entity.ftl");
        entity.setTargetPkgName("entity");
        entity.setTargetFileName(GeneratorConst.PLACEHOLDER + ".java");
        coreTemplateList.add(entity);

        //VO
        TemplateInfo vo = new TemplateInfo();
        vo.setTemplateName("vo.ftl");
        vo.setTargetPkgName("vo");
        vo.setTargetFileName(GeneratorConst.PLACEHOLDER + "VO.java");
        coreTemplateList.add(vo);

        //DTO
        TemplateInfo dto = new TemplateInfo();
        dto.setTemplateName("dto.ftl");
        dto.setTargetPkgName("dto");
        dto.setTargetFileName(GeneratorConst.PLACEHOLDER + "DTO.java");
        coreTemplateList.add(dto);

        //适用于mybatis通用Mapper的实体类定义
        TemplateInfo tkDomain = new TemplateInfo();
        tkDomain.setTemplateName("tkDomain.ftl");
        tkDomain.setTargetPkgName("domain");
        tkDomain.setTargetFileName(GeneratorConst.PLACEHOLDER + "DO.java");
        coreTemplateList.add(tkDomain);

        //适用于原版mybatis的Mapper XML
        TemplateInfo mapperXml = new TemplateInfo();
        mapperXml.setTemplateName("mapperXml.ftl");
        mapperXml.setTargetPkgName("dao");
        mapperXml.setTargetFileName(GeneratorConst.PLACEHOLDER + "Mapper.xml");
        coreTemplateList.add(mapperXml);

        //适用于原版mybatis的Mapper接口
        TemplateInfo mapperClass = new TemplateInfo();
        mapperClass.setTemplateName("mapperClass.ftl");
        mapperClass.setTargetPkgName("dao");
        mapperClass.setTargetFileName(GeneratorConst.PLACEHOLDER + "Mapper.java");
        otherTemplateList.add(mapperClass);

        //适用于mybatis通用Mapper的Mapper接口
        TemplateInfo tkMapperClass = new TemplateInfo();
        tkMapperClass.setTemplateName("tkMapperClass.ftl");
        tkMapperClass.setTargetPkgName("dao");
        tkMapperClass.setTargetFileName(GeneratorConst.PLACEHOLDER + "CommonMapper.java");
        otherTemplateList.add(tkMapperClass);

        //适用于mybatis通用Mapper的Mapper XML
        TemplateInfo tkMapperXml = new TemplateInfo();
        tkMapperXml.setTemplateName("tkMapperXml.ftl");
        tkMapperXml.setTargetPkgName("dao");
        tkMapperXml.setTargetFileName(GeneratorConst.PLACEHOLDER + "CommonMapper.xml");
        otherTemplateList.add(tkMapperXml);

        //服务接口定义
        TemplateInfo serviceInterface = new TemplateInfo();
        serviceInterface.setTemplateName("serviceInterface.ftl");
        serviceInterface.setTargetPkgName("service");
        serviceInterface.setTargetFileName("I" + GeneratorConst.PLACEHOLDER + "Service.java");
        otherTemplateList.add(serviceInterface);

        //适用于原版mybatis的服务接口实现
        TemplateInfo serviceImpl = new TemplateInfo();
        serviceImpl.setTemplateName("serviceImpl.ftl");
        serviceImpl.setTargetPkgName("service");
        serviceImpl.setTargetFileName(GeneratorConst.PLACEHOLDER + "ServiceImpl.java");
        otherTemplateList.add(serviceImpl);

        //适用于mybatis通用Mapper的服务接口实现
        TemplateInfo tkServiceImpl = new TemplateInfo();
        tkServiceImpl.setTemplateName("tkServiceImpl.ftl");
        tkServiceImpl.setTargetPkgName("service");
        tkServiceImpl.setTargetFileName("Tk" + GeneratorConst.PLACEHOLDER + "ServiceImpl.java");
        otherTemplateList.add(tkServiceImpl);

        //控制器
        TemplateInfo controller = new TemplateInfo();
        controller.setTemplateName("controller.ftl");
        controller.setTargetPkgName("controller");
        controller.setTargetFileName(GeneratorConst.PLACEHOLDER + "Controller.java");
        otherTemplateList.add(controller);

        //Postman Collection 定义文件
        TemplateInfo postman = new TemplateInfo();
        postman.setTemplateName("postmanCollection.ftl");
        postman.setTargetPkgName("postman");
        postman.setTargetFileName(GeneratorConst.PLACEHOLDER + ".postman_collection.json");
        otherTemplateList.add(postman);

        //Postman Environment 定义文件
        TemplateInfo postmanEnv = new TemplateInfo();
        postmanEnv.setTemplateName("postmanEnvironment.ftl");
        postmanEnv.setTargetPkgName("postman");
        postmanEnv.setTargetFileName(GeneratorConst.PLACEHOLDER + ".postman_environment.json");
        otherTemplateList.add(postmanEnv);
    }

}
