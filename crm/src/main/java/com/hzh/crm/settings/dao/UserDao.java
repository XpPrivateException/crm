package com.hzh.crm.settings.dao;

import com.hzh.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

//用户表Dao
public interface UserDao {
    
    /**
     * 根据提供的用户账号和密码，查看数据库是否存在该用户
     * @param userinfo loginAct=xxx,loginPwd=xxx
     * @return 从数据库中查询到的数据，如果没有则为null
     */
    User loginUser(Map<String,String> userinfo);
    
    /**
     * 从数据库中查询所有的User对象
     * @return 存放了所有User的List集合
     */
    List<User> getUsers();
    
    
}
