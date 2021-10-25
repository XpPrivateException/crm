package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.ContactsActivityRelation;

public interface ContactsActivityRelationDao {
    
    /**
     * 新增一条关系，指定联系人和市场活动
     * @param contactsActivityRelation 关系数据
     * @return 新增成功，返回1
     */
    int saveRelation(ContactsActivityRelation contactsActivityRelation);
}
