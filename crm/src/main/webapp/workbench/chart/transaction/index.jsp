<%--
  Created by IntelliJ IDEA.
  User: hzh
  Date: 2021/10/24
  Time: 21:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Title</title>
		<script src="ECharts/echarts.min.js"></script>
		<script type="text/javascript" src="jquery/jquery-1.12.4.js"></script>
		<script type="text/javascript">
			$(function(){
				//在页面加载完后，回值统计图表
				getCharts()

			})
			function getCharts(){
				//发送ajax获取json
				$.ajax({
					url: "workbench/transaction/getCharts.do",
					type: "get",
					data: "",
					dataType: "json",
					success: function(data){
						//data:{total:?},{dataList:[{value:xxx,name:xxx},{value:xxx,name:xxx}]}
						//初始化
						var myChart = echarts.init(document.getElementById('main'));
						option = {
							title: {
								text: '交易漏斗图',
								subtext: '统计交易阶段数量的漏斗图'
							},
							series: [
								{
									name: '交易漏斗图',
									type: 'funnel',
									left: '10%',
									top: 60,
									bottom: 60,
									width: '80%',
									min: 0,
									max: data.total,
									minSize: '0%',
									maxSize: '100%',
									sort: 'descending',
									gap: 2,
									label: {
										show: true,
										position: 'inside'
									},
									labelLine: {
										length: 10,
										lineStyle: {
											width: 1,
											type: 'solid'
										}
									},
									itemStyle: {
										borderColor: '#fff',
										borderWidth: 1
									},
									emphasis: {
										label: {
											fontSize: 20
										}
									},
									data: data.dataList
								/*[
										
										{ value: 60, name: '01资质审查' },
										{ value: 40, name: '02需求分析' },
										{ value: 20, name: '03价值建议' },
										{ value: 80, name: '06谈判复审' },
										{ value: 100, name: '07成交' }
										
									]
								*/
								}
							]
						};
						//显示图表
						myChart.setOption(option);
					}
				})
				
			}
		</script>
	</head>
	<body>
		<div id="main" style="width: 600px;height:400px;"></div>
	</body>
</html>
