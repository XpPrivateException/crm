package com.hzh.crm.workbench.web.controller;

import com.hzh.crm.settings.domain.User;
import com.hzh.crm.settings.service.UserService;
import com.hzh.crm.settings.service.impl.UserServiceImpl;
import com.hzh.crm.utils.DateTimeUtil;
import com.hzh.crm.utils.PrintJson;
import com.hzh.crm.utils.ServiceFactory;
import com.hzh.crm.utils.UUIDUtil;
import com.hzh.crm.workbench.domain.Tran;
import com.hzh.crm.workbench.domain.TranHistory;
import com.hzh.crm.workbench.service.CustomerService;
import com.hzh.crm.workbench.service.TranService;
import com.hzh.crm.workbench.service.impl.CustomerServiceImpl;
import com.hzh.crm.workbench.service.impl.TranServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranController extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter TranController!");
        String path = request.getServletPath();
        
        if("/workbench/transaction/toSaveTran.do".equals(path)){
            //跳转添加交易页
            this.toSaveTran(request,response);
        }else if("/workbench/transaction/getCustomerName.do".equals(path)){
            //模糊查询客户名称
            this.getCustomerName(request,response);
        }else if("/workbench/transaction/saveTran.do".equals(path)){
            //保存交易
            this.saveTran(request,response);
        }else if("/workbench/transaction/tranDetail.do".equals(path)){
            //跳转到相似信息页
            this.detail(request,response);
        }else if("/workbench/transaction/getHistoryListByTranId.do".equals(path)){
            //查询交易历史信息
            this.getHistoryListByTranId(request,response);
        }else if("/workbench/transaction/changeStage.do".equals(path)){
            //改变交易的阶段
            this.changeStage(request,response);
        }else if("/workbench/transaction/getCharts.do".equals(path)){
            //获取统计图表
            this.getCharts(request,response);
        }
    }
    
    //获取统计图表
    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getChartsController!");
        //调用service
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> voMap = tranService.getCharts();
        //返回json
        PrintJson.printJsonObj(response,voMap);
    }
    
    //改变交易阶段
    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter changeStageController!");
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("possibilityMap");
        //封装DTO
        Tran tran = new Tran();
        tran.setId(request.getParameter("id"));
        tran.setStage(request.getParameter("stage"));
        tran.setPossibility(pMap.get(request.getParameter("stage")));
        tran.setMoney(request.getParameter("money"));
        tran.setExpectedDate(request.getParameter("expectedDate"));
        tran.setEditBy(((User)(request.getSession().getAttribute("user"))).getName());
        tran.setEditTime(DateTimeUtil.getSysTime());
        //调用service
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = tranService.changeStage(tran);
        //封装vo
        Map<String,Object> voMap = new HashMap<String,Object>();
        voMap.put("flag",flag);
        voMap.put("tran",tran);
        //返回json
        PrintJson.printJsonObj(response,voMap);
    }
    
    //查询交易历史信息
    private void getHistoryListByTranId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getHistoryListByTranIdController!");
        String tranId = request.getParameter("tranId");
        //调用service
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> tranHistoryList = tranService.getHistoryListByTranId(tranId);
        //为交易历史增加可能性字段
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("possibilityMap");
        for(TranHistory tranHistory: tranHistoryList){
            String stage = tranHistory.getStage();
            tranHistory.setPossibility( pMap.get(stage));
        }
        //返回json
        PrintJson.printJsonObj(response, tranHistoryList);
    }
    
    //跳转详细信息页
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter tranDetailController!");
        String id = request.getParameter("id");
        //调用service
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = tranService.tranDetail(id);
        //处理前端的可能性字段
        Map<String,String> possibilityMap = (Map<String, String>) request.getServletContext().getAttribute("possibilityMap");
        String possibility = possibilityMap.get(tran.getStage());
        tran.setPossibility(possibility);
        request.setAttribute("tran",tran);
        //请求转发
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }
    
    //保存交易
    private void saveTran(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("enter saveTran");
        //封装DTO
        Tran tran = new Tran();
        tran.setId(UUIDUtil.getUUID());
        tran.setOwner(request.getParameter("owner"));
        tran.setMoney(request.getParameter("money"));
        tran.setName(request.getParameter("name"));
        tran.setExpectedDate(request.getParameter("expectedDate"));
        //根据客户的名字查询id给交易的customerId赋值
        String customerName = request.getParameter("customerName");
        //tran.setCustomerId(request.getParameter("customerId"));
        tran.setStage(request.getParameter("stage"));
        tran.setType(request.getParameter("type"));
        tran.setSource(request.getParameter("source"));
        tran.setActivityId(request.getParameter("activityId"));
        tran.setContactsId(request.getParameter("contactsId"));
        tran.setCreateBy(request.getParameter(((User)request.getSession().getAttribute("user")).getName()));
        tran.setCreateTime(request.getParameter(DateTimeUtil.getSysTime()));
        tran.setDescription(request.getParameter("description"));
        tran.setContactSummary(request.getParameter("contactSummary"));
        tran.setNextContactTime(request.getParameter("nextContactTime"));
        //调用service
        TranService service = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = service.saveTran(tran,customerName);
        if(flag){
            //添加成功，重定向至列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }else{
            System.out.println("添加交易失败！");
        }
    }
    
    //模糊查询客户名称
    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("enter getCustomerNameController!");
        String name = request.getParameter("name");
        //调用service层
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> customerNameList = customerService.getCustomerName(name);
        //返回json
        PrintJson.printJsonObj(response, customerNameList);
    }
    
    //跳转添加交易页
    private void toSaveTran(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter toSaveTranController!");
        //调用service
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUsers();
        request.setAttribute("user",userList);
        //转发至新增页
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }
}
