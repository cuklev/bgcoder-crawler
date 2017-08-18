// This is free and unencumbered software released into the public domain.
// See LICENSE

const fs = require('fs');
const {execSync, spawnSync} = require('child_process');

const stageFiles = {
	cookieJar: 'downloaded/cookie-jar',
	contestsJson: 'downloaded/kendo-contests.json',
	problemsInContestDir: 'downloaded/problems-in-contest',
	contestsDir: 'downloaded/contests',
};

const runStage = (() => {
	const attachIO = {stdio: [0, 1, 2]};
	return (target, [cmd, ...args]) => fs.existsSync(target) || spawnSync(cmd, args, attachIO);
})();

runStage(stageFiles.cookieJar, ['./scripts/auth.sh', stageFiles.cookieJar]);

const categoryPath = new Map;
(function sub(path, id) {
	console.log(`Category ${id} (${path})`);
	let cmd = `./scripts/get_subcategories.sh ${stageFiles.cookieJar}`;
	if(typeof id === 'number') {
		cmd = `${cmd} ${id}`;
		categoryPath.set(id, path);
	}
	JSON.parse(execSync(cmd).toString())
		.forEach(cat => sub(`${path}/${cat.Name.replace(/\//g, '_')}`, cat.id));
})('.');

runStage(stageFiles.contestsJson, ['./scripts/get_json_contests.sh', stageFiles.cookieJar, stageFiles.contestsJson]);

const contestsKendo = JSON.parse(fs.readFileSync(stageFiles.contestsJson, 'utf-8')).Data;
const contestsCount = contestsKendo.length;

for(const i in contestsKendo) {
	const contest = contestsKendo[i];
	const id = contest.Id;

	if(id === 322 || id === 168 || id === 167 || id === 166) {
		continue;
	}

	contest.Name = contest.Name.replace(/\//g, '_');
	const name = contest.Name;
	const contestDir = `${stageFiles.contestsDir}/${categoryPath.get(contest.CategoryId)}/${name}`;
	const filename = `${stageFiles.problemsInContestDir}/${id}.json`;

	console.log(`Contest ${+i + 1}/${contestsCount} - ${id} (${name})`);
	runStage(filename, ['./scripts/get_json_problems.sh', stageFiles.cookieJar, id, filename]);
	const problemsKendo = JSON.parse(fs.readFileSync(filename, 'utf-8'));
	for(const problem of problemsKendo) {
		const id = problem.Id;
		problem.Name = problem.Name.replace(/\//g, '_');
		const name = problem.Name;
		const problemDir = `${contestDir}/${name}`;
		const tests = `${problemDir}/tests.zip`;

		console.log(`- ${id} (${name})`);
		runStage(tests, ['./scripts/download_tests.sh', stageFiles.cookieJar, id, tests]);

		const resourcesList = `${problemDir}/resources.list`;
		if(!fs.existsSync(resourcesList)) {
			fs.writeFileSync(
				resourcesList,
				JSON.parse(execSync(`./scripts/get_resources_json.sh ${stageFiles.cookieJar} ${id}`))
					.Data
					.map(({Id, Link, Name}) => `${Name}:` + (Link ? Link : `http://bgcoder.com/Administration/Resources/Download/${Id}`))
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
