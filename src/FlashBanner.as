package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Samuel Jacob Walker
	 */
	public class FlashBanner extends MovieClip 
	{
		private var bannerXML:XML;
		
		public function FlashBanner() 
		{
			super();
			
			var l:URLLoader = new URLLoader();
			l.load(new URLRequest("xml/slidebanner.xml"));
			l.addEventListener(Event.COMPLETE, handleXMLLoadComplete);
		}
		
		private function handleXMLLoadComplete(e:Event):void 
		{
			bannerXML = new XML(e.target.data);
		}
		
		private function setupSlides():void
		{
			var mainSlideLength = bannerXML.MAIN.length();
			var sideSlideLength = bannerXML.SIDE.length();
			
			for (var i:int = 0; i < mainSlideLength, i++)
			{
				
			}
		}
		
	}

}