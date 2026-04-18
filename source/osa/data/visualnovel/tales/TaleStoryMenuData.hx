package osa.data.visualnovel.tales;

typedef TaleStoryMenuData =
{
	@:optional
	var titleAsset:String;

	@:optional
	var display:String;

	@:optional
	@:default([])
	var filters:Array<String>;
}
