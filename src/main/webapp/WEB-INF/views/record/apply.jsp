<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Date"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" type="text/css"
	href="/resources/css/inputModalTemplate.css">
<%
	int stuNo = (int) session.getAttribute("no");
	String name = String.valueOf(session.getAttribute("name"));
%>
<div class="row">
	<form id="form" action="/record/applyPost" class="col-12" method="post" onsubmit="return checkFormData()">
	<div class="col-4">
		<div class="card card-primary">
			<div class="card-header" style="background-color:#112a63;">
				<h3 class="card-title">학적변동 신청서 작성</h3>
			</div>
			<div class="alert alert-light" role="alert" style="font-size: 0.9em;padding:1em;border: 1px solid #eee;">
					<p>
						<strong>※ 학적변동 안내사항</strong>
						<br><br>
						(1)<strong> 학적구분</strong>선택 후 학기 및 기간을 선택하여 주세요<br>
<!-- 						 - 시험 기간 미설정시, 등록 직후 바로 시험에 응시 가능합니다.<br> -->
<!-- 						 - <strong>기간을 설정하지 않고 문제를 등록하여 문제 유출이 되는 경우가 종종 발생합니다.</strong><br> -->
						<br>
						(2) 학적구분에 따라 선택할수 있는 옵션이 달라집니다<br>
						 - <strong>활성화된 옵션</strong>만 입력이 가능합니다.<br>
						<br>
						(3) 이름 및 신청날짜는 자동 입력됩니다<br>
						<br>
						(4) *는 필수 선택/입력 정보입니다.
					</p>
				</div>
			<div class="card-body">
				<input style="margin:0px;padding:0px;" type="hidden" name="stuNo" value="<%=stuNo%>">
				<input style="margin:0px;padding:0px;" type="hidden" name="recYn" value="AP002">
				<input style="margin:0px;padding:0px;" type="hidden" id="recSem" name="recSem">
				<div class="segmented-control2"
					style="width: 330px; padding: 0px; vertical-align: middle;">
					<input type="radio" name="rgbCd" value="RCD001" id="tab-3" checked /><label
						for="tab-3" class="segmented-control__3"><p>휴학</p></label> <input
						type="radio" name="rgbCd" value="RCD003" id="tab-4" /> <label
						for="tab-4" class="segmented-control__5"><p>복학</p></label> <input
						type="radio" name="rgbCd" value="RCD004" id="tab-5" /> <label
						for="tab-5" class="segmented-control__6"><p>자퇴</p></label> <input
						type="radio" name="rgbCd" value="RCD005" id="tab-6" /> <label
						for="tab-6" class="segmented-control__7"><p>졸업</p></label>
				
				<label class="col-sm-1"style="color:black; margin:0px;"for="segmented-control2">&nbsp;*</label>
				</div>
				<label>&nbsp;학기 선택*&nbsp;</label>
				<div class="form-group">
					<select class="col-4 custom-select rounded-0"
						id="recYr" name="recYr">
						<option selected>년도</option>
					</select> 
					
				    <button class="btn btn-secondary" type="button" id="currentSem"></button>
				    <button class="btn btn-secondary"type="button" id="nextSem"></button>
				    <label id="selectedYRSEMlabel">&nbsp; : <code style="color:blue" id="selectedYRSEM"></code></label>
				</div>
				<div class="form-group">
					<select class="col-4 custom-select rounded-0"
						id="recPer" name="recPer" required="required">
						<option>기간</option>
						<option value="1">1년</option>
						<option value="2">2년</option>
					</select> <code>&nbsp;[휴학 선택시]</code>
				</div>
				<div class="form-group">
					<label for="exampleInputBorder">신청자*</label> <input type="text"
						class="col-4 form-control form-control-border"
						id="exampleInputBorder" readonly value="<%=name%>">
				</div>
				<div class="form-group">
					<label for="exampleInputRounded0">사유</label> <br>
					<div class="row">
					<textarea class="col-12 form-control" rows="3"  name="recRsn" id="recRsn" required="required"
						placeholder="사유를입력하여주세요" ></textarea>
						</div>
				</div>
				<div class="form-group">
				<label for="exampleInputFile">파일첨부</label>
				<div class="input-group">
				<div class="custom-file">
				<input type="file" class="custom-file-input" id="exampleInputFile" cursorshover="true">
				<label class="custom-file-label" for="exampleInputFile"></label>
				</div>
				<div class="input-group-append">
				<span class="input-group-text">Upload</span>
				</div>
				</div>
				</div>
				<div style="text-align: end; padding-top: 10px;">
				
					<div class="btn-group">
					<button type="submit" class="btn btn-sm btn-outline-primary">등록</button>
					<a onclick="dataReset()" class="btn btn-sm btn-outline-secondary">취소</a>
					<a href="/record/main?stuNo=<%=stuNo%>"class="btn btn-sm btn-outline-info">목록</a>
					</div>
				</div>
			</div>
		</div>
	</div>
			<sec:csrfInput />
	</form>
