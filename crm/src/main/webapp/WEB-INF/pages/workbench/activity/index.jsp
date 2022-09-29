<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		//导入
		$("#importActivityBtn").click(function () {
			//收集xls文件
			var activityFilename=$("#activityFile").val();
			alert(activityFilename)
			var suffix=activityFilename.substr(activityFilename.lastIndexOf(".")+1).toLocaleLowerCase();
			var filename=activityFilename.substr(activityFilename.lastIndexOf("/")+1).toLocaleLowerCase();
			if(suffix!="xls"){
				alert("只支持xls文件");
				return;
			}
			var activityfile=$("#activityFile")[0].files[0];
			if(activityfile.size>1024*1024*10){
				alert("文件超过10M");
				return;
			}
			var formData=new FormData();
			formData.append("myfile",activityfile);
			formData.append("filename",filename);
			$.ajax({
				url:"workbench/activity/fileUpload.do",
				processData:false,
				contentType:false,
				data:formData,
				dataType:"json",
				type:"post",
				success:function (data) {
					if(data.code=="1"){
						alert("成功导入"+data.retData+"记录");
						$("#importActivityModal").modal("hide")
						queryActivityByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message);
						$("#importActivityModal").modal("show")
					}
				}
			})

		})



		//选择导出
		$("#exportActivityXzBtn").click(function () {
			var idsData ="";
			$("#tBody input[type='checkbox']:checked").each(function(){
				idsData+=("ids="+$(this).val()+"&");
			});
			idsData=idsData.substr(0,idsData.length-1);
			document.location.href="workbench/activity/QueryActivityByIds.do?"+idsData;
		})

		//批量导出
		$("#exportActivityAllBtn").click(function () {
			document.location.href="workbench/activity/exportAllActivity.do"
		})

		//打开创建activity模态窗口
		$("#createActivityBtn").click(function () {
		//点击后初始化操作
				//清空插入数据form表单
			$("#createActivityForm").get(0).reset();

				//显示插入数据的模态窗口
			$("#createActivityModal").modal("show");
			$(".mydate").datetimepicker({
				language:'zh-CN',//中文格式
				format:'yyyy-mm-dd',//日期格式
				minView:'month',//可以选择的最小视图
				autoclose:true,
				initialDate:new Date(),
				todayBtn:true
			})

		});

		//删除操作

		$("#deleteBtn").click(function () {
			if(confirm("确定要删除选中项吗?")) {
				var idsData ="";
				$("#tBody input[type='checkbox']:checked").each(function(){
					alert("value : "+$(this).val())
					idsData+=("ids="+$(this).val()+"&");
				});
				idsData=idsData.substr(0,idsData.length-1);
				alert(idsData);
				$.ajax({
					url:"workbench/activity/deleteActivityByIds.do",
					data:idsData,
					dataType:"json",
					type:"post",
					success:function (data) {
						if(data.code=="1"){
							alert(data.message)
							queryActivityByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
						}else{
							alert(data.message)
						}
					}
				})
			}
		})


		//保存创建activity并且关闭模态窗口
		$("#saveCreateActivityBtn").click(function () {
			//点击后初始化操作->收集参数
			var owner=$("#create-marketActivityOwner").val();
			var name=$.trim($("#create-marketActivityName").val());
			var startTime=$("#create-startTime").val();
			var endTime=$.trim($("#create-endTime").val());
			var describe=$.trim($("#create-describe").val());
			var cost=$.trim($("#create-cost").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空")
				return ;
			}
			if(name==""){
				alert("名字不能为空")
				return ;
			}
			if(startTime!=""&&endTime!=""){
				if(startTime>endTime){
					alert("开始日期不能大于结束日期")
					return;
				}
			}else{
				alert("日期不能为空")
				return;
			}
			//js表单验证使用到正则表达式匹配
			/*
			* (1)//定义为正则表达式
			** (2)^匹配字符串开头位置
			* * (3)$匹配字符串结尾位置
			* (4)[]匹配字符集中的一个字符
			* (5){m}匹配次数 m次
			* (6){m,n}匹配次数 m~n之间的一个次数
			* (7){m,}匹配次数 m到无限次之间的一个次数
			* (8)\d	匹配一个数字 相当于[0-9]
			* (9)\D	匹配一个非数字
			* (10)\w 匹配所有字符,包括字母，数字，下划线
			* (11)* 匹配0次或多次 相当于{0,}
			* (12)+	匹配1次或多次 相当于{1,}
			* (13)? 匹配1次或0次 相当于{0,1}
			* */
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数")
				return;
			}
			$.ajax({
				url:"workbench/activity/savecreateActivity.do",
				data:{
					owner:owner,
					name:name,
					startDate:startTime,
					endDate:endTime,
					description:describe,
					cost:cost
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						//关闭创建模态窗口
						$("#createActivityModal").modal("hide");
						// 创建市场活动后自动刷新bs_pagination
						queryActivityByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message)
						$("#createActivityModal").modal("show");
					}
				}
			})




		});

		//

		/*
		edit-describe
		edit-cost
		edit-endTime
		edit-startTime
		edit-marketActivityName
		*/
		/*修改市场活动并打开模态窗口，回显数据*/
		$("#showEditActivityModalBtn").click(function () {
			if($("#tBody input[type='checkbox']:checked").size()!=1){
				alert("请选择一个要更新的记录");
				return;
			}
			var id=$("#tBody input[type='checkbox']:checked").val();
			console.log("id : "+id)
			$.ajax({
				url:"workbench/activity/selectActivityById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					$("#editActivityModal").modal("show");

					$("#edit_select").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startTime").val(data.start_date);
					$("#edit-endTime").val(data.end_date);
					$("#edit-cost").val(data.cost);
					$("#edit-describe").val(data.description);
				}
			})
		})
		/*
		 更新市场活动并关闭模态窗口

		 */
		$("#updateActivityBtn").click(function () {
			var id=$("#tBody input[type='checkbox']:checked").val();
			var owner=$("#edit_select").val();
			var name=$("#edit-marketActivityName").val();
			var start_date=$("#edit-startTime").val();
			var end_date=$("#edit-endTime").val();
			var cost=$("#edit-cost").val();
			var description=$("#edit-describe").val();
			$.ajax({
				url:"workbench/activity/updateActivityById.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:start_date,
					endDate:end_date,
					description:description,
					cost:cost
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						//关闭创建模态窗口
						$("#editActivityModal").modal("hide");
						// 创建市场活动后自动刷新bs_pagination
						queryActivityByConditionForPage($("#bs_paging1").bs_pagination('getOption','currentPage'),$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message)
						$("#editActivityModal").modal("show");
					}
				}
			})

		})


		//当市场活动页面加载完毕时，查询记录
		queryActivityByConditionForPage(1,5);

		$("#selectBtn").click(function(){

			queryActivityByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage'));

			//$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage')
		});
		$("#checkAll").click(function () {
			$("#tBody input[type='checkbox']").prop("checked", this.checked);
		})


	});


	function queryActivityByConditionForPage(pageNo,pageSize){


		var name=$("#condition_name").val();
		var condition_owner=$("#condition_owner").val();
		var condition_startDate=$("#condition_startDate").val();
		var condition_endDate=$("#condition_endDate").val();
		$.ajax({
			url:"workbench/activity/querycActivityByConditionForPage.do",
			data:{
				param_name:name,
				param_owner:condition_owner,
				param_start_date:condition_startDate,
				param_end_date:condition_endDate,
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
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
			});
				var htmlStr="";
				//jquery遍历后端返回的集合对象
				$.each(data.activityList,function (index,obj) {
					htmlStr+="<tr class='active'>"+
							"<td><input type='checkbox' value=\""+obj.id+"\"/></td>"+
							"<td><a style='text-decoration: none; cursor: pointer;'"+
							"onclick=\"window.location.href='workbench/activity/activityDetail.do?id="+obj.id+"';\">"+obj.name+"</a></td>"+
							"<td>"+obj.owner+"</td>"+
							"<td>"+obj.startDate+"</td>"+
							"<td>"+obj.endDate+"</td>"+
							"</tr>"
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

	<!-- 创建市场活动的模态窗口 -->
		<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								<c:forEach items="${requestScope.userList}" var="u">
								  <option value="${u.id}">${u.name}</option>
								</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
						<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control mydate" id="create-startTime" readonly>
						</div>
						<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control mydate" id="create-endTime" readonly>
						</div>
					</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="updateForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select id="edit_select" class="form-control" id="edit-marketActivityOwner">
								  <c:forEach items="${requestScope.userList}" var="u">
									<option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startTime" value="2020-10-10" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endTime" value="2020-10-20" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过10MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input id="condition_name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="condition_owner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input id="condition_startDate" class="form-control" type="text"  />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input id="condition_endDate" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="selectBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="showEditActivityModalBtn" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			<div id="bs_paging1">
			</div>

			
		</div>
	</div>
</body>
</html>
