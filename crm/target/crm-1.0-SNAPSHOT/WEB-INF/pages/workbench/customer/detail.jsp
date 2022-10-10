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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		//日期框架
		$(".mydate").datetimepicker({
			language:'zh-CN',//中文格式
			format:'yyyy-mm-dd',//日期格式
			minView:'month',//可以选择的最小视图
			autoclose:true,
			initialDate:new Date(),
			todayBtn:true
		})


		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		//保存备注
		//保存customerRemark
		$("#saveCreateCustomerRemarkBtn").click(function () {
			//收集数据
			var customerId='${requestScope.customer.id}'
			var noteContent=$.trim($("#remark").val());
			if(noteContent==""){
				alert("备注信息不能为空!")
				return;
			}
			$.ajax({
				url:"workbench/customer/saveCreateCustomerRemark.do",
				dataType:"json",
				data:{
					noteContent:noteContent,
					customerId:customerId
				},
				type:"post",
				success:function(data){
					if(data.code=="1"){
						$("#remark").val("");
						var htmlStr="";
						htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+data.retData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${requestScope.customer.name}</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a class=\"myHref\" name=\"editA\" remarkId=\""+data.retData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.retData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						$("#remarkDiv").before(htmlStr);
					}else{
						alert(data.message);
					}
				}
			})
		})
//显示更新市场活动备注模态窗口，回显数据
		$("#RemarkdivList").on("click","a[name='editA']",function () {
			alert("进入更新模态窗口")
			//收集数据
			var id=$(this).attr("remarkId");
			var noteContent=$("#div_"+id+" h5").text();
			// 将数据写回到更新模态窗口界面
			$("#noteContent").text(noteContent);
			$("#edit-id").val(id);
			$("#editRemarkModal").modal("show");
		})

		//更新customerRemark
		$("#updateRemarkBtn").click(function () {
			//收集数据
			var id=$("#edit-id").val();
			var noteContent=$.trim($("#noteContent").val());
			alert("id : "+id+" , "+"noteContent : "+noteContent);
			if(noteContent==""){
				alert("修改内容不能为空!")
				return ;
			}
			$.ajax({
				url:"workbench/customer/saveEditCustomerRemark.do",
				type:"post",
				dataType:"json",
				data:{
					id:id,
					noteContent:noteContent
				},
				success:function (data) {
					if(data.code=="1"){
						$("#editRemarkModal").modal("hide");
						$("#div_"+data.retData.id+" h5").text(data.retData.noteContent);
						$("#div_"+data.retData.id+" small").text(" "+data.retData.editTime+"由 ${sessionScope.sessionUser.name} 修改");
					}else{
						alert(data.message);
					}
				}
			})



		})

		//删除customerRemark

		$("#RemarkdivList").on("click","a[name='deleteA']",function () {
			if(!confirm("确定要删除?")){
				return false;
			}
			//收集参数
			var id=$(this).attr("remarkId");
			$.ajax({
				url:"workbench/customer/deleteCustomerRemarkById.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function (data) {
					if(data.code=="1"){
						$("#div_"+id).remove();
					}else{
						alert(data.message);
					}
				}
			})


		})
		//根据交易id  删除交易 交易备注 交易历史
		$("#trandivList").on("click","a[name='deleteA']",function () {
			if(!confirm("确定要删除?")){
				return false;
			}
			//收集参数
			var id=$(this).attr("tranId");
			$.ajax({
				url:"workbench/customer/deleteTranForCustomerDetailByTranId.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function (data) {
					if(data.code=="1"){
						$("#tr_"+id).remove();
					}else{
						alert(data.message);
					}
				}
			})


		})


		//根据联系人id  删除联系人 联系人备注 联系人与市场活动的关系
		$("#div_contactList").on("click","a[name='deleteA']",function () {
			if(!confirm("确定要删除?")){
				return false;
			}
			//收集参数
			var id=$(this).attr("contactId");
			$.ajax({
				url:"workbench/customer/deleteContactForCustomerDetailByContactId.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function (data) {
					if(data.code=="1"){
						$("#tr2_"+id).remove();
					}else{
						alert(data.message);
					}
				}
			})


		})
		//显示创建联系人

		$("#showCreateContactBtn").click(function () {
			$("#contactForm")[0].reset();
			$("#createContactsModal").modal("show");
		})

		//保存创建联系人
		$("#saveCreateContactBtn").click(function () {

			//收集数据
			var address             =$("#edit-address1").val();
			var nextContactTime     =$("#edit-nextContactTime").val();
			var contactSummary             =$("#edit-contactSummary").val();
			var description             = $("#create-describe").val();
			var email                     =$("#create-email").val();
			var mphone                   =$("#create-mphone").val();
			var job                          =$("#create-job").val();
			var appellation                      =$("#create-call").val();
			var fullname                       =$("#create-surname").val();
			var source                        =$("#create-clueSource").val();
			var owner                       =$("#create-contactsOwner").val();

			$.ajax({
				url:"workbench/customer/saveCreateContact.do",
				data:{
				  address        :address        ,
				  nextContactTime:nextContactTime,
				  contactSummary :contactSummary ,
				  description    :description    ,
					customerId    :'${requestScope.customer.id}'    ,
				  email          :email          ,
				  mphone         :mphone         ,
				  job            :job            ,
				  appellation    :appellation    ,
				  fullname       :fullname       ,
				  source         :source         ,
				  owner          :owner
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					if(data.code=="1"){
						$("#createContactsModal").modal("hide");
						alert("执行成功")
						var strhtml="";
						strhtml+="<tr id=\"tr2_"+data.retData.id+"\">";
						strhtml+="<td><a href=\"workbench/contacts/detail.do?id="+data.retData.id+"\" style=\"text-decoration: none;\">"+data.retData.fullname+"</a></td>"
						strhtml+="<td>"+data.retData.email+"</td>"
						strhtml+="<td>"+data.retData.mphone+"</td>"
						strhtml+="<td><a contactId=\""+data.retData.id+"\" name=\"deleteA\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\" id=\"deleteContact\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a></td>";
						strhtml+="</tr>"
						$("#contact_tbody").before(strhtml);
					}else{
						alert(data.message);
					}
				}
			})
		})


		$("#RemarkdivList").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#RemarkdivList").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})
		$("#RemarkdivList").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		})
		$("#RemarkdivList").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		})
	});
	
