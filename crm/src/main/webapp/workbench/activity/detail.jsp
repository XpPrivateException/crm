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
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" >
	
	<script type="text/javascript" src="jquery/jquery-1.12.4.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" >
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
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
		
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		
		//删除市场活动
		$("#deleteActivityBtn").click(function(){
			if(window.confirm("删除操作不可逆，确认删除?")){
				var id = $("#activityId").val();
				//发送ajax请求
				$.ajax({
					url: "workbench/activity/deleteActivity.do",
					type: "post",
					data: {"id":id},
					dataType: "json",
					success: function(data){
						if(data.flag){
							alert("删除成功!");
							window.location="workbench/activity/index.jsp";
						}else{
							alert("删除失败")
						}
					}
				})
			}
		})
		
		//打开修改市场活动给模态窗口
		$("#editActivityBtn").click(function(){
			
			//根据选中的id，在模态窗口显示具体信息
			var id = $("#activityId").val();
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
			
		})
		
		//修改市场活动
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
				success: function(data) {
					if (data.flag) {
						alert("修改成功!");
						//关闭模态窗口，回到上一页
						$("#editActivityModal").modal("hide");
						window.location = "workbench/activity/index.jsp";
					} else {
						//添加失败，弹出消息
						alert("修改市场活动失败");
					}
				}
			})
		})
		
		//保存备注
		$("#saveRemarkBtn").click(function(){
			var activityId = $("#activityId").val().trim();
			var noteContent = $("#remark").val().trim();
			$.ajax({
				url: "workbench/activity/saveRemark.do",
				type: "post",
				data: {"activityId": activityId,"noteContent":noteContent},
				dataType: "json",
				success: function(data){
					if(data.flag){
						//增加成功，在备注中显示该备注
						alert("添加成功!");
						//清空文本域内容
						$("#remark").val("");
						var html = "";
						//拼接前端页面
						html += '<div id="' + data.remark.id + '" class="remarkDiv" style="height: 60px;">';
						html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="note'+ data.remark.id + '" >' + data.remark.noteContent + '</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;" id="etime' + data.remark.id + '"> ' +  data.remark.createTime  + ' 由' +  data.remark.createBy  + '</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" onclick="editRemark(\'' + data.remark.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" onclick="deleteRemark(\'' + data.remark.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';
						$("#remarkDiv").before(html);
						//动画效果
						$("#remarkBody").on("mouseover",".remarkDiv",function(){
							$(this).children("div").children("div").show();
						})
						$("#remarkBody").on("mouseout",".remarkDiv",function(){
							$(this).children("div").children("div").hide();
						})
					}else{
						//增加失败
						alert("添加失败,请联系管理员!");
					}
				}
			})
		})
		
		//修改备注的事件
		$("#updateRemarkBtn").click(function(){
			var id = $("#remarkId").val();
			var noteContent = $("#noteContent").val().trim();
			$.ajax({
				url: "workbench/activity/updateRemark.do",
				type: "post",
				data: {
					"id": id,
					"noteContent": noteContent,
				},
				dataType: "json",
				success: function(data){
					if(data.flag){
						//修改成功，清空文本域内容，更新页面的备注信息(noteContent、editTime、editBy)
						alert("修改成功!");
						$("#noteContent").val("");
						$("#note" + id).text(noteContent);
						$("#etime" + id).text(data.remark.editTime + '由' + data.remark.editBy);
						$("#editRemarkModal").modal("hide");
					}else{
						//修改失败
						alert("修改失败,请联系管理员!");
						$("#editRemarkModal").modal("hide");
					}
				}
			})
		})
		
		//页面加载完毕后，展现关联的备注信息列表
		showRemarkList();
	})
	//展现备注信息
	function showRemarkList(){
		//根据市场活动id查询关联备注
		$.ajax({
			url: "workbench/activity/getRemarkListByActivityId.do",
			type: "get",
			data: {"activityId": "${requestScope.activity.id}"},
			dataType: "json",
			success: function(data){
				var html = "";
				$.each(data,function(index,element){
					//拼接前端页面
					html += '<div id="' + element.id + '" class="remarkDiv" style="height: 60px;">';
					html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="note'+ element.id + '" >' + element.noteContent + '</h5>';
					html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;" id="etime' + element.id + '"> ' + (element.editFlag == 0 ? element.createTime : element.editTime) + ' 由' + (element.editFlag == "0" ? element.createBy : element.editBy) + '</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" onclick="editRemark(\'' + element.id + '\')"  href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" onclick="deleteRemark(\'' + element.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				})
				$("#remarkDiv").before(html);
				//动画效果
				$("#remarkBody").on("mouseover",".remarkDiv",function(){
					$(this).children("div").children("div").show();
				})
				$("#remarkBody").on("mouseout",".remarkDiv",function(){
					$(this).children("div").children("div").hide();
				})
			}
		})
	}
	
	//删除备注
	function deleteRemark(id){
		if(window.confirm("删除操作不可逆，确认删除?")){
			$.ajax({
				url: "workbench/activity/deleteRemarkById.do",
				type: "post",
				data: {"id":id},
				dataType: "json",
				success: function(data){
					if(data.flag){
						//删除成功，刷洗列表
						alert("删除成功!");
						$("#" + id).remove();
						showRemarkList();
					}else{
						alert("删除失败,请联系管理员!");
					}
				}
			})
		}
	}
	
	//打开修改备注的模态窗口
	function editRemark(id){
		//将备注的信息填充到文本域中，再打开模态窗口
		$("#remarkId").val(id);
		$("#noteContent").val($("#note"+ id).text());
		$("#editRemarkModal").modal("show");
	}
	
	
	
    </script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="update-remark">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                    <h4 class="modal-title" id="update-activity">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startDate" />
                            </div>
                            <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endDate" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" />
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<input type="hidden" id="activityId" value="${requestScope.activity.id}"/>
		<div class="page-header">
			<h3>市场活动-${requestScope.activity.name}<small> ${requestScope.activity.startDate} ~ ${requestScope.activity.endDate} </small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteActivityBtn" ><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>