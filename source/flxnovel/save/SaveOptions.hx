package flxnovel.save;

import flxnovel.save.fields.*;

typedef SaveOptions =
{
	var pcname:Null<Bool>;

	@:deprecated('fpsCounter save field is depricated, use debugDisplay')
	var ?fpsCounter:Null<Bool>;

	var debugDisplay:Null<Bool>;

	var uiOrientation:UIOrientation;
}
