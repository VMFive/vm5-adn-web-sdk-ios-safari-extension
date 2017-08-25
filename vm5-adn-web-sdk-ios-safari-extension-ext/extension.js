var MMExtensionClass = function() {};

MMExtensionClass.prototype = {
    run: function(arguments) {
      var result = [];
      var divs = document.getElementsByTagName("div");
      for (var i = 0; i < divs.length; i++) {
        var divName = "";
        if (divs[i].getAttribute("id")) {
          divName += "#" + divs[i].id;
        }
        else if (divs[i].getAttribute("class")) {
          divName += "." + divs[i].className.replace(new RegExp(" ", "g"), ".");
        }

        if (divName.length) {
          result.push(divName);
        }
      }
      arguments.completionFunction({ "url": window.location.href, "divs": result });
    },

    finalize: function(arguments) {
      var a = arguments["adType"];
      var s = arguments["selector"];

      if (a.length && s.length) {
        var meta = document.createElement('meta');
        meta.httpEquiv = "Content-Security-Policy";
        meta.content = `default-src 'unsafe-inline' * data:;`;
        document.head.appendChild(meta);

        function insertAd(adType, selector) {
          console.warn(adType, selector);

          var newNode = document.createElement('div');
          newNode.innerHTML = `
            <div id="vm5ad-js-sdk" data-mode="fast"></div>
            <vmfive-ad-unit placement-id="580db15a4a801a2674a56f83" ad-type='${adType}'></vmfive-ad-unit>
          `;

          var selectorNode = document.querySelector(selector);
          selectorNode.parentNode.insertBefore(newNode, selectorNode.nextSibling);

          [
            "https://vawpro.vm5apis.com/man.js",
            "https://man.vm5apis.com/dist/adn-web-sdk.js",
            "https://raw.githubusercontent.com/VMFive/vm5-adn-web-sdk-integration-previewer/master/chrome-extension/init-ad.js",
          ].forEach(function(src) {
            var script = document.createElement('script');
            script.src = src;
            script.async = false;
            script.onload = () => {
              console.warn(src)
            }
            document.head.appendChild(script);
          });
        }
        insertAd(a, s);
      }
    }
};

var ExtensionPreprocessingJS = new MMExtensionClass;
