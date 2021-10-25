package com.hzh.crm.workbench.service.impl;

import com.hzh.crm.utils.SqlSessionUtil;
import com.hzh.crm.workbench.dao.CustomerDao;
import com.hzh.crm.workbench.domain.Customer;
import com.hzh.crm.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    
    //模糊查询客户名称
    @Override
    public List<String> getCustomerName(String name) {
        System.out.println("enter getCustomerNameService!");
        //调用dao
        List<String> customerNameList = customerDao.getCustomerName(name);
        return customerNameList;
    }
}