</div>

<script type="text/javascript">
		//option에 append 해줄 변수 // 현재년도/다음년도/현재학기/다음학기/체크된라디오
		let setCurrentRecYr,setNextRecYr,setCurrentSemester,setNextSemester,checkedRgbCdValue ="";
		//option value에 담을 변수
		let month,year,nextYear,currentSemester,nextSemester = ""; 
		let date = new Date();
		let nextYearExist,rgbCdisChanged = false;
		
		$(document).ready(function(){
			year = date.getFullYear(); //년도 recYr
			month = date.getMonth();
		    if (month == '3' || month == '4' || month == '5' || month == '6') currentSemester = 1;
			else if (month == '9' || month == '10' || month == '11' || month == '12') currentSemester = 2;
		    setRecYr();//현재년도가 2학기일경우 현재년도 + 다음년도
		});	
		
		$("#nextSem").on("click",function(){
			if($("#recYr option:selected").val() == $("#recYr option:eq(0)").val()){
				Swal.fire({
					  icon: 'error',
					  title: '년도를 먼저 선택해 주세요',
					})
				return;
			}
			var sem = this.innerHTML
			$("input[name='recSem']").val(sem.substr(0,1));
			var yr = $("select[name=recYr] :selected").val();
			$("#selectedYRSEM").html("&nbsp;"+ yr +"년도 "+ sem + "입니다");
		});
		
		$("#currentSem").on("click",function(){
			if($("#recYr option:selected").val() == $("#recYr option:eq(0)").val()){
				Swal.fire({
					  icon: 'error',
					  title: '년도를 먼저 선택해 주세요',
					})
				return;
			}
			var sem = this.innerHTML
			$("input[name='recSem']").val(sem.substr(0,1));
			var yr = $("select[name=recYr] :selected").val();
			$("#selectedYRSEM").html("&nbsp;"+ yr +"년도 "+ sem + "입니다");
		});
		
		$("#recYr").change(function(){
			if($("input[type='radio'][name='rgbCd']:checked").val() == 'RCD001'){ //휴학일 경우에만 현재학기 선택 가능
				if($("#recYr option:selected").val() == nextYear){
					$("#nextSem").show();
					$("#currentSem").hide();
					return;
				} else {
					$("#currentSem").show();
					$("#nextSem").hide();
					return;
				}
			} 
				return;
		});
		
		function resetYRSEM(){
			if(rgbCdisChanged){
			$("#recYr option:eq(0)").prop("selected",true);
			$("#recPer option:eq(0)").prop("selected",true);
			$("#recSem option:eq(0)").prop("selected",true);
			$("#currentSem").hide();
			$("#nextSem").hide();
		    $("#recRsn").removeAttr('disabled');
		    $("#recPer").removeAttr("disabled");
		    $("#recRsn").attr("required",false);
		    $("#recPer").attr("required",false);
		    $("#selectedYRSEM").html("");
			rgbCdisChanged = false;
			 recPerValidation = false;
		 	  recRsnValidation = false;
			return;
			}
			return;
		}
		
		$("input[type='radio'][name='rgbCd']").change(function() {
			rgbCdisChanged = true;
			resetYRSEM();
			//복학이나 졸업을 선택할 경우 사유를 적지 않아도 된다
			 checkedRgbCdValue =$("input[type='radio'][name='rgbCd']:checked").val();
			switch (checkedRgbCdValue) {
				  case 'RCD001'://휴학 현학기 다음학기 기간 니맘대로 사유o
				  nextYearViewOnlyRCD001();
				  $("#recRsn").attr("required","required");
				  $("#recPer").attr("required","required");
		 		  break;
				  case 'RCD003'://복학 무조건 다음학기 기간x 사유x
				  nextYearViewOnlyRCD001();
				  $("#nextSem").show();
				  $("#recRsn").attr('disabled','disabled');
				  $("#recPer").attr("disabled",'disabled');
				    break;
				  case 'RCD004'://자퇴 무조건 현학기 기간x 사유o
				  nextYearViewOnlyRCD001();
				  $("#currentSem").show();
				  $("#recPer").attr("disabled","disabled");
				  recRsnValidation = true;
				  $("#recRsn").attr("required","required");
				    break;
				  case 'RCD005'://졸업 무조건 다음학기 기간x 사유x
				  nextYearViewOnlyRCD001();
				  $("#nextSem").show();
				  $("#recRsn").attr('disabled',"disabled");
				  $("#recPer").attr("disabled","disabled");
				    break;
				}
		});
	/*recYr select option에 nextYear 값이 있다면 휴학일때는 선택할 수 있지만 
	  휴학이 아닐때는 다음학기(내년도 1학기)만 선택 하여야 한다.
	*/
	function nextYearViewOnlyRCD001(){
		if(nextYearExist){//내년이 존재하나요?(2학기있나요?)
			if($("input[type='radio'][name='rgbCd']:checked").val()=='RCD001'){//휴학이면 리턴
				$("#recYr option:eq(1)").removeAttr("disabled");
				$("#recYr option:eq(2)").removeAttr("disabled");
				return;
			} 
			if($("input[type='radio'][name='rgbCd']:checked").val()=='RCD004') {//자퇴면 현학기만
					$("#recYr option:eq(1)").removeAttr("disabled");
					$("#recYr option:eq(2)").attr("disabled","disabled");
					return;
			} else {
					$("#recYr option:eq(1)").attr("disabled","disabled");
					$("#recYr option:eq(2)").removeAttr("disabled");
					return;
			}
		}
		return;
	}		
	//현재 학기가 2학기일경우 nextYear를 다음년도로 
	function setRecYr(){
		//학기선택버튼 전체 가리기
		$("#currentSem").hide();
		$("#nextSem").hide();
// 		if(!(nextYear - year == 1)){nextYear--; return;}
		if(currentSemester == 2){//현재2학기면
			nextYearExist = true;
			nextYear = year + 1;//다음년도
			nextSemester = 1;//다음학기
			
			$("#currentSem").text(currentSemester+"학기");
			$("#nextSem").text(nextSemester+"학기");
			
			setCurrentRecYr = `<option value='\${year}'>\${year}년도</option>`;
			$("#recYr").append(setCurrentRecYr);
			setNextRecYr = `<option value='\${nextYear}'>\${nextYear}년도</option>`;
			$("#recYr").append(setNextRecYr);
			return;
			}
				
			//현재 2학기가아니면
			nextYearExist = false;
			nextSemester = currentSemester+1;
			setCurrentRecYr = `<option value='\${year}'>\${year}년도</option>`;
			$("#recYr").append(setCurrentRecYr);	
			$("#currentSem").text(currentSemester+"학기");
			$("#nextSem").text(nextSemester+"학기");
			
		}
	
	
	$.fn.clearForm = function () {
		  return this.each(function () {
		    var type = this.type,
		      tag = this.tagName.toLowerCase();
		    if (tag === 'form') {
		      return $(':input', this).clearForm();
		    }
		    if (
// 		      type === 'text' ||
// 		      type === 'password' ||
// 		      type === 'hidden' ||
		      tag === 'textarea'
		    ) {
		      this.value = '';
// 		    } else if (type === 'checkbox' || type === 'radio') {
// 		      this.checkedIndex = 0;
		    } else if (tag === 'select') {
		      this.selectedIndex = 0;
		    }
		  });
		};
	
	function checkFormData(){
		
		if($("#recYr option:selected").val() == $("#recYr option:eq(0)").val()){
			Swal.fire({
				  icon: 'error',
				  title: '년도 선택해 주세요',
				})
			return false;
		}
		
		if($("#recSem").val() == "" || $("#recSem").val() == null){
			Swal.fire({
				  icon: 'error',
				  title: '학기를 선택해주세요',
				})
		    return false;
		} 
		
		var checkPer = $("input[type='radio'][name='rgbCd']:checked").val() == 'RCD001'
			?  $("#recPer option:checked").val() == $("#recPer option:eq(0)").val()
					?  true   :  false 
						:	false ;
		if(checkPer){
		Swal.fire({
		icon: 'error',
		title: '기간을 선택해주세요',
		})
		return false;	
		} 

		return true;
	}
		
	function dataReset(){
		Swal.fire({
			  title: '작성을 취소하시겠습니까?',
			  text: "작성한 내용이 모두 지워집니다",
			  icon: 'warning',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '삭제',
			  cancelButtonText: '취소'
			}).then((result) => {
			  if (result.isConfirmed) {
			    Swal.fire(
			      '삭제완료',
			      '작성 내용 모두 삭제 되었습니다',
			      'success',
			    )
			      $("#selectedYRSEM").html("");
			      $("#form").clearForm();
			  }
			});
			  return;
	}
</script>



