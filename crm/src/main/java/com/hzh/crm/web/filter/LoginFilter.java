package com.hzh.crm.web.filter;

import com.hzh.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

//防止恶意登录
public class LoginFilter implements Filter {
    public void init(FilterConfig config) throws ServletException {
    }
    
    public void destroy() {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        System.out.println("enter LoginFilter!");
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getServletPath();
        //不过滤登录行为
        if ("/login.jsp".equals(path) || "/index.jsp".equals(path) || "/settings/user/login.do".equals(path)) {
            chain.doFilter(request, response);
        } else {
            HttpSession session = req.getSession(false);
            //如果有user，则为正常登录；否则重定向至登录页面
            if (session.getAttribute("user") != null) {
                chain.doFilter(request, response);
            } else {
                //返回登录页面
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        }
    }
}
