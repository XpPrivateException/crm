package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {
    
    /**
     * 新增一条交易历史信息
     * @param tranHistory 交易历史
     * @return 如果添加成功，返回1
     */
    int saveTranHistory(TranHistory tranHistory);
    
    /**
     * 根据交易id，查询交易历史信息
     * @param tranId 交易的id
     * @return 查询到的所有交易历史信息
     */
    List<TranHistory> getHistoryListByTranId(String tranId);
}
