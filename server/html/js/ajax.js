window.server = {};
server.get = function(path,handler) {
    $.ajax({
      type: 'GET',
      url: path,
      contentType: "application/json",
      processData: false,
      success: handler,
      dataType: "text"
    });
}
server.post = function(path,d,handler) {
    $.ajax({
      type: 'POST',
      url: path,
      contentType: "application/json",
      processData: false,
      data: d,
      success: handler,
      dataType: "text"
    });
}
