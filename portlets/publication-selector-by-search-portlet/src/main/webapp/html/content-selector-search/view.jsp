<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

<portlet:defineObjects />

<jsp:useBean id="st" class="com.tjaglcs.plugins.ContentSelector"/>

<c:catch var ="catchException">
	<c:set var="pubData" value="${st.fetchPublication(renderRequest) }" />
	<c:set var="selectedVolumes" value="${pubData.getSelectedVolumes() }" />

	<c:set var="isSingleIssue" value="${pubData.getIsSingleIssue() }" />
</c:catch>



<c:choose>
	<c:when test = "${catchException != null}">
		<div class="alert alert-info">No articles found.</div>
		
	</c:when>
	
	<c:otherwise>
		<aui:form cssClass="content-selector-form">
	
		<div id="noUiSlider"  class="noUi--slider-outer-container">
			<!-- TODO get values from bean -->
			<span class="noUi--year-label" id="noUiSliderMin">${pubData.getStartYear() }</span>
			<div class="noUi--slider-inner-container">
				<div id="noUiSliderRange" data-min-year="${pubData.getStartYear() }" data-max-year="${pubData.getEndYear() }"></div>
			</div>
			
			<span class="noUi--year-label" id="noUiSliderMax">${pubData.getStartYear() }</span>
		</div>
			
	    <aui:fieldset cssClass="selector-fieldset">
	
	        <aui:select label="" id="volumeOptions" name="volume" showEmptyOption="false" cssClass="dropdown" helpMessage="Select a volume.">
	
				<aui:option value="selectAVolume">Select a volume</aui:option>
				
				<%-- populated by JSON from Java bean --%>
			    
				
	        </aui:select>
	        
	        <c:if test="${isSingleIssue }">
		        <aui:select label="" id="issueOptions" name="issue" showEmptyOption="false" cssClass="dropdown" helpMessage="Select an issue." disabled="true">
		
					<aui:option value="selectAnIssue">Select an issue</aui:option>
				    <%-- populated by JSON from Java bean --%>
					
		        </aui:select>
	        </c:if>
	
			
			
			<!--<aui:button value=" > " id="btnSubmit" cssClass="btn btn-primary" aria-label="Submit"/>-->
	
	        
	    </aui:fieldset>
	    
	</aui:form>
	
	<liferay-ui:error key="no-volume-found" message="no-volume-found"/>
	<liferay-ui:error key="no-issue-found" message="no-issue-found"/>
	
	
	<c:forEach items="${selectedVolumes}" var = "currentVolume" varStatus="i">
	
	
	
	<div>
		<section class="volume-container">
		<h2 id="volume${currentVolume.getNumber() }">Volume <c:out value="${currentVolume.getNumber() }"/></h2>
		
		
		<p class="year-label"><c:out value="${currentVolume.getYear() }"/> <c:out value="${currentVolume.getEditionType() }"/> Edition</p>
		
		<c:forEach items="${currentVolume.getIssues() }" var = "issue" varStatus="i">
			

				<c:choose>
					<c:when test="${issue.getName() != ''}">
						<c:set var="issueLabel" value="${issue.getName() } Issue"/>
					</c:when>
					<c:otherwise>
						<c:set var="issueLabel" value="Issue ${issue.getNumber() }"/>
					</c:otherwise>
				</c:choose>
		
				
				
				<%-- <c:if test="${issue==pubData.getMostRecentIssue() }">Most Recent!</c:if> --%>
				
						
				
				 
				 <nav class="table-of-contents-container" aria-labelledby="volume${currentVolume.getNumber() }">
				 	<h3><c:out value="${issueLabel }"/></h3>
					 <c:forEach items="${issue.getArticles()}" var = "article" varStatus="i">

					 	<p class="toc-entry">
					 	
					 		<c:choose>
						 		<c:when test="${article.getURL()==null }">
						 			<c:out value="${article.getTitle() }"/>
						 		</c:when>
						 		<c:otherwise>
						 			<a href="${article.getURL() }" target="_blank"><c:out value="${article.getTitle() }"/></a>
						 		</c:otherwise>
					 		</c:choose>
					 	
					 	</p>
					 	<p class="author-names">${article.getAuthors() }</p>
					 </c:forEach>
				 </nav>
				 
			
			
			 
			    	
		</c:forEach>
	</section>
	
	</div>
	
	</c:forEach>
	
	<aui:script use="aui-base, event, node">
	    
	    (function(){
	    	var config = {
	        		'namespace': '<portlet:namespace/>',
	                'jsonData': ${pubData.getJson() },
	                'volumeDropdown':document.getElementById('<portlet:namespace/>' + 'volumeOptions'),
	                'issueDropdown':document.getElementById('<portlet:namespace/>' + 'issueOptions'),
	                'isSingleIssue':${isSingleIssue }
	        } 
	        		
	        		console.log(config.jsonData)
	        		
	        //populate volume menu		
	    	buildSlider();		
	    	
	    	//bind event handlers
       		if(config.isSingleIssue){		
   	        	
   		        config.volumeDropdown.addEventListener('change', function(event){
   		        	getIssues();
   		         });
   		        
   		        config.issueDropdown.addEventListener('change', function(event){
   		        	navigate();
   		         });
   		        
   	        } else if(!config.isSingleIssue){
   	        	config.volumeDropdown.addEventListener('change', function(event){
   	        		navigate();
   		         }); 
   	        	
   	        }
	        
	        function getIssues(){
	        	var volumeDropdown = config.volumeDropdown;
	        	var issueDropdown = config.issueDropdown;
	        	var jsonData = ${pubData.getJson() };
				
	        	if(volumeDropdown.value=="selectAVolume"){
	        		disableMenu(issueDropdown);
	        		issueDropdown.value="selectAnIssue"; 
	        		return false;
	        	}
	        	
	        	issueDropdown.removeAttribute("disabled");
	        	
	        	var yearStr = volumeDropdown.value.split(":")[0];
	        	var yearObj = jsonData.publication.years[yearStr];
	        	
	        	for(var vol in yearObj){
	        		console.log("volume " + yearObj[vol].issues)
	        		for(var issue in yearObj[vol].issues){
	        			console.log(yearObj[vol].issues[issue]);
	        		}
	        		
	        		var issues = yearObj[vol].issues;
	        	}
	        	
	    

	        	//var issues = jsonData.publication.volumes["volume" + volumeDropdown.value].issues;
	        	
	        	populateMenu(issueDropdown, issues, "Issue", undefined,undefined);
	
	        } 
	        
	        
	        function clearMenu(menu){
	        	//console.log("attempting to clear " + menu);
	        	//clear existing options, skipping the first
				while (menu.children.length > 1) {
					menu.removeChild(menu.lastChild);
				}
	        }
	        
	        
	        function populateMenu(menu, items, type, startYear, endYear){
	        	if(!startYear){
	        		startYear=0;
	        	}
	        	
	        	if(!endYear){
	        		endYear=9999;
	        	}
	        	
	        	//if single issue, clear sub (issue) menu
	        	clearMenu(menu);	
	        	
	        	var fragment = document.createDocumentFragment();
	        	var optionArray = [];
	        	
	        	for(var prop in items){
	        		
	        		if(parseInt(prop)<startYear || parseInt(prop)>endYear){
	        			continue;
	        		}
	        		
	        		var option = document.createElement("option");
	        		
	        		
	        		if(type=="Issue" && items[prop].name!=""){
	        			var optionString = items[prop].name + " " + type;
	        		} else{

	        			var volArray = buildVolArray(items[prop]);
	        			var volLable = volArray>1 ? " (volume " : " (volumes "
	        			var volString = volLable + volArray.join(", ") + ")";

	        			var optionString = prop + volString;
	        		}
	        		
	        		option.innerHTML = optionString;
	        		option.setAttribute("value",prop + ":" + volArray.join("-"));
	        		optionArray.push(option);

	            }
	        	
	        	//sort and add to fragment
	        	var sortByValue = function(a, b) {
	        		return parseInt(b.value) - parseInt(a.value);
	            }

	        	optionArray.sort(sortByValue);

	        	for(var i = 0; i<optionArray.length; i++){
	        		fragment.appendChild(optionArray[i]);
	        	}
	        	
	        	menu.appendChild(fragment);
	        } 
	        
	        function buildVolArray(yearJson){
	        
	        	var volArray = [];
	        	
	        	for(var vol in yearJson){
	        		volArray.push(yearJson[vol].number);	
    			}
	        	
	        	//return volArray.join("-");
	        	return volArray;
	        }
	        
	        function navigate(){
	        	var jsonData = ${pubData.getJson() };
	        	var volumeDropdown = config.volumeDropdown;
	        	
	        	if(config.isSingleIssue){		
	        		var issueDropdown = config.issueDropdown;
	        		} else{
	        		var issueDropdown = null;
	        		}
	        	
	        	
	        	//var pubCode = jsonData.publication.pubCode;
	        	var volumeNumber = volumeDropdown.value.split(":")[1];
	        	if(config.isSingleIssue){		
	        		var issueNumber = issueDropdown.value;
	        		} else{
	        			var issueNumber=-1;
	        		}
	        	
	        	
	        	var queryString = getQueryString(volumeNumber,issueNumber);
	        	
	         	if(volumeDropdown.value=="selectAVolume" || (issueDropdown && issueDropdown.value=="selectAnIssue")) {
	             	return false;
	             } else {
	            	var baseUrl = window.location.href.split('#')[0];
	             	var url = baseUrl.split('?')[0] + queryString;
	             	console.log("navigating to " + url);
	             }
	
	             window.location.href = url;
	        }
	        
	        /*config.submitButton.addEventListener('click', function(event){
	        	var jsonData = ${pubData.getJson() };
	        	var volumeDropdown = config.volumeDropdown;
	        	
	        	if(config.isSingleIssue){		
	        		var issueDropdown = config.issueDropdown;
	        		} else{
	        		var issueDropdown = null;
	        		}
	        	
	        	
	        	//var pubCode = jsonData.publication.pubCode;
	        	var volumeNumber = volumeDropdown.value;
	        	if(config.isSingleIssue){		
	        		var issueNumber = issueDropdown.value;
	        		} else{
	        			var issueNumber=-1;
	        		}
	        	
	        	
	        	var queryString = getQueryString(volumeNumber,issueNumber);
	        	
	         	if(volumeDropdown.value=="selectAVolume" || (issueDropdown && issueDropdown.value=="selectAnIssue")) {
	             	return false;
	             } else {
	            	var baseUrl = window.location.href.split('#')[0];
	             	var url = baseUrl.split('?')[0] + queryString;
	             	console.log("navigating to " + url);
	             }
	
	             window.location.href = url;
	         }); */
	        
	        
	        function getQueryString(volumeNumber,issueNumber){
	            
	        	var queryString = "";
	        	queryString+="?vol=" + volumeNumber;
	        	if(issueNumber>0){
	        	queryString+= "&no=" + issueNumber;
	        	}
	        	
	        	return queryString;
	        }
	        
	        
	        function buildSlider() {
	        	var instance = this;
	        	
	        	var slider = document.querySelector('#noUiSliderRange');
	        	var min = parseInt(slider.dataset.minYear);
	        	var max = parseInt(slider.dataset.maxYear);
	        	
	        	var minInput = document.querySelector('#noUiSliderMin');
	        	var maxInput = document.querySelector('#noUiSliderMax');
	        	
	        	//slider can't handle it when there's just one year
	        	if(min==max){
	        		return false;
	        	}
	        	
	        	noUiSlider.create(slider, {
	        	    start: [min, max],
	        	    connect: true,
	        	    padding:0,
	        	    step:1,
	        	    range: {
	        	        'min': min,
	        	        'max': max
	        	    },
	        	    format:{
	        	    	to: function(value){
	        	    		return parseInt(value);
	        	    	},
	        	    	from: function(value){
	        	    		return parseInt(value);
	        	    	},
	        	    }
	        	});
		
	        	slider.noUiSlider.on('update', function( values, handle ) {
	        		minInput.innerHTML = values[0];
	        		maxInput.innerHTML = values[1];
	        		
	        		//re-populate volume selector, clear and disable issue selector
	        		//populateMenu(config.volumeDropdown, config.jsonData.publication.volumes, "Volume", values[0],values[1]);
	        		populateMenu(config.volumeDropdown, config.jsonData.publication.years, "Year", values[0],values[1]);
	        		
	        		if(config.isSingleIssue){
	        			clearMenu(config.issueDropdown);
	        			disableMenu(config.issueDropdown);
	            	}
	        		
	        		
	        	});
	        	
	
	        		
	        }
	        
	        function disableMenu(menu){
	        	menu.setAttribute("disabled", "disabled");
	        }
	        
	    })();
	 	
	    
	
	    
	
	</aui:script>
	</c:otherwise>

</c:choose>





