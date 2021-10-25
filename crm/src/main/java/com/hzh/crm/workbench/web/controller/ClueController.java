package com.hzh.crm.workbench.web.controller;

import com.hzh.crm.exception.ConvertException;
import com.hzh.crm.settings.domain.User;
import com.hzh.crm.settings.service.UserService;
import com.hzh.crm.settings.service.impl.UserServiceImpl;
import com.hzh.crm.utils.DateTimeUtil;
import com.hzh.crm.utils.PrintJson;
import com.hzh.crm.utils.ServiceFactory;
import com.hzh.crm.utils.UUIDUtil;
import com.hzh.crm.vo.PaginationVo;
import com.hzh.crm.workbench.domain.Activity;
import com.hzh.crm.workbench.domain.Clue;
import com.hzh.crm.workbench.domain.Tran;
import com.hzh.crm.workbench.service.ActivityService;
import com.hzh.crm.workbench.service.ClueService;
import com.hzh.crm.workbench.service.impl.ActivityServiceImpl;
import com.hzh.crm.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter ClueController!");
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
        System.out.println(basePath);
        String path = request.getServletPath();
        if("/workbench/clue/getUserList.do".equals(path)){
            //获取所有者下拉框选项
            this.getUserList(request,response);
        }else if("/workbench/clue/saveClue.do".equals(path)){
            //新增线索
            this.saveClue(request,response);
        }else if("/workbench/clue/pageSelectClue.do".equals(path)){
            //分页查询
            this.pageSelectClue(request,response);
        }else if("/workbench/clue/clueDetail.do".equals(path)){
            //跳转线索详细信息页
            this.clueDetail(request,response);
        }else if("/workbench/clue/getActivityListByClueId.do".equals(path)){
            //查询线索id关联的市场活动
            this.getActivityListByClueId(request,response);
        }else if("/workbench/clue/unbund.do".equals(path)){
            //删除关系表的一条关系
            this.unbund(request,response);
        }else if("/workbench/clue/getActivityListByNameNotClueId.do".equals(path)){
            //根据关键字模糊查询没有关联线索ID的市场活动
            this.getActivityListByNameNotClueId(request,response);
        }else if("/workbench/clue/bundActivity.do".equals(path)){
            //关联新的市场活动
            this.bundActivity(request,response);
        }else if("/workbench/clue/getActivityListByName".equals(path)){
            //根据关键字模糊查询市场活动
            this.getActivityListByName(request, response);
        }else if("/workbench/clue/convert.do".equals(path)){
            //不需要同时创建交易记录的线索转换
            try {
                this.convert(request,response);
            } catch (ConvertException e) {
                e.printStackTrace();
            }
        }
    }
    
    //创建交易记录的线索转换
    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException, ConvertException {
        System.out.println("enter convertController!");
        //封装DTO
        String clueId = request.getParameter("clueId");
        String needTran = request.getParameter("flag");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        Tran tran = null;
        if("a".equals(needTran)){
            //程序执行到此处，说明需要同时创建交易信息，封装tran对象
            tran = new Tran();
            tran.setMoney(request.getParameter("money"));
            tran.setName(request.getParameter("name"));
            tran.setExpectedDate(request.getParameter("expectedDate"));
            tran.setStage(request.getParameter("stage"));
            tran.setActivityId(request.getParameter("activityId"));
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tran.setCreateBy(createBy);
            tran.setId(UUIDUtil.getUUID());
        }
        //调用service
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = service.convert(clueId, tran, createBy);
        if(flag){
            //增加成功，重定向到线索页面
            response.sendRedirect(request.getContextPath() + "/workbench/clue/index.jsp");
        }else{
            System.out.println("线索转换失败!");
        }
    }
    
    //根据名称模糊查询市场活动
    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getActivityListByNameController!");
        //封装DTO
        String activityName = request.getParameter("activityName");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = service.getActivityListByName(activityName);
        //返回json
        PrintJson.printJsonObj(response, activityList);
    }
    
    //关联新的市场活动
    private void bundActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter bundActivityController!");
        //封装DTO
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");
        //调用service层
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = service.bundActivity(clueId,activityIds);
        //返回json
        PrintJson.printJsonFlag(response, flag);
    }
    
    //根据名称模糊查询市场活动
    private void getActivityListByNameNotClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getActivityListByNameNotClueIdController!");
        //封装DTO
        Map<String,String> map = new HashMap<>();
        map.put("activityName",request.getParameter("activityName"));
        map.put("clueId",request.getParameter("clueId"));
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = service.getActivityListByNameNotClueId(map);
        //返回json
        PrintJson.printJsonObj(response, activityList);
    }
    
    //删除关系表的一条关系
    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter unbundController!");
        String relationId = request.getParameter("id");
        //调用service
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = service.unbund(relationId);
        //返回json
        PrintJson.printJsonFlag(response, flag);
    }
    
    //查询线索id关联的市场活动
    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getActivityListByClueIdController!");
        String clueId = request.getParameter("clueId");
        //调用service
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = service.getActivityListByClueId(clueId);
        //返回json
        PrintJson.printJsonObj(response,activityList);
    }
    
    //跳转线索详细信息页
    private void clueDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter clueDetailController!");
        String id = request.getParameter("id");
        //调用service
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = service.clueDetail(id);
        //请求转发至详细信息页
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }
    
    //分页查询
    private void pageSelectClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter pageSeleteClueController!");
        //封装Map对象给底层数据库
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("startLimit",(pageNo-1) * pageSize);
        map.put("pageSize",pageSize);
        map.put("fullname",request.getParameter("fullname"));
        map.put("company",request.getParameter("company"));
        map.put("phone",request.getParameter("phone"));
        map.put("source",request.getParameter("source"));
        map.put("owner",request.getParameter("owner"));
        map.put("mphone",request.getParameter("mphone"));
        map.put("state",request.getParameter("state"));
        //调用service
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        PaginationVo<Clue> clueVo = clueService.pageSelectClue(map);
        PrintJson.printJsonObj(response,clueVo);
    }
    
    //新增线索
    private void saveClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter saveClueController!");
        //封装Clue对象
        Clue clue = new Clue();
        clue.setId(UUIDUtil.getUUID());
        clue.setFullname(request.getParameter("fullname"));
        clue.setAppellation(request.getParameter("appellation"));
        clue.setOwner(request.getParameter("owner"));
        clue.setCompany(request.getParameter("company"));
        clue.setJob(request.getParameter("job"));
        clue.setEmail(request.getParameter("email"));
        clue.setPhone(request.getParameter("phone"));
        clue.setWebsite(request.getParameter("website"));
        clue.setMphone(request.getParameter("mphone"));
        clue.setState(request.getParameter("state"));
        clue.setSource(request.getParameter("source"));
        clue.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clue.setDescription(request.getParameter("description"));
        clue.setContactSummary(request.getParameter("contactSummary"));
        clue.setNextContactTime(request.getParameter("nextContactTime"));
        clue.setAddress(request.getParameter("address"));
    
        //调用dao
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = service.saveClue(clue);
        //返回json给前端
        PrintJson.printJsonFlag(response,flag);
        
    }
    
    //获取所有者下拉框选项
    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter clueGetUserController");
        //复用user的service层
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = service.getUsers();
        PrintJson.printJsonObj(response, userList);
    }
}
