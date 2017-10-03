// This is free and unencumbered software released into the public domain.
// See LICENSE

'use strict';

const fs = require('fs');
const {spawnSync} = require('child_process');

const files = Object.freeze({
	cookieJar: './cookie-jar',
	authScript: './scripts/auth.sh',
	addGroupTypeScript: './scripts/add_group_type.sh',
	addProblemScript: './scripts/add_problem.sh',
	listScript: './scripts/list_group_type.sh',
});


// authentication
fs.existsSync(files.cookieJar) || spawnSync(files.authScript, files.cookieJar, {stdio: [0, 1, 2]});


// add groups and types
// here

function parseIDs(output) {
	const result = new Map;

	output.split('\n')
		.map(x => x.split(/:/))
		.forEach(([id, name]) => result.set(name, id));

	result.delete();
	return result;
}

const [groupIdMap, typeIdMap] = ['group', 'type']
	.map(x => spawnSync(files.listScript, [files.cookieJar, x], {encoding: 'utf-8'}))
	.map(x => parseIDs(x.output[1]));
