<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	<script type="text/javascript">
	$(function(){



		//批量删除操作
		$("#deleteClueBtn").click(function () {
			if(confirm("确定要删除选中项吗?")) {
				var idsData ="";
				$("#tBody input[type='checkbox']:checked").each(function(){
					alert("value : "+$(this).val())
					idsData+=("ids="+$(this).val()+"&");
				});
				idsData=idsData.substr(0,idsData.length-1);
				alert(idsData);
				$.ajax({
					url:"workbench/clue/deleteClueByIds.do",
					data:idsData,
					dataType:"json",
					type:"post",
					success:function (data) {
						if(data.code=="1"){
							alert(data.message)
							queryClueByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
						}else{
							alert(data.message)
						}
					}
				})
			}
		})

		$("#edit-nextContactTime").datetimepicker({
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

		$("#createClueBtn").click(function () {
			$("#saveCreateForm")[0].reset();
			$("#createClueModal").modal("show");
		})
		$("#saveCreateClue").click(function () {

			//收集数据
				var	address            =$.trim($("#create-address").val());
				var	nextContactTime    =$.trim($("#create-nextContactTime").val());
				var	contactSummary     =$.trim($("#create-contactSummary").val());
				var	describe           =$.trim($("#create-describe").val());
				var	source             =$.trim($("#create-source").val());
				var	state             =$.trim($("#create-status").val());
				var	mphone             =$.trim($("#create-mphone").val());
				var	website            =$.trim($("#create-website").val());
				var	phone              =$.trim($("#create-phone").val());
				var	email              =$.trim($("#create-email").val());
				var	job                =$.trim($("#create-job").val());
				var	appellation         =$.trim($("#create-call").val());
				var	owner          		=$.trim($("#create-clueOwner").val());
				var	fullname			=$.trim($("#create-surname").val());
				var	company            =$.trim($("#create-company").val());

				$.ajax({
					url:"workbench/clue/saveCreateClue.do",
					data:{
						address            :address            ,
						nextContactTime    :nextContactTime    ,
						contactSummary     :contactSummary     ,
						description           :describe           ,
						source             :source             ,
						state             :state             ,
						mphone             :mphone             ,
						website            :website            ,
						phone              :phone              ,
						email              :email              ,
						job                :job                ,
						appellation:appellation,
						owner:owner,
						fullname:fullname,
						company:company
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					if(data.code=="1"){
						$("#createClueModal").modal("hide");
						alert("执行成功")
					}else{
						alert(data.message);
					}
				}
				})
		})


		//当线索页面加载完毕时，查询记录
		queryClueByConditionForPage(1,5);

		$("#selectForPagesBtn").click(function(){
			queryClueByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage'));

			//$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage')
		});
		$("#checkAll").click(function () {
			$("#tBody input[type='checkbox']").prop("checked", this.checked);
		})


		/*修改市场活动并打开模态窗口，回显数据*/
		$("#showEditClueModalBtn").click(function () {
			if($("#tBody input[type='checkbox']:checked").size()!=1){
				alert("请选择一个要更新的记录");
				return;
			}
			var id=$("#tBody input[type='checkbox']:checked").val();
			console.log("id : "+id)
			$.ajax({
				url:"workbench/clue/selectClueById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					$("#EditClueModal").modal("show");
					$("#edit-address").val(data.address);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-describe").val(data.description);
					$("#edit-source").val(data.source);
					$("#edit-status").val(data.state);
					$("#edit-mphone").val(data.mphone);
					$("#edit-website").val(data.website);
					$("#edit-phone").val(data.phone);
					$("#edit-email").val(data.email);
					$("#edit-job").val(data.job);
					$("#edit-surname").val(data.fullname);
					$("#edit-call").val(data.appellation);
					$("#edit-company").val(data.company);
					$("#edit-clueOwner").val(data.owner);

				}
			})
		})



		//更新线索并关闭模态窗口
		$("#updateClueBtn").click(function () {
		var id              	=$("#tBody input[type='checkbox']:checked").val();
		var  address 			=$("#edit-address").val();
		var  nextContactTime 	=	$("#edit-nextContactTime").val();
		var  contactSummary 	=$("#edit-contactSummary").val();
		var   describe			=			$("#edit-describe").val();
		var  source 			=	$("#edit-source").val();
		var   status			=	$("#edit-status").val();
		var   mphone			=	$("#edit-mphone").val();
		var  website		 =	$("#edit-website").val();
		var  phone 				=	$("#edit-phone").val();
		var  email 				=	$("#edit-email").val();
		var  job			 =	$("#edit-job").val();
		var   surname			=	$("#edit-surname").val();
		var   call				=	$("#edit-call").val();
		var   company				=	$("#edit-company").val();
		var   clueOwner				=	$("#edit-clueOwner").val();
			$.ajax({
				url:"workbench/clue/updateClueById.do",
				data:{
					id               :	id            ,
					address          :	address       ,
					nextContactTime  :	nextContactTime,
					contactSummary   :	contactSummary,
					description         :	describe      ,
					source           :	source        ,
					state           :	status        ,
					mphone           :	mphone        ,
					website          :	website       ,
					phone            :	phone         ,
					email            :	email         ,
					job              :	job           ,
					fullname          :	surname       ,
					appellation             :	call          ,
					company          :	company       ,
					owner        :	clueOwner
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						//关闭创建模态窗口
						$("#EditClueModal").modal("hide");
						// 创建市场活动后自动刷新bs_pagination
						queryClueByConditionForPage($("#bs_paging1").bs_pagination('getOption','currentPage'),$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message)
						$("#EditClueModal").modal("show");
					}
				}
			})

		})


	});
	function queryClueByConditionForPage(pageNo,pageSize){

		var	select_fullname= $("#select_fullname").val();
		var	select_company=  $("#select_company").val();
		var	select_mphone=   $("#select_mphone").val();
		var	select_source=   $("#select_source").val();
		var	select_owner=    $("#select_owner").val();
		var	select_phone=    $("#select_phone").val();
		var	select_state=    $("#select_state").val();
		$.ajax({
			url:"workbench/clue/queryClueByConditionForPage.do",
			data:{
				select_state     :select_state    ,
				select_phone     :select_phone    ,
				select_owner     :select_owner    ,
				select_source    :select_source   ,
				select_mphone    :select_mphone   ,
				select_company   :select_company  ,
				select_fullname  :select_fullname,
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
						queryClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
				var htmlStr="";
				//jquery遍历后端返回的集合对象
				$.each(data.clueList,function (index,obj) {
					htmlStr+= "<tr>";
					htmlStr+=	"<td><input type=\"checkbox\" value=\""+obj.id+"\" /></td>";
					htmlStr+=	"<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href=\'workbench/clue/detailClue.do?clueId="+obj.id+"\';\">"+obj.fullname+obj.appellation+"</a></td>";
					htmlStr+=	"<td>"+obj.company+"</td>";
					htmlStr+=	"<td>"+obj.mphone+"</td>";
					htmlStr+=	"<td>"+obj.phone+"</td>";
					htmlStr+=	"<td>"+obj.source+"</td>";
					htmlStr+=	"<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.state+"</td>";
					htmlStr+=	"</tr>"
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
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="saveCreateForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<c:forEach items="${appellationList}" var="ppellation">
										<option value="${ppellation.id}">${ppellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateClue" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="EditClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<c:forEach items="${appellationList}" var="ppellation">
										<option value="${ppellation.id}">${ppellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
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
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateClueBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="select_fullname" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="select_company" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="select_mphone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="select_source" class="form-control">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="select_owner" class="form-control" type="text">
				    </div>
				  </div>



				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="select_phone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="select_state" class="form-control">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  <button id="selectForPagesBtn"  type="button" class="btn btn-default">查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createClueBtn" type="button" class="btn btn-primary"  ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="showEditClueModalBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteClueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detailClue.do?clueId=593f337138984188949deb11b359934b';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detailClue.do?clueId=593f337138984188949deb11b359934b';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
				<div id="bs_paging1"></div>
			</div>



		</div>
	</div>
</body>
</html>