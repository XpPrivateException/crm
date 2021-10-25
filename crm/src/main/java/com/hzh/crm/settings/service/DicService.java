package com.hzh.crm.settings.service;

import com.hzh.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

//数据字典service
public interface DicService {
    
    /**
     * 从数据字典库中，查询所有的数据
     * @return 将所有的数据存储到一个封装好的map集合
     * 这个Map集合的key部分，是数据字典的类型
     * Value部分，是这个类型对应查询到的所有数据字典值，存储在List集合中
     */
    //查询数据字典
    Map<String, List<DicValue>> getAllDic();
}
