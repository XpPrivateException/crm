package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    
    /**
     * 向数据库添加一条线索数据
     * @param clue 需要添加的线索
     * @return 添加成功，返回1
     */
    int saveClue(Clue clue);
    
    /**
     * 根据查询条件，从数据库查询线索信息
     * @param map 条件查询
     * @return 查询到的所有的线索集合
     */
    List<Clue> pageSelectClue(Map<String, Object> map);
    
    /**
     * 根据查询条件，查询总条数
     * @param map 查询条件
     * @return 查询到的总条数
     */
    int selectCountClue(Map<String, Object> map);
    
    /**
     * 根据id查询单条记录
     * @param id 指定的id
     * @return 查询到的线索记录，其中owner为user表中的name
     */
    Clue clueDetail(String id);
    
    /**
     * 根据线索的id，查询该线索
     * @param clueId 线索id
     * @return 查询到的线索，owner为user表的id
     */
    Clue selectClueById(String clueId);
    
    /**
     * 删除线索
     * @param clueId 线索ID
     * @return 成功返回1
     */
    int deleteClue(String clueId);
}
