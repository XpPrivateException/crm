package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {
    
    /**
     * 根据名称，查询客户
     * @param name 客户的名称就是公司的名称
     * @return 查询到的客户，没有查询到则为null
     */
    Customer selectCustomerByName(String name);
    
    /**
     * 新增一条客户信息
     * @param customer 客户对象
     * @return 添加成功，返回1
     */
    int saveCustomer(Customer customer);
    
    /**
     * 根据名称模糊查询相似的名称信息
     * @param name 给定的字符串
     * @return 查询到的名称集合
     */
    List<String> getCustomerName(String name);
}
