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

	import com.myavatareditor.air.fileio.FileInvoke;
	import com.myavatareditor.data.AvatarUtils;
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.data.parsers.GenericData;
	import flash.system.Capabilities;
	
	/**
	 * 
	 */
	public class Initializer implements IInitialize {
		
		/**
		 * Creates an instance of an initializer for the passed in
		 * target.  Different initializers are used in different
		 * situations depending on the environment being used to 
		 * playback the SWF.  More specifically, WebInvoke instances
		 * are created for SWFs run in the browser and FileInvoke
		 * instances are used for AIR applications.
		 * @param	target
		 * @return
		 */
		public static function create(target:IHasAvatar):IInitialize {
			if (!target) return null;
			
			var initializer:IInitialize;
			
			switch (Capabilities.playerType){
				
				case "Desktop": // AIR version
					initializer = new FileInvoke(target);
					break;
				
				default:
					initializer = new WebInvoke(target);
					break;
			}
			
			return initializer;
		}
		
		
		
		public var target:IHasAvatar;
		
		public function Initializer(target:IHasAvatar) {
			this.target = target;
		}
		
		public function initialize():void {
			if (!target || !target.avatarData) return;
			var data:* = getCharacterData();
			if (data){
				new GenericData().parse(data, target.avatarData);
				target.draw();
			}
		}
		
		public function getCharacterData():* {
			var data:* = null;
			
			// last saved character in shared object if available
			if (target.fileManager) {
				data = target.fileManager.getLocal();
				if (data is Array){
					data = data[0];
				}
			}
			
			return data || AvatarUtils.DEFAULT_BOY;
		}
	}
}