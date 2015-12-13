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
		var selectedLayerSet:Array<Layer> = [];

		try{
			selectedLayerToLayerSet(document);
		}catch(error:Dynamic){
			return selectedLayerSet;
		}

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
	public static function selectedLayerToLayerSet(document:Document)
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
		//Lib.executeAction(idGrp, descGrp, DialogModes.ALL);
		Lib.executeAction(idGrp, descGrp, DialogModes.NO);
	}


	public static function selectSingleLayer(layerName:String)
	{
		var idslct = Lib.charIDToTypeID(CharacterID.SELECT);
		var desc = new ActionDescriptor();
		var idnull = Lib.charIDToTypeID(CharacterID.NULL);
		var ref = new ActionReference();
		var idLyr = Lib.charIDToTypeID(CharacterID.LAYER);
		ref.putName(idLyr, layerName);
		desc.putReference(idnull, ref);
		var idMkVs = Lib.charIDToTypeID(CharacterID.MKVS);
		desc.putBoolean(idMkVs, false);
		Lib.executeAction(idslct, desc, DialogModes.NO);
	}
}
