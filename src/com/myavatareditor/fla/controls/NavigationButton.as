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
	
	
	/**
	 * Generic navigation button class..  NavigationButton
	 * instances use their instance name to determine
	 * a frame label in their parent container to which they
	 * should navigate when clicked.  The priority of these click
	 * events is -100 allowing other click listeners to fire first.
	 */
	public class NavigationButton extends MovieClip {

		private var frameName:String;
			
		public function NavigationButton() {
			if (name.indexOf("nav") == 0) {
				frameName = "frame" + name.substr(3);
				addEventListener(MouseEvent.CLICK, gotoLabelHandler, false, -100, true);
			}
		}
		
		public function gotoLabelHandler(event:MouseEvent):void {
			try {
				MovieClip(parent).gotoAndStop(frameName);
			}catch (error:Error){}
		}
	}
}