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

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Tabs used for navigation of the feature sets
	 * available in the main Avatar Editor interface.
	 */
	public class RampSlider extends MovieClip {
		
		public static const START_DRAG:String	= "startDrag";
		
		public var dragger:MovieClip;
			
		public var minValue:Number	= 0;
		public var maxValue:Number	= 100;
			
		private var minSlide:Number	= 0;
		private var maxSlide:Number	= 230;
		
			
		public function get value():Number {
			return _value;
		}
		public function set value(n:Number):void {
			if (n == _value) return;
			if (n < minValue) _value = minValue;
			else if (n > maxValue) _value = maxValue;
			else _value = n;
			dragger.x = (minSlide + (maxSlide - minSlide)) * (_value - minValue)/(maxValue - minValue);
		}
		private var _value:Number	= 0;
		
		public function RampSlider(){
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, startDragging, false, 0, true);
		}
		
		private function startDragging(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, duringDragging, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDragging, false, 0, true);
			dispatchEvent(new Event(START_DRAG));
		}
		
		private function duringDragging(event:MouseEvent):void {
			var loc:Number = mouseX;
			if (loc < minSlide) loc = minSlide;
			else if (loc > maxSlide) loc = maxSlide;
			
			_value = minValue + (maxValue - minValue) * (loc - minSlide)/(maxSlide - minSlide);
			dragger.x = loc;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function endDragging(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, duringDragging, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endDragging, false);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}