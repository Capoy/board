<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../includes/header.jsp" %>

<style>

.uploadResult {

	width : 100%;
	background-color: #eee;
}

.uploadResult ul {

	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {

	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
	cursor: pointer;
}

.uploadResult ul li img {

	width: 100px;
	margin: 5px;
}

.uploadResult ul li span {

	color: black;
	font-size: 16px;
}

.bigPictureWrapper {

	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255, 255, 255, 0.5);
}

.bigPicture {

	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

</style>

<script>
$(document).ready(function(e){
	
	var formObj = $("form[role='form']");
	
	$("button[type='submit']").on("click", function(e){
				
		e.preventDefault();	// 기존 form submit은 중지
		
		console.log("Submit clicked");
		
		var operation = $(this).data("oper");
		var titleVal = $("input[name='title']").val(); 
		var contentVal = $("textarea[name='content']").val();
		var writerVal = $("input[name='writer']").val();
		
		if(operation === "list") {
			
			formObj.attr("action", "/board/list").attr("method", "get");			
			formObj.empty();

			formObj.submit();
			
			return;
		}
		
		if(titleVal == "" || contentVal == "" || writerVal == ""){
			
			alert("빈 칸이 존재합니다.");
			
			return;
		}
		
		var str = "";
		
		$(".uploadResult ul li").each(function(i, obj){
			
			var jobj = $(obj);
			
			console.dir(jobj);
			
			str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
			str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
			str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
			str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
		});
		
		formObj.append(str).submit();

	});
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5MB
	
	function checkExtension(fileName, fileSize){
		
		if(fileSize >= maxSize){
			
			alert("파일 사이즈 초과");
			
			return false;
		}
		
		if(regex.test(fileName)){
			
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			
			return false;
		}
		
		return true;
	}
	
	function showUploadResult(uploadResultArr){
		
		if(!uploadResultArr || uploadResultArr.length == 0) {
			
			return;
		}
		
		var uploadUL = $(".uploadResult ul");
		
		var str = "";
		
		$(uploadResultArr).each(function(i, obj){
			
			//image type
			if(obj.fileType) {
				
				var fileCallPath = encodeURIComponent( obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				
				str += "<li data-path='" + obj.uploadPath + "'";
				str += " data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>";
				str += "<div>";
				str += "<span>" + obj.fileName + "&nbsp;</span>";
				str += "<button type='button' data-file=\'"+ fileCallPath + "\' data-type='image' class='btn btn-danger btn-circle'>";
				str += "<i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName=" + fileCallPath + "'>";
				str += "</div></li>";
				
			} else {
				
				var fileCallPath = encodeURIComponent( obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				
				str += "<li data-path='" + obj.uploadPath + "'";
				str += " data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>";
				str += "<div>";
				str += "<span>" + obj.fileName + "&nbsp;</span>";
				str += "<button type='button' data-file=\'"+ fileCallPath + "\' data-type='file' class='btn btn-danger btn-circle'>";
				str += "<i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'>";
				str += "</div></li>";
			}
		});
		
		uploadUL.append(str);
	}
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("input[type='file']").change(function(e){
		
		var formData = new FormData();
		
		var inputFile = $("input[name='uploadFile']");
		
		var files = inputFile[0].files;
		
		console.log(files);
		
		for(var i = 0; i < files.length; i++){
			
			if( !checkExtension(files[i].name, files[i].size) ){
				
				return false;
			}
			
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data: formData,
			type: 'POST',
			dataType: 'json',
			success: function(result){
				
				console.log(result);
				showUploadResult(result); // 업로드 결과 처리 함수
			}
		});
	});
	
	$(".uploadResult").on("click", "button", function(e){
		
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var targetLi = $(this).closest("li");
		var type = $(this).data("type");
		
		$.ajax({
			url: '/deleteFile',
			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data: {fileName: targetFile, type: type},
			dataType: 'text',
			type: 'POST',
			success: function(result){
		
				targetLi.remove();
			}
		});	//$.ajax
	});
	
});
</script>
    
<div class="row">
    <div class="col-lg-12">
        <a href='/board/list'>
        	<h1 class="page-header">Board</h1>
        </a>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
			<div class="panel-heading">
				<b>Register</b>
			</div>
            <div class="panel-body">
                <form role="form" action="/board/register" method="post">
                	
                	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
                
                	<div class="form-group">
                		<label>Title</label>
                		<input class="form-control" name='title' required>
                	</div>
                	<div class="form-group">
                		<label>Textarea</label>
                		<textarea class="form-control" rows="3" name='content' required></textarea>
                	</div>
                	<div class="form-group">
                		<label>Writer</label>
                		<input class="form-control" name='writer' value="<sec:authentication property="principal.username" />" readonly>
                	</div>
                	<button type="submit" class="btn btn-default">Submit</button>
                	<button type="reset" class="btn btn-default">Reset</button>
                	<button type="submit" data-oper='list' class="btn btn-info">List</button>
                	
                </form>
                
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
        	<div class="panel-heading">
        		<b>File Attach</b>
        	</div>
        	<div class="panel-body">
        		<div class="form-group uploadDiv">
        			<input type="file" name="uploadFile" multiple>
        		</div>
        		
        		<div class="uploadResult">
        			<ul>
        			</ul>
        		</div>
        	</div>
        	<!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<%@include file="../includes/footer.jsp" %>