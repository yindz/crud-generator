package com.foobar.generator.util;

import com.foobar.generator.constant.GeneratorConst;
import org.apache.commons.text.CaseUtils;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.util.Map;

/**
 * 字符串工具类
 *
 * @author yin
 */
public class StringUtils extends org.apache.commons.lang3.StringUtils {

    /**
     * 下划线转驼峰
     *
     * @param underlineStr          下划线字符串
     * @param capitalizeFirstLetter 结果首字母是否大写
     * @return 驼峰字符串
     */
    public static String underlineToCamel(String underlineStr, boolean capitalizeFirstLetter) {
        if (isEmpty(underlineStr)) {
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
        if (StringUtils.isEmpty(src)) {
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
    public static void loadSqlFile(String xmlFile, Map<String, String> map){
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder dbd = dbf.newDocumentBuilder();
            Document doc = dbd.parse(GeneratorConst.class.getResourceAsStream(xmlFile));
            XPathFactory f = XPathFactory.newInstance();
            XPath path = f.newXPath();
            NodeList nodes = (NodeList) path.evaluate("sql/select", doc, XPathConstants.NODESET);
            for (int i = 0; i < nodes.getLength(); i++) {
                Node node = nodes.item(i);
                if (node == null) {
                    continue;
                }
                NamedNodeMap attr = node.getAttributes();
                Node id = attr.getNamedItem("id");
                if (id != null) {
                    map.put(id.getNodeValue(), node.getTextContent());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
