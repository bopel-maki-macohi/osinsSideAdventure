package osa.modding.events;

enum abstract ScriptEventType(String) from String to String
{
	var CREATE = 'CREATE';
	var UPDATE = 'UPDATE';
	var DESTROY = 'DESTROY';
}
