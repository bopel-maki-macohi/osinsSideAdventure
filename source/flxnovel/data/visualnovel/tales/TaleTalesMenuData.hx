package flxnovel.data.visualnovel.tales;

typedef TaleTalesMenuData =
{
	@:optional
	var titleAsset:String;

	@:optional
	var display:String;

	@:optional
	@:default([])
	var filters:Array<String>;
}
