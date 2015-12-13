package extension;

import common.RenamingLayerType;
import common.RenamingMode;
import common.GenerativeLayerRenamingInitialErrorEvent;
import common.ClassName;
import common.JsxEvent;
import haxe.Unserializer;
import haxe.Serializer;

enum JsxRunnerEvent
{
	INITIAL_ERROR_EVENT(error:GenerativeLayerRenamingInitialError);
	SUCCESS;
	NONE;
}

class JsxRunner
{
	private var mainFunction:Void->Void;
	private var csInterface:AbstractCSInterface;
	private var jsxEvent:JsxEvent;
	private var event:JsxRunnerEvent;
	private static inline var INSTANCE_NAME = "jsxInstance";

	private var imageExtension:String;
	private var renamingMode:RenamingMode;
	private var renamingLayerType:RenamingLayerType;

	public function getEvent():JsxRunnerEvent
	{
		var n = event;
		event = JsxRunnerEvent.NONE;
		return n;
	}

	public function new()
	{
		csInterface = AbstractCSInterface.create();
	}
	public function run()
	{
		mainFunction();
	}

	public function call(imageExtension:String, renamingMode:RenamingMode, renamingLayerType:RenamingLayerType)
	{
		this.imageExtension = imageExtension;
		this.renamingMode = renamingMode;
		this.renamingLayerType = renamingLayerType;

		event = JsxRunnerEvent.NONE;
		jsxEvent = JsxEvent.NONE;

		csInterface.evalScript('var $INSTANCE_NAME = new ${ClassName.JSX_CLASS}();');

		csInterface.evalScript('$INSTANCE_NAME.getInitialErrorEvent();', function(result){
			jsxEvent = JsxEvent.GOTTEN(result);
		});
		mainFunction = observeToRecieveInitialErrorEvent;
	}
	private function observeToRecieveInitialErrorEvent()
	{
		switch(recieveJsxEvent())
		{
			case JsxEvent.NONE: return;
			case JsxEvent.GOTTEN(serializedEvent):

				var initialErrorEvent:GenerativeLayerRenamingInitialErrorEvent = Unserializer.run(serializedEvent);
				switch(initialErrorEvent)
				{
					case GenerativeLayerRenamingInitialErrorEvent.ERROR(error):
						destroy(JsxRunnerEvent.INITIAL_ERROR_EVENT(error));
					case GenerativeLayerRenamingInitialErrorEvent.NONE:
						execute();
				}
		}
	}
	private function execute()
	{
		var serializedRenamingMode = Serializer.run(renamingMode);
		var serializedRenamingLayerType = Serializer.run(renamingLayerType);

		csInterface.evalScript('$INSTANCE_NAME.execute("$imageExtension", "$serializedRenamingMode", "$serializedRenamingLayerType");');
		destroy(JsxRunnerEvent.SUCCESS);
	}
	private function recieveJsxEvent():JsxEvent
	{
		var n = jsxEvent;
		jsxEvent = JsxEvent.NONE;
		return n;
	}
	private function destroy(event:JsxRunnerEvent)
	{
		this.event = event;
		mainFunction = finish;
	}
	private function finish(){}
}
