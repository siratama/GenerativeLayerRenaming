package extension;

import common.RenamingMode;
import extension.View.ViewEvent;
import extension.JsxRunner.JsxRunnerEvent;
import js.Browser;
import haxe.Timer;

class Panel
{
	private var timer:Timer;
	private static inline var TIMER_SPEED_CALM = 250;
	private static inline var TIMER_SPEED_RUNNING = 50;

	private var mainFunction:Void->Void;
	private var csInterface:AbstractCSInterface;
	private var jsxLoader:JsxLoader;
	private var view:View;
	private var jsxRunner:JsxRunner;

	public static function main(){
		new Panel();
	}
	public function new(){
		Browser.window.addEventListener("load", initialize);
	}
	private function initialize(event)
	{
		csInterface = AbstractCSInterface.create();
		jsxLoader = new JsxLoader();
		jsxRunner = new JsxRunner();
		view = View.instance;

		startRunning(loadJsx, TIMER_SPEED_RUNNING);
	}

	//
	private function startRunning(func:Void -> Void, speed:Int){
		mainFunction = func;
		setTimer(speed);
	}
	private function changeRunning(func:Void -> Void, speed:Int){
		timer.stop();
		startRunning(func, speed);
	}
	private function setTimer(speed:Int){
		timer = new Timer(speed);
		timer.run = run;
	}
	private function run(){
		mainFunction();
	}

	//
	private function loadJsx()
	{
		jsxLoader.run();
		if(jsxLoader.isFinished()){
			initializeToClickUI();
		}
	}

	//
	private function initializeToClickUI()
	{
		changeRunning(observeToClickUI, TIMER_SPEED_CALM);
	}
	private function observeToClickUI()
	{
		switch(view.getEvent()){
			case ViewEvent.NONE: return;
			case ViewEvent.CLICKED(renamingMode):
				initializeToCallFrameAnimationExport(renamingMode);
		}
	}
	private function initializeToCallFrameAnimationExport(renamingMode:RenamingMode)
	{
		jsxRunner.call(view.getImageExtension(), renamingMode, view.getRenamingLayerType());
		changeRunning(callFrameAnimationExport, TIMER_SPEED_RUNNING);
	}
	private function callFrameAnimationExport()
	{
		jsxRunner.run();
		var event = jsxRunner.getEvent();
		switch(event){
			case JsxRunnerEvent.NONE: return;

			case JsxRunnerEvent.INITIAL_ERROR_EVENT(error):
				js.Browser.alert(cast(error, String));
				initializeToClickUI();

			case JsxRunnerEvent.SUCCESS:
				initializeToClickUI();
		}
	}
}

