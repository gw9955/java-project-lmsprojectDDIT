<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/qnaBoard.css" />
<link rel="stylesheet" href="/resources/css/qnaDetail.css" />
<style type="text/css">
.card-body {
	min-height: 677px;
}

#btnRound {
	float: right;
	position: relative;
	right: 25px;
	top: 50px;
}

#listBtn {
	float: left;
	position: relative;
	top: 50px;
	left: 28px;
}

#listBtn, #btnRound {
	margin-bottom: 65px;
}

#modal {
	display: inline-block;
	position: absolute;
	margin-left: 25%;
	background: white;
	z-index: 9999;
	border: 1px solid #777;
	border-radius: 20px;
	width: 500px;
	height: 600px;
}

#modal-close img {
	display: inline-block;
	width: 35px;
	height: 35px;
	float: right;
	margin-top: 20px;
	margin-right: 25px;
}

#modal-close {
	cursor: pointer;
}

#modaltitle {
	margin-top: 80px;
}

#modaltitle span {
	display: inline-block;
	width: 100px;
	color: black;
	text-align: center;
	font-size: 15pt;
}

#modaltitle input {
	width: 270px;
	height: 40px;
	border: none;
	border-bottom: 2px solid #001353;
}

#modalcontent {
	background: green;
	margin-top: 25px;
}

#modalcontent span {
	color: black;
	display: inline-block;
	width: 70px;
	text-align: center;
	font-size: 13pt;
	float: left;
	margin-left: 18px;
}

#modalcontent textarea {
	width: 350px;
	height: 350px;
	margin-right: 50px;
	padding: 15px;
	float: right;
	resize: none;
}

#saveBtn {
	float: right;
	margin-top: 20px;
	margin-right: 50px;
}

.btn-primary {
	background-color: #2a5388;
	border: #2a5388;
	box-shadow: #2a5388;
}

.btn-primary:hover {
	background-color: #4671af;
	border: #4671af;
	box-shadow: #4671af;
}
</style>
<script type="text/javascript" defer="defer">
$(function(){
	$("#listBtn").on('click',function(){
		location.href="/main/qna";
	})

	$('#replUpdate').on('click',function(){

		qnaCd = $('#replUpdate').data('qnacd');
		qnarCon = $('#replUpdate').data('qnarcon');

		console.log(qnaCd,qnarCon);
		$("#repCon").attr("readonly",false);
		$("#replUpdate").css("display","none");
		$("#replUpdateBtn").css("display", "inline-block");

		//댓글 수정
		$('#replUpdateBtn').on('click',function(){
			qnaCd = $('#replUpdate').data('qnacd');

			qnarCon = $("#repCon").val();
			$.ajax({
				url:"/qna/replyUpdate",
				data:{
					qnaCd : qnaCd,
					qnarCon : qnarCon
				},
				dataType:"json",
				type:"post",
				success:function(res){
					if(res==1){
						alert("수정이 완료되었습니다.")
						window.location.reload();

					}
					else{
						alert("수정에 실패했습니다.")
					}
				}
			})
			$("#repCon").attr("readonly",true);
				$("#replUpdate").css("display","inline-block");
				$("#replUpdateBtn").css("display", "none");
		});
	});

	$('#updateBtn').on('click',function(){
		var qnaCd = $('#updateBtn').data('qnacd');
		var qnaCon = $('#updateBtn').data('qnacon');

		$("#modal").css('display','inline-block');

	})

	$('#deleteBtn').on('click',function(){
		var qnaCd = $("#deleteBtn").data('qnacd');
		$.ajax({
			url:"/qna/qnaDelete",
			data : {qnaCd:qnaCd},
			dataType : "json",
			type:"post",
			success:function(res){
				if(res==1){
					alert("삭제되었습니다.");
					location.href="/main/qna";
				}
				else{
					alert("삭제에 실패하였습니다.");
				}
			}
		})
	})

	$("#modal-close").on('click',function(){
		$("#modal").css('display','none');
	})

	$("#saveBtn").on('click',function(){
		var qnaCd = $('#saveBtn').data('qnacd');
		var title = $("#modaltitle input").val();
		var content = $("#modalcontent textarea").val();


		$.ajax({
			url:"/qna/qnaUpdate",
			type:"post",
			dataType : "json",
			data : {
					qnaCd : qnaCd,
					title : title,
					content : content
			},
			success : function(res){
				if(res==1){
					alert("수정이 완료되었습니다.");
					window.location.reload();
				}
				else{
					alert("수정에 실패하였습니다.");
				}
			}

		})
	})

	$('#qnaReplInsertBtn').on('click',function(){
		$('#insertA').html(
				'네 그렇습니다. 사범대학생의 경우 2009학번부터, 일반 교직과정설치학과의 교직이수자들은 2010년에 교직이수자로 선발된 학생부터 반드시 교육봉사활동을 하여야 합니다.');

	})

});
function qnarInsert(qnaCd){

		var reply = $("#insertA").val();
		var qnaCd= qnaCd;

		if(reply == null){
			alert("답변을 입력해주세요");
			return;
		}

		var memCd = $('#memCd').val();

		$.ajax({
			url:"/qna/qnarWrite",
			type:"post",
			data :{
					reply:reply,
					qnaCd:qnaCd,
					memCd:memCd
				},
			dataType:"json",
			success: function(res){
				if(res == 1){
					alert("등록되었습니다.");
					window.location.reload();
				}
				else{
					alert("등록에 실패하였습니다.");
				}
			},
			error : function(res){

				console.log("에러발생");
			}
		})
}


