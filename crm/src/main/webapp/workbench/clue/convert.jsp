<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
    <head>
        <base href="<%=basePath%>">
		<meta charset="UTF-8">
		
		<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
		<script type="text/javascript" src="jquery/jquery-1.12.4.js"></script>
		<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
		
		
		<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
		<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
		<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

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
				$("#isCreateTransaction").click(function(){
					if(this.checked){
						$("#create-transaction2").show(200);
					}else{
						$("#create-transaction2").hide(200);
					}
				});
				
				//放大镜的弹出模态窗口事件
				$("#openSearchModalBtn").click(function(){
					$("#searchActivityModal").modal("show");
				})
				
				//模态窗口的搜索事件
				$("#activityName").keydown(function(event){
					if(13==event.keyCode){
						$.ajax({
							url: "workbench/clue/getActivityListByName",
							type: "get",
							data: {"activityName": $("#activityName").val().trim()},
							dataType: "json",
							success: function(data){
								//data:[{市场活动1},{2},{3}]
								var html = "";
								$.each(data,function(index,element){
									html += '<tr>';
									html += '<td><input type="radio" name="activityRadio" value="' + element.id + '"/></td>';
									html += '<td id="' + element.id + '">' + element.name + '</td>';
									html += '<td>' + element.startDate + '</td>';
									html += '<td>' + element.endDate + '</td>';
									html += '<td>' + element.owner + '</td>';
									html += '</tr>';
								})
								$("#activitySearchBody").html(html);
							}
						});
						return false;
					}
				})
				
				//选择市场活动提交的事件
				$("#submitActivityBtn").click(function(){
					//将选择项的id填充到activityId隐藏域，将文本填充到activityNameText
					var activityId = $(":input[name=activityRadio]:checked").val();
					var activityName = $("#"+activityId).text();
					$("#activityId").val(activityId);
					$("#activityNameText").val(activityName);
					//关闭模态窗口，清空搜索框内容，取消选中
					$("#searchActivityModal").modal("hide");
					$("#activityName").val("");
					$(":input[name=activityRadio]:checked").prop("checked",false);
				})
				
				//线索转换按钮的事件
				$("#convertBen").click(function(){
					if(window.confirm("确定将当前线索转换吗？")){
						//操作完毕后，响应回到线索页面
						//当点击确定转换，发出传统请求到后台，操作数据库。
						//如果用户选择了”为客户创建交易“，需要分支判断
						if($("#isCreateTransaction").prop("checked")){
							//需要创建交易，同时提交交易的信息，直接提交表单
							//workbench/clue/convert.do?clueId=xxx&money=xxx&expectedDate=xxx&name=xxx&stage=xxx&activityId=xxx
							$("#tranForm").submit()
						}else{
							//不需要创建交易，只需要线索的id
							window.location.href = "workbench/clue/convert.do?clueId=${param.id}";
						}
					}
					
				})
			});
		</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">
						
						
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="tranForm" action="workbench/clue/convert.do" method="post">
			<input type="hidden" name="flag" value="a" />
			<input type="hidden" name="clueId" value="${param.id}">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option value=""></option>
		    	<c:forEach items="${applicationScope.stage}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityNameText" placeholder="点击上面搜索" readonly>
			  <input type="hidden" id="activityId" name="activityId"/>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convertBen" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>