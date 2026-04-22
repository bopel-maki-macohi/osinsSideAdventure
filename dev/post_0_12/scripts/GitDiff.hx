package dev.post_0_12.scripts;

import sys.io.Process;

/**
 * haxe -m dev.post_0_12.scripts.GitDiff --interp
 */
class GitDiff
{
	public static function getGitBranch()
	{
		var gitBranch:String = '';

		var process = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
		if (process.exitCode() != 0)
		{
			trace('Could not get the git branch... Is this an actual git repo?');
			return null;
		}

		gitBranch = process.stdout.readLine();
		trace('Git branch: ${gitBranch}');

		process.close();

		return gitBranch;
	}

	public static function getGitCommit(branch:String = 'HEAD')
	{
		var gitCommit:String = '';

		var process = new sys.io.Process('git', ['rev-parse', branch]);
		if (process.exitCode() != 0)
		{
			trace('Could not get the git commit... Is this an actual git repo?');
			return null;
		}

		gitCommit = process.stdout.readLine();
		trace('Raw Git commit (branch: $branch): ${gitCommit}');

		process.close();

		return gitCommit.substr(0, 7);
	}

	static function main()
	{
		// git diff 8ea485c18ef21378bfb114c5df2192aad83aa273...efe815676d7d3fcef3724ee777d8159746e4c96d --shortstat

		var curBranch = getGitBranch();

		var mainCommit = getGitCommit('stable');
		var curCommit = getGitCommit(curBranch);

		var process = new Process('git', ['diff', '$mainCommit...$curCommit', '--shortstat']);
		if (process.exitCode() != 0)
			return;

		trace(process.stdout.readLine());
	}
}
