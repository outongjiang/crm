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
	<link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"/>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript"
			src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" >
		$(function () {
			$("#myDate").datetimepicker({
				language:'zh-CN',//中文格式
				format:'yyyy-mm-dd',//日期格式
				minView:'month',//可以选择的最小视图
				autoclose:true,
				initialDate:new Date(),
				todayBtn:true
			})
		})
	</script>
<meta charset="UTF-8">
	<title>演示bs_datatimepicker插件</title>
</head>
<body>
	<input type="text" id="myDate">

</body>
</html>