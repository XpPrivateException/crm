package com.hzh.crm.workbench.service.impl;

import com.hzh.crm.utils.SqlSessionUtil;
import com.hzh.crm.utils.UUIDUtil;
import com.hzh.crm.workbench.dao.CustomerDao;
import com.hzh.crm.workbench.dao.TranDao;
import com.hzh.crm.workbench.dao.TranHistoryDao;
import com.hzh.crm.workbench.domain.Customer;
import com.hzh.crm.workbench.domain.Tran;
import com.hzh.crm.workbench.domain.TranHistory;
import com.hzh.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    
    //新增交易信息
    @Override
    public boolean saveTran(Tran tran, String customerName) {
        System.out.println("enter saveTranService!");
        boolean flag = true;
        //分析是否需要新建客户
        Customer customer = customerDao.selectCustomerByName(customerName);
        if(null != customer){
            //有这个客户
            tran.setCustomerId(customer.getId());
        }else{
            //没有这个客户，需要新增客户
            String customerId = UUIDUtil.getUUID();
            tran.setCustomerId(customerId);
            Customer newCustomer = new Customer();
            newCustomer.setId(customerId);
            newCustomer.setOwner(tran.getOwner());
            newCustomer.setName(tran.getName());
            newCustomer.setCreateBy(tran.getCreateBy());
            newCustomer.setCreateTime(tran.getCreateTime());
            newCustomer.setContactSummary(tran.getContactSummary());
            newCustomer.setNextContactTime(tran.getNextContactTime());
            newCustomer.setDescription(tran.getDescription());
            int count1 = customerDao.saveCustomer(newCustomer);
            if(1 != count1){
                //新增客户失败
                flag = false;
            }
        }
        //程序执行到此，说明客户处理完毕，新增交易
        int count2 = tranDao.saveTran(tran);
        if(1 != count2){
            //新增交易失败
            flag = false;
        }
        //新增交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setStage(tran.getStage());
        tranHistory.setCreateBy(tran.getCreateBy());
        int count3 = tranHistoryDao.saveTranHistory(tranHistory);
        if(1 != count3){
            //新增交易历史失败
            flag = false;
        }
        return flag;
    }
    
    //查询交易信息
    @Override
    public Tran tranDetail(String id) {
        System.out.println("enter tranDetailService");
        Tran tran = tranDao.tranDetail(id);
        return tran;
    }
    
    //根据交易id查询关联的所有交易历史
    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        System.out.println("enter getHistoryListByTranIdService");
        //调用dao
        List<TranHistory> tranHistoryList = tranHistoryDao.getHistoryListByTranId(tranId);
        return tranHistoryList;
    }
    
    //修改交易信息
    @Override
    public boolean changeStage(Tran tran) {
        boolean flag = true;
        //先调用dao，修改交易信息
        int count = tranDao.changeStage(tran);
        if(1 != count){
            //说明修改失败
            flag = false;
        }
        //调用dao，新增交易历史信息
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(tran.getEditTime());
        tranHistory.setCreateBy(tran.getEditBy());
        int count2 = tranHistoryDao.saveTranHistory(tranHistory);
        if(1 != count2){
            //新增失败
            flag = false;
        }
        return flag;
    }
    
    //查询交易记录，统计成图标
    @Override
    public Map<String, Object> getCharts() {
        //取得总条数total
        int total = tranDao.getTotal();
        //取得交易信息dataList
        List<Map<String,Object>> dataList = tranDao.getTranList();
        //封装到VO对象中
        Map<String,Object> voMap = new HashMap<>();
        voMap.put("total",total);
        voMap.put("dataList",dataList);
        return voMap;
    }
}
