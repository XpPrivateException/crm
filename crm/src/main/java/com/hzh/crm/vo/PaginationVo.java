package com.hzh.crm.vo;

import java.util.List;

public class PaginationVo<T> {
    private int total;
    private List<T> dataList;
    
    public PaginationVo() {
    }
    
    public PaginationVo(int total, List<T> dataList) {
        this.total = total;
        this.dataList = dataList;
    }
    
    public int getTotal() {
        return total;
    }
    
    public void setTotal(int totalsize) {
        this.total = totalsize;
    }
    
    public List<T> getDataList() {
        return dataList;
    }
    
    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
