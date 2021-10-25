package com.hzh.crm.workbench.web.controller;

import com.hzh.crm.settings.domain.User;
import com.hzh.crm.settings.service.UserService;
import com.hzh.crm.settings.service.impl.UserServiceImpl;
import com.hzh.crm.utils.*;
import com.hzh.crm.vo.PaginationVo;
import com.hzh.crm.workbench.dao.ActivityRemarkDao;
import com.hzh.crm.workbench.domain.Activity;
import com.hzh.crm.workbench.domain.ActivityRemark;
import com.hzh.crm.workbench.service.ActivityService;
import com.hzh.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//市场活动控制器层
public class ActivityController extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter ActivityController");
        String path = request.getServletPath();
        if("/workbench/activity/getUsers.do".equals(path)){
            //查询所有用户信息
            this.getUsers(request,response);
        }else if("/workbench/activity/saveActivity.do".equals(path)){
            //新增市场活动
            this.saveActivity(request,response);
        }else if("/workbench/activity/pageSelectActivity.do".equals(path)){
            //动态分页查询市场活动
            this.pageSelectActivity(request,response);
        }else if("/workbench/activity/deleteActivity.do".equals(path)){
            //删除市场活动
            this.deleteActivity(request,response);
        }else if("/workbench/activity/selectUserAndActivity.do".equals(path)){
            //查询用户信息列表和根据市场活动id查询信息
            this.selectUserAndActivity(request,response);
        }else if("/workbench/activity/updateActivity.do".equals(path)){
            //更新市场活动的信息
            this.updateActivity(request,response);
        }else if("/workbench/activity/selectActivityDetail.do".equals(path)){
            //查询市场活动及关联的备注详细信息
            this.selectActivityDetail(request,response);
        }else if("/workbench/activity/getRemarkListByActivityId.do".equals(path)){
            //根据市场活动id查询关联的所有备注信息
            this.getRemarkListByActivityId(request,response);
        }else if("/workbench/activity/deleteRemarkById.do".equals(path)){
            //删除市场活动备注
            this.deleteRemarkById(request,response);
        }else if("/workbench/activity/saveRemark.do".equals(path)){
            //新增市场活动备注
            this.saveRemark(request,response);
        }else if("/workbench/activity/updateRemark.do".equals(path)){
            //修改市场活动备注
            this.updateRemark(request,response);
        }
    }
    
    //修改市场活动备注
    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter updateRemarkController!");
        //封装备注对象
        ActivityRemark remark = new ActivityRemark();
        remark.setId(request.getParameter("id"));
        remark.setNoteContent(request.getParameter("noteContent"));
        remark.setEditFlag("1");
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = service.updateRemark(remark);
        //给前端返回json
        Map<String,Object> voMap = new HashMap<String,Object>();
        voMap.put("flag",flag);
        voMap.put("remark",remark);
        PrintJson.printJsonObj(response,voMap);
    }
    
    //新增市场活动备注
    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter saveRemarkContrller!");
        //封装备注信息
        ActivityRemark remark = new ActivityRemark();
        remark.setId(UUIDUtil.getUUID());
        remark.setNoteContent(request.getParameter("noteContent"));
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        remark.setEditFlag("0");
        remark.setActivityId(request.getParameter("activityId"));
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = service.saveRemark(remark);
        Map<String,Object> voMap = new HashMap<String,Object>();
        voMap.put("flag",flag);
        voMap.put("remark",remark);
        //给前端返回json数据
        PrintJson.printJsonObj(response, voMap);
    }
    
    //删除市场活动备注
    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter deleteRemarkByIdController!");
        String id = request.getParameter("id");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = service.deleteRemarkById(id);
        PrintJson.printJsonFlag(response, flag);
    }
    
    //根据市场活动id查询关联的所有备注信息
    private void getRemarkListByActivityId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getRemarkListByActivityIdController!");
        String activityId = request.getParameter("activityId");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> remarkList = service.getRemarkListByActivityId(activityId);
        //给前端返回json
        PrintJson.printJsonObj(response, remarkList);
    }
    
    //查询市场活动及关联的备注详细信息
    private void selectActivityDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter selectActivityDetailController!");
        String id = request.getParameter("id");
        //调用service层
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = service.selectActivityDetail(id);
        //请求转发
        request.setAttribute("activity",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }
    
    //更新市场活动的信息
    private void updateActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter updateActivityController!");
        //封装Activity对象
        Activity activity = new Activity();
        activity.setId(request.getParameter("id"));
        activity.setOwner(request.getParameter("owner"));
        activity.setName(request.getParameter("name"));
        activity.setStartDate(request.getParameter("startDate"));
        activity.setEndDate(request.getParameter("endDate"));
        activity.setCost(request.getParameter("cost"));
        activity.setDescription(request.getParameter("description"));
        //修改时间
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(((User)request.getSession(false).getAttribute("user")).getName());
        //调用Service层
        ActivityService activityService = (ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.updateActivity(activity);
        PrintJson.printJsonFlag(response,flag);
    }
    
    //查询用户信息列表和根据市场活动id查询信息
    private void selectUserAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter selectUserAndActivityController!");
        String id = request.getParameter("id");
        //调用service层
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //根据市场活动id查询
        Map<String,Object> map = service.selectUserAndActivity(id);
        PrintJson.printJsonObj(response, map);
    }
    
    //根据id删除市场活动
    private void deleteActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter deleteActivityController!");
        String[] ids = request.getParameterValues("id");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = service.deleteActivity(ids);
        //转换为json
        PrintJson.printJsonFlag(response,flag);
    }
    
    //动态分页查询市场活动
    private void pageSelectActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter pageSelectActivityController!");
        //封装Map对象给底层数据库
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("startLimit",(pageNo-1) * pageSize);
        map.put("pageSize",pageSize);
        map.put("name",request.getParameter("name"));
        map.put("owner",request.getParameter("owner"));
        map.put("startDate",request.getParameter("startDate"));
        map.put("endDate",request.getParameter("endDate"));
        //调用service
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        PaginationVo<Activity> activityVo = activityService.pageSelectActivity(map);
        PrintJson.printJsonObj(response,activityVo);
    }
    
    //新增市场活动信息
    private void saveActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter saveActivityController!");
        //封装Activity对象
        Activity activity = new Activity();
        activity.setId(UUIDUtil.getUUID());
        activity.setOwner(request.getParameter("owner"));
        activity.setName(request.getParameter("name"));
        activity.setStartDate(request.getParameter("startDate"));
        activity.setEndDate(request.getParameter("endDate"));
        activity.setCost(request.getParameter("cost"));
        activity.setDescription(request.getParameter("description"));
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy(((User)request.getSession(false).getAttribute("user")).getName());
        //调用Service层
        ActivityService activityService = (ActivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.saveActivity(activity);
        PrintJson.printJsonFlag(response,flag);
    }
    
    //获得所有用户List，转换为Json传递给前端
    private void getUsers(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getUsersController!");
        //由于登录是用户相关的业务，所以调用用户service层
        UserService userService = (UserService)ServiceFactory.getService(new UserServiceImpl()) ;
        List<User> users = userService.getUsers();
        PrintJson.printJsonObj(response,users);
    }
}
