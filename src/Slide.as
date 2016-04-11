package 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
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
		private var tweenTimer:Timer;
		
		private static const LOADER_BAR_MAX_WIDTH:int = 450;
		
		private var _url:String;
		private var _title:String;
		
		public function Slide(url:String, title:String) 
		{
			_url = url;
			_title = title;
		}
		
		public function loadImage():void
		{
			_imageLoading = true;
			l.load(new URLRequest(_url));
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoaderProgress);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaderComplete);
		}
		
		private function handleLoaderComplete(e:Event):void 
		{
			//Expand bar, remove, add image.
			tweenTimer = new Timer(500, 0);
			tweenTimer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
			openingTween = new Tween(loaderBar_mc, "height", Strong.easeOut, 3, 275, 350, false);
			tweenTimer.start();
		}
		
		private function handleTimerEvent(e:TimerEvent):void 
		{
			//Timerevent fires when tween of bar expand is complete
			loaderBar_mc.visible = false;
			_imageDisplayed = true;
			addChild(l.content);
			title_txt.text = _title;
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
			removeChild(l.content);
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