package osa.modding.events;

class ScriptEventDispatcher
{
	public static function dispatch(target:Null<IScriptedEventClass>, event:BasicScriptEvent)
	{
		if (target == null || event == null)
			return;

		target.onScriptEvent(event);

		switch (event.type)
		{
			case CREATE:
				target.onCreate(event);
			case UPDATE:
				target.onUpdate(cast event);
			case DESTROY:
				target.onDestroy(event);

			default:
		}
	}
}
