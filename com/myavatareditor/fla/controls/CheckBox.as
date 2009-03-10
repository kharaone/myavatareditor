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
	import flash.text.TextField;
	
	/**
	 * Basic CheckBox control.
	 */
	public class CheckBox extends ToggleView {
		
		public static const CHECK_STYLE:int	= 2;
		public static const BOX_STYLE:int	= 3;
		
		public var label:TextField;
		
		/**
		 * Indicates whether or not the check box is checked.
		 */
		public function get checked():Boolean {
			return _checked;
		}
		public function set checked(value:Boolean):void {
			if (value == _checked) return;
			_checked = value;
			gotoAndStop(_checked ? _style : 1);
			dispatchEvent(new Event(Event.CHANGE));
		}
		private var _checked:Boolean = false;
		
		/**
		 * Determines what the checkbox will look like when it
		 * is checked. Options include CHECK_STYLE and
		 * BOX_STYLE.
		 */
		public function get style():int {
			return _style;
		}
		public function set style(value:int):void {
			if (value == _style) return;
			if (value < 2) return;
			if (value > 3) return;
			_style = value;
			if (_checked) gotoAndStop(_style);
		}
		private var _style:int = CHECK_STYLE;
		
		
		public function CheckBox() {
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		
		protected function clickHandler(event:MouseEvent):void {
			checked = !checked;
		}
	}
}