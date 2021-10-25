package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    
    /**
     * 新增一条交易信息
     * @param tran 交易的信息，存有customerId、activityId、contactsId
     * @return 新增成功，返回1
     */
    int saveTran(Tran tran);
    
    /**
     * 根据交易的id，查询详细信息
     * @param tranId 交易的id
     * activityId=市场活动源，owner=user表的id，contactId=contacts表的id
     * @return 交易信息
     */
    Tran tranDetail(String tranId);
    
    /**
     * 修改交易的信息
     * @param tran 新的交易内容
     * @return 修改成功，返回1
     */
    int changeStage(Tran tran);
    
    /**
     * 查询总记录条数
     * @return 查询到的所有交易记录
     */
    int getTotal();
    
    /**
     * 查询所有的交易记录
     * @return 交易记录的List集合
     */
    List<Map<String,Object>> getTranList();
}
