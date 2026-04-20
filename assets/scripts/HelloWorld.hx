import osa.modding.events.ScriptEvent;
import osa.modding.modules.Module;

class HelloWorld extends Module
{
	override public function new()
	{
		super('helloworld');
	}

	override function onScriptEvent(event:ScriptEvent)
	{
		trace(event.toString());
	}
}
