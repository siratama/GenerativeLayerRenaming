package jsx.layer;

import common.ImageExtension;
import common.ImageExtension;
import lib.FileDirectory;
import psd.Layer;

using common.ImageExtension;

class LayerProperty
{
	private var layer:Layer;
	private var layerName:String;
	public var absolutePath(default, null):String;
	public var directoryPath:Array<String>;
	public var defaultName(default, null):String;
	private var renamedFileName:Null<String>;
	private var includedImageExtension:IncludedImageExtension;

	public function new(layer:Layer, directoryPath:Array<String>)
	{
		this.layer = layer;
		this.layerName = layer.name;
		this.directoryPath = directoryPath;

		parseLayerName();

		absolutePath = (directoryPath.length == 0) ?
			defaultName :
			[directoryPath.join(FileDirectory.PATH_COLUMN), defaultName].join(FileDirectory.PATH_COLUMN);
	}
	private function parseLayerName()
	{
		includedImageExtension = layerName.getIncludedImageExtension();
		switch(includedImageExtension)
		{
			case IncludedImageExtension.NONE:
				defaultName = layerName;

			case IncludedImageExtension.EXISTS(imageExtension):

				// aaa/bbb/ccc.png -> aaa/bbb/ccc
				var tempPath = layerName.split(ImageExtension.COLUMN + imageExtension)[0];

				// aaa/bbb/ccc -> ccc
				defaultName = tempPath.split(FileDirectory.PATH_COLUMN).pop();
		}
	}
	public function isIncludedImageExtension():Bool
	{
		return !Type.enumEq(includedImageExtension, IncludedImageExtension.NONE);
	}
	public function equals(check:Layer):Bool
	{
		return layer == check;
	}
	public function toDefaultName()
	{
		if(isChanged())
			layer.name = defaultName;
	}
	public function toSimpleName()
	{
		if(isChanged())
			layer.name = defaultName + ImageExtension.COLUMN + OptionalParameter.instance.imageExtension;
	}
	public function toAbsolutePathName()
	{
		if(isChanged())
			layer.name = absolutePath + ImageExtension.COLUMN + OptionalParameter.instance.imageExtension;
	}
	private function isChanged():Bool
	{
		switch(includedImageExtension)
		{
			case IncludedImageExtension.NONE: return true;
			case IncludedImageExtension.EXISTS(imageExtension):
				return OptionalParameter.instance.imageExtension == imageExtension;
		}
	}
}
