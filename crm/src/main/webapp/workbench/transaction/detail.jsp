<%@ page import="com.hzh.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.hzh.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
    //准备字典类型为stage的字典值列表
	List<DicValue> dvList = (List<DicValue>) application.getAttribute("stage");
    //准备阶段和可能性之间的对应关系
	Map<String,String> pMap = (Map<String, String>) application.getAttribute("possibilityMap");
    Set<String> pSet = pMap.keySet();
    //获取分界点阶段的stage下标
	int cutPoint = 0;
	for(int i=0; i< dvList.size(); i++){
        DicValue dicValue = dvList.get(i);
        String stage = dicValue.getValue();
        //如果这个阶段在pMap中的可能性为0，说明这个阶段就是分界点
        if("0".equals(pMap.get(stage))){
			cutPoint = i;
            break;
        }
	}
%>
<!DOCTYPE html>
<html>
    <head>
        <base href="<%=basePath%>">
        <meta charset="UTF-8">

        <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

        <style type="text/css">
        .mystage{
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }
        .closingDate{
            font-size : 15px;
            cursor: pointer;
            vertical-align: middle;
        }
        </style>
	
        <script type="text/javascript" src="jquery/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
        
        <script type="text/javascript">
        
            //默认情况下取消和保存按钮是隐藏的
            var cancelAndSaveBtnDefault = true;
            
            $(function(){
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
                
                
                //阶段提示框
                $(".mystage").popover({
                    trigger:'manual',
                    placement : 'bottom',
                    html: 'true',
                    animation: false
                }).on("mouseenter", function () {
                            var _this = this;
                            $(this).popover("show");
                            $(this).siblings(".popover").on("mouseleave", function () {
                                $(_this).popover('hide');
                            });
                        }).on("mouseleave", function () {
                            var _this = this;
                            setTimeout(function () {
                                if (!$(".popover:hover").length) {
                                    $(_this).popover("hide")
                                }
                            }, 100);
                        });
				
				//在页面加载完成后，展示历史列表
				showHistoryList()
            });
			
			//展示历史列表
			function showHistoryList(){
				$.ajax({
					url: "workbench/transaction/getHistoryListByTranId.do",
					type: "get",
					data:{"tranId": "${requestScope.tran.id}"},
					dataType: "json",
					success: function(data){
						var html = "";
						$.each(data,function(index,element){
							html += '<tr>';
							html += '<td>' + element.stage + '</td>';
							html += '<td>' + element.money + '</td>';
							html += '<td>' + element.possibility + '</td>';
							html += '<td>' + element.expectedDate + '</td>';
							html += '<td>' + element.createTime + '</td>';
							html += '<td>' + element.createBy + '</td>';
							html += '</tr>';
						})
						$("#tranHistoryBody").html(html);
					}
					
				})
			}
   
			//改变阶段
            function changeStage(stage,index){
				$.ajax({
					url: "workbench/transaction/changeStage.do",
					type: "post",
					data: {
						"id": "${tran.id}",
						"stage": stage,
						"money": "${tran.money}",
						"expectedDate": "${tran.expectedDate}"
					},
					dataType: "json",
					success: function(data){
						if(data.flag){
							//data: {"flag":true/false,"stage":"?","possibility":"?","editBy":"?","editTime":"?"}
							//改变阶段成功，需要刷新详细信息页
							alert("改变阶段成功！");
							$("#stage").text(data.tran.stage);
							$("#possibility").text(data.tran.possibility);
							$("#editBy").text(data.tran.editBy);
							$("#editTime").text(data.tran.editTime);
							//改变图标颜色
							changeIcon(stage,index);
						}else{
							alert("改变阶段失败！");
						}
					
					}
				})
			}
   
			//改变阶段图标
			function changeIcon(stage,index) {
				//获取当前阶段信息
				var currentPossibility = $("#possibility").text();
				var point = "<%=cutPoint%>"
				//如果当前阶段可能性为0
				if ("0" == currentPossibility) {
					//1、程序执行到此处，说明交易失败了，需要判断当前具体的阶段
					for (var i = 0; i < point; i++) {
						//前七个一定是黑圈
						$("#"+i).removeClass();
						$("#"+i).addClass("glyphicon glyphicon-record mystage");
						$("#"+i).css("color","#000000");
					}
					for (var i = point; i < <%=dvList.size()%>; i++) {
						//程序执行到此，说明已循环到交易失败的阶段
						if (index == i) {
							//程序执行到此，说明已经循环到了当前的失败阶段，将其设置为红X
							$("#"+ index).removeClass();
							$("#"+ index).addClass("glyphicon glyphicon-remove mystage");
							$("#"+ index).css("color","red");
						}else{
							//程序执行到此，说明当前失败阶段不是循环到的的失败阶段，将其设置为黑X
							$("#"+ i).removeClass();
							$("#"+ i).addClass("glyphicon glyphicon-remove mystage");
							$("#"+ i).css("color","#000000");
						}
					}
				}else{
					//1、程序执行到此处，说明当前交易未失败，可以判断完成了哪些阶段，未完成哪些阶段、当前处于哪个加断
					for (var i = 0; i < point; i++) {
						if (i == index) {
							//程序执行到此处，说明正处于当前阶段，设置样式
							$("#"+i).removeClass();
							$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
							$("#"+i).css("color","#90F790");
						} else if(i < index){
							//程序执行到此处，说明当前的阶段已经完成了，设置样式
							$("#"+i).removeClass();
							$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
							$("#"+i).css("color","#90F790");
						} else if (i > index) {
							//程序执行到此处，说明当前阶段未完成，设置样式
							$("#"+i).removeClass();
							$("#"+i).addClass("glyphicon glyphicon-record mystage");
							$("#"+i).css("color","#000000");
						}
					}
					for (var i = point; i < <%=dvList.size()%>; i++) {
						//程序执行到此，说明已循环到交易失败的阶段，将其设置为黑X
						$("#"+ i).removeClass();
						$("#"+ i).addClass("glyphicon glyphicon-remove mystage");
						$("#"+ i).css("color","#000000");
					}
				}
			}
			
		</script>
		
	</head>
	<body>
		
		<!-- 返回按钮 -->
		<div style="position: relative; top: 35px; left: 10px;">
			<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
		</div>
		
		<!-- 大标题 -->
		<div style="position: relative; left: 40px; top: -30px;">
			<div class="page-header">
				<h3>${requestScope.tran.customerId}-${requestScope.tran.name} <small>￥${requestScope.tran.money}</small></h3>
			</div>
			<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
				<button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
				<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>
		</div>
		
		<!-- 阶段状态 -->
		<div style="position: relative; left: 40px; top: -50px;">
			阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				//根据当前交易的阶段，确定图标的样式，并根据交易失败的分界点cutPoint确定失败的样式
				//获取当前交易
				Tran currentTran = (Tran) request.getAttribute("tran");
				//获取当前交易阶段及其对应可能性
				String currentStage = currentTran.getStage();
				String currentPossibility = currentTran.getPossibility();
				//根据当前阶段和可能性，动态设置span的样式
				//先判断当前阶段是不是交易失败
				if("0".equals(currentPossibility)){
					int index = 0;
					//1、程序执行到此处，说明交易失败了，需要判断当前具体的阶段
					for(DicValue dicValue: dvList){
						String tempText = dicValue.getText();
						//当前循环到了哪个阶段
						String tempStage = dicValue.getValue();
						//当前循环到了哪个可能性
						String tempPossibility = pMap.get(tempStage);
						//2、先判断是否循环到了交易失败的阶段
						if("0".equals(tempPossibility)){
							//程序执行到此，说明已循环到交易失败的阶段
							//3、需要判断循环到的阶段是否是当前的阶段，因为需要二选一，如果是则设置为红色，不是为黑色
							if(currentStage.equals(tempStage)){
								//程序执行到此，说明已经循环到了当前的失败阶段，将其设置为红X
			%>
								<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" style="color: red;"></span>-----------
			<%
							}else{
								//程序执行到此，说明当前失败阶段不是循环到的的失败阶段，将其设置为黑X
			%>
								<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" ></span>-----------
			<%
							}
						}else{
							//2、程序执行到此，说明循环到的不是交易失败的阶段，直接设置为黑X
			%>
							<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" ></span>-----------
			<%
						}
					index++;
				}
				}else{
					int index = 0;
					//1、程序执行到此处，说明当前交易未失败，可以判断完成了哪些阶段，未完成哪些阶段、当前处于哪个加断
					for(DicValue dicValue: dvList){
						String tempText = dicValue.getText();
						//循环到了哪个阶段
						String tempStage = dicValue.getValue();
						//循环到了哪个可能性
						String tempPossibility = pMap.get(tempStage);
						//2、先判断是否循环到了交易失败的阶段
						if("0".equals(tempPossibility)){
							//程序执行到此，说明循环到了交易失败的阶段，直接设置样式为黑X
			%>
							<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" ></span>-----------
			<%
						}else {
							//3、程序执行到此，说明不是交易失败的阶段，可以开始定位当前处于哪个阶段
							if (currentPossibility.equals(tempPossibility)) {
								//程序执行到此处，说明正处于当前阶段，设置样式
			%>
								<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" style="color: #90F790;"></span>-----------
			<%
							}else if(Integer.parseInt(tempPossibility) < Integer.parseInt(currentPossibility)){
								//程序执行到此处，说明当前的阶段已经完成了，设置样式
			%>
								<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" style="color: #90F790;"></span>-----------
			<%
							}else if(Integer.parseInt(tempPossibility) > Integer.parseInt(currentPossibility)){
								//程序执行到此处，说明当前阶段未完成，设置样式
			%>
								<span id='<%=index%>' onclick="changeStage('<%=tempStage%>','<%=index%>')" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="<%=tempText%>" ></span>-----------
			<%
							}
						}
					}
					index++;
					
				}

			%>

			<span class="closingDate">${requestScope.tran.expectedDate}</span>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
	<div style="position: relative; left: 40px; height: 30px;">
		<div style="width: 300px; color: gray;">所有者</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.owner}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.money}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 10px;">
		<div style="width: 300px; color: gray;">名称</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerId}-${requestScope.tran.name}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.expectedDate}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 20px;">
		<div style="width: 300px; color: gray;">客户名称</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerId}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${requestScope.tran.stage}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 30px;">
		<div style="width: 300px; color: gray;">类型</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.type}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${requestScope.tran.possibility}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 40px;">
		<div style="width: 300px; color: gray;">来源</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.source}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.activityId}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 50px;">
		<div style="width: 300px; color: gray;">联系人名称</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.contactsId}</b></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 60px;">
		<div style="width: 300px; color: gray;">创建者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.createTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 70px;">
		<div style="width: 300px; color: gray;">修改者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${requestScope.tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${requestScope.tran.editTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 80px;">
		<div style="width: 300px; color: gray;">描述</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${requestScope.tran.description}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 90px;">
		<div style="width: 300px; color: gray;">联系纪要</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${requestScope.tran.contactSummary}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 100px;">
		<div style="width: 300px; color: gray;">下次联系时间</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.nextContactTime}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
	<div class="page-header">
		<h4>备注</h4>
	</div>

<!-- 备注1 -->
<div class="remarkDiv" style="height: 60px;">
	<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
	<div style="position: relative; top: -40px; left: 40px;" >
		<h5>哎呦！</h5>
		<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
		<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
		</div>
	</div>
</div>

<!-- 备注2 -->
<div class="remarkDiv" style="height: 60px;">
	<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
	<div style="position: relative; top: -40px; left: 40px;" >
		<h5>呵呵！</h5>
		<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
		<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
		</div>
	</div>
</div>

<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
	<form role="form" style="position: relative;top: 10px; left: 10px;">
		<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
		<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
			<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
			<button type="button" class="btn btn-primary">保存</button>
		</p>
	</form>
</div>
</div>

	<!-- 阶段历史 -->
	<div>
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>阶段历史</h4>
		</div>
		<div style="position: relative;top: 0px;">
			<table id="activityTable" class="table table-hover" style="width: 900px;">
				<thead>
					<tr style="color: #B3B3B3;">
						<td>阶段</td>
						<td>金额</td>
						<td>可能性</td>
						<td>预计成交日期</td>
						<td>创建时间</td>
						<td>创建人</td>
					</tr>
				</thead>
				<tbody id="tranHistoryBody">
				
				
				</tbody>
			</table>
		</div>
		
	</div>
	</div>

	<div style="height: 200px;"></div>

	</body>
</html>