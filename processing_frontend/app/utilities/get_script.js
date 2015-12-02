export function getScript(url, success) {
  const head = document.getElementsByTagName("head")[0];
  const script = document.createElement("script");
  let done = false;
  
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