</script>

</head>
<body>

<!-- 修改客户备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id">
					<div class="form-group">
						<label for="noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form id="contactForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
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
									<c:forEach items="${appellation}" var="a">
										<option value="${a.id}">${a.value}</option>
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
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input id="customerId" type="hidden" value="${requestScope.customer.id}">
								<input value="${requestScope.customer.name}"  type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建" readonly>
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
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="edit-nextContactTime" value="2017-05-01">
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
					<button type="button" class="btn btn-primary" id="saveCreateContactBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="workbench/customer/index.do" ><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.customer.name} <small><a href="http://www.bjpowernode.com" target="_blank">${requestScope.customer.website}</a></small></h3>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.editBy}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="RemarkdivList" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<c:forEach items="${customerRemarkList}" var="Remark">
		<div id="div_${Remark.id}" class="remarkDiv" style="height: 60px;">
			<img title="${sessionScope.sessionUser.name}" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${Remark.noteContent} </h5>
				<font color="gray">客户</font> <font color="gray">-</font> <b>${requestScope.customer.address}${requestScope.customer.name}</b>
				<small style="color: gray;">
					<c:if test="${Remark.editFlag=='1'}">${Remark.editTime}</c:if>
					<c:if test="${Remark.editFlag!='1'}">${Remark.createTime}</c:if>
					由${Remark.editFlag=='1'?Remark.editBy:Remark.createBy}
						${Remark.editFlag=='1'?"修改":"创建"}
				</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" name="editA" remarkId="${Remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" name="deleteA" remarkId="${Remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		</c:forEach>


		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateCustomerRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div id="trandivList">
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${tranList}" var="tran">
						<tr id="tr_${tran.id}">
							<td><a href="workbench/transaction/detail.do?tranId=${tran.id}" style="text-decoration: none;">${requestScope.customer.name}-${tran.name}</a></td>
							<td>${tran.money}</td>
							<td>${tran.stage}</td>
							<td>${tran.possibility}</td>
							<td>${tran.expectedDate}</td>
							<td>${tran.type}</td>
							<td><a tranId="${tran.id}" name="deleteA" id="deleteTranBtn" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/saveForCustomerDetail.do?resource=customer&customerName=${requestScope.customer.name}&customerId=${requestScope.customer.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div id="div_contactList">
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contact_tbody">
					<c:forEach items="${contactList}" var="c">
						<tr id="tr2_${c.id}">
							<td><a href="workbench/contacts/detail.do?id=${c.id}" style="text-decoration: none;">${c.fullname}</a></td>
							<td>${c.email}</td>
							<td>${c.mphone}</td>
							<td><a contactId="${c.id}" name="deleteA" href="javascript:void(0);"  style="text-decoration: none;" id="deleteContact"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="showCreateContactBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>