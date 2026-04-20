package flxnovel.save;

typedef SaveOptions =
{
	var pcname:Null<Bool>;
	
	@:allow(Save)
	@:depricated('fpsCounter save field is depricated, use debugDisplay')
	var ?fpsCounter:Null<Bool>;

	var debugDisplay:Null<Bool>;
}
