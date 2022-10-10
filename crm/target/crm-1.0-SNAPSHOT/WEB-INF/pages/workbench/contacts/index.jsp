<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

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
	<%--引入BOOTSTRAP_DATATIMEPICKER插件--%>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">
	//定义分页查询函数
	function queryContactByConditionForPage(pageNo,pageSize){
		var	source             =  $("#edit-clueSource").val();
		var	customer_id        =   $("#selectCustomerName").val();
		var	fullname           =   $("#selectName").val();
		var	owner          =   $("#selectOwner").val();
		$.ajax({
			url:"workbench/contact/queryContactByConditionForPage.do",
			data:{
				source      :source      ,
				customer_id :customer_id ,
				fullname    :fullname    ,
				owner       :owner       ,
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
						queryContactByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
				var htmlStr="";
				//jquery遍历后端返回的集合对象
				$.each(data.contactList,function (index,obj) {
					htmlStr+="<tr class=\"active\">"
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\" /></td>"
					htmlStr+=	"<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href=\'workbench/contact/detailContact.do?contactId="+obj.id+"\';\">"+obj.fullname+"</a></td>";
					htmlStr+="<td>"+obj.customerId+"</td>"
					htmlStr+="<td>"+obj.owner+"</td>"
					htmlStr+="<td>"+obj.source+"</td>"
					htmlStr+="<td>"+obj.createTime+"</td>"
					htmlStr+="</tr>"
				});
				$("#tBody").html(htmlStr);
				$("#tBody input[type='checkbox']").click(function () {
					if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
						$("#checkAll").prop("checked",true);
					}else{
						$("#checkAll").prop("checked",false);
					}
				})
			}
		})
	}



	$(function() {
		//日期框架
		$(".mydate").datetimepicker({
			language: 'zh-CN',//中文格式
			format: 'yyyy-mm-dd',//日期格式
			minView: 'month',//可以选择的最小视图
			autoclose: true,
			initialDate: new Date(),
			todayBtn: true
		})


		//定制字段
		$("#definedColumns > li").click(function (e) {
			//防止下拉菜单消失
			e.stopPropagation();
		});
		//显示联系人创建模态窗口
		$("#showcreateContactBtn").click(function () {
			$("#saveCreateForm")[0].reset();
			$("#createContactsModal").modal("show");
		})

		//保存创建联系人
		$("#saveCreateContactBtn").click(function () {

			//收集数据
			var address = $("#edit-address1").val();
			var nextContactTime = $("#create-nextContactTime1").val();
			var contactSummary = $("#create-contactSummary1").val();
			var description = $("#create-describe").val();
			var customerId = $("#create-accountName").val();
			var email = $("#create-email").val();
			var mphone = $("#create-mphone").val();
			var job = $("#create-job").val();
			var fullname = $("#create-surname").val();
			var source = $("#create-clueSource").val();
			var owner = $("#create-contactsOwner").val();

			$.ajax({
				url: "workbench/contact/saveCreateContact.do",
				data: {
					address: address,
					nextContactTime: nextContactTime,
					contactSummary: contactSummary,
					description: description,
					customerId: customerId,
					email: email,
					mphone: mphone,
					job: job,
					fullname: fullname,
					source: source,
					owner: owner

				},
				dataType: "json",
				type: "post",
				success: function (data) {
					if (data.code == "1") {
						$("#createContactsModal").modal("hide");
						alert("执行成功")
						queryContactByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					} else {
						alert(data.message);
					}
				}
			})
		})

		//显示更新模态窗口并且回显数据
		$("#showupdateContactBtn").click(function () {
			if ($("#tBody input[type='checkbox']:checked").size() != 1) {
				alert("请选择一个要更新的记录");
				return;
			}
			var id = $("#tBody input[type='checkbox']:checked").val();
			console.log("id : " + id)
			$.ajax({
				url: "workbench/contact/selectContactById.do",
				data: {
					id: id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					$("#edit-address1").val(data.address);
					$("#edit-nextContactTime1").val(data.nextContactTime);
					$("#edit-contactSummary1").val(data.contactSummary);
					$("#edit-describe").val(data.description);
					$("#edit-customerName").val(data.customer_id);
					$("#edit-email").val(data.email);
					$("#edit-mphone").val(data.mphone);
					$("#edit-job").val(data.job);
					$("#edit-call").val(data.appellation);
					alert(data.appellation)
					$("#edit-clueSource1").val(data.source);
					$("#edit-contactsOwner").val(data.owner);
					$("#editContactsModal").modal("show");
				}
			})
		})

		//更新联系人并关闭模态窗口
		$("#saveEditContactBtn").click(function () {
			var 	id              	=$("#tBody input[type='checkbox']:checked").val();
			var  address                                            =$("#edit-address2").val();
			var  nextContactTime                                            =$("#edit-nextContactTime1").val();
			var   contactSummary                                           =$("#edit-contactSummary1").val();
			var   description                                           =$("#edit-describe").val();
			var   customerId                                           =$("#edit-customerName").val();
			var   email                                           =$("#edit-email").val();
			var   mphone                                           =$("#edit-mphone").val();
			var   job                                           =$("#edit-job").val();
			var   appellation                                           =$("#edit-call").val();
			var   fullname                                           =$("#edit-surname").val();
			var   source                                           =$("#edit-clueSource1").val();
			var   owner                                           =$("#edit-contactsOwner").val();
			$.ajax({
				url:"workbench/contact/saveEditContactById.do",
				data:{
					id            :	id            ,
				address          :address          ,
				nextContactTime  :nextContactTime  ,
				 contactSummary  : contactSummary  ,
				 description     : description     ,
				 customerId      : customerId      ,
				 email           : email           ,
				 mphone          : mphone          ,
				 job             : job             ,
				 appellation     : appellation     ,
				 fullname        : fullname        ,
				 source          : source          ,
				 owner           : owner
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						//关闭创建模态窗口
						$("#editContactsModal").modal("hide");
						// 创建市场活动后自动刷新bs_pagination
						queryContactByConditionForPage($("#bs_paging1").bs_pagination('getOption','currentPage'),$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message)
						$("#editContactsModal").modal("show");
					}
				}
			})

		})

		//批量删除操作
		$("#deleteContactBtn").click(function () {
			if(confirm("确定要删除选中项吗?")) {
				var idsData ="";
				$("#tBody input[type='checkbox']:checked").each(function(){
					alert("value : "+$(this).val())
					idsData+=("ids="+$(this).val()+"&");
				});
				idsData=idsData.substr(0,idsData.length-1);
				alert(idsData);
				$.ajax({
					url:"workbench/contact/deletecontactByIds.do",
					data:idsData,
					dataType:"json",
					type:"post",
					success:function (data) {
						if(data.code=="1"){
							alert(data.message)
							queryContactByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
						}else{
							alert(data.message)
						}
					}
				})
			}
		})


		//当联系人页面加载完毕时，查询记录
		queryContactByConditionForPage(1,5);

		$("#selectForPagesBtn").click(function(){
			queryContactByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage'));

			//$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage')
		});
		$("#checkAll").click(function () {
			$("#tBody input[type='checkbox']").prop("checked", this.checked);
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
		//自动补全客户名称
		$("#edit-customerName").typeahead({
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

	});


</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form id="saveCreateForm"  class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
									<c:forEach items="${requestScope.userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
									<c:forEach items="${requestScope.sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${requestScope.appellationList}" var="ppellation">
										<option value="${ppellation.id}">${ppellation.value}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-accountName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input  type="text" class="form-control mydate" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address1">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateContactBtn" type="button" class="btn btn-primary" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form id="editForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
								  <option></option>
									<c:forEach items="${requestScope.sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellationList}" var="ppellation">
										<option value="${ppellation.id}">${ppellation.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-nextContactTime1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input  type="text" class="form-control mydate" id="edit-nextContactTime1">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditContactBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
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
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="edit-clueSource">
						  <option></option>
						  <c:forEach items="${requestScope.sourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input id="selectBirth" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="selectForPagesBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="showcreateContactBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="showupdateContactBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>2000-10-10</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>2000-10-10</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="bs_paging1"></div>
			</div>
		</div>
	</div>
</body>
</html>