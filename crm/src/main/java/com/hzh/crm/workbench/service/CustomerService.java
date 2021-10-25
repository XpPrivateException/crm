package com.hzh.crm.workbench.service;

import java.util.List;

public interface CustomerService {
    /**
     * 根据字符串模糊查询
     * @param name 字符串
     * @return 查询到的所有相关的客户的名称集合
     */
    List<String> getCustomerName(String name);
}
