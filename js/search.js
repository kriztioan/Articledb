// We're using a global variable to store the number of occurrences
var SearchString = "";
var SearchStringLen = 0;
var SearchResults = [ ];
var iSearchResult = 0;
var IgnoreFlag = true;

// helper function, recursively searches in elements and their child nodes
function HighlightAllOccurencesOfStringForElement(element) {
  var SearchStr = IgnoreFlag ? SearchString.toLowerCase() : SearchString;
  if (element) {
    if (element.nodeType == 3) {        // Text node
      while (true) {
        var value = element.nodeValue;  // Search for in text node
        var idx = (IgnoreFlag) ? value.toLowerCase().indexOf(SearchStr) : value.indexOf(SearchStr);
        
        if (idx < 0) break;             // not found, abort
        
        var span = document.createElement("span");
        var text = document.createTextNode(value.substr(idx,SearchStrLen));
        span.appendChild(text);
        span.setAttribute("class","Highlight");
        span.style.backgroundColor="orange";
        span.style.color="black";
        text = document.createTextNode(value.substr(idx+SearchStrLen));
        element.deleteData(idx, value.length - idx);
        var next = element.nextSibling;
        element.parentNode.insertBefore(span, next);
        SearchResults.push(span);
        element.parentNode.insertBefore(text, next);
        element = text;
      }
    } else if (element.nodeType == 1) { // Element node
      if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
        for (var i=element.childNodes.length-1; i>=0; i--) {
          HighlightAllOccurencesOfStringForElement(element.childNodes[i]);
        }
      }
    }
  }
  if (SearchResults.length > 0) {
    SearchResults.reverse();//sort(function(a,b){return b.getBoundingClientRect()-a.getBoundingClientRect()});
    SearchResults[0].scrollIntoView();
  }
}

// the main entry point to start the search
function HighlightAllOccurencesOfString(keyword, direction, ignore, wrap) {
  if(keyword == SearchString && IgnoreFlag == ignore) {
    if (SearchResults.length > 0) {
      if (direction) {
        if (iSearchResult + 1 >= SearchResults.length) {
        if (wrap) iSearchResult = 0;
        } else ++iSearchResult;
      } else {
        if (iSearchResult - 1 <= 0) {
          if (wrap) iSearchResult = SearchResults.length-1;
        } else --iSearchResult;
      }
      SearchResults[iSearchResult].scrollIntoView();
    }
    return;
  }
  IgnoreFlag = ignore;
  SearchString = keyword;
  SearchStrLen = SearchString.length;
  RemoveAllHighlights();
  HighlightAllOccurencesOfStringForElement(document.body);
}

// helper function, recursively removes the highlights in elements and their childs
function RemoveAllHighlightsForElement(element) {
  if (element) {
    if (element.nodeType == 1) {
      if (element.getAttribute("class") == "Highlight") {
        var text = element.removeChild(element.firstChild);
        element.parentNode.insertBefore(text,element);
        element.parentNode.removeChild(element);
        return true;
      } else {
        var normalize = false;
        for (var i=element.childNodes.length-1; i>=0; i--) {
          if (RemoveAllHighlightsForElement(element.childNodes[i])) {
            normalize = true;
          }
        }
        if (normalize) {
          element.normalize();
        }
      }
    }
  }
  return false;
}

// the main entry point to remove the highlights
function RemoveAllHighlights() {
  iSearchResult = 0;
  SearchResults = [];
  RemoveAllHighlightsForElement(document.body);
}
