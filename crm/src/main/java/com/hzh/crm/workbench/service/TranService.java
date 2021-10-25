package com.hzh.crm.workbench.service;

import com.hzh.crm.workbench.domain.Tran;
import com.hzh.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    
    /**
     * 新增一条交易数据
     * @param tran 交易的信息
     * @param customerName 需要根据客户的名称来获取id，如果没有该客户，则新建客户
     * @return 增加成功，返回1
     */
    boolean saveTran(Tran tran, String customerName);
    
    /**
     * 根据id查询交易信息
     * @param tranId 交易id
     * @return 返回交易信息
     */
    Tran tranDetail(String tranId);
    
    /**
     * 根据交易的id，查询关联的交易历史数据
     * @param tranId 交易id
     * @return 存储了交易历史的List集合
     */
    List<TranHistory> getHistoryListByTranId(String tranId);
    
    /**
     * 修改交易的信息
     * @param tran 新的交易信息对象
     * @return 修改成功返回1
     */
    boolean changeStage(Tran tran);
    
    /**
     * 查询交易记录，统计成图标
     * @return 返回存储了所有的交易记录信息
     */
    Map<String, Object> getCharts();
}
