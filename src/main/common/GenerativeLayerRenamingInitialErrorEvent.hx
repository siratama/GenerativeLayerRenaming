package common;

enum GenerativeLayerRenamingInitialErrorEvent
{
	NONE;
	ERROR(error:GenerativeLayerRenamingInitialError);
}

@:enum abstract GenerativeLayerRenamingInitialError(String)
{
	var UNOPENED_DOCUMENT = "Unopened document.";
}
