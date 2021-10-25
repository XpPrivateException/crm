package com.hzh.crm.settings.dao;

import com.hzh.crm.settings.domain.DicValue;

import java.util.List;

//数据字典值
public interface DicValueDao {
    
    /**
     * 根据数据字典类型，查询关联的所有数据字典纸
     * @param typeCode 给定的数据字典类型
     * @return 存储了查询到的所有数据字典的List集合
     */
    List<DicValue> getAllByTypeCode(String typeCode);
}
