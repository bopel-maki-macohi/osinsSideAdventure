import osa.modding.events.basic.BasicScriptEvent;
import osa.modding.modules.Module;

class HelloWorld extends Module
{
	override public function new()
	{
		super('helloworld');
	}

	override function onScriptEvent(event:BasicScriptEvent)
	{
		trace(event.toString());
	}
}
