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
package com.myavatareditor.fla.dialogs {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * Alert instances are to be added to the root movie clip to be
	 * displayed over all over content.  They display a message that is
	 * dismissed with an OK button.  The graphics within the Alert symbol
	 * in the FLA library determines whether or not it blocks events to
	 * controls below it.  If interaction is intended to be blocked, 
	 * the Alert should include an InteractiveObject instance (such as a
	 * Sprite) that covers the entire area of the screen.
	 */
	public class Alert extends MovieClip {
		
		public var okButton:MovieClip;
		public var label:TextField;
			
		/**
		 * Message to display in the alert dialog
		 */
		public function get message():String {
			return label.text;
		}	
		public function set message(s:String):void {
			label.text = s;
		}
		
		/**
		 * Constructor for creating new alert
		 * dialogs to be used for displaying messages.
		 * @param message The message to display in
		 * 		the alert dialog.
		 */
		public function Alert(message:String = ""){
			if (message) this.message = message;
			okButton.addEventListener(MouseEvent.CLICK, clickOkHandler, false, 0, true);
		}
		
		protected function clickOkHandler(event:MouseEvent):void {
			// assumes no responsibility of removing other references.
			// when removed, Alert is considered unneeded
			okButton.removeEventListener(MouseEvent.CLICK, clickOkHandler, false);
			if (parent) parent.removeChild(this);
		}
	}
}