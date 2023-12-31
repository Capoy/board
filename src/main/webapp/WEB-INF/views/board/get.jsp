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
	z-index: 100;
	background: rgba(255, 255, 255, 0.5);
}

.bigPicture {

	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.chat li {

	cursor: pointer;
}

</style>
    
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
				<b>#<c:out value="${board.bno }" /></b>
			</div>
            <div class="panel-body">                     	
                	<div class="form-group">
                		<label>Title</label>
                		<input class="form-control" name='title' value='<c:out value="${board.title }" />'readonly="readonly" >
                	</div>
                	<div class="form-group">
                		<label>Textarea</label>
                		<textarea class="form-control" rows="3" name='content' readonly="readonly"><c:out value='${board.content }' /></textarea>
                	</div>
                	<div class="form-group">
                		<label>Writer</label>
                		<input class="form-control" name='writer' value='<c:out value="${board.writer }" />' readonly="readonly">
                	</div>
                	
                	<sec:authentication property="principal" var="pinfo" />
                	
                	<sec:authorize access="isAuthenticated()" >
                		
                		<c:if test="${pinfo.username eq board.writer}">
		                	<button data-oper='modify' class="btn btn-default">
		                			Modify
		                	</button>
	                	</c:if>
	                	
	                </sec:authorize>
                	
                	<button data-oper='list' class="btn btn-info">                		
	                	List
	                </button>
                	
                	<form id='operForm' action="/board/modify" method="get">
                		<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno }" />' />
                		<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }" />' />
                		<input type='hidden' name='amount' value='<c:out value="${cri.amount }" />' />
                		<input type='hidden' name='type' value='<c:out value="${cri.type }" />' />
                		<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }" />' />
                	</form>             
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div>

<div class='row'>
	<div class="col-lg-12">
		<!-- /.panel -->
		<div class="panel panel-default">
		
			<!--
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
			</div>
			-->
			
			<div class="panel-heading">
				Files
			</div>
			<!-- /.panel-heading -->
			
			<div class="panel-body">
			
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
				
			</div>		
			
		</div>
	</div>
	
</div>

<div class='row'>
	<div class="col-lg-12">
		<!-- /.panel -->
		<div class="panel panel-default">
		
			<!--
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
			</div>
			-->
			
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
				
				<sec:authorize access="isAuthenticated()" >
					<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
				</sec:authorize>
			</div>
			<!-- /.panel-heading -->
			
			<div class="panel-body">
			
				<ul class="chat">
					<!-- start reply -->
					
					<!-- end reply -->
				</ul>
				
			</div>		
			
			<div class="panel-footer">
			
			</div>
			
		</div>
	</div>
	
</div>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
            </div>
            
            <div class="modal-body">
               <div class="form-group">
               		<label>Reply</label>
               		<input class="form-control" name='reply' value='reply'>
               </div>
               <div class="form-group">
               		<label>Replyer</label>
               		<input class="form-control" name='replyer' value='replyer' readonly>
               </div>
               <div class="form-group">
               		<label>Reply Date</label>
               		<input class="form-control" name='replyDate' value=''>
               </div>
            </div>
            
            <div class="modal-footer">
                <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
                <button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
	$(document).ready(function() {
		
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e) {
			
			operForm.submit();
		});
		
		$("button[data-oper='list']").on("click", function() {
			
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
	});
</script>

