package flxnovel.data.visualnovel.background;

typedef BackgroundPropData =
{
    @:default(shape)
	var type:BackgroundPropType;

    @:optional
    var width:Int;
    
    @:optional
    var height:Int;
    
    @:optional
    @:default('0xFFFFFF')
    var color:String;
}
