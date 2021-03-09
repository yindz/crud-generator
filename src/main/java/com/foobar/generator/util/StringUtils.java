package com.foobar.generator.util;

import com.foobar.generator.constant.GeneratorConst;
import org.apache.commons.text.CaseUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * 字符串工具类
 *
 * @author yin
 */
public class StringUtils extends org.apache.commons.lang3.StringUtils {
    private static final Logger logger = LoggerFactory.getLogger(StringUtils.class);

    /**
     * 数据库标识符格式：以字母开头，可以包含字母、数字、下划线，长度2~30个字符
     */
    private static final Pattern IDENTIFIER = Pattern.compile("^[a-zA-Z][a-zA-Z0-9_]{1,29}$");

    /**
     * 下划线转驼峰
     *
     * @param underlineStr          下划线字符串
     * @param capitalizeFirstLetter 结果首字母是否大写
     * @return 驼峰字符串
     */
    public static String underlineToCamel(String underlineStr, boolean capitalizeFirstLetter) {
        if (isBlank(underlineStr)) {
            return underlineStr;
        }
        return CaseUtils.toCamelCase(underlineStr, capitalizeFirstLetter, '_');
    }

    /**
     * 解析整数
     *
     * @param src 原字符串
     * @return 整数
     */
    public static int parseInt(String src) {
        if (isBlank(src)) {
            return 0;
        }
        try {
            return Integer.parseInt(src);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 加载SQL语句
     *
     * @param xmlFile
     * @param map
     */
    public static void loadSqlFile(String xmlFile, Map<String, String> map) {
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder dbd = dbf.newDocumentBuilder();
            Document doc = dbd.parse(GeneratorConst.class.getResourceAsStream(xmlFile));
            if (doc == null) {
                logger.error("SQL配置文件{}不存在!", xmlFile);
                return;
            }
            XPathFactory f = XPathFactory.newInstance();
            XPath path = f.newXPath();
            NodeList nodes = (NodeList) path.evaluate("sql/select", doc, XPathConstants.NODESET);
            if (nodes == null || nodes.getLength() == 0) {
                logger.error("SQL配置文件{}有效内容为空!", xmlFile);
                return;
            }
            for (int i = 0; i < nodes.getLength(); i++) {
                Node node = nodes.item(i);
                if (node == null) {
                    continue;
                }
                NamedNodeMap attr = node.getAttributes();
                Node id = attr.getNamedItem("id");
                if (id != null && isNotBlank(id.getNodeValue())) {
                    String content = node.getTextContent();
                    if (isNotBlank(content)) {
                        map.put(id.getNodeValue(), StringUtils.trim(content));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 拆分字符串并转换成Set
     *
     * @param src 待拆分的字符串
     * @param sep 分隔符
     * @return Set
     */
    public static Set<String> splitToSet(String src, String sep) {
        Set<String> resultSet = new HashSet<>();
        if (isBlank(src) || isBlank(sep)) {
            return resultSet;
        }
        String[] tmp = split(deleteWhitespace(src), sep);
        if (tmp.length == 0) {
            return resultSet;
        }
        return Arrays.stream(tmp).filter(StringUtils::isNotBlank).collect(Collectors.toSet());
    }

    /**
     * 校验是否为有效的数据库标识符
     *
     * @param identifier 数据库标识符
     * @return 是否为有效的数据库标识符
     */
    public static boolean isValidIdentifier(String identifier) {
        if (isBlank(identifier)) {
            return false;
        }
        return IDENTIFIER.matcher(identifier).matches();
    }
}
