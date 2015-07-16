
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.job("mtaQuery", function(request, status) {
  console.log("cloud job started");
  Parse.Cloud.httpRequest({
    url: "http://datamine.mta.info/mta_esi.php?key=8365fd8b2dddf1d6145d3b9f9cbd0fdb&feed_id=2",
    followRedirects: true
  }).then(function(httpResponse) {
    // success
    console.log(httpResponse.headers);
    console.log("http request finished");
    var file = new Parse.File("LTrainData.proto", {base64: httpResponse.buffer.toString('base64', 0, httpResponse.buffer.length)});
    console.log("file created");

    file.save().then(function() {
      console.log("successful save!");
    }, function(error) {
      throw "Error saving proto file to parse";
    });

    var TrainData = Parse.Object.extend("TrainData");
    var trainData = new TrainData();
    trainData.set("LData", file);
    trainData.save(null, {
      success: function(trainData) {
        status.success();
      }, 
      error: function(trainData, error) {
        throw "Failed to create new object";
      }
    });
    

    
  },function(httpResponse) {
    status.error();
    console.error('Request failed with response code ' + httpResponse.status);
  });

});
