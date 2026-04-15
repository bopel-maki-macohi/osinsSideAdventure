package osa.util.macros;

#if !display
class GitMacro
{
	public static macro function getGitCommit()
	{
		var commitHash:String = '';

		#if !display
		var pos = haxe.macro.Context.currentPos();

		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0)
		{
			haxe.macro.Context.info('Could not get the git commit... Is this an actual git repo?', pos);
		}

		commitHash = process.stdout.readLine().substr(0, 7);
		haxe.macro.Context.info('Git commit: ${commitHash}', pos);

		process.close();
		#end

		return macro $v{commitHash};
	}

	public static macro function getGitBranch()
	{
		var gitBranch:String = '';

		#if !display
		var pos = haxe.macro.Context.currentPos();

		var process = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
		if (process.exitCode() != 0)
		{
			haxe.macro.Context.info('Could not get the git branch... Is this an actual git repo?', pos);
		}

		gitBranch = process.stdout.readLine();
		haxe.macro.Context.info('Git branch: ${gitBranch}', pos);

		process.close();
		#end

		return macro $v{gitBranch};
	}
    
	public static macro function getHasLocalChanges()
	{
		var gitBranch:Bool = true;

		#if !display
        var pos = haxe.macro.Context.currentPos();

		var process = new sys.io.Process('git', ['diff', '--quiet']);
        
        gitBranch = process.exitCode(true) == 1;
		haxe.macro.Context.info('Local Git: ${gitBranch}', pos);

		process.close();
		#end

		return macro $v{gitBranch};
	}
}
#end
