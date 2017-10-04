// This is free and unencumbered software released into the public domain.
// See LICENSE

'use strict';

const fs = require('fs');
const path = require('path');
const {spawnSync} = require('child_process');

const files = Object.freeze({
	cookieJar: './cookie-jar',
	authScript: './scripts/auth.sh',
	addGroupTypeScript: './scripts/add_group_type.sh',
	addProblemScript: './scripts/add_problem.sh',
	listScript: './scripts/list_group_type.sh',
});


// authentication
fs.existsSync(files.cookieJar) || spawnSync(files.authScript, [], {stdio: [0, 1, 2]});


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

const UTF8 = Object.freeze({encoding: 'utf-8'});
const [groupIdMap, typeIdMap] = ['group', 'type']
	.map(x => spawnSync(files.listScript, [x], UTF8))
	.map(x => idParser(x.output[1]));

function paramParser(output) {
	const result = new Map;

	output.split('\n')
		.map(x => x.split(/:/))
		.forEach(([param, value]) => result.set(param, value));

	result.delete();
	return result;
}

function* getAllFilesRecursive(dir, file = '') {
	const fullName = path.join(dir, file);

	if(fs.statSync(fullName).isDirectory()) {
		for(const x of fs.readdirSync(fullName)) {
			yield* getAllFilesRecursive(fullName, x);
		}
	} else {
		yield { dir, file };
	}
}

const categoryMap = require('./categoryMap');

const base = '../bgcoder/downloaded/contests';
[...getAllFilesRecursive(base)]
	.filter(x => x.file === 'problem.params')
	.forEach((x, index, all) => {
		console.log(`Uploading ${index + 1}/${all.length}`);

		const paramsFile = path.join(x.dir, x.file);
		const resourcesFile = path.join(x.dir, 'resources.list');

		const contestId = paramParser(fs.readFileSync(path.join(x.dir, '..', 'contest.params'), UTF8)).get('Id'); // Ugly
		const problemParams = paramParser(fs.readFileSync(paramsFile, UTF8));
		const problemResources = paramParser(fs.readFileSync(resourcesFile, UTF8));

//		const categories = x.dir
//			.substring(base.length + 1) // remove base
//			.split(/\//g)
//			.map(categoryMap.map)
//			.join('');

		// do upload here
		const problemName = problemParams.get('Name');

		spawnSync(files.addProblemScript, [
				`bgcoder${contestId}p${problemParams.get('Id')}`,   // problem id
				problemParams.get('Name'),                          // problem name
				'description',                                      // description
				problemParams.get('MaximumPoints'),                 // points
				(problemParams.get('TimeLimit') / 1000) + '',       // time limit ms
				(problemParams.get('MemoryLimit') / 1024 | 0) + '', // memory limit KB
				// Group?
				// Types...?
			]);
	});


// for DEBUGging
// console.log(categoryMap.failed);
