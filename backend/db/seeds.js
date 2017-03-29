'use strict';

var co = require('co');

var database = require('../lib/database');

function onerror(err) {
  console.error(err.stack);
}

co(function *() {
  yield database.sync({force: true});

  yield database.Project.create({ title: 'Test Ranchering', team: 'john' });
  yield database.Project.create({ title: 'Gitviz', team: 'joe, donald' });
  yield database.Project.create({ title: 'Saatiobot', team: 'kostya' });
  yield database.Project.create({ title: 'Pydamsa', team: 'ivan' });
  yield database.Project.create({ title: 'Watson', team: 'emma' });
  yield database.Project.create({ title: '#thankssoftware', team: 'brad' });
  yield database.Project.create({ title: 'Good Enough Auction', team: 'ahmed, li' });
  yield database.Project.create({ title: 'Triviabot', team: 'nastya, alex, tapio' });
   
  console.log("Projects added successfully.");
}).catch(onerror);
