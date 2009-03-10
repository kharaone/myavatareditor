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

	import com.myavatareditor.fla.editor.EditorSWF;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Tabs used for navigation of the feature sets
	 * available in the main Avatar Editor interface.
	 */
	public class Tab extends AbstractHoverHilite {
		
		public var frameName:String;
		private var editor:EditorSWF;
		
		public function Tab(){
			buttonMode	= true;
			editor		= EditorSWF(parent);
			frameName	= "frame" + name.slice(3);
			addEventListener(MouseEvent.CLICK, navigateToTabHandler, false, 0, true);
		}
		
		public function navigateToTabHandler(event:Event):void {
			editor.gotoAndStop(frameName);
		}
	}
}