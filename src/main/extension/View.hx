package extension;
import js.html.svg.ViewElement;
import common.RenamingMode;
import common.RenamingMode;
import common.RenamingLayerType;
import extension.parts.Button;
import jQuery.JQuery;
class View
{
	@:allow(extension) private static var instance(get, null):View;
	private static inline function get_instance():View
		return instance == null ? instance = new View(): instance;

	private var element:JQuery;
	private var absolutePathButton:Button;
	private var simpleButton:Button;
	private var defaultButton:Button;

	private static inline var SLIDE_SPEED = "fast";

	private function new()
	{
		element =  new JQuery("#container");

		var runElement = new JQuery("#run");
		setTitleBar("run_title", runElement);
		absolutePathButton = new Button(runElement, "absolute_path");
		simpleButton = new Button(runElement, "simple");
		defaultButton = new Button(runElement, "default");

		setTitleBar("setting_title", new JQuery("#setting"));
	}
	private function setTitleBar(titleBarId:String, slideElement:JQuery){

		var titleElement = new JQuery("#" + titleBarId);
		titleElement.mousedown(function(event){

			if(slideElement.is(":hidden"))
				slideElement.slideDown(SLIDE_SPEED);
			else
				slideElement.slideUp(SLIDE_SPEED);
		});
	}

	public function getEvent():ViewEvent
	{
		return
			absolutePathButton.isClicked() ? ViewEvent.CLICKED(RenamingMode.ABSOLUTE_PATH):
			simpleButton.isClicked() ? ViewEvent.CLICKED(RenamingMode.SIMPLE):
			defaultButton.isClicked() ? ViewEvent.CLICKED(RenamingMode.DEFAULT): ViewEvent.NONE;
	}
	public function getRenamingLayerType():RenamingLayerType
	{
		var inputElements = new JQuery("#renaming_layer_type input:radio[name='renaming_layer_type']");
		var selectedIndex = inputElements.index(inputElements.filter(":checked"));
		return switch(selectedIndex)
		{
			case 0: RenamingLayerType.SELECTED;
			case _: RenamingLayerType.INCLUDED_IMAGE_EXTENSION;
		}
	}
	public function getImageExtension():String
	{
		return new JQuery("#image_extension input", element).val();
	}
}

enum ViewEvent
{
	NONE;
	CLICKED(renamingMode:RenamingMode);
}