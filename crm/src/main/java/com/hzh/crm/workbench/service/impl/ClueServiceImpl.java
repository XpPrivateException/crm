package com.hzh.crm.workbench.service.impl;

import com.hzh.crm.exception.ConvertException;
import com.hzh.crm.utils.DateTimeUtil;
import com.hzh.crm.utils.SqlSessionUtil;
import com.hzh.crm.utils.UUIDUtil;
import com.hzh.crm.vo.PaginationVo;
import com.hzh.crm.workbench.dao.*;
import com.hzh.crm.workbench.domain.*;
import com.hzh.crm.workbench.service.ClueService;

import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    
    //线索相关表
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    //客户相关表
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    //联系人相关表
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    //交易相关表
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    
    //添加线索
    @Override
    public boolean saveClue(Clue clue) {
        System.out.println("enter saveClueService!");
        boolean flag = false;
        //调用dao
        int count = clueDao.saveClue(clue);
        if(1 == count){
            //添加成功
            SqlSessionUtil.getSqlSession().commit();
            flag = true;
        }
        return flag;
    }
    
    //分页查询
    @Override
    public PaginationVo<Clue> pageSelectClue(Map<String, Object> map) {
        System.out.println("enter pageSelectClueService!");
        PaginationVo<Clue> clueVo = new PaginationVo<Clue>();
        //调用dao分别查询
        List<Clue> clueList = clueDao.pageSelectClue(map);
        int total = clueDao.selectCountClue(map);
        //封装vo对象
        clueVo.setTotal(total);
        clueVo.setDataList(clueList);
        return clueVo;
    }
    
    
    //查询线索详细信息
    @Override
    public Clue clueDetail(String id) {
        System.out.println("enter clueDetailService!");
        //调用dao
        Clue clue = clueDao.clueDetail(id);
        return clue;
    }
    
    //删除指定的市场活动与线索关系
    @Override
    public boolean unbund(String relationId) {
        System.out.println("enter unbundService!");
        boolean flag = false;
        //调用dao
        int count = clueActivityRelationDao.unbund(relationId);
        if(count == 1){
            //删除成功
            flag = true;
            SqlSessionUtil.getSqlSession().commit();
        }
        return flag;
    }
    
    //绑定线索与市场活动
    @Override
    public boolean bundActivity(String clueId, String[] activityIds) {
        System.out.println("enter bundActivityService");
        boolean flag = false;
        int count = 0;
        for(String activityId: activityIds){
            //封装每个DTO
            ClueActivityRelation relation = new ClueActivityRelation();
            relation.setClueId(clueId);
            relation.setActivityId(activityId);
            relation.setId(UUIDUtil.getUUID());
            //调用dao
            count += clueActivityRelationDao.bundActivity(relation);
        }
        if(count == activityIds.length){
            //添加成功
            flag = true;
            SqlSessionUtil.getSqlSession().commit();
        }
        return flag;
    }
    
    //线索转换
    @Override
    public boolean convert(String clueId, Tran tran, String createBy) throws ConvertException {
        System.out.println("enter convertService");
        String createTime = DateTimeUtil.getSysTime();
        boolean flag = true;
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueDao.selectClueById(clueId);
        System.out.println("selectClueById finish!");
        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        String company = clue.getCompany();
        Customer customer = customerDao.selectCustomerByName(company);
        if(null == customer){
            //客户不存在，需要新建客户存储到数据库中
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(clue.getCompany());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());
            //添加客户
            int count1 = customerDao.saveCustomer(customer);
            if(count1 != 1){
                //添加失败
                flag = false;
                throw new ConvertException("新增客户失败！");
            }
        }
        System.out.println("selectCustomerByName finish!");
    
        //-----程序运行到此处，已经获得客户信息-----
        //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource (clue.getSource());
        contacts.setCustomerId (customer.getId());
        contacts.setFullname (clue.getFullname());
        contacts.setAppellation (clue.getAppellation());
        contacts.setEmail (clue.getEmail());
        contacts.setMphone (clue.getMphone());
        contacts.setJob (clue.getJob());
        contacts.setCreateBy (createBy);
        contacts.setCreateTime (createTime);
        contacts.setDescription (clue.getDescription());
        contacts.setContactSummary (clue.getContactSummary());
        contacts.setNextContactTime (clue.getNextContactTime());
        contacts.setAddress (clue.getAddress());
        int count2 = contactsDao.saveContacts(contacts);
        if(1 != count2){
            //添加联系人失败
            flag = false;
            throw new ConvertException("添加联系人失败！");
        }
        System.out.println("saveContacts finish!");
       
        //-----程序运行到此处，已经获得联系人信息-----
        //(4) 线索备注转换到客户备注以及联系人备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.getClueRemarkListByClueId(clueId);
        for(ClueRemark clueRemark : clueRemarkList){
            //取出备注的信息，转换为客户及联系人的备注信息
            String noteContent = clueRemark.getNoteContent();
            //客户备注对象
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setNoteContent(noteContent);
            int count3 = customerRemarkDao.saveCustomerRemark(customerRemark);
            if(1 != count3){
                //添加客户备注失败
                flag = false;
                throw new ConvertException("添加客户备注失败！");
            }
            //联系人备注对象
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setNoteContent(noteContent);
            int count4 = contactsRemarkDao.saveContactsRemark(contactsRemark);
            if(1 != count4){
                //添加联系人备注失败
                flag = false;
                throw new ConvertException("添加联系人备注失败！");
            }
        }
        System.out.println("saveCustomerRemark and saveContactsRemark finish!");
        //-----程序运行到此处，已经获得备注的信息-----
        //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getRelationListByClueId(clueId);
        for(ClueActivityRelation clueActivityRelation: clueActivityRelationList){
            //将每一个关联的市场活动id与联系人id绑定
            String activityId = clueActivityRelation.getActivityId();
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(activityId);
            int count5 = contactsActivityRelationDao.saveRelation(contactsActivityRelation);
            if(1 != count5){
                //绑定联系人和市场活动失败
                flag = false;
                throw new ConvertException("绑定联系人和市场活动失败！");
            }
        }
        System.out.println("saveContactsActivityRelationRelation finish!");
        //-----程序运行到此处，已经完成绑定新的联系人、客户、市场活动-----
        //(6) 如果有创建交易需求，创建一条交易
        if(null != tran){
            //程序执行到此，说明需要创建交易
            tran.setCustomerId(customer.getId());
            tran.setContactsId(contacts.getId());
            tran.setOwner(clue.getOwner());
            tran.setSource(clue.getSource());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setContactSummary(clue.getContactSummary());
            tran.setDescription(clue.getDescription());
            //创建交易信息
            int count6 = tranDao.saveTran(tran);
            if(1 != count6){
                //新增交易失败
                flag = false;
                throw new ConvertException("新增交易失败！");
            }
            System.out.println("saveTran finish!");
            //-----程序运行到此处，已经新增交易-----
            //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(createTime);
            tranHistory.setCreateBy(createBy);
            tranHistory.setTranId(tran.getId());
            int count7 = tranHistoryDao.saveTranHistory(tranHistory);
            if(1 != count7){
                //新增交易历史失败
                flag = false;
                throw new ConvertException("新增交易历史失败！");
            }
            System.out.println("saveTranHistory finish!");
        }
        //-----程序运行到此处，已经新增交易历史-----
        //(8) 删除线索备注
        for(ClueRemark clueRemark : clueRemarkList) {
            int count8 = clueRemarkDao.deleteClueRemark(clueRemark);
            if(1 != count8){
                //删除线索备注失败
                flag = false;
                throw new ConvertException("删除线索备注失败！");
            }
        }
        System.out.println("deleteClueRemark finish!");
        //-----程序运行到此处，已经删除线索备注-----
        //(9) 删除线索和市场活动的关系
        for(ClueActivityRelation clueActivityRelation: clueActivityRelationList){
            int count9 = clueActivityRelationDao.deleteRelation(clueActivityRelation);
            if(1 != count9){
                //删除线索和市场活动关系失败
                flag = false;
                throw new ConvertException("删除线索和市场活动关系失败！");
            }
        }
        System.out.println("deleteClueActivityRelationRemark finish!");
        //-----程序运行到此处，已经删除线索和活动关系-----
        //(10) 删除线索
        int count10 = clueDao.deleteClue(clueId);
        if(1 != count10){
            flag = false;
            //删除线索失败
            throw new ConvertException("删除线索失败！");
        }
        System.out.println("deleteClue finish!");
        return flag;
        
    }
}
