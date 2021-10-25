package com.hzh.crm.workbench.service;

import com.hzh.crm.vo.PaginationVo;
import com.hzh.crm.workbench.domain.Activity;
import com.hzh.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

//处理市场业务层
public interface ActivityService {
    
    /**
     * 新增一个市场活动信息到数据库
     * @param activity 市场活动对象
     * @return 新增成功，返回true，否则未false
     */
    boolean saveActivity(Activity activity);
    
    /**
     * 分页查询所有的市场活动
     * @param map 存放了pageNo,pageSize,name,owner,startDate,endDate
     * @return 返回一个分页Vo，存放了所有的市场活动的List
     */
    PaginationVo<Activity> pageSelectActivity(Map<String,Object> map);
    
    /**
     * 根据id删除指定的市场活动
     * 在删除市场活动前，需要先删除关联的市场活动备注
     * @param activityIds 需要删除的id
     * @return 如果全部删除成功，则返回true
     */
    boolean deleteActivity(String[] activityIds);
    
    /**
     * 根据市场活动的id，查询该市场活动的详细信息和用户信息
     * @param id 市场活动的id
     * @return map集合，以便转换为json：user:{xxx},activity:[{活动1},{活动2}]
     */
    Map<String,Object> selectUserAndActivity(String id);
    
    /**
     * 修改市场活动相关项
     * @param activity 新的市场活动数据
     * @return 如果修改成功，返回true
     */
    boolean updateActivity(Activity activity);
    
    /**
     * 查询市场活动、关联的备注的详细信息
     * @param id 需要查询的市场活动id
     * @return 封装好的市场活动对象
     */
    Activity selectActivityDetail(String id);
    
    /**
     * 根据市场活动的信息，查询出所有关联的备注信息
     * @param activityId 市场活动的id
     * @return List集合，里面的每一个元素都是一个备注信息
     */
    List<ActivityRemark> getRemarkListByActivityId(String activityId);
    
    /**
     * 根据给定的市场活动的备注id，调用dao完成删除操作
     * @param id 市场活动的备注的id
     * @return 删除成功，则返回true
     */
    boolean deleteRemarkById(String id);
    
    /**
     * 添加新的市场活动备注信息
     * @param remark 封装好的市场活动备注
     * @return 添加成功，返回true
     */
    boolean saveRemark(ActivityRemark remark);
    
    /**
     * 修改指定的市场活动备注信息
     * @param remark 封装好的新备注内容，其中id是指定的要修改的备注
     * @return 如果修改成功，返回true
     */
    boolean updateRemark(ActivityRemark remark);
    
    /**
     * 根据给定的线索id，查询关联的所有市场活动列表
     * @param clueId 线索的id
     * @return 存储了所有关联的市场活动列表
     * 其中存储的Activity的id，是关系表中的id而非其本身的id
     */
    List<Activity> getActivityListByClueId(String clueId);
    
    /**
     * 根据名称和线索的id，模糊查询未关联该线索的市场活动
     * @param map activityName = ? clueId = ?
     * @return 查询到的市场活动List集合
     */
    List<Activity> getActivityListByNameNotClueId(Map<String,String> map);
    
    /**
     * 根据名称模糊查询市场活动
     * @param activityName 模糊查询名称
     * @return 查询到的所有市场活动
     */
    List<Activity> getActivityListByName(String activityName);
}
