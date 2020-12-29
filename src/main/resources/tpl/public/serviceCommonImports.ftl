import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
import com.google.common.base.Preconditions;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
<#if useDubboServiceAnnotation = 1>import org.apache.dubbo.config.annotation.Service;<#else>import org.springframework.stereotype.Service;</#if>

import ${basePkgName}.domain.${table.javaClassName}DO;
import ${basePkgName}.dto.${table.javaClassName}DTO;
import ${basePkgName}.dto.${table.javaClassName}QueryDTO;
import ${basePkgName}.util.${table.javaClassName}Converter;
import ${basePkgName}.service.I${table.javaClassName}Service;
import ${basePkgName}.dao.${table.javaClassName}Mapper;
