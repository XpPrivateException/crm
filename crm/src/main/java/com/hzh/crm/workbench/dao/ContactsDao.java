package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.Contacts;

public interface ContactsDao {
    
    /**
     * 新增一个联系人信息
     * @param contacts 联系人独享
     * @return 添加成功返回1
     */
    int saveContacts(Contacts contacts);
}
