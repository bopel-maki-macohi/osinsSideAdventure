package flxnovel.util.macros;

class GitMacro
{
	public static macro function getGitCommit()
	{
		var commitHash:String = '';

		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0)
		{
			trace('Could not get the git commit... Is this an actual git repo?');
		}

		commitHash = process.stdout.readLine().substr(0, 7);
		trace('Git commit: ${commitHash}');

		process.close();

		return macro $v{commitHash};
	}

	public static macro function getGitBranch()
	{
		var gitBranch:String = '';

		var process = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
		if (process.exitCode() != 0)
		{
			trace('Could not get the git branch... Is this an actual git repo?');
		}

		gitBranch = process.stdout.readLine();
		trace('Git branch: ${gitBranch}');

		process.close();

		return macro $v{gitBranch};
	}

	public static macro function getHasLocalChanges()
	{
		var gitBranch:Bool = true;

		var process = new sys.io.Process('git', ['diff', '--quiet']);

		gitBranch = process.exitCode(true) == 1;
		trace('Local Git: ${gitBranch}');

		process.close();

		return macro $v{gitBranch};
	}
}
