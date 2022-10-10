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
			var map={name:'otj',
				value:'学java'}
			$.ajax({
				url:"testMapParam",
				dataType:"json",
				type:"post",
				contentType : 'application/json',
				data:{
					name:"otj"
					,value:"学java"
				}
				,success:function (data) {

				}
			})
		})
	</script>
</head>
<body>

</body>
</html>