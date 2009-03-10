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
	
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.data.parsers.HexCodeString;
	import com.myavatareditor.display.DisplayUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * The My Avatar Editor logo. When clicked, it will take you to
	 * the main web site, www.myavatareditor.com loading in the 
	 * character currently loaded.
	 */
	public class LogoLink extends Sprite {
		
		/**
		 * Base url used for the link of the logo. This will
		 * be added to with the avatar query variable for loading
		 * the current avatar data into editor.
		 */
		public var baseURL:String = "http://www.myavatareditor.com/";
		
		// timeline instances
		public var areaMap:MovieClip;
		
		public function LogoLink() {
			areaMap.alpha = 0;
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			buttonMode = true;
		}
		
		protected function clickHandler(event:MouseEvent):void {
			var url:String = baseURL;
			
			// find the avatar data of the SWF host
			// and convert it to a hex code string to load
			// into the editor when the url is loaded
			var avatarHost:IHasAvatar = DisplayUtils.findAncestorByType(IHasAvatar, this) as IHasAvatar;
			if (avatarHost){
				var code:String = new HexCodeString().write(avatarHost.avatarData);
				if (code) url += "?avatar=" + code;
			}
			try {
				navigateToURL(new URLRequest(url), "_blank");
			}catch (error:Error){}
		
		}
	}
	
}