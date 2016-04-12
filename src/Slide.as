package 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author Samuel Jacob Walker
	 */
	public class Slide extends MovieClip 
	{
		private var _imageDisplayed:Boolean;
		private var _imageLoading:Boolean;
		
		private var l:Loader = new Loader();
		
		private var openingTween:Tween;
		private var expandingTween:Tween;
		private var tweenTimer:Timer;
		
		private static const LOADER_BAR_MAX_WIDTH:int = 800;
		
		private var url:String;
		private var title:String;
		private var description:String;
		private var link:String
		
		public function Slide(url:String, title:String, description:String, link:String) 
		{
			this.url = url;
			this.title = title;
			this.description = description;
			this.link = link;
			
			trace("Title = " +  title);
			trace("Description = " + description);
			
			_imageDisplayed = new Boolean(false);
		}
		
		public function loadImage():void
		{
			_imageLoading = true;
			l.load(new URLRequest(url));
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoaderProgress);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaderComplete);
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		
		private function handleIOError(e:IOErrorEvent):void 
		{
			error_txt.text = e.toString();
		}
		
		private function handleLoaderComplete(e:Event):void 
		{
			//Expand bar, remove, add image.
			tweenTimer = new Timer(500, 0);
			tweenTimer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
			openingTween = new Tween(loaderBar_mc, "height", Strong.easeOut, 3, FlashBanner.BANNER_HEIGHT, 500, false);
			//expandingTween = new Tween(loaderBar_mc, "y", Strong.easeOut, loaderBar_mc.x, 400, 350, false);
			tweenTimer.start();
		}
		
		private function handleTimerEvent(e:TimerEvent):void 
		{
			//Timerevent fires when tween of bar expand is complete
			tweenTimer.stop();
			tweenTimer.removeEventListener(TimerEvent.TIMER, handleTimerEvent);
			
			loaderBar_mc.visible = false;
			_imageDisplayed = true;
			
			imageContainer_mc.addChild(l.content);
			FlashBanner.resizeMe(l.content, FlashBanner.BANNER_WIDTH, FlashBanner.BANNER_HEIGHT);
			l.x = FlashBanner.BANNER_WIDTH - l.content.width;
			
			title_txt.width = l.content.width;
			description_txt.width = l.content.width;
			//title_txt.x = l.x;
			//description_txt.x = l.x;
			
			trace("Title = " +  title);
			trace("Description = " + description);
			
			//bg_mc.width = l.content.width; match image width
			//bg_mc.y = (imageContainer_mc.y - bg_mc.height) + 5; broken
			trace("New width = " + bg_mc.width);
			
			title_txt.text = title;
			description_txt.text = description;
			addEventListener(MouseEvent.CLICK, handleUserClick);
		}
		
		private function handleUserClick(e:MouseEvent):void 
		{
			if (link != "") //If link not null, navigate to link
			{
				navigateToURL(new URLRequest(link), "_self");
			}
		}
		
		private function handleLoaderProgress(e:ProgressEvent):void 
		{
			//Adjust loading bar width
			loaderBar_mc.width = LOADER_BAR_MAX_WIDTH * (e.bytesLoaded / e.bytesTotal);
		}
		
		public function reset():void
		{
			loaderBar_mc.visible = true;
			loaderBar_mc.height = 3;
			imageContainer_mc.removeChild(l.content);
			l = new Loader();
		}
		
		public function get imageDisplayed():Boolean 
		{
			return _imageDisplayed;
		}
		
		public function get imageLoading():Boolean 
		{
			return _imageLoading;
		}
		
	}

}