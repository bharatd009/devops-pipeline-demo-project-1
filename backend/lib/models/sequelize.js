'use strict';

var Sequelize = require('sequelize');
var config = require('../config');

var sequelize = new Sequelize(config.DATABASE_URL, {
  logging: false
});

module.exports = sequelize;
