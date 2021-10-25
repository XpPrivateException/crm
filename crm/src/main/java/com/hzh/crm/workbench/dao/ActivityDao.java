package com.hzh.crm.workbench.dao;

import com.hzh.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

//市场活动表Dao层
public interface ActivityDao {
    
    /**
     * 新增一个市场活动
     * @param activity 市场活动的对象
     * @return 如果成功，则返回1，否则为0
     */
    int saveActivity(Activity activity);
    
    /**
     * 动态查询市场活动并分页
     * @param map 动态查询的条件——pageNo,pageSize,name,owner,startDate,endDate
     * @return 存放了查询到的所有市场活动Activity
     */
    List<Activity> pageSelectActivity(Map<String,Object> map);
    
    /**
     * 根据动态查询条件查询总条数
     * @param map 动态查询的条件——pageNo,pageSize,name,owner,startDate,endDate
     * @return 总条数
     */
    int selectCountActivity(Map<String,Object> map);
    
    /**
     * 根据市场活动的id删除指定的数据
     * @param activityIds 指定id
     * @return 删除成功返回1，否则为0
     */
    int deleteActivityByIds(String[] activityIds);
    
    /**
     * 根据id查询执行的市场活动信息
     * @param id 指定的市场活动id
     * @return 封装好的activity对象
     */
    Activity selectActivityById(String id);
    
    /**
     * 修改市场活动，这个市场活动的id是已经存在的
     * @param activity 新的市场活动信息对象
     * @return 如果修改成功，返回1
     */
    int updateActivity(Activity activity);
    
    /**
     * 根据id查询市场活动，需要查询出该市场活动的所有者
     * @param id 市场活动的id
     * @return 封装好的市场活动信息，其中所有者是一个表连接得到的姓名
     */
    Activity selectActivityDetail(String id);
    
    /**
     * 从市场活动表、线索表、线索与市场活动表中
     * 根据线索的id，查询对应的所有关联的市场活动表
     * @param clueId 线索的id
     * @return 所有关联的市场活动，封装为List集合
     * 其中Activity的id值应该为关系表中对应的id值以方便后续操作
     */
    List<Activity> getActivityListByClueId(String clueId);
    
    /**
     * 查询市场活动信息， 要求：
     * 未关联该线索(clueId)，名称模糊查询(activityName)
     * @param map 存储了模糊查询的市场活动名称和线索id
     * @return 查询到的市场活动集合
     */
    List<Activity> getActivityListByNameNotClueId(Map<String, String> map);
    
    /**
     * 模糊查询市场活动
     * @param activityName 查询条件
     * @return 查询到的List集合
     */
    List<Activity> getActivityListByName(String activityName);
}
