<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>

    <base href="<%=basePath%>">
<html>
<head>
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-3.6.1.js"></script>
</head>
<body>

<script type="text/javascript">
    $(function () {
        $.ajax({
            url:'test3',
            data:{

            },
            type:'post',
            dataType:'json',
            success:function (data) {
                    window.location.href="test2";
            }
        })
    })
</script>
</body>
</html>