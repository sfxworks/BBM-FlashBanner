package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	/**
	 * ...
	 * @author Samuel Jacob Walker
	 */
	public class FlashBanner extends MovieClip 
	{
		private var bannerXML:XML;
		private var slides:Vector.<Slide>;
		private var currentSlide:int;
		public static const BANNER_WIDTH:int = 800;//px
		public static const BANNER_HEIGHT:int = 450;
		private var transitionTimer:Timer;
		private var transitionTween:Tween;
		
		public function FlashBanner() 
		{
			super();
			
			var l:URLLoader = new URLLoader();
			l.load(new URLRequest("slidebanner.xml"));
			l.addEventListener(Event.COMPLETE, handleXMLLoadComplete);
			l.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		
		private function handleIOError(e:IOErrorEvent):void 
		{
			error_txt.text = e.toString();
			trace(e);
		}
		
		private function handleXMLLoadComplete(e:Event):void 
		{
			bannerXML = new XML(e.target.data);
			trace(bannerXML.@transitionTime);
			
			setupSlides();
		}
		
		private function setupSlides():void
		{
			var mainSlideLength = bannerXML.slide.length();
			trace("Banner slide length = " + mainSlideLength);
			slides = new Vector.<Slide>();
			for (var i:int = 0; i < mainSlideLength; i++)
			{
				trace("Description = " + bannerXML.slide[i].@description);
				var slide:Slide = new Slide(bannerXML.slide[i], bannerXML.slide[i].@title, bannerXML.slide[i].@description, bannerXML.slide[i].@link);
				trace("image path added = " + bannerXML.slide[i]);
				slides.push(slide);
				slide.x = BANNER_WIDTH * i;
				slideContainer_mc.addChild(slide);
			}
			
			transitionTimer = new Timer(parseInt(bannerXML.@transitionTime));
			transitionTimer.addEventListener(TimerEvent.TIMER, handleTransitionTimer);
			
			//Init
			currentSlide = new int(1);
			transitionTimer.start();
			slides[currentSlide - 1].loadImage();
		}
		
		private function handleTransitionTimer(e:TimerEvent):void 
		{
			trace("Transition");
			if (slides[currentSlide - 1].imageDisplayed) //Check to see if image loaded or not before transitioning to new image.
			{
				trace("Image is displayed");
				//slides[currentSlide - 1].reset();
				if (currentSlide == slides.length)
				{
					trace("Hit max number of slides. reseting.");
					currentSlide = 0;
				}
				currentSlide++;
				
				transitionTween = new Tween(slideContainer_mc, "x", Strong.easeOut, slideContainer_mc.x, ((currentSlide - 1) * BANNER_WIDTH) * -1, 3, true);
				if (!slides[currentSlide - 1].imageLoading)
				{
					slides[currentSlide - 1].loadImage();
				}
				
			}
			
		}
		
		public static function resizeMe(mc:DisplayObject , maxW:Number, maxH:Number = 0, constrainProportions:Boolean = true):void
		{
			maxH = maxH == 0 ? maxW : maxH;
			mc.width = maxW;
			mc.height = maxH;
			if (constrainProportions)
			{
				mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;
			}
		}
		
	}

}