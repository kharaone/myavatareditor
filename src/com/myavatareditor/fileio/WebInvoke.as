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
package com.myavatareditor.fileio {
	
	import com.myavatareditor.data.AvatarData;
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.fla.dialogs.Alert;
	import flash.display.DisplayObject;
	
	/**
	 * Defines initialization for the an avatar controller
	 * such as the editor when being run in the context of
	 * a web page.  Invocation from a web page means looking
	 * for character data in the query variables of the URL
	 * string as well as the shared object (as a fallback).
	 */
	public class WebInvoke extends Initializer {
		
		public function WebInvoke(target:IHasAvatar) {
			super(target);
		}
		
		public override function initialize():void {
			super.initialize();
		}
		
		public override function getCharacterData():* {
			var data:*;
			
			// attempt to retrieve character info from FlashVars
			// (query string parameters)
			try {
				var params:Object = DisplayObject(target).loaderInfo.parameters;
				data = params.avatar || params.mii; // fallback to mii if avatar not there
			}catch (error:Error){}
			
			// fallback to default avatar data if no params
			return data || super.getCharacterData();
		}
	}
}