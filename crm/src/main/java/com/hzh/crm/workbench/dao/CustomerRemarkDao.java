package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.CustomerRemark;

public interface CustomerRemarkDao {
    
    /**
     * 新增一条客户备注信息
     * @param customerRemark 客户备注
     * @return 添加成功，则返回1
     */
    int saveCustomerRemark(CustomerRemark customerRemark);
}
