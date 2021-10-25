<%--
  Created by IntelliJ IDEA.
  User: hzh
  Date: 2021/10/19
  Time: 15:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
    <head>
        <base href="<%=basePath%>">
        <meta charset="UTF-8">
        <title>Welcome !</title>
        <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="jquery/jquery-1.12.4.js"></script>
        <script type="text/javascript">
            
            $(function(){
                
                //使当前窗口为顶级窗口
                if(window.top != window){
                    window.top.location = window.location;
                }
                
                //页面加载完毕后，清楚文本框并获得焦点
                $("#loginAct").val("");
                $("#loginAct").focus();
                //当点击input，清除span提示信息
                $("#loginAct").click(function(){
                    $("#msg").text("");
                })
                $("#loginPwd").click(function(){
                    $("#msg").text("");
                })
                //提交表单
                $("#submitBtn").click(function(){
                    //验证登录
                    if(validaForm()) {
                        $("form").submit();
                    }
                })
                $(window).keydown(function(event){
                    if(13 === event.keyCode){
                        //验证登录
                        if(validaForm()) {
                            $("form").submit();
                        }
                    }
                })
            })
            //验证登录
            function validaForm(){
                var loginAct = $("#loginAct").val().trim();
                var loginPwd = $("#loginPwd").val().trim();
                if(loginAct == "" || loginPwd == ""){
                    $("#msg").html("<font style='color:red'>账号和密码不能为空!</font>");
                    return false;
                }
                //ajax查询用户名/密码/日期/冻结状态/可访问ip
                $.ajax({
                    type: "post",
                    url: "settings/user/login.do",
                    data: {
                        "loginAct": loginAct,
                        "loginPwd": loginPwd
                    },
                    dataType: "json",
                    success: function(data){
                        //data: {"flag":true/false,"errorMsg":"xx"}
                        if(data.flag){
                            window.location.href = "workbench/index.jsp"
                        }else{
                            $("#msg").html("<font style='color:red'>" + data.errorMsg + "</font>")
                            return false;
                        }
                    }
                });
            }
            
            
        </script>
    </head>
    <body>
        <div style="position: absolute; top: 0px; left: 0px; width: 60%;">
            <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
        </div>
        <div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
            <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;CRM</span></div>
        </div>
        
        <div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
            <div style="position: absolute; top: 0px; right: 60px;">
                <div class="page-header">
                    <h1>登录</h1>
                </div>
                <form action="workbench/index.jsp" class="form-horizontal" role="form">
                    <div class="form-group form-group-lg">
                        <div style="width: 350px;">
                            <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                        </div>
                        <div style="width: 350px; position: relative;top: 20px;">
                            <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                        </div>
                        <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
                            
                            <span id="msg"></span>
                        
                        </div>
                        <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block" style="width: 350px; position: relative;top: 45px;">登录</button>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
