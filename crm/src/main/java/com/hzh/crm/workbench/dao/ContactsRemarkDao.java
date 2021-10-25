package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.ContactsRemark;

public interface ContactsRemarkDao {
    
    /**
     * 新增一条联系人备注的信息
     * @param contactsRemark 联系人备注信息
     * @return 新增成功返回1
     */
    int saveContactsRemark(ContactsRemark contactsRemark);
}
