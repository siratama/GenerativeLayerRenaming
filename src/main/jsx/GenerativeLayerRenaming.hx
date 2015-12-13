package jsx;

import common.RenamingMode;
import psd.Layer;
import common.RenamingLayerType;
import js.Lib;
import jsx.layer.LayerStructure;
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
		GenerativeLayerRenamingJSXRunner.execute(RenamingMode.ABSOLUTE_PATH, RenamingLayerType.SELECTED);
		#elseif ToAbsolutePathInImageExtensionLayer
		GenerativeLayerRenamingJSXRunner.execute(RenamingMode.ABSOLUTE_PATH, RenamingLayerType.INCLUDED_IMAGE_EXTENSION);

		#elseif ToDefaultInSelectedLayer
		GenerativeLayerRenamingJSXRunner.execute(RenamingMode.DEFAULT, RenamingLayerType.SELECTED);
		#elseif ToDefaultInImageExtensionLayer
		GenerativeLayerRenamingJSXRunner.execute(RenamingMode.DEFAULT, RenamingLayerType.INCLUDED_IMAGE_EXTENSION);

		#elseif ToSimpleInSelectedLayer
		GenerativeLayerRenamingJSXRunner.execute(RenamingMode.SIMPLE, RenamingLayerType.SELECTED);
		#elseif ToSimpleInImageExtensionLayer
		GenerativeLayerRenamingJSXRunner.execute(RenamingMode.SIMPLE, RenamingLayerType.INCLUDED_IMAGE_EXTENSION);
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
	public function execute(imageExtension:String, serializedRenamingMode:String, serializedRenamingLayerType:String):Void
	{
		var renamingMode:RenamingMode = Unserializer.run(serializedRenamingMode);
		var renamingLayerType:RenamingLayerType = Unserializer.run(serializedRenamingLayerType);
		OptionalParameter.instance.set(imageExtension);

		activeDocument = application.activeDocument;
		selectForceSingleLayer(renamingLayerType);

		var layerStructure = new LayerStructure(activeDocument, activeDocument.layers, []);
		layerStructure.parse();
		layerStructure.rename(renamingMode, renamingLayerType);
	}

	/**
	 * When a layer name is changed when no layers are selected, an error occurs.
	 * 一つもレイヤーが選択されていない状態で Layer.name の変更を行うとエラーが発生するため
	 * 強制的に適当なレイヤーを選択
	 */
	private function selectForceSingleLayer(renamingLayerType:RenamingLayerType)
	{
		switch(renamingLayerType)
		{
			case RenamingLayerType.SELECTED: return;
			case RenamingLayerType.INCLUDED_IMAGE_EXTENSION:
				var layer:Layer = activeDocument.layers[0];
				LayerUtil.selectSingleLayer(layer.name);
		}
	}
}
private class GenerativeLayerRenamingJSXRunner
{
	public static function execute(renamingMode:RenamingMode, renamingLayerType:RenamingLayerType)
	{
		var generativeLayerRenaming = new GenerativeLayerRenaming();
		var errorEvent:GenerativeLayerRenamingInitialErrorEvent = Unserializer.run(generativeLayerRenaming.getInitialErrorEvent());
		switch(errorEvent)
		{
			case GenerativeLayerRenamingInitialErrorEvent.ERROR(error):
				alert(cast(error, String));

			case GenerativeLayerRenamingInitialErrorEvent.NONE:
				generativeLayerRenaming.execute(
					"png",
					Serializer.run(renamingMode),
					Serializer.run(renamingLayerType)
				);
		}
	}
}

