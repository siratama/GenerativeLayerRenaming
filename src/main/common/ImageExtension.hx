package common;

@:enum abstract ImageExtension(String) to String
{
	var PNG = ".png";
	var JPG = ".jpg";
	var GIF = ".gif";
}

class ImageExtensionUtil
{
	public static function getIncludedImageExtension(layerName:String):IncludedImageExtension
	{
		return
			(layerName.indexOf(ImageExtension.PNG) != -1) ?
				IncludedImageExtension.EXISTS(ImageExtension.PNG):

			(layerName.indexOf(ImageExtension.JPG) != -1) ?
				IncludedImageExtension.EXISTS(ImageExtension.JPG):

			(layerName.indexOf(ImageExtension.GIF) != -1) ?
				IncludedImageExtension.EXISTS(ImageExtension.GIF):

				IncludedImageExtension.NONE;
	}
}

enum IncludedImageExtension
{
	NONE;
	EXISTS(imageExtension:ImageExtension);
}
