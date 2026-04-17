package osa.util.macros;

#if !display
class GitMacro
{
	public static macro function getGitCommit()
	{
		var commitHash:String = '';

		#if !display
		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0)
		{
			trace('Could not get the git commit... Is this an actual git repo?', pos);
		}

		commitHash = process.stdout.readLine().substr(0, 7);
		trace('Git commit: ${commitHash}');

		process.close();
		#end

		return macro $v{commitHash};
	}

	public static macro function getGitBranch()
	{
		var gitBranch:String = '';

		#if !display
		var process = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
		if (process.exitCode() != 0)
		{
			trace('Could not get the git branch... Is this an actual git repo?', pos);
		}

		gitBranch = process.stdout.readLine();
		trace('Git branch: ${gitBranch}');

		process.close();
		#end

		return macro $v{gitBranch};
	}
    
	public static macro function getHasLocalChanges()
	{
		var gitBranch:Bool = true;

		#if !display
		var process = new sys.io.Process('git', ['diff', '--quiet']);
        
        gitBranch = process.exitCode(true) == 1;
		trace('Local Git: ${gitBranch}');

		process.close();
		#end

		return macro $v{gitBranch};
	}
}
#end
