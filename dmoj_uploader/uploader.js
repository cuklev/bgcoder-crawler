// This is free and unencumbered software released into the public domain.
// See LICENSE

'use strict';

const fs = require('fs');
const {execSync, spawnSync} = require('child_process');

const stageFiles = Object.freeze({
	cookieJar: './cookie-jar',
});

const runStage = (() => {
	const attachIO = {stdio: [0, 1, 2]};
	return (target, [cmd, ...args]) => fs.existsSync(target) || spawnSync(cmd, args, attachIO);
})();

runStage(stageFiles.cookieJar, ['./scripts/auth.sh', stageFiles.cookieJar]);
