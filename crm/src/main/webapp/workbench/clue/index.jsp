<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
    <head>
        <base href="<%=basePath%>">
        <meta charset="UTF-8">
        <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
        <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
        
        <script type="text/javascript" src="jquery/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
		<link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" >
		<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
		<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
        <script type="text/javascript">

	        $(function(){
				
				//日历控件
				$(".time").datetimepicker({
					minView: "month",
					language:  'zh-CN',
					format: 'yyyy-mm-dd',
					autoclose: true,
					todayBtn: true,
					pickerPosition: "top-left"
				});
				
				//在打开添加线索模态窗口时，获取所有者的下拉框选项
				$("#addClueBtn").click(function(){
					$.ajax({
						url: "workbench/clue/getUserList.do",
						type: "get",
						data: "",
						dataType: "json",
						success: function(data){
							//data:[{用户1},{用户2}]
							var html = "";
							$.each(data,function(index,element){
								html += "<option value='" + element.id + "'>" + element.name + "</option>";
							})
							$("#create-owner").html(html);
							//让默认选中
							$("#create-owner").val("${sessionScope.user.id}");
							$("#createClueModal").modal("show");
						}
					})
				})
		
				//新增线索的保存事件
				$("#saveClueBtn").click(function(){
					$.ajax({
						url: "workbench/clue/saveClue.do",
						type: "post",
						data: {
							"fullname": $("#create-fullname").val().trim(),
							"appellation": $("#create-appellation").val().trim(),
							"owner": $("#create-owner").val().trim(),
							"company": $("#create-company").val().trim(),
							"job": $("#create-job").val().trim(),
							"email": $("#create-email").val().trim(),
							"phone": $("#create-phone").val().trim(),
							"website": $("#create-website").val().trim(),
							"mphone": $("#create-mphone").val().trim(),
							"state": $("#create-state").val().trim(),
							"source": $("#create-source").val().trim(),
							"description": $("#create-description").val().trim(),
							"contactSummary": $("#create-contactSummary").val().trim(),
							"nextContactTime": $("#create-nextContactTime").val().trim(),
							"address": $("#create-address").val().trim()
						},
						dataType: "json",
						success: function(data){
							if(data.flag){
								//增加成功
								alert("添加成功!");
								$("#createClueModal").modal("hide");
								pageList(1,2);
							}else{
								//增加失败
								alert("添加失败!");
							}
						}
					})
				})
				
				//分页查询按钮事件
				$("#queryBtn").click(function(){
					//当点击时，给隐藏域赋值
					$("#hidden-fullname").val($("#query-fullname").val());
					$("#hidden-company").val($("#query-company").val());
					$("#hidden-phone").val($("#query-phone").val());
					$("#hidden-source").val($("#query-source").val());
					$("#hidden-owner").val($("#query-owner").val());
					$("#hidden-mphone").val($("#query-mphone").val());
					$("#hidden-state").val($("#query-state").val());

					//触发分页查询
					pageList(1,2);
				})

				//全选/全不选
				$("#checkAll").click(function(){
					$("input[name=clueBox]").prop("checked",this.checked);
				})
				
				//页面加载完成后，进行查询
				pageList(1,2)
	        });
			
			//复选框
			function clueCheck(){
				$("#checkAll").prop("checked",$("input[name=clueBox]:checked").length == $("input[name=clueBox]").length);
			}
			
			//分页查询
			function pageList(pageNo, pageSize){
				//将隐藏域取出来，赋值给搜索框
				$("#query-fullname").val($("#hidden-fullname").val());
				$("#query-company").val($("#hidden-company").val());
				$("#query-phone").val($("#hidden-phone").val());
				$("#query-source").val($("#hidden-source").val());
				$("#query-owner").val($("#hidden-owner").val());
				$("#query-mphone").val($("#hidden-mphone").val());
				$("#query-state").val($("#hidden-state").val());
				//发送ajax请求
				$.ajax({
					url: "workbench/clue/pageSelectClue.do",
					type: "get",
					data: {
						"pageNo": pageNo,
						"pageSize": pageSize,
						"fullname": $("#query-fullname").val().trim(),
						"company": $("#query-company").val().trim(),
						"phone": $("#query-phone").val().trim(),
						"source": $("#query-source").val().trim(),
						"owner": $("#query-owner").val().trim(),
						"mphone": $("#query-mphone").val().trim(),
						"state": $("#query-state").val().trim(),
					},
					dataType: "json",
					success: function(data){
						var html = "";
						$.each(data.dataList,function(index,element){
							html += "<tr>";
							html += "<td><input type='checkbox' name='clueBox' value='" + element.id + "' onclick='clueCheck()' /></td>";
							//onclick='window.location.href='workbench/clue/detail.do?id=';'
							html += "<td><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"workbench/clue/clueDetail.do?id=" + element.id + "\";' >" + element.fullname + "</a></td>";
							html += "<td>" + element.company + "</td>";
							html += "<td>" + element.phone + "</td>";
							html += "<td>" + element.mphone + "</td>";
							html += "<td>" + element.source + "</td>";
							html += "<td>" + element.owner + "</td>";
							html += "<td>" + element.state + "</td>";
							html += "</tr>";
						})
						$("#clueBody").html(html);
						//总页数
						var totalPages = data.total % pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize) + 1
						//数据处理完毕后，分页展示信息
						$("#cluePage").bs_pagination({
							currentPage: pageNo, // 页码
							rowsPerPage: pageSize, // 每页显示的记录条数
							maxRowsPerPage: 20, // 每页最多显示的记录条数
							totalPages: totalPages, // 总页数
							totalRows: data.total, // 总记录条数
							visiblePageLinks: 3, // 显示几个卡片
							showGoToPage: true,
							showRowsPerPage: true,
							showRowsInfo: true,
							showRowsDefaultInfo: true,
							//回调函数，当点击分页组件时触发
							onChangePage : function(event, data){
								pageList(data.currentPage , data.rowsPerPage);
							}
						})
					}
				})
			}
			
        </script>
</head>
<body>
	
	<input type="hidden" id="hidden-fullname"/>
	<input type="hidden" id="hidden-company"/>
	<input type="hidden" id="hidden-phone"/>
	<input type="hidden" id="hidden-source"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-mphone"/>
	<input type="hidden" id="hidden-state"/>
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<c:forEach items="${applicationScope.appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<c:forEach items="${applicationScope.clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<c:forEach items="${applicationScope.source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
			
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="query-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
						  <option value=""></option>
						  <c:forEach items="${applicationScope.source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
					
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="query-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
						  <option value=""></option>
						  <c:forEach items="${applicationScope.clueState}" var="c">
							  <option value="${c.value}">${c.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
					
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage">
				
				</div>
				
			</div>
			
		</div>
		
	</div>
</body>
</html>