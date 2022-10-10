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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<meta charset="UTF-8">
	<title>演示自动补全插件</title>
	<script type="text/javascript" >
		$(function () {
			$("#customerName").typeahead({

				source:function (jquery,process) {
					$.ajax({
						url:"workbench/customer/queryCustomerName.do",
						dataType:"json",
						type:"post",
						success:function (data) {
							process(data)
						}
					})
				}

			})
		})
	</script>
</head>

<body>
	<input type="text" id="customerName">
</body>
</html>