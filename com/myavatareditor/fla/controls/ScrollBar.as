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
	
	import com.myavatareditor.data.Range;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ScrollBar extends MovieClip {
		
		// stage instances
		public var arrowUp:MovieClip;
		public var arrowDown:MovieClip;
		public var scroller:MovieClip;
		
		private var _target:TextField;
		
		private var doScrollUpdate:Boolean = true;
		
		public function get target():TextField {
			return _target;
		}
		public function set target(t:TextField):void {
			if (_target) {
				_target.removeEventListener(Event.SCROLL, updateScrollerPosition, false);
			}
			_target = t;
			if (_target){
				_target.addEventListener(Event.SCROLL, updateScrollerPosition, false, 0, true);
			}
		}
			
		public var scrollerRange:Range = new Range(50, 274);
			
		public function ScrollBar(){
			arrowUp.addEventListener(MouseEvent.CLICK, scrollUp, false, 0, true);
			arrowDown.addEventListener(MouseEvent.CLICK, scrollDown, false, 0, true);
			scroller.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
		}
		
		private function scrollUp(event:MouseEvent):void {
			if (!target) return;
			_target.scrollV--;
		}
		private function scrollDown(event:MouseEvent):void {
			if (!target) return;
			_target.scrollV++;
		}
		private function mouseDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollDrag, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			doScrollUpdate = false;
		}
		private function scrollDrag(event:MouseEvent):void {
			if (!target) return;
			var position:Number = scrollerRange.clamp(mouseY);
			scroller.y = position;
			var targetRange:Range = new Range(1, _target.maxScrollV);
			_target.scrollV = targetRange.valueAt(scrollerRange.percentAt(position), true);
		}
		private function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollDrag, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp, false);
			doScrollUpdate = true;
		}
		
		private function updateScrollerPosition(event:Event):void {
			if (!doScrollUpdate) return;
			var targetRange:Range = new Range(1, _target.maxScrollV);
			scroller.y = scrollerRange.valueAt(targetRange.percentAt(_target.scrollV));
		}
	}
}