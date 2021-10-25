package com.hzh.crm.workbench.service;

import com.hzh.crm.exception.ConvertException;
import com.hzh.crm.vo.PaginationVo;
import com.hzh.crm.workbench.domain.Clue;
import com.hzh.crm.workbench.domain.Tran;

import java.util.Map;

public interface ClueService {
    
    /**
     * 创建一条新线索
     * @param clue 封装好的需要添加的线索
     * @return 添加成功，返回true
     */
    boolean saveClue(Clue clue);
    
    /**
     * 动态分页查询
     * @param map key是动态查询的条件，value是这个查询条件的值
     * @return 封装好的PagenationVo对象
     * 一个属性为总条数total，一个属性为封装了所有查询到的Clue的集合
     */
    PaginationVo<Clue> pageSelectClue(Map<String,Object> map);
    
    /**
     * 根据id查询线索信息
     * @param id 指定的id
     * @return 查询到的线索
     */
    Clue clueDetail(String id);
    
    /**
     * 根据关系表的id，删除线索和市场活动的关联
     * @param relationId 关系表id
     * @return 删除成功返回true
     */
    boolean unbund(String relationId);
    
    /**
     * 为线索关联市场活动
     * @param clueId 线索的id
     * @param activityIds 需要关联的市场活动的id，可能有多个
     * @return 添加成功，返回true
     */
    boolean bundActivity(String clueId, String[] activityIds);
    
    /**
     * 将一条线索转换为客户，同时可能需要新增一个交易
     * @param clueId 该线索的id
     * @param tran 在线索转换为客户时同时创建的交易，如果没有创建则为null
     * @param createBy 创建人，数据库中多个表存在的字段
     * @return 如果转换成功(即新增客户)，返回true
     */
    boolean convert(String clueId, Tran tran, String createBy) throws ConvertException;
}
