// This is free and unencumbered software released into the public domain.
// See LICENSE

'use strict';

const fs = require('fs');
const path = require('path')

const {spawnSync} = require('child_process');

function absolutePath(...args) {
	return path.join(__dirname, ...args);
}

const stageFiles = Object.freeze({
	cookieJar: absolutePath('downloaded', 'cookie-jar'),
	contestsJson: absolutePath('downloaded', 'kendo-contests.json'),
	problemsInContestDir: absolutePath('downloaded', 'problems-in-contest'),
	contestsDir: absolutePath('downloaded', 'contests'),
});

const scriptFiles = Object.freeze({
	auth: absolutePath('scripts', 'auth.sh'),
	getSubcategories: absolutePath('scripts', 'get_subcategories.sh'),
	getJsonContests: absolutePath('scripts', 'get_json_contests.sh'),
	getJsonProblems: absolutePath('scripts', 'get_json_problems.sh'),
	getJsonResources: absolutePath('scripts', 'get_json_resources.sh'),
	downloadTests: absolutePath('scripts', 'download_tests.sh'),
});

const childOptions = Object.freeze({
	env: {
		COOKIE_JAR: process.env.COOKIE_JAR || stageFiles.cookieJar,
		OJS_URL: process.env.OJS_URL || 'http://bgcoder.com',
	}
});

const runStage = (() => {
	const options = {
		stdio: [0, 1, 2],
		env: childOptions.env,
	};
	return (target, [cmd, ...args]) => fs.existsSync(target) || spawnSync(cmd, args, options);
})();

runStage(stageFiles.cookieJar, [scriptFiles.auth]);

const categoryPath = new Map;
(function sub(path, id) {
	console.log(`Category ${id || '(none)'} (${path})`);
	const args = [];
	if(typeof id === 'number') {
		args.push(id.toString());
		categoryPath.set(id, path);
	}
	JSON.parse(spawnSync(scriptFiles.getSubcategories, args, childOptions).stdout)
		.forEach(cat => sub(`${path}/${cat.Name.replace(/\//g, '_')}`, cat.id));
})('.');

runStage(stageFiles.contestsJson, [scriptFiles.getJsonContests, stageFiles.contestsJson]);

const contestsKendo = JSON.parse(fs.readFileSync(stageFiles.contestsJson, 'utf-8')).Data;
const contestsCount = contestsKendo.length;

for(const i in contestsKendo) {
	const contest = contestsKendo[i];
	const id = contest.Id;

	if(id === 322 || id === 168 || id === 167 || id === 166) {
		// Empty contests
		// HARDcoded skip :D
		continue;
	}

	contest.Name = contest.Name.replace(/\//g, '_');
	const name = contest.Name;
	const contestDir = `${stageFiles.contestsDir}/${categoryPath.get(contest.CategoryId)}/${name}`;
	const filename = `${stageFiles.problemsInContestDir}/${id}.json`;

	console.log(`Contest ${+i + 1}/${contestsCount} - ${id} (${name})`);
	runStage(filename, [scriptFiles.getJsonProblems, id, filename]);
	const problemsKendo = JSON.parse(fs.readFileSync(filename, 'utf-8'));
	for(const problem of problemsKendo) {
		const id = problem.Id;
		problem.Name = problem.Name.replace(/\//g, '_');
		const name = problem.Name;
		const problemDir = `${contestDir}/${name}`;
		const tests = `${problemDir}/tests.zip`;

		console.log(`- ${id} (${name})`);
		runStage(tests, [scriptFiles.downloadTests, id, tests]);

		const resourcesList = `${problemDir}/resources.list`;
		if(!fs.existsSync(resourcesList)) {
			fs.writeFileSync(
				resourcesList,
				JSON.parse(spawnSync(scriptFiles.getJsonResources, [id.toString()], childOptions).stdout)
					.Data
					.map(({Id, Link, Name}) => `${Name}:` + (Link ? Link : `${childOptions.env.OJS_URL}/Administration/Resources/Download/${Id}`))
					.concat('')
					.join('\n'));
		}

		const problemParams = `${problemDir}/problem.params`;
		if(!fs.existsSync(problemParams)) {
			fs.writeFileSync(
				problemParams,
				Object.entries(problem)
					.map(([k, v]) => `${k}:${v}`)
					.concat('')
					.join('\n'));
		}
	}

	const contestParams = `${contestDir}/contest.params`;
	if(!fs.existsSync(contestParams)) {
		contest.SelectedSubmissionTypes = contest.SelectedSubmissionTypes
			.map(x => x.Name)
			.join(',');
		fs.writeFileSync(
			contestParams,
			Object.entries(contest)
				.map(([k, v]) => `${k}:${v}`)
				.concat('')
				.join('\n'));
	}
}
