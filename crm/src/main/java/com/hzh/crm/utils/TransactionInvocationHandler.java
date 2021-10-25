package com.hzh.crm.utils;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.apache.ibatis.session.SqlSession;

//service层业务代理类，完成事务的提交、会滚等操作
public class TransactionInvocationHandler implements InvocationHandler{
	
	private Object target;
	
	public TransactionInvocationHandler(Object target){
		
		this.target = target;
		
	}

	@Override
	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		
		SqlSession sqlSession = null;
		
		Object obj = null;
		
		try{
            sqlSession = SqlSessionUtil.getSqlSession();
			
			obj = method.invoke(target, args);
            
            sqlSession.commit();
		}catch(Exception e){
            sqlSession.rollback();
			e.printStackTrace();
			
			//处理的是什么异常，就继续往上抛什么异常
			throw e.getCause();
		}finally{
			SqlSessionUtil.myClose(sqlSession);
		}
		
		return obj;
	}
	
	public Object getProxy(){
		
		return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(),this);
		
	}
	
}











































