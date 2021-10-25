package com.hzh.crm.settings.web.controller;

import com.hzh.crm.settings.domain.User;
import com.hzh.crm.settings.service.UserService;
import com.hzh.crm.settings.service.impl.UserServiceImpl;
import com.hzh.crm.utils.MD5Util;
import com.hzh.crm.utils.PrintJson;
import com.hzh.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

//用户控制层
public class UserController extends HttpServlet {
    
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("enter UserController!");
        
        String path = request.getServletPath();
        
        if("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if("/settings/user/xxx.do".equals(path)){
        
        }
    }
    
    //验证登录
    public void login(HttpServletRequest request, HttpServletResponse response){
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //转换MD5密文
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        System.out.println(ip);
        //调用service层
        try {
            UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
            User user = userService.login(loginAct, loginPwd, ip);
            request.getSession().setAttribute("user", user);
            //程序执行到此处，表示登录成功，给出json信息：{"flag":true}
            PrintJson.printJsonFlag(response, true);
        }catch(Exception e){
            e.printStackTrace();
            //程序执行到此出，表明登录失败，应该给出json错误信息{"errorMsg":"xxx"}
            String errorMsg = e.getMessage();
            Map<String,Object> msgMap = new HashMap<String,Object>();
            msgMap.put("flag",false);
            msgMap.put("errorMsg",errorMsg);
            PrintJson.printJsonObj(response,msgMap);
        }
    }
}
