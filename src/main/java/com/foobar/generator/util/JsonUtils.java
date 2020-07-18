package com.foobar.generator.util;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.foobar.generator.config.GeneratorConfig;
import com.foobar.generator.info.TemplateInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

/**
 * JSON工具
 *
 * @author yin
 */
public class JsonUtils {
    private static final Logger logger = LoggerFactory.getLogger(JsonUtils.class);

    private static final ObjectMapper mapper = new ObjectMapper();

    static {
        mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
    }

    /**
     * 解析json字符串为对象
     *
     * @param json 待解析的json字符串
     * @param type 类型
     * @param <T>  泛型类型
     * @return 对象
     */
    public static <T> T readAsObject(String json, Class<T> type) {
        try {
            return mapper.readValue(json, type);
        } catch (IOException e) {
            logger.error("解析json出现异常", e);
        }
        return null;
    }

    /**
     * 读取资源文件
     *
     * @param jsonFile 资源文件名
     * @param clazz    类
     * @param <T>      泛型
     * @return 泛型对象列表
     */
    public static <T> List<T> readResourceAsList(String jsonFile, Class<T> clazz) {
        InputStream ins = JsonUtils.class.getClassLoader().getResourceAsStream(jsonFile);
        if (ins == null) {
            throw new RuntimeException("无法读取JSON文件" + jsonFile);
        }
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(ins));
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                json.append(line);
            }
            return readAsList(json.toString(), clazz);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                ins.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 解析json字符串为List
     *
     * @param json  待解析的json字符串
     * @param clazz 类
     * @param <T>   泛型
     * @return list实例
     */
    public static <T> List<T> readAsList(String json, Class<T> clazz) {
        try {
            CollectionType collectionType = mapper.getTypeFactory().constructCollectionType(List.class, clazz);
            return mapper.readValue(json, collectionType);
        } catch (IOException e) {
            logger.error("解析json出现异常", e);
        }
        return null;
    }

    /**
     * 对象转换为json
     *
     * @param obj      对象
     * @param beautify 是否美化格式
     * @return json字符串
     */
    public static String toJson(Object obj, boolean beautify) {
        try {
            return beautify ? mapper.writerWithDefaultPrettyPrinter().writeValueAsString(obj) : mapper.writeValueAsString(obj);
        } catch (IOException e) {
            logger.error("生成json出现异常", e);
        }
        return null;
    }
}
