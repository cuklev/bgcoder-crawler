// This is free and unencumbered software released into the public domain.
// See LICENSE

'use strict';

const fs = require('fs');
const path = require('path');
const {spawnSync} = require('child_process');

function absolutePath(...args) {
	return path.join(__dirname, ...args);
}

const files = Object.freeze({
	authScript: absolutePath('scripts', 'auth.sh'),
	addGroupTypeScript: absolutePath('scripts', 'add_group_type.sh'),
	addProblemScript: absolutePath('scripts', 'add_problem.sh'),
	listScript: absolutePath('scripts', 'list_group_type.sh'),
});

const childOptions = Object.freeze({
	env: {
		COOKIE_JAR: process.env.COOKIE_JAR || absolutePath('cookie-jar'),
		DMOJ_URL: process.env.DMOJ_URL || 'http://localhost:8081',
	},
	encoding: 'utf-8',
});


// authentication
console.log('Authenticating...');
spawnSync(files.authScript, [], {stdio: [0, 1, 2], env: childOptions.env});


// add groups and types
// here

function idParser(output) {
	const result = new Map;

	output.split('\n')
		.map(x => x.split(/:/))
		.forEach(([id, name]) => result.set(name, id));

	result.delete();
	return result;
}

const [groupIdMap, typeIdMap] = ['group', 'type']
	.map(x => spawnSync(files.listScript, [x], childOptions))
	.map(x => idParser(x.output[1]));

function paramParser(output) {
	const result = new Map;

	output.split('\n')
		.map(x => x.split(/:/))
		.forEach(([param, value]) => result.set(param, value));

	result.delete();
	return result;
}

function* findAllProblems(dir, file = '') {
	const fullName = path.join(dir, file);

	if(fs.statSync(fullName).isDirectory()) {
		for(const x of fs.readdirSync(fullName)) {
			yield* findAllProblems(fullName, x);
		}
	} else if(file === 'problem.params') {
		yield { dir, file };
	}
}

const categoryMap = require('./categoryMap');

const base = '../bgcoder/downloaded/contests';
[...findAllProblems(base)]
	.forEach((x, index, all) => {
		console.log(`Uploading ${index + 1}/${all.length}`);

		const paramsFile = path.join(x.dir, x.file);
		const resourcesDir = path.join(x.dir, 'resources');

		const contestId = paramParser(fs.readFileSync(path.join(x.dir, '..', 'contest.params'), UTF8)).get('Id'); // Ugly
		const problemParams = paramParser(fs.readFileSync(paramsFile, UTF8));

//		const categories = x.dir
//			.substring(base.length + 1) // remove base
//			.split(/\//g)
//			.map(categoryMap.map)
//			.join('');

		// TODO: Find the best resource for description here

		// do upload here

		spawnSync(files.addProblemScript, [
				`bgcoder${contestId}p${problemParams.get('Id')}`,   // problem id
				problemParams.get('Name'),                          // problem name
				'description',                                      // description
				problemParams.get('MaximumPoints'),                 // points
				(problemParams.get('TimeLimit') / 1000) + '',       // time limit ms
				(problemParams.get('MemoryLimit') / 1024 | 0) + '', // memory limit KB
				'1',                                                // group id
				'1 2',                                              // type ids
			], childOptions);
	});


// for DEBUGging
// console.log(categoryMap.failed);
