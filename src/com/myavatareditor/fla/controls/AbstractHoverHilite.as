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
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * Base class for simple controls within the 
	 * Avatar Editor interface that display a highlighted
	 * color when the mouse rolls over them
	 */
	public class AbstractHoverHilite extends MovieClip {
		
		/**
		 * Constructor for AbstractHoverHilite; assigns
		 * necessary event handlers to provide
		 * hover functionality to the current instance
		 */
		public function AbstractHoverHilite() {
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, pressHilite, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, hoverHilite, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, unHoverHilite, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, hoverHilite, false, 0, true);
		}
		private function hoverHilite(event:MouseEvent):void {
			transform.colorTransform = new ColorTransform(1, 1, 1, alpha, 20, 20, 20, 0);
		}
		private function pressHilite(event:MouseEvent):void {
			transform.colorTransform = new ColorTransform(1, 1, 1, alpha, -20, -20, -20, 0);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, releaseOutHilite, false, 0, true);
			removeEventListener(MouseEvent.ROLL_OVER, hoverHilite, false);
			removeEventListener(MouseEvent.ROLL_OUT, unHoverHilite, false);
		}
		private function unHoverHilite(event:MouseEvent):void {
			transform.colorTransform = new ColorTransform(1, 1, 1, alpha, 0, 0, 0, 0);
		}
		private function releaseOutHilite(event:MouseEvent):void {
			if (event.target != this){
				transform.colorTransform = new ColorTransform(1, 1, 1, alpha, 0, 0, 0, 0);
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, releaseOutHilite, false);
			addEventListener(MouseEvent.ROLL_OVER, hoverHilite, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, unHoverHilite, false, 0, true);
		}
	}
}
