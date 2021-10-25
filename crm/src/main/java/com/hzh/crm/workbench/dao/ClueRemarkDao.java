package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    
    /**
     * 从线索备注表查询关联了线索id的所有备注
     * @param clueId 线索的id
     * @return 查询到的线索备注信息
     */
    List<ClueRemark> getClueRemarkListByClueId(String clueId);
    
    /**
     * 删除线索备注
     * @param clueRemark 线索备注信息
     * @return 删除成功，返回1
     */
    int deleteClueRemark(ClueRemark clueRemark);
}
