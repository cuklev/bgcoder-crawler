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
	categories: absolutePath('downloaded', 'categories'),
	contestsJson: absolutePath('downloaded', 'kendo-contests.json'),
	problemsInContestDir: absolutePath('downloaded', 'problems-in-contest'),
	contestsDir: absolutePath('downloaded', 'contests'),
});

const scriptFiles = Object.freeze({
	auth: absolutePath('scripts', 'auth.sh'),
	getSubcategories: absolutePath('scripts', 'get_subcategories.sh'),
	getHiddenCategories: absolutePath('scripts', 'get_hidden_categories.sh'),
	getJsonContests: absolutePath('scripts', 'get_json_contests.sh'),
	getJsonProblems: absolutePath('scripts', 'get_json_problems.sh'),
	getJsonResources: absolutePath('scripts', 'get_json_resources.sh'),
	downloadTests: absolutePath('scripts', 'download_tests.sh'),
	downloadResource: absolutePath('scripts', 'download_resource.sh'),
});

const childOptions = Object.freeze({
	env: {
		COOKIE_JAR: process.env.COOKIE_JAR || absolutePath('downloaded', 'cookie-jar'),
		OJS_URL: process.env.OJS_URL || 'http://bgcoder.com',
	}
});

console.log('Authenticating...');
// script prompts for credentials
spawnSync(scriptFiles.auth, [], {stdio: 'inherit', env: childOptions.env});

const categoryPath = new Map;
if(!fs.existsSync(stageFiles.categories)) {
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

	// There is a hidden category
	JSON.parse(spawnSync(scriptFiles.getHiddenCategories, [], childOptions).stdout)
		.Data
		.forEach(({Id, Name}) => {
			console.log(`Category ${Id} (${Name})`);
			categoryPath.set(Id, Name)
		});

	// Save categories
	fs.writeFileSync(stageFiles.categories, [...categoryPath.entries()]
			.map(([id, path]) => `${id}:${path}`)
			.join('\n'));
} else {
	console.log('Loading saved categories...');

	fs.readFileSync(stageFiles.categories, 'utf-8')
		.split('\n')
		.map(x => x.split(/:/))
		.forEach(([id, path]) => id && categoryPath.set(+id, path));
}

console.log('Downloading contests JSON...');
fs.existsSync(stageFile.contestsJson) || spawnSync(scriptFiles.getJsonContests, [stageFiles.contestsJson], childOptions);

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
	const contestDir = path.join(stageFiles.contestsDir, categoryPath.get(contest.CategoryId), name);
	const filename = path.join(stageFiles.problemsInContestDir, `${id}.json`);

	console.log(`Contest ${+i + 1}/${contestsCount} - ${id} (${name})`);
	fs.existsSync(filename) || spawnSync(scriptFiles.getJsonProblems, [id, filename], childOptions);
	const problemsKendo = JSON.parse(fs.readFileSync(filename, 'utf-8'));
	for(const problem of problemsKendo) {
		const id = problem.Id;
		problem.Name = problem.Name.replace(/\//g, '_');
		const name = problem.Name;
		const problemDir = path.join(contestDir, name);
		const testsZip = path.join(problemDir, 'tests.zip');

		console.log(`- ${id} (${name})`);
		fs.existsSync(testsZip) || spawnSync(scriptFiles.downloadTests, [id, testsZip], childOptions);

		const resourcesDir = path.join(problemDir, 'resources');
		const resourcesReady = path.join(resourcesDir, '.done');
		fs.existsSync(resourcesDir) || fs.mkdirSync(resourcesDir);
		if(!fs.existsSync(resourcesReady)) {
			JSON.parse(spawnSync(scriptFiles.getJsonResources, [id.toString()], childOptions).stdout)
				.Data
				.forEach(({Id, Link, Name}) => {
					if(Link) {
						const filename = path.join(resourcesDir, `${Name}.link`)
						fs.writeFileSync(filename, Link);
					} else {
						spawnSync(scriptFiles.downloadResource, [`${childOptions.env.OJS_URL}/Administration/Resources/Download/${Id}`, resourcesDir], childOptions);
					}
				});
			fs.writeFileSync(resourcesReady, '');
		}

		const problemParams = path.join(problemDir, 'problem.params');
		if(!fs.existsSync(problemParams)) {
			fs.writeFileSync(
				problemParams,
				Object.entries(problem)
					.map(([k, v]) => `${k}:${v}`)
					.concat('')
					.join('\n'));
		}
	}

	const contestParams = path.join(contestDir, 'contest.params');
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
