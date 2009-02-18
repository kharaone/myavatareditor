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
package com.myavatareditor.fla {
	
	import com.myavatareditor.data.AvatarData;
	import com.myavatareditor.data.AvatarUtils;
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.data.parsers.GenericData;
	import com.myavatareditor.data.parsers.AvatarEditorXML;
	import com.myavatareditor.data.parsers.HexCodeString;
	import com.myavatareditor.data.parsers.ConsoleBinary;
	import com.myavatareditor.external.JavaScriptAPI;
	import com.myavatareditor.fileio.IInitialize;
	import com.myavatareditor.fileio.Initializer;
	import com.myavatareditor.fileio.FileManager;
	import com.myavatareditor.fla.character.AvatarCharacter;
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	
	/**
	 * Core API for editor and avatar character SWFs (avatar managers)
	 * - the common APIs of what is required for implementation by 
	 * IHasAvatar.
	 */
	public class AvatarManagerCore extends MovieClip {
		
		public var initializer:IInitialize;
		public var version:String = "0"; // assume versionText provides this
		
		/**
		 * Avatar data relating to the avatar being displayed.
		 * To be overriden by subclasses.
		 */
		public function get avatarData():AvatarData { return null; }
		public function set avatarData(value:AvatarData):void {}
		
		/**
		 * Manages file IO for avatar characters.
		 */
		public function get fileManager():FileManager {
			return _fileManager;
		}
		private var _fileManager:FileManager = new FileManager();
		
		/**
		 * Source for an avatar's data.  By default, this is null
		 * until set.  When set, the data, beit XML, a hex string,
		 * a binary, or whathaveyou, will be parsed and the avatar
		 * data updated.  The value of avatarSource will always be
		 * the same as the value it was set.  For the actual avatar
		 * data, use the avatarData property.
		 */
		public function get avatarSource():* {
			return _avatarSource;
		}
		public function set avatarSource(value:*):void {
			try {
				new GenericData().parse(value, avatarData);
				_avatarSource = value;
				draw();
			}catch (error:Error){
				throw error;
			}
		}
		private var _avatarSource:* = null;
		
		/**
		 * Accesses XML parser to set and get XML data from
		 * an avatar.
		 */
		public function get avatarXML():XML {
			try {
				return new AvatarEditorXML().write(avatarData);
			}catch (error:Error){}
			return null;
		}
		public function set avatarXML(xml:XML):void {
			try {
				new AvatarEditorXML().parse(xml, avatarData);
				draw();
			}catch (error:Error){}
		}
		
		/**
		 * Accesses hex code parser to set and get hex string
		 * data from an avatar.
		 */
		public function get avatarHex():String {
			try {
				return new HexCodeString().write(avatarData);
			}catch (error:Error){}
			return null;
		}
		public function set avatarHex(hex:String):void {
			try {
				new HexCodeString().parse(hex, avatarData);
				draw();
			}catch (error:Error){}
		}
		
		/**
		 * Accesses binary parser to set and get binary byte array
		 * data from an avatar.
		 */
		public function get avatarBinary():ByteArray {
			try {
				return new ConsoleBinary().write(avatarData);
			}catch (error:Error){}
			return null;
		}
		public function set avatarBinary(bytes:ByteArray):void {
			try {
				new ConsoleBinary().parse(bytes, avatarData);
				draw();
			}catch (error:Error){}
		}
		
		/**
		 * Returns the value of an avatar characteristic by name.
		 */
		public function getAvatarValue(name:String):* {
			if (name in avatarData){
				return avatarData[name];
			}
			return null;
		}
		
		/**
		 * Sets the value of an avatar characteristic by name. If the
		 * value is not within the allowed limits, it is clamped within
		 * those limits.
		 * @param	name
		 * @param	value
		 */
		public function setAvatarValue(name:String, value:*):void {
			AvatarCharacter.setValueInRange(name, value, avatarData);
		}
		
		/**
		 * Constructor.
		 */
		public function AvatarManagerCore() {
			super();
			stop();
			
			initializer = Initializer.create(this as IHasAvatar);
		}
		
		public function initialize():void {
			if (initializer){
				initializer.initialize();
			}
			
			// add JS APIs if not loaded into anything
			if (loaderInfo && loaderInfo.loader == null){ 
				JavaScriptAPI.initialize(this as IHasAvatar);
			}
		}
		
		/**
		 * Randomizes an avatar using a smart randomize.
		 */
		public function randomizeAvatar():void {
			AvatarUtils.smartRandomize(avatarData);
			draw();
		}
		
		/**
		 * Causes avatar and/or interface to update. To be overridden
		 * by subclasses.
		 * @param	quickDraw When true, implies that CPU or otherwise
		 * intensive actions should not be performed.
		 */
		public function draw(quickDraw:Boolean = false):void {}
	}
	
}