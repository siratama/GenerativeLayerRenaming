package jsx.layer;

import common.RenamingMode;
import jsx.util.LayerUtil;
import common.RenamingLayerType;
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
	public function rename(renamingMode:RenamingMode, renamingLayerType:RenamingLayerType)
	{
		var renamedLayerPropertySet = getRenamedLayerPropertySet(renamingLayerType);
		switch(renamingMode)
		{
			case RenamingMode.ABSOLUTE_PATH:
				for (layerProperty in renamedLayerPropertySet) layerProperty.toAbsolutePathName();

			case RenamingMode.SIMPLE:
				for (layerProperty in renamedLayerPropertySet) layerProperty.toSimpleName();

			case RenamingMode.DEFAULT:
				for (layerProperty in renamedLayerPropertySet) layerProperty.toDefaultName();
		}
	}
	private function getRenamedLayerPropertySet(renamingLayerType:RenamingLayerType):Array<LayerProperty>
	{
		var renamedLayerPropertySet:Array<LayerProperty> = [];
		switch(renamingLayerType)
		{
			case RenamingLayerType.SELECTED:
				var selectedLayerSet = LayerUtil.getSlectedLayerSet(document);
				for (selectedLayer in selectedLayerSet)
				{
					renamedLayerPropertySet.push(
						layerPropertyMap[selectedLayer]
					);
				}

			case RenamingLayerType.INCLUDED_IMAGE_EXTENSION:
				for (layerProperty in layerPropertySet)
				{
					if(layerProperty.isIncludedImageExtension()){
						renamedLayerPropertySet.push(layerProperty);
					}
				}
		}
		return renamedLayerPropertySet;
	}
}

