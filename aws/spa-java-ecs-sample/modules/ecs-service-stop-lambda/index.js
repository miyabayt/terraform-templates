'use strict';

var AWS = require('aws-sdk');

module.exports.handler = function(event, context) {
  var ecs = new AWS.ECS();
  ecs.updateService({ cluster: event['cluster_name'], service: event['service_name'], desiredCount: 0 }, function(err, data) {
    if (err) console.log(err, err.stack);
    else console.log(data);
  });
};
