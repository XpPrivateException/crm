<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>welcome!</title>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" >
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" >
    
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
			pickerPosition: "bottom-left"
		});
		
		//创建按钮的事件
        $("#addBtn").click(function(){
			$.ajax({
				url: "workbench/activity/getUsers.do",
				type: "get",
				data: "",
				dataType: "json",
				success: function(data){
					//添加模态窗口中的用户
					var ownerOption = "";
					$.each(data,function(index,element){
						ownerOption += "<option value='" + element.id + "'>" + element.name + "</option>";
					});
					$("#create-owner").html(ownerOption);
					//将当前登录的用户设置为下拉框默认选项
					$("#create-owner").val("${sessionScope.user.id}");
					//操作模态窗口：调用模态窗口的jquery对象调用modal方法，show:打开窗口，hide:关闭窗口
					$("#createActivityModal").modal("show");
				}
			})
        })
		
		//创建的模态窗口的保存按钮添加事件
		$("#saveBtn").click(function(){
			$.ajax({
				url: "workbench/activity/saveActivity.do",
				type: "post",
				data: {
					"owner": $("#create-owner").val().trim(),
					"name": $("#create-name").val().trim(),
					"startDate": $("#create-startDate").val().trim(),
					"endDate": $("#create-endDate").val().trim(),
					"cost": $("#create-cost").val().trim(),
					"description": $("#create-description").val().trim()
				},
				dataType: "json",
				success: function(data){
					if(data.flag){
						//添加成功后，回到第一页，维持每页的记录数
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						//清空模态窗口的内容，关闭模态窗口
						$("#addActivityForm")[0].reset();
						$("#createActivityModal").modal("hide");
					}else{
						//添加失败，弹出消息
						alert("新增市场活动失败");
					}
				}
			});
		});
		
        //修改按钮的事件
        $("#editBtn").click(function() {
			
			var $delActivity = $("input[name=activityBox]:checked");
			if ($delActivity.length == 0) {
				alert("请选择需要修改的市场活动");
			} else if ($delActivity.length > 1) {
				alert("请选择仅1条记录进行修改")
			} else {
				//根据选中的id，在模态窗口显示具体信息
				var id = $delActivity.val();
				$.ajax({
					url: "workbench/activity/selectUserAndActivity.do",
					type: "post",
					data: {"id":id},
					dataType: "json",
					success: function(data){
						//处理下拉框
						var html = "";
						$.each(data.userList,function(index,element){
							html += "<option value='" + element.id + "'>" + element.name + "</option>";
						})
						$("#edit-owner").html(html);
						//处理表单项的activity
						$("#edit-name").val(data.activity.name);
						$("#edit-owner").val(data.activity.owner);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-description").val(data.activity.description);
						$("#edit-id").val(data.activity.id);
						//打开模态窗口
						$("#editActivityModal").modal("show");
					}
				});
				
			}
		})
		
		//修改模态窗口的修改按钮添加事件
		$("#updateBtn").click(function(){
			$.ajax({
				url: "workbench/activity/updateActivity.do",
				type: "post",
				data: {
					"id": $("#edit-id").val().trim(),
					"owner": $("#edit-owner").val().trim(),
					"name": $("#edit-name").val().trim(),
					"startDate": $("#edit-startDate").val().trim(),
					"endDate": $("#edit-endDate").val().trim(),
					"cost": $("#edit-cost").val().trim(),
					"description": $("#edit-description").val().trim()
				},
				dataType: "json",
				success: function(data){
					if(data.flag){
						//修改成功后，维持原有的页数和条数
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
					}else{
						//添加失败，弹出消息
						alert("修改市场活动失败");
					}
				}
			});
		})
		
		//全选/全不选
		$("#checkAll").click(function(){
			$("input[name=activityBox]").prop("checked",this.checked);
		})
		
		//为查询按钮绑定分页查询方法
		$("#queryBtn").click(function(){
			//将查询条件保存到隐藏域
			$("#hidden-name").val($("#query-name").val());
			$("#hidden-owner").val($("#query-owner").val());
			$("#hidden-startDate").val($("#query-startDate").val());
			$("#hidden-endDate").val($("#query-endDate").val());
			pageList(1,2);
		})
		
		//删除按钮的事件
		$("#deleteBtn").click(function(){
			var $delActivity = $("input[name=activityBox]:checked");
			if($delActivity.length == 0){
				//程序执行到此处，说明没有选择要删除的选项
				alert("请选择需要删除的市场活动");
			}else{
				//url:workbench/activity/deleteActivity.do？id=xxx&id=xxx
				//程序执行到此处，进行删除，拼接id字符串
				var param = ""
				for(var i = 0; i< $delActivity.length; i++){
					param += "id=";
					param += $delActivity[i].value;
					if(i < $delActivity.length-1) {
						param += "&";
					}
				}
				if(window.confirm("删除操作不可逆，确认删除?")){
					//发送ajax请求
					$.ajax({
						url: "workbench/activity/deleteActivity.do",
						type: "post",
						data: param,
						dataType: "json",
						success: function(data){
							if(data.flag){
								//删除成功后，回到第一页，维持条数
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								//删除失败，回到第一页，维持条数
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}
						}
					})
				}
			}
		})

		//页面加载完成之后，触发分页查询列表方法
		pageList(1,2);
	});
	
	//复选框
	function activityCheck(){
		$("#checkAll").prop("checked",$("input[name=activityBox]:checked").length == $("input[name=activityBox]").length);
	}
	
	//动态分页查询
	function pageList(pageNo,pageSize){
		//去除复选框
		$("#checkAll").prop("checked",false);
		//将隐藏域保存的信息取出来，写进搜索框
		$("#query-name").val($("#hidden-name").val());
		$("#query-owner").val($("#hidden-owner").val());
		$("#query-startDate").val($("#hidden-startDate").val());
		$("#query-endDate").val($("#hidden-endDate").val());
		$.ajax({
			url: "workbench/activity/pageSelectActivity.do",
			type: "get",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"name": $("#query-name").val().trim(),
				"owner": $("#query-owner").val().trim(),
				"startDate": $("#query-startDate").val().trim(),
				"endDate": $("#query-endDate").val().trim()
			},
			dataType: "json",
			success: function(data){
			/*
				需要的参数：总条数,分页查询得到的数据
				data:[{"total":100},
				{"dataList":[{市场活动1},{市场活动2},{市场活动3}]}]
			*/
				var addActivity = "";
				$.each(data.dataList,function(index,element){
					addActivity +=	"<tr class='active'>";
					addActivity +=	"	<td><input type='checkbox' name='activityBox' value='" + element.id + "' onclick='activityCheck()'/></td>";
					addActivity +=	"	<td><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\"workbench/activity/selectActivityDetail.do?id=" + element.id + "\";'>" + element.name + "</a></td>";
					addActivity +=	"	<td>" + element.owner + "</td>";
					addActivity +=	"	<td>" + element.startDate + "</td>";
					addActivity +=	"	<td>" + element.endDate + "</td>";
					addActivity +=	"</tr>";
				})
				$("#activityBody").html(addActivity);
				//总页数
				var totalPages = data.total % pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize) + 1
				//数据处理完毕后，结合分页查询展现分页信息
				$("#activityPage").bs_pagination({
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
						$("#checkAll").prop("checked",false);
					}
				});
			}
		});
	}
	
    </script>
</head>
<body>
	<input type="hidden" id="hidden-name" />
	<input type="hidden" id="hidden-owner" />
	<input type="hidden" id="hidden-startDate" />
	<input type="hidden" id="hidden-endDate" />
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="addActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" style="cursor: pointer" readonly />
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" style="cursor: pointer" readonly />
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id" />
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="发传单"/>
                            </div>
						</div>
						
						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" style="cursor: pointer" readonly/>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" style="cursor: pointer" readonly/>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost"/>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
					  <input class="form-control" type="text" id="query-name">
					</div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="queryBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
                    <!--
                        data-toggle="modal"：点击按钮，打开一个模态窗口
                        data-target="#id"：打开哪个模态窗口，通过#id来寻找
                        但这样写死后，按钮的功能无法扩充
                        对于触发模态窗口的操作，应该由js代码操作
                    -->
				  <button type="button" class="btn btn-primary" id="addBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
					
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">
				
				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>