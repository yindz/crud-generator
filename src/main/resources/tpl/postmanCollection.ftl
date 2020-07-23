{
  "info": {
    "_postman_id": "${uuid()}",
    "name": "${table.comments}服务API接口",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "分页查询${table.comments}数据",
      "event": [
        {
          "listen": "test",
          "script": {
            "id": "${uuid()}",
            "exec": [
              ""
            ],
            "type": "text/javascript"
          }
        }
      ],
      "protocolProfileBehavior": {
        "disableBodyPruning": true
      },
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/x-www-form-urlencoded"
          }
        ],
        "body": {
          "mode": "urlencoded",
          "urlencoded": []
        },
        "url": {
          "raw": "{{baseURL}}/${table.javaClassNameLower}/get${table.javaClassName}List",
          "host": [
            "{{baseURL}}"
          ],
          "path": [
            "${table.javaClassNameLower}",
            "get${table.javaClassName}List"
          ],
          "query": [
            <#list table.columns as column>
            {
              "key": "${column.columnCamelNameLower}",
              "value": "",
              "description": "${column.columnComment!''}"
            }<#if column?has_next>,</#if>
            </#list>,
            {
              "key": "pageNo",
              "value": "1",
              "description": "页码"
            },
            {
              "key": "pageSize",
              "value": "10",
              "description": "分页大小"
            }
          ]
        }
      },
      "response": []
    },

    {
      "name": "插入${table.comments}数据",
      "event": [
        {
          "listen": "test",
          "script": {
            "id": "${uuid()}",
            "exec": [
              ""
            ],
            "type": "text/javascript"
          }
        }
      ],
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json; charset=utf-8"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n<#list table.columns as column><#if column.isPrimaryKey == 0>    \"${column.columnCamelNameLower}\": \"\"<#if column?has_next>,\n</#if></#if></#list>\n}",
          "options": {
              "raw": {
                "language": "json"
              }
          }
        },
        "url": {
          "raw": "{{baseURL}}/${table.javaClassNameLower}/insert",
          "host": [
            "{{baseURL}}"
          ],
          "path": [
            "${table.javaClassNameLower}",
            "insert"
          ]
        }
      },
      "response": []
    },

    {
      "name": "更新${table.comments}数据",
      "event": [
        {
          "listen": "test",
          "script": {
            "id": "${uuid()}",
            "exec": [
              ""
            ],
            "type": "text/javascript"
          }
        }
      ],
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json; charset=utf-8"
          }
        ],
        "body": {
            "mode": "raw",
            "raw": "{\n<#list table.columns as column>    \"${column.columnCamelNameLower}\": \"\"<#if column?has_next>,\n</#if></#list>\n}",
            "options": {
                "raw": {
                "language": "json"
                }
            }
        },
        "url": {
          "raw": "{{baseURL}}/${table.javaClassNameLower}/update",
          "host": [
            "{{baseURL}}"
          ],
          "path": [
            "${table.javaClassNameLower}",
            "update"
          ]
        }
      },
      "response": []
    },

    {
      "name": "删除${table.comments}数据",
      "event": [
        {
          "listen": "test",
          "script": {
            "id": "${uuid()}",
            "exec": [
              ""
            ],
            "type": "text/javascript"
          }
        }
      ],
      "request": {
        "method": "DELETE",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/x-www-form-urlencoded"
          }
        ],
        "body": {
          "mode": "urlencoded",
          "urlencoded": [
            <#list table.columns as column>
            <#if column.isPrimaryKey == 1>{
              "key": "${column.columnCamelNameLower}",
              "value": "",
              "description": "${column.columnComment!''}"
            }</#if>
            </#list>
          ]
        },
        "url": {
          "raw": "{{baseURL}}/${table.javaClassNameLower}/delete",
          "host": [
            "{{baseURL}}"
          ],
          "path": [
            "${table.javaClassNameLower}",
            "delete"
          ]
        }
      },
      "response": []
    }

  ],
  "protocolProfileBehavior": {}
}