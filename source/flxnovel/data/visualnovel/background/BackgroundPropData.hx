package flxnovel.data.visualnovel.background;

typedef BackgroundPropData =
{
	var id:String;

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
