package flxnovel.data.visualnovel.speaker;

typedef SpeakerConfigData =
{
	@:optional
	@:default(center)
	public var orientation:SpeakerOrientation;

	@:optional
	@:default(0.0)
	public var orientationOffset:Float;
}
