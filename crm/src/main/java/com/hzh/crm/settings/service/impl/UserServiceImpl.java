package com.hzh.crm.settings.service.impl;

import com.hzh.crm.exception.LoginException;
import com.hzh.crm.settings.dao.UserDao;
import com.hzh.crm.settings.domain.User;
import com.hzh.crm.settings.service.UserService;
import com.hzh.crm.utils.DateTimeUtil;
import com.hzh.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    
    //用户登录
    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        
        Map<String,String> userinfo = new HashMap<String,String>();
        userinfo.put("loginAct",loginAct);
        userinfo.put("loginPwd",loginPwd);
        User user = null;
        //调用dao查询
        user = userDao.loginUser(userinfo);
        if(user == null){
            //程序执行到此处，说明没有该用户
            throw new LoginException("密码错误或用户不存在!");
        }else{
            //程序执行到此处，说明有该用户
            //需要继续判断失效时间、锁定状态、允许ip
            String currentTime = DateTimeUtil.getSysTime();
            if(user.getExpireTime().compareTo(currentTime) < 0){
                throw new LoginException("账号已失效!");
            }
            if("0".equals(user.getLockState())){
                throw new LoginException("账号已被锁定!");
            }
            if(! user.getAllowIps().contains(ip)){
                throw new LoginException("帐号ip已受限,请联系管理员!");
            }
        }
        //程序执行到此处，说明用户正常，允许登录
        return user;
    }
    
    //从数据库查询所有的用户
    @Override
    public List<User> getUsers() {
        return userDao.getUsers();
    }
}
