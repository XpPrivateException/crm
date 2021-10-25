package com.hzh.crm.settings.service.impl;

import com.hzh.crm.settings.dao.DicTypeDao;
import com.hzh.crm.settings.dao.DicValueDao;
import com.hzh.crm.settings.domain.DicType;
import com.hzh.crm.settings.domain.DicValue;
import com.hzh.crm.settings.service.DicService;
import com.hzh.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

//数据字典service层
public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);
    
    @Override
    public Map<String, List<DicValue>> getAllDic() {
        System.out.println("enter getAllDicDicService!");
        Map<String,List<DicValue>> dicMap = new HashMap<String,List<DicValue>>();
        //先查询所有的数据类型
        List<DicType> dicTypeList = dicTypeDao.getAllDicType();
        //再根据数据类型，查询所有的数据值
        for(DicType dicType: dicTypeList){
            //根据数据类型，查询所有的数据
            String typeCode = dicType.getCode();
            List<DicValue> dicValueList = dicValueDao.getAllByTypeCode(typeCode);
            //存储到Map集合中
            dicMap.put(typeCode,dicValueList);
        }
        return dicMap;
    }
}
