<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><meta charset="UTF-8"></head>
<body>
${sessionScope.role.name}
<script type="text/javascript"></script>
<c:if test="${not empty cookie.c}">
    <input type="checkbox" id="isRemPwd" checked>
</c:if>
${cookie.c.value}
<c:if test="${ empty cookie.c}">
    <input type="checkbox" id="isRemPwd" >
</c:if>
</body>
</html>