package com.hzh.crm.settings.dao;

import com.hzh.crm.settings.domain.DicType;

import java.util.List;

//数据字典类型
public interface DicTypeDao {
    
    /**
     * 查询所有的数据字典类型
     * @return 返回数据字典类型存储到List集合
     */
    List<DicType> getAllDicType();
}