</script>
</head>
<body>

	<div class="allRound">
		<div class="card">
			<div class="card-body">
				<h3>
					&nbsp;<i class="mdi mdi-comment-question-outline"></i>&nbsp;문의게시판
				</h3>
				<input type="hidden" id="memCd" value="${qnaVO.memCd }">
				<hr style="border: 1px solid #001353;">
				<div id="modal" style="display: none;">
					<div id="modal-close">
						<img src="/resources/images/free-icon-close-button-2696714.png">
					</div>
					<div id="modaltitle">
						<span>제목</span> <input type="text" value="${qnaVO.qnaTtl }">
					</div>
					<div id="modalcontent">
						<span>내용</span>
						<textarea>${qnaVO.qnaConDisplay }</textarea>
					</div>
					<br style="clear: both;" />
					<button id="saveBtn" type="button" class="btn btn-light"
						data-qnacd='${qnaVO.qnaCd}'>저장</button>
				</div>

				<form method="POST" id="questionForm">
					<div class="titleRound">
						<label id="qnatitle">제목</label>
						<div id="qnaTitle">${qnaVO.qnaTtl}</div>
						<div id="viewRound">
							<label id="viewCnt">조회수</label>
							<div id="viewCntNum">${qnaVO.qnaHit }</div>
						</div>
						<c:if test="${memSession.managerVO.mgrCd != null}">
						<div style="float:right">
							<div id="qnaWriterRound" style="display : inline-block;float:left;">
								<label id="qnaWriter">작성자</label>
								<div id="qnaWriterCd">${qnaVO.memCd}</div>
								<div id="qnaWriterNm">${qnaVO.memberVO.memNm}</div>
							</div>
							<div id="date" style="left:70px;">
								<label id="qnarDt">작성일</label>
								<div id="qnarDate">
									<fmt:formatDate value="${qnaVO.qnaDt }" />
								</div>
							</div>
						</div>
						</c:if>
						<hr style="border: 1px solid #dedede;clear:both;">
					</div>
					<div class="textArea" style="font-size: 12pt;">${qnaVO.qnaConDisplay }</div>
					<input type="button" id="listBtn" class="btn btn-light" value="목록">
					<div id="btnRound">
						<c:if test="${empty qnaVO.qnaReplyVO.qnarCon}">
							<c:if test="${sessionScope.memSession.managerVO.mgrCd eq null}">
								<input type="button" id="updateBtn" class="btn btn-primary"
									data-qnacd='${qnaVO.qnaCd}'
									data-qnacon='${qnaVO.qnaConDisplay }' value="수정">
								<input type="button" id="deleteBtn" class="btn btn-primary"
									data-qnacd='${qnaVO.qnaCd}' value="삭제">
							</c:if>
						</c:if>
					</div>
				</form>
				<br>
				<c:set var="qnarCon" value="${qnaVO.qnaReplyVO.qnarCon}" />
				<c:if test="${not empty qnarCon}">
					<!-- 답변 있는경우 -->
					<div id="reply">
						<div id="repWriter">학사관리팀</div>
						<div id="date">
							<label id="qnarDt">작성일</label>
							<div id="qnarDate">
								<fmt:formatDate value="${qnaVO.qnaReplyVO.qnarDt }" />
							</div>
						</div>
						<hr style="border: 1px solid #dedede; clear: both;">
						<textarea id="repCon" readonly>${qnaVO.qnaReplyVO.qnarCon }</textarea>
					</div>
				</c:if>
				<br style="clear: both;">
				<!-- 답변 없을 경우 -->
				<c:if test="${sessionScope.memSession.managerVO.mgrCd != null }">
					<c:if test="${empty qnaVO.qnaReplyVO.qnarCon}">
						<div id="qnaReplyArea">
							<div id="answer">답변</div>
							<div id="answerArea">
								<textarea id="insertA"></textarea>
							</div>
						</div>
						<br style="clear: both;">
						<c:if test="${sessionScope.memSession.managerVO.mgrCd != null }">
							<button type="button" class="btn btn-secondary" id="qnaReplInsertBtn">자동입력</button>
							<input type="button" onclick="qnarInsert(${qnaVO.qnaCd});"
								id="qnarInsert" class="btn btn-primary" value="등록">
						</c:if>
					</c:if>
				</c:if>
				<!-- 답변 있는 경우 만들어지는 버튼 -->
				<c:if test="${not empty qnaVO.qnaReplyVO.qnarCon}">
					<c:if test="${sessionScope.memSession.managerVO.mgrCd != null }">
						<input type="button" id="replUpdate" data-qnacd='${qnaVO.qnaCd}'
							data-qnarcon='${qnaVO.qnaReplyVO.qnarCon }'
							class="btn btn-primary" value="수정" />
						<input type="button" id="replUpdateBtn"
							data-qnacd='${qnaVO.qnaCd}' class="btn btn-primary" value="등록"
							style="display: none;" />
					</c:if>
				</c:if>
			</div>
		</div>
	</div>


</body>
</html>
