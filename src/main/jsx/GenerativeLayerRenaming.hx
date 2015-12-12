package jsx;

import psd.Layer;
import common.Mode;
import js.Lib;
import common.ImageExtension;
import jsx.parser.layer.LayerStructure;
import jsx.util.LayerUtil;
import common.GenerativeLayerRenamingInitialErrorEvent;
import haxe.Serializer;
import haxe.Unserializer;
import psd.Application;
import psd.Document;
import psd.Lib.app;
import psd.Lib.alert;

using jsx.util.ErrorChecker;

@:keep
@:native("GenerativeLayerRenaming")
class GenerativeLayerRenaming
{
	private var application:Application;
	private var activeDocument:Document;

	public static function main()
	{
		#if ToAbsolutePathInSelectedLayer
		GenerativeLayerRenamingJSXRunner.toAbsolutePath(Mode.SELECTED_LAYER);
		#elseif ToAbsolutePathInImageExtensionLayer
		GenerativeLayerRenamingJSXRunner.toAbsolutePath(Mode.IMAGE_EXTENSION_LAYER);

		#elseif ToDefaultInSelectedLayer
		GenerativeLayerRenamingJSXRunner.toDefaultName(Mode.SELECTED_LAYER);
		#elseif ToDefaultInImageExtensionLayer
		GenerativeLayerRenamingJSXRunner.toDefaultName(Mode.IMAGE_EXTENSION_LAYER);

		#elseif ToSimpleInSelectedLayer
		GenerativeLayerRenamingJSXRunner.toDefaultExtensionName(Mode.SELECTED_LAYER);
		#elseif ToSimpleInImageExtensionLayer
		GenerativeLayerRenamingJSXRunner.toDefaultExtensionName(Mode.IMAGE_EXTENSION_LAYER);
		#end
	}
	public function new()
	{
		application = app;
	}
	public function getInitialErrorEvent():String
	{
		var error =
			(application.documents.length == 0) ?
				GenerativeLayerRenamingInitialError.UNOPENED_DOCUMENT: null;

		var event = (error == null) ? GenerativeLayerRenamingInitialErrorEvent.NONE: GenerativeLayerRenamingInitialErrorEvent.ERROR(error);
		return Serializer.run(event);
	}

	//
	public function toAbsolutePath(serializedImageExtension:String, serializedMode:String):Void
	{
		var mode:Mode = Unserializer.run(serializedMode);
		OptionalParameter.instance.set(Unserializer.run(serializedImageExtension));

		activeDocument = application.activeDocument;
		var layerStructure = createLayerStructure();

		layerStructure.toAbsolutePathLayerName(
			getSelectedLayerSet(mode)
		);
	}
	public function toDefault(serializedImageExtension:String, serializedMode:String)
	{
		var mode:Mode = Unserializer.run(serializedMode);
		OptionalParameter.instance.set(Unserializer.run(serializedImageExtension));

		activeDocument = application.activeDocument;
		var layerStructure = createLayerStructure();

		layerStructure.toDefaultLayerName(
			getSelectedLayerSet(mode)
		);
	}
	public function toSaimple(serializedImageExtension:String, serializedMode:String)
	{
		var mode:Mode = Unserializer.run(serializedMode);
		OptionalParameter.instance.set(Unserializer.run(serializedImageExtension));

		activeDocument = application.activeDocument;
		var layerStructure = createLayerStructure();

		layerStructure.toSaimpleLayerName(
			getSelectedLayerSet(mode)
		);
	}
	private function createLayerStructure():LayerStructure
	{
		var layerStructure = new LayerStructure(activeDocument, activeDocument.layers, []);
		layerStructure.parse();
		return layerStructure;
	}
	private function getSelectedLayerSet(mode:Mode):Array<Layer>
	{
		return switch(mode){
			case Mode.SELECTED_LAYER: LayerUtil.getSlectedLayerSet(activeDocument);
			case Mode.IMAGE_EXTENSION_LAYER: null;
		}
	}
}
private class GenerativeLayerRenamingJSXRunner
{
	public static function toAbsolutePath(mode:Mode)
	{
		var generativeLayerRenaming = new GenerativeLayerRenaming();
		var errorEvent:GenerativeLayerRenamingInitialErrorEvent = Unserializer.run(generativeLayerRenaming.getInitialErrorEvent());
		switch(errorEvent)
		{
			case GenerativeLayerRenamingInitialErrorEvent.ERROR(error):
				alert(cast(error, String));

			case GenerativeLayerRenamingInitialErrorEvent.NONE:
				var serializedImageExtension = Serializer.run(ImageExtension.PNG);
				var serializedMode = Serializer.run(mode);
				generativeLayerRenaming.toAbsolutePath(serializedImageExtension, serializedMode);
		}
	}
	public static function toDefaultExtensionName(mode:Mode)
	{
		var generativeLayerRenaming = new GenerativeLayerRenaming();
		var errorEvent:GenerativeLayerRenamingInitialErrorEvent = Unserializer.run(generativeLayerRenaming.getInitialErrorEvent());
		switch(errorEvent)
		{
			case GenerativeLayerRenamingInitialErrorEvent.ERROR(error):
				alert(cast(error, String));

			case GenerativeLayerRenamingInitialErrorEvent.NONE:
				var serializedImageExtension = Serializer.run(ImageExtension.PNG);
				var serializedMode = Serializer.run(mode);
				generativeLayerRenaming.toSaimple(serializedImageExtension, serializedMode);
		}
	}
	public static function toDefaultName(mode:Mode)
	{
		var generativeLayerRenaming = new GenerativeLayerRenaming();
		var errorEvent:GenerativeLayerRenamingInitialErrorEvent = Unserializer.run(generativeLayerRenaming.getInitialErrorEvent());
		switch(errorEvent)
		{
			case GenerativeLayerRenamingInitialErrorEvent.ERROR(error):
				alert(cast(error, String));

			case GenerativeLayerRenamingInitialErrorEvent.NONE:
				var serializedImageExtension = Serializer.run(ImageExtension.PNG);
				var serializedMode = Serializer.run(mode);
				generativeLayerRenaming.toDefault(serializedImageExtension, serializedMode);
		}
	}
}

