<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<link rel="stylesheet" href="/resources/css/qnaBoard.css">
<style>
    .detailTitle {
        color: inherit;
    }

    .detailTitle:hover {
        color: inherit;
        cursor: pointer;
        font-weight: bold;
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

    #qnaMark {
        width: 30px;
        margin-left: 10px;
        margin-bottom: 10px;
    }
</style>
<script>
    function detail(idx) {
        $('#frm_' + idx).submit();
    }

    $(function () {

        $('#ansWait').click(function () {
            var checked = $('#ansWait').is(':checked');
            var code = '';
            if (checked) {
                $('.flag_true').attr('style', "display:none;");  //숨기기
            } else {
                $('.flag_true').attr('style', "display:show;");  //보이기
            }

        })
    })

</script>

<div class="card">
    <div id="qnaBoard" class="card-body">
        <h3><i class="mdi mdi-comment-question-outline"></i>&nbsp;문의게시판</h3>
        <br>
        <form name="frm" id="frm" action="/qna/main" method="get">
            <div id="boardFilter" class="searchNtc">
                <select name="cond" aria-controls="dataTable" class="custom-select">
                    <option value="title" <c:if test="${map.cond=='title'}">selected</c:if>>글제목</option>
                    <option value="artContent" <c:if test="${map.cond=='content'}">selected</c:if>>글내용</option>
                </select>
                <label id="searchKey">
                    <input type="search" name="keyword"
                           placeholder="검색어를 입력하세요"
                           value="${map.keyword}" class="form-control dropdown-toggle"/>
                </label>
                <label>
                    <button id="searchBtn" type="submit" class="btn btn-secondary">검색</button>
                </label>
            </div>
        </form>
        <br>
        <%--        <c:if test="${memSession.managerVO.mgrCd ==null }">--%>
        <br>
        <button type="button" class="btn btn-primary" id="questionInsert" onClick="location.href='/qna/qnaWrite'">+
            질문하기
        </button>
        <%--        </c:if>--%>
        <c:if test="${memSession.managerVO.mgrCd !=null }">
            <div id="ansWaitRound"><input type="checkbox" id="ansWait"/><label>&nbsp;미답변</label></div>
        </c:if>
        <br>
        <table class="table mb-0">
            <thead class="table-light">
            <tr style="border-top: 2px solid #112a63">
                <th>No</th>
                <th>제목</th>
                <th>답변여부</th>
                <th>조회수</th>
                <th>공개여부</th>
            </tr>
            </thead>
            <tbody>
            <%--            <c:if test="${memSession.managerVO.mgrCd == null}">--%>
            <c:forEach var="list" items="${showList}" varStatus="stat">
                <%--                    <c:set var="qnarCon" value="${vo.qnaReplyVO.qnarCon }"/>--%>
                <%--                    <form action="/qna/qnaDetail" id="frm_${ stat.index }" method="post">--%>
                <input type="hidden" name="qnaCd" value="${vo.qnaCd}">
                <input type="hidden" name="memCd" value="${vo.memCd}">
                <tr id="${stat.index}" style="background : #fcfdff;">
                    <td>${vo.rnum}</td>
                    <td>
                        <c:set var="qnaYn" value="${list.qnaAccess}"/>
                        <c:if test="${list.qnaAccess == 0 }">
                            <c:set var="memCd" value="${sessionScope.memSession.memCd }"/>
                            <c:if test="${memCd eq vo.memCd}">
                                <a id="detailBtn" onclick="detail(${ stat.index })"
                                   class="detailTitle">${list.qnaTitle}</a>
                            </c:if>
                            <c:if test="${memCd ne vo.memCd}">
                                ${list.qnaTitle }
                            </c:if>
                        </c:if>
                        <c:if test="${list.qnaAccess == 1 }">
                            <a id="detailBtn" onclick="detail(${ stat.index })"
                               class="detailTitle">${list.qnaTitle}</a>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${qnarCon eq null}">
                            <span style="color:#777">답변대기</span>
                        </c:if>
                        <c:if test="${qnarCon ne null}">
                            <span style="color:#001353; font-weight:bold;">답변완료</span>
                        </c:if>
                    </td>
                    <td>${list.hit}</td>
                    <td>
                        <c:set var="qnaYn" value="${list.qnaAccess}"/>
                        <c:if test="${list.qnaAccess == 0 }">
                            <img alt="비공개" src="/resources/images/free-icon-lock-4735421.png" id="lockImg">
                        </c:if>
                    </td>
                </tr>
                </form>
            </c:forEach>
            <%--            </c:if>--%>
            <c:if test="${memSession.managerVO.mgrCd != null}">
                <c:forEach var="vo" items="${list.content}" varStatus="stat">
                    <c:set var="qnarCon" value="${vo.qnaReplyVO.qnarCon }"/>

                    <form action="/qna/qnaDetail" id="frm_${ stat.index }" method="post">
                        <input type="hidden" name="qnaCd" value="${vo.qnaCd}">
                        <input type="hidden" name="memCd" value="${vo.memCd}">
                        <tr id="${stat.index}" class="flag_${qnarCon ne null}">
                            <td>${vo.rnum}</td>
                            <td style="text-align:left;">
                                <a id="detailBtn" onclick="detail(${ stat.index })" class="detailTitle">${vo.qnaTtl}</a>
                            </td>
                            <td>

                                <c:if test="${qnarCon eq null }">
                                    <span style="color:#777">답변대기</span>
                                </c:if>
                                <c:if test="${qnarCon ne null }">
                                    <span style="color:#001353; font-weight:bold;">답변완료</span>
                                </c:if>
                            </td>
                            <td>${vo.qnaHit}</td>
                            <td>
                                <!-- 관리자는 무조건 공개 -->
                            </td>
                        </tr>
                    </form>
                </c:forEach>
            </c:if>
            </tbody>
        </table>
        <div id="pageBarBtn" style="text-align:center;">
            <button type="button" class="btn btn-light"
                    <c:if test='${ list.startPage lt 6 }'>disabled</c:if>
                    onclick="location.href='/main/qna?show=${ map.show }&cond=${ map.cond }&keyword=${ map.keyword }&currentPage=${ list.startPage - 5 }'">
                <i class="uil-angle-double-left"></i></button>
            <button type="button" class="btn btn-light"
                    <c:if test='${ list.startPage == list.currentPage }'>disabled</c:if>
                    onclick="location.href='/main/qna?show=${ map.show }&cond=${ map.cond }&keyword=${ map.keyword }&currentPage=${ list.currentPage - 1 }'">
                <i class="uil uil-angle-left"></i></button>
            <c:forEach var="pNo" begin="${ list.startPage }" end="${ list.endPage }">
                <c:if test="${ pNo == 0 }"><c:set var="pNo" value="1"></c:set></c:if>
                <button type="button"
                        class="btn btn-<c:if test="${ list.currentPage != pNo }">light</c:if><c:if test="${ list.currentPage == pNo }">primary</c:if>"
                        onclick="location.href='/main/qna?show=${ map.show }&cond=${ map.cond }&keyword=${ map.keyword }&currentPage=${ pNo }'">
                        ${ pNo }
                </button>
            </c:forEach>
            <button type="button" class="btn btn-light"
                    <c:if test='${ list.endPage == list.currentPage }'>disabled</c:if>
                    onclick="location.href='/main/qna?show=${ map.show }&cond=${ map.cond }&keyword=${ map.keyword }&currentPage=${ list.currentPage + 1 }'">
                <i class="uil uil-angle-right"></i></button>
            <button type="button" class="btn btn-light"
                    <c:if test="${ list.endPage ge list.totalPages }">disabled</c:if>
                    onclick="location.href='show=${ map.show }&cond=${ map.cond }&keyword=${ map.keyword }&currentPage=${ list.startPage + 5 }'">
                <i class="uil-angle-double-right"></i></button>
        </div>
    </div>
</div>
