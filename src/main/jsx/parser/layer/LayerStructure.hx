package jsx.parser.layer;

import psd.Application;
import jsx.util.Bounds;
import psd.Document;
import psd.LayerSet;
import psd.Layers;
import psd.Layer;
import psd.LayerTypeName;
using jsx.util.Bounds;
import psd.Lib.app;

class LayerStructure
{
	private var application:Application;
	private var document:Document;
	private var layers:Layers;
	private var parentDirectoryPath:Array<String>;

	public var layerPropertySet(default, null):Array<LayerProperty>;
	public var layerPropertyMap(default, null):Map<Layer, LayerProperty>;

	public function new(document:Document, layers:Layers, parentDirectoryPath:Array<String>)
	{
		this.document = document;
		this.layers = layers;
		this.parentDirectoryPath = parentDirectoryPath;

		application = app;
		layerPropertySet = [];
		layerPropertyMap = new Map();
	}
	public function parse()
	{
		for (i in 0...layers.length)
		{
			var layer:Layer = layers[i];
			var layerProperty = new LayerProperty(layer, parentDirectoryPath);
			layerPropertySet.push(layerProperty);
			layerPropertyMap[layer] = layerProperty;

			if(layer.typename == LayerTypeName.LAYER_SET)
			{
				var layerSet = cast(layer, LayerSet);

				var directoryPath = parentDirectoryPath.copy();
				directoryPath.push(layerProperty.defaultName);
				var childLayerStructure = new LayerStructure(document, layerSet.layers, directoryPath);

				childLayerStructure.parse();
				layerPropertySet = layerPropertySet.concat(childLayerStructure.layerPropertySet);

				for(key in childLayerStructure.layerPropertyMap.keys())
					layerPropertyMap[key] = childLayerStructure.layerPropertyMap[key];
			}
		}
	}

	//
	public function toDefaultLayerName(?selectedLayerSet:Array<Layer>)
	{
		var checkedLayerPropertySet = getCheckedLayerPropertySet(selectedLayerSet);
		for (layerProperty in checkedLayerPropertySet)
			layerProperty.toDefaultName();
	}
	public function toSaimpleLayerName(?selectedLayerSet:Array<Layer>)
	{
		var checkedLayerPropertySet = getCheckedLayerPropertySet(selectedLayerSet);
		for (layerProperty in checkedLayerPropertySet)
			layerProperty.toSimpleName();
	}
	public function toAbsolutePathLayerName(?selectedLayerSet:Array<Layer>)
	{
		var checkedLayerPropertySet = getCheckedLayerPropertySet(selectedLayerSet);
		for (layerProperty in checkedLayerPropertySet){
			layerProperty.toAbsolutePathName();
		}
	}
	private function getCheckedLayerPropertySet(selectedLayerSet:Array<Layer>):Array<LayerProperty>
	{
		if(selectedLayerSet == null){
			return getIncluededImageExtensionLayerPropertySet();
		}

		var checkedLayerPropertySet:Array<LayerProperty> = [];
		for (selectedLayer in selectedLayerSet)
		{
			checkedLayerPropertySet.push(
				layerPropertyMap[selectedLayer]
			);
		}
		return checkedLayerPropertySet;
	}
	private function getIncluededImageExtensionLayerPropertySet():Array<LayerProperty>
	{
		var checkedLayerPropertySet:Array<LayerProperty> = [];
		for (layerProperty in layerPropertySet)
		{
			if(layerProperty.isIncludedImageExtension()){
				checkedLayerPropertySet.push(layerProperty);
			}
		}
		return checkedLayerPropertySet;
	}
}

