<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../includes/header.jsp" %>

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
				&nbsp<button id='regBtn' type='button' class="btn btn-primary btn-xs pull-right">Register</button>
			</div>
            <div class="panel-body">
                <table width="100%" class="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>#no</th>
                            <th>title</th>
                            <th>writer</th>
                            <th>regDate</th>
                            <th>updateDate</th>
                        </tr>
                    </thead>
                    <tbody>
                    	<c:forEach items="${list }" var="board">
                    	
                    		<tr>
                    			<td><c:out value="${board.bno }" /></td>
                    			<td>
                    				<a class='move' href='<c:out value="${board.bno }" />'>
                    					<c:out value="${board.title }" /> <b>[<c:out value="${board.replyCnt }" />]</b>
                    				</a>
                    			</td>
                    			<td><c:out value="${board.writer }" /></td>
                    			<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regDate }" /></td>
                    			<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }" /></td>
                    		</tr>
                    	
                    	</c:forEach>
                    </tbody>
                </table>
                <!-- /.table-responsive -->
                
                <div class='row'>
                	<div class="col-lg-12">
                	
                		<form id='searchForm' action="/board/list" method='get'>
                			<select name='type'>
                				<option value=""
                					<c:out value="${pageMaker.cri.type == null ? 'selected' : ''}" />>-</option>
                				<option value="T"
                					<c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}" />>Title</option>                				
                				<option value="C"
                					<c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}" />>Content</option>                				
                				<option value="W"
                					<c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : '' }" />>Writer</option>                				
                				<option value="TC"
                					<c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : '' }" />>Title or Content</option>                				
                				<option value="TW"
                					<c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : '' }" />>Title or Writer</option>                				
                				<option value="TWC"
                					<c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : '' }" />>Title or Content or Writer</option>                				
                			</select>
                			
                			<input type='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword }" />' />
                			<input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum }" />' />
                			<input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount }" />' />
                			
                			<button class='btn btn-default'>Search</button>
                		</form>
                	
                	</div>
                </div>
                
                <div class="pull-right">
	                <ul class="pagination">
	                	<c:if test="${pageMaker.prev }">
	                		<li class="page-item"><a class="page-link" href="1">Start</a></li>
						    <li class="page-item"><a class="page-link" href="${pageMaker.cri.pageNum - 10 }">Prev</a></li>
						</c:if>
						
						<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
						    <li class="page-item ${pageMaker.cri.pageNum == num ? "active" : "" }"><a class="page-link" href="${num }">${num }</a></li>
						</c:forEach>
						
						<c:if test="${pageMaker.next }">
						    <li class="page-item"><a class="page-link" href="${pageMaker.cri.pageNum + 10 }">Next</a></li>
						    <li class="page-item"><a class="page-link" href="${pageMaker.realEnd }">End</a></li>
						</c:if>
	  				</ul>
	  			</div>
	  			
	  			<form id='actionForm' action="/board/list" method='get'>
	  				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum }'>
	  				<input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
	  				<input type='hidden' name='type' value='<c:out value="${pageMaker.cri.type }" />' />
                	<input type='hidden' name='keyword' value='<c:out value="${pageMaker.cri.keyword }" />' />	  				
	  			</form>
	  			<!-- /.pagination -->
                                            
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->
            
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
            </div>
            <div class="modal-body">
               	 처리가 완료되었습니다.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<script>

	$(document).ready(function(){
		
		var result = '<c:out value="${result}" />';
		
		checkModal(result);
		
		history.replaceState({}, null, null);
		
		function checkModal(result) {
			
			if (result === '' || history.state) {
				
				return;
			}
			
			if (parseInt(result) > 0) {
				
				$(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.");
			}
			
			$("#myModal").modal("show");
		}
		
		$("#regBtn").on("click", function(){
			
			self.location = "/board/register";
		});
	
		
		var actionForm = $("#actionForm");
		
		$(".page-item a").on("click", function(e) {
			
			var pageNum = $(this).attr("href");
			var realEnd = '<c:out value="${pageMaker.realEnd }" />';
			
			if(pageNum > parseInt(realEnd)) {
				
				pageNum = realEnd;
			}
			
			e.preventDefault();
			console.log('click');
			
			actionForm.find("input[name='pageNum']").val(pageNum);
			actionForm.submit();
		});
		
		$(".move").on("click", function(e){
			
			e.preventDefault();
			actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});
		
		var searchForm = $("#searchForm");
		
		$("#searchForm button").on("click", function(e){
			
			if(!searchForm.find("option:selected").val()){
				
				alert("검색 종류를 선택하세요");
				
				return false;
			}
			
			if(!searchForm.find("input[name='keyword']").val()){
				
				alert("키워드를 입력하세요");
				
				return false;
			}
			
			searchForm.find("input[name='pageNum']").val("1");
			
			e.preventDefault();
			
			searchForm.submit();
		});
	});

</script>

<%@include file="../includes/footer.jsp" %>        