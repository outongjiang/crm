<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<%--引入jQuery--%>
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<%--引入bootstrap框架--%>
	<link rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<%--引入BOOTSTRAP_DATATIMEPICKER插件--%>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>
	<script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
	<meta charset="UTF-8">
	<title>演示echarts插件</title>
	<script type="text/javascript" >
		$(function () {
			var myChart = echarts.init($("#main")[0]);
			var option  = {
				title: {
					text: '交易统计图表',
					subtext:'交易表中各个阶段的数量'
				},
				tooltip: {
					trigger: 'item',
					formatter: '{a} <br/>{b} : {c}'
				},
				toolbox: {
					feature: {
						dataView: { readOnly: false },
						restore: {},
						saveAsImage: {}
					}
				},
				legend: {
					data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
				},
				series: [
					{
						name: '数据量',
						type: 'funnel',
						left: '10%',
						width: '80%',
						label: {
							formatter: '{b}数据量'
						},
						labelLine: {
							show: true
						},
						itemStyle: {
							opacity: 0.7
						},
						emphasis: {
							label: {
								position: 'inside',
								formatter: '{b}数据量: {c}'
							}
						},
						data: [
							{ value: 80, name: 'Visit' },
							{ value: 40, name: 'Inquiry' },
							{ value: 40, name: 'Order' },
							{ value: 80, name: 'Click' },
							{ value: 100, name: 'Show' }
						]
					}

				]
			};
			myChart.setOption(option);
		})
	</script>
</head>
<body>
<div id="main" style="width: 600px;height: 700px;"></div>
</body>
</html>