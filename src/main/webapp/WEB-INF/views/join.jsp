<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Create Account</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" method="post" action="/join">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Userid" name="userid" type="text" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Username" name="userName" type="text" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Password" name="userpw" type="password" value="">
                                    <input class="form-control" placeholder="Confirm" name="confirmUserpw" type="password" value="">
                                </div>
                                <div class="check">
                                </div>

                                <!-- Change this to a button or input when using this as a form -->
                                
                                <a href="#" class="btn btn-lg btn-info btn-block">Join</a>
                                <a href="/board/list" class="btn btn-lg btn-default btn-block">Back</a>
                            </fieldset>
                            
                            <input type="hidden" name="authList[0].userid" value="" />
                            <input type="hidden" name="authList[0].auth" value="ROLE_USER" />
                            <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>
    
    <script>
    	
    	function idCheck(userid){
	
    		var checkResult;
    		
			$.ajax({
				url: '/idCheck',
				data: {userid : userid},
				type: 'get',
				dataType: 'text',
				async: false,
				success: function(result){
						
					checkResult = result;
	
				}
			});
			
			return checkResult;
    	}
    
    	$(".btn-info").on("click", function(e){
    		
    		e.preventDefault();
    		
    		var userid = $("input[name='userid']").val();
    		var userName = $("input[name='userName']").val();
    		var password = $("input[name='userpw']").val();
    		var confirmPassword = $("input[name='confirmUserpw']").val();
    		
    		if(userid === "" || userName === "" || password === ""){
    			
    			alert("빈 칸이 존재합니다.");
    			
    			return;
    		}
    		
    		if(idCheck(userid) === 'Y') {
    			
    			alert("중복되는 아이디입니다.");
    			
    			return;
    			
    		} else {
    			
    			$("input[name='authList[0].userid']").val(userid);
    		}
    		
    		if(password != confirmPassword){
    			
    			alert("입력하신 패스워드가 일치하지 않습니다.");
    			
    			return;
    		}
    		
    		$("form").submit();

    	});
    
    </script>
    
    <c:if test="${param.login != null }">
    	<script>
    		self.location="/board/list";
    	</script>
    </c:if>

</body>

</html>
