package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    
    /**
     * 查询关联了市场活动的备注
     * @param activityIds 所有市场活动的id
     * @return 具体查询到的数量
     */
    int selectCountByIds(String[] activityIds);
    
    /**
     * 删除所有关联了该市场活动id的备注
     * @param activityIds 市场活动的id
     * @return 删除成功的条数
     */
    int deleteRemarkByIds(String[] activityIds);
    
    /**
     * 根据给定的市场活动的id，查询市场活动备注表关联的信息
     * @param activityId 外键，市场活动id
     * @return 存储了封装好的备注信息的List集合
     */
    List<ActivityRemark> getRemarkListByActivityById(String activityId);
    
    /**
     * 删除数据库中的指定id的备注信息
     * @param id 市场活动的备注的id
     * @return 删除成功，返回1
     */
    int deleteRemarkById(String id);
    
    /**
     * 新增一条市场活动备注信息
     * @param remark 市场活动备注
     * @return 新增成功，返回1
     */
    int saveRemark(ActivityRemark remark);
    
    /**
     * 修改市场活动备注信息
     * @param remark 市场活动备注信息，id为指定修改某一个
     * @return 修改成功，返回1
     */
    int updateRemark(ActivityRemark remark);
}
