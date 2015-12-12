package jsx.parser.layer;

import common.ImageExtension;
import lib.FileDirectory;
import psd.Layer;
using common.ImageExtension.ImageExtensionUtil;

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
				var tempPath = layerName.split(imageExtension)[0];

				// aaa/bbb/ccc -> ccc
				defaultName = tempPath.split(FileDirectory.PATH_COLUMN).pop();
		}
	}
	public function isIncludedImageExtension():Bool
	{
		return includedImageExtension != IncludedImageExtension.NONE;
	}
	public function equals(check:Layer):Bool
	{
		return layer == check;
	}
	public function toDefaultName()
	{
		layer.name = defaultName;
	}
	public function toSimpleName()
	{
		layer.name = defaultName + ImageExtension.PNG;
	}
	public function toAbsolutePathName()
	{
		layer.name = absolutePath + ImageExtension.PNG;
	}
	public function getDirectoryPathString():String
	{
		return directoryPath.join(FileDirectory.PATH_COLUMN);
	}
}
