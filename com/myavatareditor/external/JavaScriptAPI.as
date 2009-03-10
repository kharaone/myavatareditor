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
package com.myavatareditor.external {
	
	import com.myavatareditor.data.AvatarUtils;
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.data.parsers.GenericData;
	import com.myavatareditor.data.parsers.HexCodeString;
	import com.myavatareditor.data.parsers.AvatarEditorXML;
	import flash.external.ExternalInterface;
	
	/**
	 * Includes JavaScript callbacks for accessing and setting 
	 * data or invoking commands related to an avatar.
	 */
	public class JavaScriptAPI {
		
		public static var hasInitialized:Boolean = false;
		private static var target:IHasAvatar;
		
		/**
		 * Setsup JavaScript callbacks.  This only happens once. If 
		 * initialize is called multiple times, any call beyond the first
		 * is ignored.
		 * @param	target The IHasAvatar instance being controlled or
		 * queried by the JavaScript calls.  Whenever initialize is called
		 * any existing target will be replaced with the new target.
		 */
		public static function initialize(target:IHasAvatar):void {
			if (!target || hasInitialized) return;
			hasInitialized = true;
			
			JavaScriptAPI.target = target;
			if (ExternalInterface.available){
				initExternalInterface();
			}
		}
		
		private static function initExternalInterface():void {
			try {
				ExternalInterface.addCallback("getAvatarValue",		jsGetAvatarValue);
				ExternalInterface.addCallback("setAvatarValue",		jsSetAvatarValue);
				ExternalInterface.addCallback("getAvatarHex",		jsGetAvatarHex);
				ExternalInterface.addCallback("setAvatarHex",		jsSetAvatarHex);
				ExternalInterface.addCallback("getAvatarXML",		jsGetAvatarXML);
				ExternalInterface.addCallback("setAvatarXML",		jsSetAvatarXML);
				ExternalInterface.addCallback("setAvatarSource",	jsSetAvatarSource);
				ExternalInterface.addCallback("randomizeAvatar",	jsRandomizeAvatar);
				ExternalInterface.addCallback("draw",				jsDraw);
			}catch (error:Error) {}
		}
		
		private static function jsGetAvatarValue(name:String = null):String {
			try {
				return target.getAvatarValue(name);
			}catch (error:Error){}
			return null;
		}
		
		private static function jsSetAvatarValue(name:String = null, value:* = null, ...rest):void {
			try {
				target.setAvatarValue(name, value);
			}catch (error:Error){}
		}
		
		private static function jsGetAvatarHex(...rest):String {
			try {
				return new HexCodeString().write(target.avatarData);
			}catch (error:Error){}
			return null;
		}
		
		private static function jsSetAvatarHex(hex:String = null, ...rest):void {
			try {
				new HexCodeString().parse(hex, target.avatarData);
				target.draw();
			}catch (error:Error){}
		}
		
		private static function jsGetAvatarXML(...rest):String {
			try {
				return new AvatarEditorXML().write(target.avatarData);
			}catch (error:Error){}
			return null;
		}
		
		private static function jsSetAvatarXML(xml:String = null, ...rest):void {
			try {
				new AvatarEditorXML().parse(XML(xml), target.avatarData);
				target.draw();
			}catch (error:Error){}
		}
		
		private static function jsSetAvatarSource(data:String = null, ...rest):void {
			try {
				new GenericData().parse(data, target.avatarData);
				target.draw();
			}catch (error:Error){}
		}
		
		private static function jsRandomizeAvatar(...rest):void {
			try {
				AvatarUtils.smartRandomize(target.avatarData);
				target.draw();
			}catch (error:Error){}
		}
		
		private static function jsDraw(quickDraw:Boolean = false, ...rest):void {
			try {
				target.draw(quickDraw);
			}catch (error:Error){}
		}
	}
}