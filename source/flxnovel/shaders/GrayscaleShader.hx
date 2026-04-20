package flxnovel.shaders;

import flixel.addons.display.FlxRuntimeShader;

class GrayscaleShader extends FlxRuntimeShader
{
	public var amount:Float = 1;

	public function new(amount:Float = 1)
	{
		super('grayscale'.shaderFile().readText());
		setAmount(amount);
	}

	public function setAmount(value:Float):Void
	{
		amount = value;
		this.setFloat("_amount", amount);
	}
}
