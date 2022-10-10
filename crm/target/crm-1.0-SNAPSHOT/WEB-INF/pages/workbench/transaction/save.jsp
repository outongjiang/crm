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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">
		$(function () {
			//取消键，返回交易主页面
			$("#cancelBtn").click(function () {
				window.location.href="workbench/transaction/index.do";
			})
			$("#cancelToCustomerDetailBtn").click(function () {
				window.location.href="workbench/customer/customerDetail.do?id=${requestScope.customerId}";
			})

			//创建交易如果参数customer不存在则新创建一个customer
			$("#saveCreateBtn").click(function () {
				var nextContactTime  =$("#create-nextContactTime").val();
				var contactSummary  =$.trim($("#create-contactSummary").val());
				var description      =$.trim($("#create-describe").val());
				var contactsName     =$.trim($("#create-contactsName").val());
				var activityId       =$("#activityId").val();
				var source        	 =$("#create-clueSource").val();
				var contactsId  		=$("#create-contactsId").val();
				var type  				=$("#create-transactionType").val();
				var stage  				=$("#create-transactionStage").val();
				var customerName  		=$("#create-accountName").val();
				var expectedDate  		=$("#create-expectedClosingDate").val();
				var name  				=$.trim($("#create-transactionName").val());
				var money  					=$.trim($("#create-amountOfMoney").val());
				var owner  					=$("#create-transactionOwner").val();
				alert(type)
				if(money==''){
					alert("金钱不能为空!")
					return;
				}
				if(name==''){
					alert("名称不能为空!")
					return;
				}
				if(contactsName==''){
					alert("联系人不能为空!")
					return;
				}
				if(contactSummary==''){
					alert("纪要不能为空!")
					return;
				}
				if(description==''){
					alert("描述不能为空!")
					return;
				}
				$.ajax({
					url:"workbench/transaction/saveCreateTran.do",
					data:{
				nextContactTime:nextContactTime,
				contactSummary :contactSummary ,
				description    :description    ,
				contactsName   :contactsName   ,
				activityId     :activityId     ,
				source        :source        ,
				contactsId  :contactsId  ,
				type  		:type  		,
				stage  		:stage  		,
				customerName  :customerName  ,
				expectedDate  :expectedDate  ,
				name  		:name  		,
				money  		:money  		,
				owner  		:owner

					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							window.location.href="workbench/transaction/index.do";
						}else{
							alert(data.message);
						}
					}

				})


			})

			//创建保存交易为客户备注页面
			$("#saveCreateForCustomerDetaiBtn").click(function () {
				var nextContactTime  =$("#create-nextContactTime").val();
				var contactSummary  =$.trim($("#create-contactSummary").val());
				var description      =$.trim($("#create-describe").val());
				var contactsName     =$.trim($("#create-contactsName").val());
				var activityId       =$("#activityId").val();
				var source        	 =$("#create-clueSource").val();
				var contactsId  		=$("#create-contactsId").val();
				var type  				=$("#create-transactionType").val();
				var stage  				=$("#create-transactionStage").val();
				var customerName  		=$("#create-accountName").val();
				var expectedDate  		=$("#create-expectedClosingDate").val();
				var name  				=$.trim($("#create-transactionName").val());
				var money  					=$.trim($("#create-amountOfMoney").val());
				var owner  					=$("#create-transactionOwner").val();
				if(money==''){
					alert("金钱不能为空!")
					return;
				}
				if(name==''){
					alert("名称不能为空!")
					return;
				}
				if(contactsName==''){
					alert("联系人不能为空!")
					return;
				}
				if(contactSummary==''){
					alert("纪要不能为空!")
					return;
				}
				if(description==''){
					alert("描述不能为空!")
					return;
				}
				$.ajax({
					url:"workbench/transaction/saveCreateTran.do",
					data:{
						nextContactTime:nextContactTime,
						contactSummary :contactSummary ,
						description    :description    ,
						contactsName   :contactsName   ,
						activityId     :activityId     ,
						source        :source        ,
						contactsId  :contactsId  ,
						type  		:type  		,
						stage  		:stage  		,
						customerName  :customerName  ,
						expectedDate  :expectedDate  ,
						name  		:name  		,
						money  		:money  		,
						owner  		:owner

					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							window.location.href="workbench/customer/customerDetail.do?id=${requestScope.customerId}";
						}else{
							alert(data.message);
						}
					}

				})


			})

			//创建保存交易为联系人备注页面
			$("#saveCreateForContactsDetaiBtn").click(function () {
				var nextContactTime  =$("#create-nextContactTime").val();
				var contactSummary  =$.trim($("#create-contactSummary").val());
				var description      =$.trim($("#create-describe").val());
				var contactsName     =$.trim($("#create-contactsName").val());
				var activityId       =$("#activityId").val();
				var source        	 =$("#create-clueSource").val();
				var contactsId  		=$("#create-contactsId").val();
				var type  				=$("#create-transactionType").val();
				var stage  				=$("#create-transactionStage").val();
				var customerName  		=$("#create-accountName").val();
				var expectedDate  		=$("#create-expectedClosingDate").val();
				var name  				=$.trim($("#create-transactionName").val());
				var money  					=$.trim($("#create-amountOfMoney").val());
				var owner  					=$("#create-transactionOwner").val();
				if(money==''){
					alert("金钱不能为空!")
					return;
				}
				if(name==''){
					alert("名称不能为空!")
					return;
				}
				if(contactsName==''){
					alert("联系人不能为空!")
					return;
				}
				if(contactSummary==''){
					alert("纪要不能为空!")
					return;
				}
				if(description==''){
					alert("描述不能为空!")
					return;
				}
				$.ajax({
					url:"workbench/transaction/saveCreateTran.do",
					data:{
						nextContactTime:nextContactTime,
						contactSummary :contactSummary ,
						description    :description    ,
						contactsName   :contactsName   ,
						activityId     :activityId     ,
						source        :source        ,
						contactsId  :contactsId  ,
						type  		:type  		,
						stage  		:stage  		,
						customerName  :customerName  ,
						expectedDate  :expectedDate  ,
						name  		:name  		,
						money  		:money  		,
						owner  		:owner

					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							window.location.href="workbench/contact/detailContact.do?contactId=${requestScope.resource}";
						}else{
							alert(data.message);
						}
					}

				})


			})
			//自动补全客户名称
			$("#create-accountName").typeahead({
				source:function (jquery,process) {
					$.ajax({
						url:"workbench/customer/queryCustomerName.do",
						dataType:"json",
						type:"post",
						data:{
							customerName:$("#create-accountName").val()
						},
						success:function (data) {
							process(data)
						}
					})
				}
			})


			$("#create-transactionStage").change(function () {
				var stageValue=$("#create-transactionStage option:selected").text();
				if(stageValue==""){
					$("#create-possibility").val("");
					return;
				}
				$.ajax({
					url:"workbench/transaction/getPossibilityByStage.do",
					data:{
						stageValue:stageValue
					},
					type:"post",
					dataType:"json",
					success:function(data) {
						$("#create-possibility").val(data);
					}
				})
			})



			$("#create-expectedClosingDate").datetimepicker({
				language:'zh-CN',//中文格式
				format:'yyyy-mm-dd',//日期格式
				minView:'month',//可以选择的最小视图
				autoclose:true,
				initialDate:new Date(),
				todayBtn:true
			})
			$("#create-nextContactTime").datetimepicker({
				language:'zh-CN',//中文格式
				format:'yyyy-mm-dd',//日期格式
				minView:'month',//可以选择的最小视图
				autoclose:true,
				initialDate:new Date(),
				todayBtn:true
			})

			//显示全部市场活动源模态窗口
			$("#showSearchActivityModal").click(function () {
				$("#findMarketActivity").modal("show");
				$.ajax({
					url:"workbench/transaction/queryActivityForTransactionSaveByName.do",
					data:{
						activityName:""
					},
					dataType:"json",
					type:"post",
					success:function (data) {

						//遍历data，显示搜索到的市场活动列表
						var htmlStr="";
						$.each(data,function(index,obj){
							htmlStr+="<tr>"
							htmlStr+="<td><input value='"+obj.id+"' activityName='"+obj.name+"' type=\"radio\" name=\"activity\"/></td>";
							htmlStr+="<td>"+obj.name+"</td>";
							htmlStr+="<td>"+obj.startDate+"</td>";
							htmlStr+="<td>"+obj.endDate+"</td>";
							htmlStr+="<td>"+obj.owner+"</td>";
							htmlStr+="</tr>";
						})
						$("#tbody").html(htmlStr);
					}
				})
			})
			//搜索市场活动源
			$("#searchBtn").keyup(function () {
				$(window).keydown(function (e) {
					if(e.keyCode==13){
						return false;
					}
				})
				var activityName=this.value;
				$.ajax({
					url:"workbench/transaction/queryActivityForTransactionSaveByName.do",
					data:{
						activityName:activityName
					},
					dataType:"json",
					type:"post",
					success:function (data) {
						//遍历data，显示搜索到的市场活动列表
						var htmlStr="";
						$.each(data,function(index,obj){
							htmlStr+="<tr>"
							htmlStr+="<td><input value='"+obj.id+"' activityName='"+obj.name+"' type=\"radio\" name=\"activity\"/></td>";
							htmlStr+="<td>"+obj.name+"</td>";
							htmlStr+="<td>"+obj.startDate+"</td>";
							htmlStr+="<td>"+obj.endDate+"</td>";
							htmlStr+="<td>"+obj.owner+"</td>";
							htmlStr+="</tr>";
						})
						$("#tbody").html(htmlStr);

					}
				})
			})


			//选定市场活动源
			$("#tbody").on("click","input[type='radio']",function () {
				var activityId=this.value;
				var activityName=$(this).attr("activityName");
				$("#create-activitySrc").val(activityName)
				$("#activityId").val(activityId)
				$("#findMarketActivity").modal("hide")
			})

			//显示全部联系人模态窗口
			$("#showSearchContactModal").click(function () {
				$("#findContacts").modal("show");
				$.ajax({
					url:"workbench/transaction/queryContactsForTransactionSaveByName.do",
					data:{
						fullname:""
					},
					dataType:"json",
					type:"post",
					success:function (data) {

						var htmlStr="";
						$.each(data,function(index,obj){
							htmlStr+="<tr>"
							htmlStr+="<td><input value='"+obj.id+"' contactName='"+obj.fullname+"' type=\"radio\" name=\"contact\"/></td>";
							htmlStr+="<td>"+obj.fullname+"</td>";
							htmlStr+="<td>"+obj.email+"</td>";
							htmlStr+="<td>"+obj.mphone+"</td>";
							htmlStr+="</tr>";
						})
						$("#contact_tbody").html(htmlStr);
					}
				})
			})
			//搜索联系人
			$("#contact_searchBtn").keyup(function () {
				$(window).keydown(function (e) {
					if(e.keyCode==13){
						return false;
					}
				})
				var fullname=this.value;
				$.ajax({
					url:"workbench/transaction/queryContactsForTransactionSaveByName.do",
					data:{
						fullname:fullname
					},
					dataType:"json",
					type:"post",
					success:function (data) {
						//遍历data，显示搜索到的市场活动列表
						var htmlStr="";
						$.each(data,function(index,obj){
							htmlStr+="<tr>"
							htmlStr+="<td><input value='"+obj.id+"' contactName='"+obj.fullname+"' type=\"radio\" name=\"contact\"/></td>";
							htmlStr+="<td>"+obj.fullname+"</td>";
							htmlStr+="<td>"+obj.email+"</td>";
							htmlStr+="<td>"+obj.mphone+"</td>";
							htmlStr+="</tr>";
						})
						$("#contact_tbody").html(htmlStr);

					}
				})
			})


			//选定联系人
			$("#contact_tbody").on("click","input[type='radio']",function () {
				var contactId=this.value;
				var contactName=$(this).attr("contactName");
				$("#create-contactsName").val(contactName)
				$("#create-contactsId").val(contactId)
				$("#findContacts").modal("hide")
			})
		})
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchBtn" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tbody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="contact_searchBtn" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contact_tbody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<c:if test="${empty requestScope.customerId}">
			<button id="saveCreateBtn" type="button" class="btn btn-primary">保存</button>
			</c:if>
			<c:if test="${not empty requestScope.customerId}">
				<c:if test="${requestScope.resource!='customer'}">
					<button id="saveCreateForContactsDetaiBtn" type="button" class="btn btn-primary">保存</button>
				</c:if>
				<c:if test="${requestScope.resource == 'customer'}">
					<button id="saveCreateForCustomerDetaiBtn" type="button" class="btn btn-primary">保存</button>
				</c:if>
			</c:if>
			<c:if test="${not empty requestScope.customerId}">
				<button id="cancelToCustomerDetailBtn" type="button" class="btn btn-default"><a href="javascript:void(0);" onclick="window.history.back();">取消</a> </button>
			</c:if>
			<c:if test="${empty requestScope.customerId}">
			<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
			</c:if>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
					<c:forEach items="${userList}" var="u">
						<option value="${u.id}">${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<c:if test="${not empty requestScope.customerName}">
					<input  type="text" class="form-control" id="create-accountName" value="${customerName}" readonly>
				</c:if>
				<c:if test="${empty requestScope.customerName}">
					<input  type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
				</c:if>
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.id}">${s.value}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.id}">${t.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.id}">${s.value}</option>
					</c:forEach>
				</select>
			</div>
			<label  for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" id="showSearchActivityModal"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="activityId" >
				<input type="text" class="form-control" id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="showSearchContactModal" href="javascript:void(0);" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId">
				<input type="text" class="form-control" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>