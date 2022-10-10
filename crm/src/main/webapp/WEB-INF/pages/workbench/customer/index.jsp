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
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//打开创建customer模态窗口
		$("#showCreateCustomerBtn").click(function () {
			//点击后初始化操作
			//清空插入数据form表单
			$("#createCustomerForm").get(0).reset();

			//显示插入数据的模态窗口
			$("#createCustomerModal").modal("show");
			$(".mydate").datetimepicker({
				language:'zh-CN',//中文格式
				format:'yyyy-mm-dd',//日期格式
				minView:'month',//可以选择的最小视图
				autoclose:true,
				initialDate:new Date(),
				todayBtn:true
			})

		});

		//保存创建客户并且关闭模态窗口
		$("#saveCreateCustomerBtn").click(function () {
			//点击后初始化操作->收集参数
		var	address     		=   $("#createaddress").val();
		var	nextContactTime   =   $("#create-nextContactTime").val();
		var	contactSummary    =   $("#create-contactSummary").val();
		var	description          =   $("#create-describe").val();
		var	phone             =   $("#create-phone").val();
		var	website           =   $("#create-website").val();
		var	name     			=   $("#create-customerName").val();
		var	owner    		 =   $("#create-customerOwner").val();
			//表单验证
			if(owner==""){
				alert("所有者不能为空")
				return ;
			}
			if(name==""){
				alert("名字不能为空")
				return ;
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
			$.ajax({
				url:"workbench/customer/savecreateCustomer.do",
				data:{
				address     	:address     	,
				nextContactTime :nextContactTime ,
				contactSummary  :contactSummary  ,
				description     :description     ,
				phone           :phone           ,
				website         :website         ,
				name     		:name     	,
					owner:owner
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						//关闭创建模态窗口
						$("#createCustomerModal").modal("hide");
						// 创建市场活动后自动刷新bs_pagination
						//等等要打开！！！！
						 queryCustomerByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message)
						$("#createCustomerModal").modal("show");
					}
				}
			})
		});

		//当客户面加载完毕时，查询记录
		queryCustomerByConditionForPage(1,5);

		$("#selectForPageByConditionBtn").click(function(){

			queryCustomerByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage'));

			//$("#bs_paging1").bs_pagination('getOption', 'rowsPerPage')
		});
		$("#checkAll").click(function () {
			$("#tBody input[type='checkbox']").prop("checked", this.checked);
		})
		/*修改客户并打开模态窗口，回显数据*/
		$("#showEditCustomerModalBtn").click(function () {
			if($("#tBody input[type='checkbox']:checked").size()!=1){
				alert("请选择一个要更新的记录");
				return;
			}
			var id=$("#tBody input[type='checkbox']:checked").val();
			console.log("id : "+id)
			$.ajax({
				url:"workbench/customer/selectCustomerById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					$("#editCustomerModal").modal("show");
					$("#create-address").val(data.address);
					$("#create-nextContactTime2").val(data.nextContactTime);
					$("#create-contactSummary1").val(data.contactSummary);
					$("#edit-describe").val(data.description);
					$("#edit-phone").val(data.phone);
					$("#edit-website").val(data.website);
					$("#edit-customerName").val(data.name);
					$("#edit-customerOwner").val(data.owner);
				}
			})
		})
		//保存更新并关闭模态窗口
		$("#saveEditBtn").click(function () {
			var id               =$("#tBody input[type='checkbox']:checked").val();
			var address          =$("#create-address").val();
			var nextContactTime  =$("#create-nextContactTime2").val();
			var contactSummary   =$("#create-contactSummary1").val();
			var description      =$("#edit-describe").val();
			var phone            =$("#edit-phone").val();
			var website          =$("#edit-website").val();
			var name             =$("#edit-customerName").val();
			var owner            =$("#edit-customerOwner").val();
			$.ajax({
				url:"workbench/customer/updateCustomerById.do",
				data:{
				id             :id             ,
				address        :address        ,
				nextContactTime:nextContactTime,
				contactSummary :contactSummary ,
				description    :description    ,
				phone          :phone          ,
				website        :website        ,
				name           :name           ,
				owner          :owner
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						//关闭创建模态窗口
						$("#editCustomerModal").modal("hide");
						// 创建市场活动后自动刷新bs_pagination
						queryCustomerByConditionForPage($("#bs_paging1").bs_pagination('getOption','currentPage'),$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message)
						$("#editCustomerModal").modal("show");
					}
				}
			})

		})
		//选中删除

//删除操作

		$("#deleteCustomerBtn").click(function () {
			if(confirm("确定要删除选中项吗?")) {
				var idsData ="";
				$("#tBody input[type='checkbox']:checked").each(function(){
					alert("value : "+$(this).val())
					idsData+=("ids="+$(this).val()+"&");
				});
				idsData=idsData.substr(0,idsData.length-1);
				alert(idsData);
				$.ajax({
					url:"workbench/customer/deleteCustomerByIds.do",
					data:idsData,
					dataType:"json",
					type:"post",
					success:function (data) {
						if(data.code=="1"){
							alert(data.message)
							queryCustomerByConditionForPage(1,$("#bs_paging1").bs_pagination('getOption','rowsPerPage'));
						}else{
							alert(data.message)
						}
					}
				})
			}
		})



});



function queryCustomerByConditionForPage(pageNo,pageSize){
    //收集查询条件
    var website =$("#selectWebsite").val();
    var phone  =$("#selectMphone").val();
    var owner    =$("#selectOwner").val();
    var name    =$("#selectName").val();
    $.ajax({
        url:"workbench/customer/querycCustomerByConditionForPage.do",
        data:{
            website:website,
            phone :phone ,
            owner  :owner  ,
            name   :name   ,
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
                    queryCustomerByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                }
            });
            var htmlStr="";
            //jquery遍历后端返回的集合对象
            $.each(data.customerList,function (index,obj) {
                htmlStr+="<tr class='active'>"+
                        "<td><input type='checkbox' value=\""+obj.id+"\"/></td>"+
                        "<td><a style='text-decoration: none; cursor: pointer;'"+
                        "onclick=\"window.location.href='workbench/transaction/detail.do?id="+obj.id+"';\">"+obj.name+"</a></td>"+
                        "<td>"+obj.owner+"</td>"+
                        "<td>"+obj.phone+"</td>"+
                        "<td>"+obj.website+"</td>"+
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

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form id="createCustomerForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
									<c:forEach items="${requestScope.userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
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
                                    <input type="text" class="form-control mydate" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="createaddress"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
									<c:forEach items="${requestScope.userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
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
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditBtn" type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <input id="selectName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="selectOwner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="selectMphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input id="selectWebsite" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="selectForPageByConditionBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="showCreateCustomerBtn" type="button" class="btn btn-primary" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="showEditCustomerModalBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"  /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>http://www.bjpowernode.com</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>http://www.bjpowernode.com</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="bs_paging1"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>