package jsx.util;
import psd.LayerSet;
import psd.Document;
import psd.Layer;
import psd_private.CharacterID;
import psd_private.StringID;
import psd_private.Lib;
import psd_private.DialogModes;
import psd_private.ActionReference;
import psd_private.ActionDescriptor;
class LayerUtil
{
	public static function getSlectedLayerSet(document:Document):Array<Layer>
	{
		selectedLayerToLayerSet();

		var selectedLayerSet:Array<Layer> = [];
		var tempLayerSet = cast(document.activeLayer, LayerSet);
		for (i in 0...tempLayerSet.layers.length)
		{
			var layer = tempLayerSet.layers[i];
			selectedLayerSet.push(layer);
		}
		History.undo(document);

		return selectedLayerSet;
	}

	/**
	 * You can get selected layers after calling this method by document.activeLayer.layers.
	 */
	public static function selectedLayerToLayerSet()
	{
		var idGrp = Lib.stringIDToTypeID(StringID.GROUP_LAYERS_EVENT);
		var descGrp = new ActionDescriptor();
		var refGrp = new ActionReference();
		refGrp.putEnumerated(
			Lib.charIDToTypeID(CharacterID.LAYER),
			Lib.charIDToTypeID(CharacterID.ORDN),
			Lib.charIDToTypeID(CharacterID.TARGET)
		);
		descGrp.putReference(Lib.charIDToTypeID(CharacterID.NULL), refGrp);
		Lib.executeAction(idGrp, descGrp, DialogModes.ALL);
	}
}
