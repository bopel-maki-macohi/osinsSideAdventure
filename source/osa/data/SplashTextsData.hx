package osa.data;

import haxe.macro.Expr;

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
