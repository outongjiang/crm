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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">
		$(function () {
			$("#create-nextContactTime").val('${requestScope.transaction.nextContactTime}');
			$("#create-contactSummary").val('${requestScope.transaction.contactSummary}');
			$("#create-describe").val('${requestScope.transaction.description}');
			$("#create-contactsName").val('${requestScope.transaction.contactsName}');
			$("#activityId").val('${requestScope.transaction.activityId}');
			$("#create-activitySrc").val('${requestScope.transaction.activityName}');
			$("#create-clueSource").val('${requestScope.transaction.source}');
			$("#create-possibility").val('${requestScope.transaction.possibility}');
			$("#create-transactionType").val('${requestScope.transaction.type}');
			$("#create-transactionStage").val('${requestScope.transaction.stage}');
			$("#create-accountName").val('${requestScope.transaction.customerId}');
			$("#create-expectedClosingDate").val('${requestScope.transaction.expectedDate}');
			$("#create-transactionName").val('${requestScope.transaction.name}');
			$("#create-amountOfMoney").val('${requestScope.transaction.money}');
			$("#create-transactionOwner").val('${requestScope.transaction.owner}');
			$(".mydate").datetimepicker({
				language:'zh-CN',//中文格式
				format:'yyyy-mm-dd',//日期格式
				minView:'month',//可以选择的最小视图
				autoclose:true,
				initialDate:new Date(),
				todayBtn:true
			})
			$("#saveEditTranBtn").click(function () {
				var  nextContactTime                              =$("#create-nextContactTime").val();
				var   contactSummary                             =$("#create-contactSummary").val();
				var   description                             =$("#create-describe").val();
				var   contactsId                             =$("#create-contactsId").val();
				var   activityId                             =$("#activityId").val();
				var    source                            =$("#create-clueSource").val();
				var    type                            =$("#create-transactionType").val();
				var    stage                            =$("#create-transactionStage").val();
				var    customerId                            =$("#create-accountName").val();
				var    expectedDate                            =$("#create-expectedClosingDate").val();
				var     name                           =$("#create-transactionName").val();
				var   money                             =$("#create-amountOfMoney").val();
				var    owner                            =$("#create-transactionOwner").val();
				$.ajax({
					url:"workbench/transaction/saveEditTran.do",
					data:{
						id:'${requestScope.transaction.id}',
					nextContactTime  :nextContactTime  ,
					 contactSummary  : contactSummary  ,
					 description     : description     ,
					 contactsId      : contactsId      ,
					 activityId      : activityId      ,
					  source         :  source         ,
					  type           :  type           ,
					  stage          :  stage          ,
					  customerId     :  customerId     ,
					  expectedDate   :  expectedDate   ,
					   name          :   name          ,
					 money           : money           ,
					  owner          :  owner
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						window.location.href="workbench/transaction/index.do";
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
			//根据选择阶段自动补全可能性


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
			$("#showContactsModalBtn").click(function () {
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
			$("#searchContactsBtn").keyup(function () {
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

			$("#cancelBtn").click(function () {
				window.location.href="workbench/transaction/index.do";
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
						    <input id="searchContactsBtn" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveEditTranBtn" type="button" class="btn btn-primary">保存</button>
			<button id="cancelBtn"  type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				  <c:forEach items="${requestScope.userList}" var="u">
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
				<input type="text" class="form-control mydate" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
				  <c:forEach items="${requestScope.stageList}" var="stage">
					  <option value="${stage.id}">${stage.value}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${requestScope.typeList}" var="t">
						<option value="${t.id}">${t.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input  type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${requestScope.sourceList}" var="s">
						<option value="${s.id}">${s.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a id="showSearchActivityModal" href="javascript:void(0);" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="activityId">
				<input type="text" class="form-control" id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="showContactsModalBtn" href="javascript:void(0);" ><span class="glyphicon glyphicon-search"></span></a></label>
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
				<input type="text" class="form-control mydate" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>