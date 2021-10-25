package com.hzh.crm.settings.service;

import com.hzh.crm.exception.LoginException;
import com.hzh.crm.settings.domain.User;

import java.util.List;

//用户Service
public interface UserService {
    
    /**
     * 关于系统登陆的用户操作
     * @param loginAct 用户账户
     * @param loginPwd 用户密码
     * @param ip 用户允许访问的IP地址
     * @return 如果该用户账号密码正确，时间未失效，未被冻结，IP地址未受限，则返回该用户表示允许登录
     * @throws LoginException 用户登录失败的提示
     */
    User login(String loginAct,String loginPwd,String ip) throws LoginException;
    
    /**
     * 从数据库查询所有用户
     * @return 存放了所有用户的List集合
     */
    List<User> getUsers();
}
