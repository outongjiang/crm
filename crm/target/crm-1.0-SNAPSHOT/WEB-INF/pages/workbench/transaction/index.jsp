<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"/>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript"
			src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--引入BOOTSTRAP_DATATIMEPICKER插件--%>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>
<script type="text/javascript">

	$(function(){
		$("#createBtn").click(function () {
			window.location.href="workbench/transaction/save.do";
		})


		$("#showEditBtn").click(function () {
			if($("#tranTbodyList input[type='checkbox']:checked").size()!=1){
				alert("请选择一个要更新的记录");
				return;
			}
			var id=$("#tranTbodyList input[type='checkbox']:checked").val();
			console.log("id : "+id)
			window.location.href="workbench/transaction/selectTransactionById.do?id="+id;

		})

		//当交易页面加载完毕时，查询记录
		queryTransactionByConditionForPage(1,5);

		$("#selectBtn").click(function(){

			queryTransactionByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage'));

			//$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage')
		});
		$("#checkAll").click(function () {
			$("#tranTbodyList input[type='checkbox']").prop("checked", this.checked);
		})

//删除操作

		$("#deleteBtn").click(function () {
			if(confirm("确定要删除选中项吗?")) {
				var idsData ="";
				$("#tranTbodyList input[type='checkbox']:checked").each(function(){
					alert("value : "+$(this).val())
					idsData+=("ids="+$(this).val()+"&");
				});
				idsData=idsData.substr(0,idsData.length-1);
				alert(idsData);
				$.ajax({
					url:"workbench/transaction/deleteTransactionByIds.do",
					data:idsData,
					dataType:"json",
					type:"post",
					success:function (data) {
						if(data.code=="1"){
							alert(data.message)
							queryTransactionByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
						}else{
							alert(data.message)
						}
					}
				})
			}
		})

	});
	function queryTransactionByConditionForPage(pageNo,pageSize){
		var    contactId                 =$("#selectContactName").val();
		var    source                    =$("#selectSource").val();
		var    type                      =$("#selectType").val();
		var    stage                     =$("#selectStage").val();
		var    name                      =$("#selectName").val();
		var    owner                     =$("#selectOwner").val();
		var coustomerId =$("#selectCustomerName").val();
		$.ajax({
			url:"workbench/transaction/querytransactionByConditionForPage.do",
			data:{
				 contactId:contactId,
				 source   :source   ,
				 type     :type     ,
				 stage    :stage    ,
				 name     :name     ,
				 owner    :owner    ,
				coustomerId:coustomerId,
				beginNo:pageNo,
				pageSize:pageSize
			},
			dataType:"json",
			type:"post",
			success:function (data) {
				var totalPages=0;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}
				$("#bs_paging1").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					visiblePageLinks: 3,
					totalPages:totalPages,
					showGoToPage:true,
					showRowsPerPage:true,
					showRowsInfo:true,
					onChangePage:function(event,pageObj){
						queryTransactionByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
				var htmlStr="";
				//jquery遍历后端返回的集合对象
				$.each(data.transactionList,function (index,obj) {
				htmlStr+="<tr>"
				htmlStr+="<td><input type=\"checkbox\" value=\'"+obj.id+"\' /></td>"
					htmlStr+=	"<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href=\'workbench/transaction/detail.do?tranId="+obj.id+"\';\">"+obj.customerId+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.customerId+"</td>"
					htmlStr+="	<td>"+obj.stage+"</td>"
					htmlStr+="<td>"+obj.type+"</td>"
					htmlStr+="<td>"+obj.owner+"</td>"
					htmlStr+="<td>"+obj.source+"</td>"
					htmlStr+="<td>"+obj.contactsId+"</td>"
					htmlStr+="	</tr>"
				});
				$("#tranTbodyList").html(htmlStr);
				$("#tranTbodyList input[type='checkbox']").click(function () {
					if($("#tranTbodyList input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
						$("#checkAll").prop("checked",true);
					}else{
						$("#checkAll").prop("checked",false);
					}
				})
			}
		})

	}
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="selectOwner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="selectName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="selectCustomerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="selectStage" class="form-control">
					  	<option></option>
						  <c:forEach items="${stageList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="selectType" class="form-control">
					  	<option></option>
						  <c:forEach items="${transactionTypeList}" var="t">
							  <option value="${t.id}">${t.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="selectSource" class="form-control" id="create-clueSource">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="selectContactName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="selectBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="showEditBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranTbodyList">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?tranId=${requestScope.transaction.id}';">动力节点-交易01</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>新业务</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>李四</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
				<div id="bs_paging1"></div>
			</div>
			

			
		</div>
		
	</div>
</body>
</html>