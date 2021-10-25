package com.hzh.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

//字符编码集过滤器
public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("enter encodingFilter!");
        //过滤字符编码集
        servletRequest.setCharacterEncoding("utf-8");
        servletResponse.setContentType("text/html;charset=utf-8");
    
        filterChain.doFilter(servletRequest,servletResponse);
    
    }
}
