var robot = require("robotjs");

var screenSize = robot.getScreenSize();
function center_cursor() {
  var sc = robot.getScreenSize();
  robot.moveMouse(sc.width/2, sc.height/2);
}

function handle_mouse(req) {
  var arrReq = req.split("_")
  if (arrReq.length > 1) {
    switch (arrReq[0]) {
      case "/move":
      if (arrReq.length == 3) {
        // points in screen percentage
        robot.moveMouse(parseFloat(screenSize.width) * parseFloat(arrReq[1]) / 100, parseFloat(screenSize.height) * parseFloat(arrReq[2]) / 100);
      }
      break;
      case "/movexy":
      if (arrReq.length == 3) {
        var mouse = robot.getMousePos();
        robot.moveMouse(parseFloat(mouse.x) + parseFloat(arrReq[1]), parseFloat(mouse.y) + parseFloat(arrReq[2]));
      }
      break;
    }
  }
}

require('http').createServer(function(req, res) {
        res.writeHead(200, {'content-type':'text/plain'});
        if (req.url == "/favicon.ico") {
          res.end(response+"\n");
          return;
        }
        switch(req.url) {
          case "/left": robot.mouseClick(); break;
          case "/right": robot.mouseClick("right"); break;
          case "/center_cursor": center_cursor(); break;
          default: handle_mouse(req.url); break;
        }
        res.end("\n");
}).listen(3128);
