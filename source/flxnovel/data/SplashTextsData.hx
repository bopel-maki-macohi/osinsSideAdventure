package flxnovel.data;

typedef SplashTextsData =
{
	lines:Array<SplashTextData>
}

typedef SplashTextData =
{
	?clearWatermark:Bool,

	?filter:String,
	?specialCase:String,

	line:Array<String>
}
