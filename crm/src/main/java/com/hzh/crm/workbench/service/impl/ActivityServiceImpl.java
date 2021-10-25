package com.hzh.crm.workbench.service.impl;

import com.hzh.crm.settings.dao.UserDao;
import com.hzh.crm.settings.domain.User;
import com.hzh.crm.utils.SqlSessionUtil;
import com.hzh.crm.vo.PaginationVo;
import com.hzh.crm.workbench.dao.ActivityDao;
import com.hzh.crm.workbench.dao.ActivityRemarkDao;
import com.hzh.crm.workbench.domain.Activity;
import com.hzh.crm.workbench.domain.ActivityRemark;
import com.hzh.crm.workbench.service.ActivityService;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    //新增市场活动
    @Override
    public boolean saveActivity(Activity activity) {
        System.out.println("enter saveActivityService!");
        boolean flag = false;
        SqlSession sqlSession = SqlSessionUtil.getSqlSession();
        //调用dao
        int count = activityDao.saveActivity(activity);
        if(count == 1){
            //程序执行到这里，表示新增成功
            sqlSession.commit();
            flag = true;
        }
        return flag;
    }
    
    //分页查询市场活动
    @Override
    public PaginationVo<Activity> pageSelectActivity(Map<String,Object> map) {
        System.out.println("enter pageSelectActivityService!");
        //调用dao分别查询
        List<Activity> activities = activityDao.pageSelectActivity(map);
        int totalsize = activityDao.selectCountActivity(map);
        //封装Vo对象并返回
        PaginationVo<Activity> activityVo = new PaginationVo<>();
        activityVo.setDataList(activities);
        activityVo.setTotal(totalsize);
        return activityVo;
    }
    
    //删除市场活动
    @Override
    public boolean deleteActivity(String[] deleteIds) {
        System.out.println("enter deleteActivityService!");
        boolean flag = false;
        int activityDeleted = 0;
        //在删除市场活动前需要先删除备注
        //查询需要删除的备注数量
        int remarkToDelete = activityRemarkDao.selectCountByIds(deleteIds);
        //执行删除备注
        int remarkDeleted = activityRemarkDao.deleteRemarkByIds(deleteIds);
        //如果全部删除，则删除市场活动
        if(remarkToDelete == remarkDeleted) {
            //调用dao 删除所有的ids
            activityDeleted += activityDao.deleteActivityByIds(deleteIds);
        }
        if(activityDeleted == deleteIds.length){
            //程序执行到此处，说明全部删除成功，可以提交事务
            SqlSessionUtil.getSqlSession().commit();
            flag = true;
        }
        return flag;
    }
    
    //查询用户信息列表和根据市场活动id查询信息
    @Override
    public Map<String, Object> selectUserAndActivity(String id) {
        System.out.println("enter selectUserAndActivityService!");
        Map<String,Object> map = new HashMap<String ,Object>();
        //调用用户的dao获取数据
        List<User> userList = userDao.getUsers();
        //调用市场活动dao查询单挑数据
        Activity activity = activityDao.selectActivityById(id);
        map.put("userList",userList);
        map.put("activity",activity);
        return map;
    }
    
    //修改市场活动
    @Override
    public boolean updateActivity(Activity activity) {
        System.out.println("enter updateActivityService!");
        boolean flag = false;
        //调用dao
        int count = activityDao.updateActivity(activity);
        if(count == 1){
            //程序执行到此处，说明修改成功
            flag = true;
            SqlSessionUtil.getSqlSession().commit();
        }
        return flag;
    }
    
    //查询市场活动详细信息
    @Override
    public Activity selectActivityDetail(String id) {
        System.out.println("enter selectActivityDetailByIdService!");
        Activity activity = activityDao.selectActivityDetail(id);
        return activity;
    }
    
    //根据市场活动id查询关联的所有备注信息
    @Override
    public List<ActivityRemark> getRemarkListByActivityId(String activityId) {
        System.out.println("enter getRemarkListByActivityIdService!");
        //调用dao
        List<ActivityRemark> remarkList = activityRemarkDao.getRemarkListByActivityById(activityId);
        return remarkList;
    }
    
    //删除市场活动备注信息
    @Override
    public boolean deleteRemarkById(String id) {
        System.out.println("enter deleteRemarkByIdService!");
        boolean flag = false;
        //调用dao
        int count = activityRemarkDao.deleteRemarkById(id);
        if(1 == count){
            //程序执行到此处，说明删除成功
            flag = true;
            SqlSessionUtil.getSqlSession().commit();
        }
        return flag;
    }
    
    //添加市场活动备注信息
    @Override
    public boolean saveRemark(ActivityRemark remark) {
        System.out.println("enter saveRemarkService!");
        boolean flag = false;
        //调用dao
        int count = activityRemarkDao.saveRemark(remark);
        if(1 == count){
            //添加成功
            flag = true;
            SqlSessionUtil.getSqlSession().commit();
        }
        return flag;
    }
    
    //修改市场备注
    @Override
    public boolean updateRemark(ActivityRemark remark) {
        System.out.println("enter updateRemarkService!");
        boolean flag = false;
        //调用dao
        int count = activityRemarkDao.updateRemark(remark);
        if(1 == count){
            //修改成功
            flag = true;
            SqlSessionUtil.getSqlSession().commit();
        }
        return flag;
    }
    
    //查询线索id关联的市场活动
    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        System.out.println("getActivityListByClueIdService");
        //调用dao
        List<Activity> activityList = activityDao.getActivityListByClueId(clueId);
        return activityList;
    }
    
    //根据名称模糊查询未关联线索id的市场活动
    @Override
    public List<Activity> getActivityListByNameNotClueId(Map<String, String> map) {
        System.out.println("enter getActivityListByNameNotClueIdService!");
        //调用dao
        List<Activity> activityList = activityDao.getActivityListByNameNotClueId(map);
        return activityList;
    }
    
    //根据名称模糊查询市场活动
    @Override
    public List<Activity> getActivityListByName(String activityName) {
        System.out.println("enter getActivityListByName!");
        //调用dao
        List<Activity> activityList = activityDao.getActivityListByName(activityName);
        return activityList;
    }
}
