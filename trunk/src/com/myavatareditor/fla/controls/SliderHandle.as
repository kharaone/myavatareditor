/*
Copyright (c) 2009 Trevor McCauley

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. 
*/
package com.myavatareditor.fla.controls {

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/** 
	 * Slider handle for setting values for
	 * Avatar width and height
	 */
	public class SliderHandle extends AbstractHoverHilite {
		
		public var min:Number = 301;
		public var max:Number = 528;
		public var span:Number = max - min;
		public var offset:Number = 0;
			
		public function SliderHandle(){
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/** 
		 * Set's percentage for slider
		 */
		public function setPercent(percent:Number):void {
			if (isNaN(percent) || percent < 0) percent = 0;
			else if (percent > 1) percent = 1;
			x = min + span * percent;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/** 
		 * Returns percentage for slider
		 */
		public function getPercent():Number {
			return (x - min)/span;
		}
		
		private function mouseDownHandler(event:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, clearMoveHandler);
			offset = x - parent.mouseX;
		}
		
		private function clearMoveHandler(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, clearMoveHandler);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function mouseMoveHandler(event:Event):void {
			x = Math.min(Math.max(min, offset + parent.mouseX), max);
			dispatchEvent(new Event("change"));
		}
	}
}