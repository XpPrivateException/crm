package com.hzh.crm.web.listener;

import com.hzh.crm.settings.domain.DicValue;
import com.hzh.crm.settings.service.DicService;
import com.hzh.crm.settings.service.impl.DicServiceImpl;
import com.hzh.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

//系统初始化监听器，监听全局作用域对象
public class SysInitListener implements ServletContextListener {
    
    /**
     * 监听全局作用域，当其被创建时，存储数据字典
     * @param sce 通过其获得监听的全局作用域对象
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("ServletContext initialized!");
        //取得全局作用域对象
        ServletContext application = sce.getServletContext();
        //调用service
        DicService service = (DicService) ServiceFactory.getService(new DicServiceImpl());
        //存储数据字典
        Map<String,List<DicValue>> dicMap = service.getAllDic();
        Set<String> dicTypeKeySet = dicMap.keySet();
        //将数据字典的类型作为key，对应的List集合作为值
        for(String key: dicTypeKeySet){
            application.setAttribute(key,dicMap.get(key));
        }
        System.out.println("ServletContext initialize finish!");
        //------------------------------------------------------------------------------------
        //处理stage2Possibility.properties文件，将键值对关系处理为java中的键值对(Map)
        Map<String,String> possibilityMap = new HashMap<String,String>();
        ResourceBundle bundle = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = bundle.getKeys();
        //遍历枚举，取得所有的key和value对应到Map集合中
        while(keys.hasMoreElements()){
            String key = keys.nextElement();
            //将key=value存储在map集合中
            possibilityMap.put(key,bundle.getString(key));
        }
        //将该map集合存储到application中
        application.setAttribute("possibilityMap",possibilityMap);
        System.out.println("Stage2Possibility.properties analyse finish!");
    }
    
}