<script type="text/javascript">
	$(document).ready(function() {
		
		console.log(replyService);
		
		var bnoValue = '<c:out value="${board.bno }" />';
		var replyUL = $(".chat");
		
		showList(1);
		
		function showList(page) {
				
				console.log("show list " + page);
			
				replyService.getList({bno : bnoValue, page : page || 1}, function(replyCnt, list) { 
				
				console.log("replyCnt: " + replyCnt);
				console.log("list: " + list);
				console.log(list);
				
				if(page == -1){
					
					pageNum = Math.ceil(replyCnt / 10.0);
					showList(pageNum);
					
					return;
				}
				
				var str = "";
				
				if(list == null || list.length == 0) {
				
					return;
				}
				
				for (var i = 0, len = list.length || 0; i < len; i++) {
					str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str += "<div><div class='header'><strong class='primary-font'>" + list[i].replyer + 
					"</strong>";
					
					str += "<small class='pull-right text-muted'>" + 
					replyService.displayTime(list[i].replyDate) + "</small></div>";
					
					str += "<p>" + list[i].reply + "</p></div></li>";
				}
				
				replyUL.html(str);
				showReplyPage(replyCnt);
				
			});	// end function
			
		} //end showList
		
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt){
			
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 10 >= replyCnt){
				endNum = Math.ceil(replyCnt / 10.0);	// endNum이 실제보다 클 때 조정
			}
			
			if(endNum * 10 < replyCnt){
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";
			
			if(prev){
				str += "<li class='page-item'><a class='page-link' href=''" + 
						(startNum - 1) + "'>Prev</a></li>";
			}
			
			for(var i = startNum; i <= endNum; i++){
				
				var active = pageNum == i ? "active" : "";
				
				str += "<li class='page-item " + active + "'><a class='page-link' href='" + 
						i + "'>" + i + "</a></li>";
			}
			
			if(next){
				str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
			}
			
			str += "</ul></div>";
			
			console.log(str);
			
			replyPageFooter.html(str);
		}
		
		replyPageFooter.on("click", "li a", function(e){
			
			e.preventDefault();
			
			console.log("page click");
			
			var targetPageNum = $(this).attr("href");
			
			console.log("targetPageNum: " + targetPageNum);
			
			pageNum = targetPageNum;
			
			showList(pageNum);
		});
		
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalCloseBtn = $("#modalCloseBtn");
		
		var replyer = null;
		
		<sec:authorize access="isAuthenticated()">
		
			replyer = '<sec:authentication property="principal.username" />';
		
		</sec:authorize>
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$("#addReplyBtn").on("click", function(e) {
			
			modal.find("input").val("");
			modalInputReply.removeAttr("readonly");
			modalInputReplyer.val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			
			$(".modal").modal("show");
			
		});
		
		//Ajax spring security header...
		$(document).ajaxSend(function(e, xhr, options){
			
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
		
		modalRegisterBtn.on("click", function(e) {
			
			var reply = {
					reply: modalInputReply.val(), 
					replyer: modalInputReplyer.val(), 
					bno: bnoValue
			};
			
			var blank_pattern = /^\s+|\s+$/g;
			
			if(reply.reply == "" || reply.replyer == "" || reply.reply.replace( blank_pattern, '' ) == "" || reply.replyer.replace( blank_pattern, '' ) == "") {
				
				alert("작성자 또는 내용을 입력해주세요.");
				
				return;
			}
			
			replyService.add(reply, function(result) {
				
				alert(result);
				
				modal.find("input").val("");
				modal.modal("hide");
				
				// showList(1);
				showList(-1);
				
			});
			
		});
		
		modalModBtn.on("click", function(e) {
			
			var originalReplyer = modalInputReplyer.val();
			
			var reply = { 
					rno: modal.data("rno"), 
					reply: modalInputReply.val(),
					replyer: originalReplyer		
			};
			
			if(!replyer) {
				
				alert("로그인 후 수정이 가능합니다.");
				modal.modal("hide");
				
				return;
			}
			
			console.log("Original Replyer: " + originalReplyer);
			
			if(replyer != originalReplyer) {
				
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				
				return;
			}
			
			replyService.update(reply, function(result) {
				
				alert(result);
				modal.modal("hide");
				showList(pageNum);
				
			});
		});
		
		modalRemoveBtn.on("click", function(e) {
			
			var rno = modal.data("rno");
			
			console.log("RNO: " + rno);
			console.log("REPLYER: " + replyer);
			
			if(!replyer) {
				
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			
			console.log("Original Replyer: " + originalReplyer);	// 댓글의 원래 작성자
			
			if(replyer != originalReplyer) {
				
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				
				return;
			}
			
			replyService.remove(rno, originalReplyer, function(result) {
				
				alert(result);
				
				modal.modal("hide");
				
				$(".chat").find("li[data-rno='" + rno + "']").remove();
				
				showList(pageNum);			
			});
		});
		
		modalCloseBtn.on("click", function() {
			
			modal.modal("hide");
		});
		
		$(".chat").on("click", "li", function(e) {
			
			var rno = $(this).data("rno");
			
			replyService.get(rno, function(reply) {
				
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id !='modalCloseBtn']").hide();
				
				if(replyer == reply.replyer) {
					
					modalModBtn.show();
					modalRemoveBtn.show();
				}
				
				$(".modal").modal("show");
				
			});
		});
	});
	
</script>

<script>
/* 	
	console.log("==========");
	console.log("JS TEST");
	
	var bnoValue = '<c:out value="${board.bno}" />';
	
	//for replyService add test
	replyService.add(
			{reply:"JS Test", replyer:"tester", bno:bnoValue}
			,
			function(result){			
				alert("RESULT: " + result);	
			}
	);
	
	//for replyService list test
 	replyService.getList({bno:bnoValue, page:1}, function(list) {
		
		for(var i = 0, len = list.length || 0; i < len; i++) {
			
			console.log(list[i]);
		}
	});
	
 
	//for replyService delete test
  	replyService.remove(45, function(count){
		
		console.log(count);
		
		if (count === "Success") {
			alert("REMOVED");
		}
		
	}, function(err) {
		alert('ERROR...');
	});
	
	//for replyService modify test
  	replyService.update({
		rno : 22,
		bno : bnoValue,
		reply : "Modified Reply..."
	}, function(result) {
		
		alert("수정 완료...");	
	});
	
 
	replyService.get(22, function(data){
		console.log(data);
	});
 */	
</script>

<script>

$(document).ready(function(){
	
	(function(){
		
		var bno = '<c:out value="${board.bno}" />';
		
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
			
			console.log("attachList");
			console.log(arr);
			
			var str = "";
			
			$(arr).each(function(i, attach){
				
				//image type
				if(attach.fileType) {
				
					var fileCallPath = encodeURIComponent( attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
					
					str += "<li data-path='" + attach.uploadPath + "'";
					str += " data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
					str += "<div>";
					str += "<img src='/display?fileName=" + fileCallPath + "'>";
					str += "</div></li>";
				
				} else {
				
					str += "<li data-path='" + attach.uploadPath + "'";
					str += " data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
					str += "<div>";
					str += "<span>" + attach.fileName + "&nbsp;</span><br/>";
					str += "<img src='/resources/img/attach.png'>";
					str += "</div></li>";
				}
				
			});
			
			$(".uploadResult ul").html(str);
			
		});	//end getJSON
		
	})();	//end function	즉시 실행 함수
	
	$(".uploadResult").on("click", "li", function(e){
		
		console.log("view image");
		
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
		
		if(liObj.data("type")){
			
			showImage(path.replace(new RegExp(/\\/g), "/"));
			
		} else {
			
			//download
			self.location = "/download?fileName=" + path
		}
	});
	
	function showImage(fileCallPath){
		
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture").html("<img src='/display?fileName=" + fileCallPath +"'>");
		
	}
	
	$(".bigPictureWrapper").on("click", function(e){
		
		$('.bigPictureWrapper').hide();
	});
});

</script>



<%@include file="../includes/footer.jsp" %>