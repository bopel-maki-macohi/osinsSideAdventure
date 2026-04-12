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

	line:Array<String>
}
