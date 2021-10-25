package com.hzh.crm.utils;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlSessionUtil {
	
	private SqlSessionUtil(){}
	
	private static SqlSessionFactory factory;
 
	static{
		
		String resource = "mybatis-config.xml";
		InputStream inputStream = null;
		try {
			inputStream = Resources.getResourceAsStream(resource);
		} catch (IOException e) {
			e.printStackTrace();
		}
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
        factory = builder.build(inputStream);
	}
	
	private static ThreadLocal<SqlSession> t = new ThreadLocal<SqlSession>();
	
	public static SqlSession getSqlSession(){
		
		SqlSession sqlSession = t.get();
		
		if(sqlSession==null){
            
            sqlSession = factory.openSession();
			t.set(sqlSession);
		}
		
		return sqlSession;
		
	}
	
	public static void myClose(SqlSession sqlSession){
		
		if(sqlSession!=null){
            sqlSession.close();
			t.remove();
		}
		
	}
	
	
}
