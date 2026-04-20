package flxnovel.data.visualnovel.background;

typedef BackgroundPropData =
{
	> GeneralData,
	> ImageData,
	> ShapeData,

	var id:String;

	@:default(shape)
	var type:BackgroundPropType;
}

typedef GeneralData =
{
	@:optional
	var scale:Float;

	@:optional
	@:default('0xFFFFFF')
	var color:String;
}

typedef ImageData =
{
	@:optional
	var asset:String;
}

typedef ShapeData =
{
	@:optional
	var width:Int;

	@:optional
	var height:Int;
}
