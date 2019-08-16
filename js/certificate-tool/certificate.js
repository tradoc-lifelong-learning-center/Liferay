//TODO
//check for text that's too long for cert and scale
//show cert only after click
//--done, but should this be a fade in or modal?
//printing/downloading


(function(){
  String.prototype.replaceAll = function(target, replacement) {
    return this.split(target).join(replacement);
  };

  window.onload = function(){
    //IF there's a name param, generate certificate
    var params = getParamsObj();
    if(params.name){
      createCertificate();
      bindClickHandler();
    } else{
      getElement("generateCertForm").style.display = "block";

    }

    //getElement("loading-animation").style.display = "none";
    getElement("loading-animation").remove();

  };

  function bindClickHandler(){
    var printButton = getElement("printCertButton");
    printButton.onclick = print;
  }

  function print(){
    window.print();
  }

  function createCertificate(){
    //get and validate name, certificate SVG
    var container = getElement("certificate-container");
    var svg = getElement("certificate");
    var params = getParamsObj();
    var nameInput = params.name;
    var nameField = getElement("name-output");
    var printForm = getElement("printCertForm");
    //var dateField = getElement("date-output");
    if(!container||!svg||!nameInput||!nameField||!printForm){return false}

    //show cert
    container.style.display = "flex";
    container.style.opacity = "100";
    printForm.style.display = "block";

    //get date
    var date = getFormattedDate();

    //set name
    setCertElement(nameField, nameInput + " as of " + date, svg);

    //set date
    //setCertElement(dateField, date, svg);


  }

  /*
  function fadeIn(element){
    element.style.display = "block";
    element.style.opacity = 100;
  }
  */

  function getFormattedDate(){
    var rawDate = new Date();

    var year = rawDate.getFullYear();
    var month = getMonthName(rawDate.getMonth());
    var day = rawDate.getDate();

    return  day + " " + month + " " + year;

  }

  function getMonthName(num){
    var monthNames = {
      "0":"January",
      "1":"February",
      "2":"March",
      "3":"April",
      "4":"May",
      "5":"June",
      "6":"July",
      "7":"August",
      "8":"September",
      "9":"October",
      "10":"November",
      "11":"December",
    }

    return monthNames[num];
  }


  function getElement(id){
    var output = document.getElementById(id);

    if(!output){
        console.log("Can't find output the id " + id)
        return false;
      } else{
        //console.log("output: " + output)
        return output;
      }
  }

/*function getInput(id){
  //get input (return false if empty)
    var input = document.getElementById(id).value;

    if(!input || input==""){
      console.log("Input is empty: " + id);
      return false;
    } else {
      return input;
    }
}*/

function setCertElement(element, content, svg){
    element.innerHTML = content;
    centerSvgElement(element, svg);
}

function centerSvgElement(element, parentSVG){
    var svgDimensions = parentSVG.getAttribute("viewBox").split(" ");
    var svgWidth = svgDimensions[2];
    var svgClientWidth = parentSVG.getBoundingClientRect().width;
    var textWidth = element.getBoundingClientRect().width;

    //ratio to adjust X when SVG is scaled down below actual SVG dimensions
    var ratio = svgWidth / svgClientWidth;

    var textXNew = (svgWidth - (textWidth * ratio)) / 2;

    element.setAttribute("x", textXNew);
}


function toObject(arr, separator) {
  var rv = {};
  for (var i = 0; i < arr.length; ++i)
    if (arr[i] !== undefined) {
      //split param key/value into object key/value, and replace + with space
      var rvKey = arr[i].split(separator)[0];

      try{
        var rvValue = decodeURIComponent(arr[i].split(separator)[1].replaceAll("\+"," "));

      } catch(e){
        var rvValue = "ERROR";
      }

      rv[rvKey] = rvValue;
    }
    return rv;
    }

function getParamsObj(){
  var paramsArr = window.location.search.replace("?","").split("&");

  return toObject(paramsArr, "=");

}

})();
