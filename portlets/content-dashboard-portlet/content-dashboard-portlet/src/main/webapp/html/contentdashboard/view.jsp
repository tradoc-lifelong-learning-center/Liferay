<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

<portlet:defineObjects />

<%
String portletResource = ParamUtil.getString(request, "portletResource");
%>

<jsp:useBean id="entries" class="java.lang.Object" scope="request"/>

<c:set var="articles" value="${entries.getArticles() }" />

<table class="table table-striped">
	<thead class="thead-dark">
		<tr>
			<th scope="col">Title</th>
			<th scope="col">ID</th>
			<th scope="col">Type</th>
			<th scope="col">Create Date</th>
			<th scope="col">Modified Date</th>
			<th scope="col">URL</th>
		</tr>
	</thead>
	<tbody>
		<% int total = 0; %>
		<c:forEach items="${articles }" var = "article" varStatus="i">
	
			<tr>
				<td><c:out value="${article.getTitle() }"/></td>
				<td><c:out value="${article.getArticleId() }"/></td>
				<td><c:out value="${article.getType() }"/></td>
				<td><c:out value="${article.getCreateDate() }"/></td>
				<td><c:out value="${article.getModifiedDate() }"/></td>
				<% total += 1; %>
			</tr>
		</c:forEach> 
		<tr>
			<th><c:out value="Total"/></th>
			<td><% out.println(total); %></td>
		</tr>
	
	</tbody>

</table>
