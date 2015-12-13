package jsx;

class OptionalParameter
{
	@:allow(jsx) private static var instance(get, null):OptionalParameter;
	private static inline function get_instance():OptionalParameter
		return instance == null ? instance = new OptionalParameter(): instance;

	public var imageExtension(default, null):String;

	private function new(){}

	public function set(imageExtension:String)
	{
		this.imageExtension = imageExtension;
	}
}
