'use strict';

var AWS = require('aws-sdk');

module.exports.handler = function(event, context) {
    var rds = new AWS.RDS();
    var today = new Date();
    var params = {
        DBClusterIdentifier: event['db_cluster_identifier']
    };
    rds.startDBCluster(params, function(err, data) {
        if (err) console.log(err, err.stack);
        else console.log(data);
    });
};
