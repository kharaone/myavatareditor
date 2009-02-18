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
	 * A control consisting of 3 individual sliders used to
	 * specify a color in RGB.
	 */
	public class ColorSlider extends MovieClip {
		
		public static const START_DRAG:String	= "startDrag";
		
		public var redDragger:MovieClip;
		public var greenDragger:MovieClip;
		public var blueDragger:MovieClip;
		public var minValue:Number				= 0;
		public var maxValue:Number				= 0xFFFFFF;
			
		private var redDraggerValue:Number		= 0;
		private var greenDraggerValue:Number	= 0;
		private var blueDraggerValue:Number		= 0;
		private var minSlide:Number				= -115.5;
		private var maxSlide:Number				= 115.5;
		private var minSliderValue:Number		= 0;
		private var maxSliderValue:Number		= 0xFF;
		private var currentDragger:MovieClip;
		
		public function get hexValue():String {
			var str:String = value.toString(16);
			while (str.length < 6) str = "0"+str;
			return str;
		}
			
		public function get value():Number {
			return int((redDraggerValue << 16) | (greenDraggerValue << 8) | blueDraggerValue);
		}
		public function set value(n:Number):void {
			var _value:Number = this.value;
			if (n == _value) return;
			
			if (n < minValue)		_value = minValue;
			else if (n > maxValue)	_value = maxValue;
			else					_value = n;
			
			redDraggerValue		= (_value >> 16);
			greenDraggerValue	= (_value >> 8)	& 0xFF;
			blueDraggerValue	= (_value)		& 0xFF;
			redDragger.x		= minSlide + (maxSlide - minSlide)*(redDraggerValue/(maxSliderValue - minSliderValue));
			greenDragger.x		= minSlide + (maxSlide - minSlide)*(greenDraggerValue/(maxSliderValue - minSliderValue));
			blueDragger.x		= minSlide + (maxSlide - minSlide)*(blueDraggerValue/(maxSliderValue - minSliderValue));
		}
			
		public function ColorSlider(){
			redDragger.addEventListener(MouseEvent.MOUSE_DOWN, startDragging, false, 0, true);
			greenDragger.addEventListener(MouseEvent.MOUSE_DOWN, startDragging, false, 0, true);
			blueDragger.addEventListener(MouseEvent.MOUSE_DOWN, startDragging, false, 0, true);
		}
		
		private function startDragging(event:MouseEvent):void {
			currentDragger = MovieClip(event.currentTarget);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, duringDragging, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDragging, false, 0, true);
			dispatchEvent(new Event(START_DRAG));
		}
		
		private function duringDragging(event:MouseEvent):void {
			var loc:Number = mouseX;
			if (loc < minSlide)			loc = minSlide;
			else if (loc > maxSlide)	loc = maxSlide;
			
			this[currentDragger.name+"Value"] = minSliderValue + (maxSliderValue - minSliderValue) * (loc - minSlide)/(maxSlide - minSlide);
			currentDragger.x = loc;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function endDragging(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, duringDragging, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endDragging, false);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}