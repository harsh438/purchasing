export function getScript(url, success) {
  var head = document.getElementsByTagName("head")[0]
  var done = false;
  var script = document.createElement("script");
  script.src = url;
  // Attach handlers for all browsers
  script.onload = script.onreadystatechange = function(){
    if (!done && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") ) {
      done = true;
      if (typeof success === 'function') success();
    }
  };
  head.appendChild(script);
}
