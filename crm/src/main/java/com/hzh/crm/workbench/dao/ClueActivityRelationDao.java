package com.hzh.crm.workbench.dao;


import com.hzh.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    
    /**
     * 从tbl_clue_acitivity_relation中，删除指定的id行
     * @param relationId 指定的id，关联了一个市场活动与线索
     * @return 删除成功返回true
     */
    int unbund(String relationId);
    
    /**
     * 在关系表新增一条数据tbl_clue_activity_relation
     * @param relation 关系数据，绑定了线索id与市场活动id
     * @return 新增成功返回1
     */
    int bundActivity(ClueActivityRelation relation);
    
    /**
     * 查询关联了线索id的所有市场活动
     * @param clueId 线索的id
     * @return 返回所有的关系对象，其中activityId属性为关联的市场活动
     */
    List<ClueActivityRelation> getRelationListByClueId(String clueId);
    
    /**
     * 删除指定的关系
     * @param clueActivityRelation 线索和市场活动关系
     * @return 删除成功返回1
     */
    int deleteRelation(ClueActivityRelation clueActivityRelation);
}
