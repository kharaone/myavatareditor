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
	
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * Manages file handling between a SWF and a user's computer or
	 * locations on the web.
	 */
	public	class		FileManager
			extends		EventDispatcher {
		
		
		public static const SAVE_OPERATION:String = "saveOperation";
		public static const LOAD_OPERATION:String = "loadOperation";
		
		public static var jpegCompression:Number = 100;
		
		public static function getDataFormat(path:String):String {
			var type:String = URLLoaderDataFormat.BINARY;
			
			var endDot:int = path.lastIndexOf(".");
			if (endDot > 0){
				var ext:String = path.substr(endDot + 1);
				switch(ext.toLowerCase()){
					
					case "txt":
					case "text":
					case "xml":
						type = URLLoaderDataFormat.TEXT;
						break;
						
					default:
						break;
				}
			}
			
			return type;
		}
		
		public static function getFileName(data:*, meta:Object = null):* {
			var baseName:String	= "avatar";
			var type:String		= "txt";
			if (meta){
				if (meta.name){
					baseName = meta.name;
				}
				if (meta.type){
					return baseName + "." + meta.type;
				}
			}
			
			if (data is XML) {
				type = "xml";
			}else if (data is BitmapData) {
				type = "jpg";
			}else if (data is ByteArray) {
				type = "mae";
			}
			
			// for strings, see if it parses to XML
			if (data is String) {
				try {
					if (XML(data)){
						type = "xml";
					}
				}catch (error:Error){ }
			}
			
			return baseName +"." + type;
		}
		
		public static function prepareSaveData(data:*, meta:Object = null):* {
			// save avatar binary
			if (data is XML) {
				return data.toXMLString();
			// save bitmap
			}else if (data is BitmapData) {
				if (meta && meta.type == "png") {
					return PNGEncoder.encode(BitmapData(data));
				}else{
					var jpeg:JPGEncoder = new JPGEncoder(jpegCompression);
					return jpeg.encode(BitmapData(data));
				}
			}
			// default data
			return data;
		}
		
		/**
		 * Default local shared object id for saving
		 * and loading avatars from the users hard drive
		 * using SharedObject.
		 */
		public var localSOID:String = "localAvatars";
		
		/**
		 * Indicates the current operation of the file manager.
		 * This may be SAVE_OPERATION or LOAD_OPERATION
		 */
		public function get operation():String {
			return _operation;
		}
		private var _operation:String;
		
		/**
		 * The data last loaded into the file manager.
		 */
		public function get data():* {
			return _data;
		}
		private var _data:*;
		
		
		private var ref:FileReference		= new FileReference();
		private var urlLoader:URLLoader		= new URLLoader();
				
		public function FileManager() {
			ref.addEventListener(Event.SELECT, selectHandler);
			ref.addEventListener(Event.COMPLETE, completeHandler);
			ref.addEventListener(IOErrorEvent.IO_ERROR, dispatchError);
			ref.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchError);
			
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, dispatchError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchError);
		}
		
		/**
		 * Invokes a save dialog for a user to save a file
		 * from the SWF onto their computer.
		 */
		public function save(data:*, meta:Object = null):void {
			_operation = SAVE_OPERATION;
			var saveData:* = prepareSaveData(data, meta);
			var defaultFileName:String = getFileName(data, meta);
			try {
				ref.save(saveData, defaultFileName);
				_data = saveData;
			}catch (error:Error) {
				dispatchError(new ErrorEvent(ErrorEvent.ERROR, false, false, error.message));
			}
		}
		
		/**
		 * Invokes a browse dialog for a user to load a file
		 * from their computer into the SWF.
		 */
		public function load():void {
			_operation	= LOAD_OPERATION;
			_data		= null;
			ref.browse();
		}
		
		/**
		 * Loads an avatar file from the specified URI.
		 * @param	url Path of avatar file to load.
		 */
		public function loadURL(url:String):void {
			
			_operation				= LOAD_OPERATION;
			_data					= null;
			urlLoader.dataFormat	= getDataFormat(url);
			
			try {
				urlLoader.load(new URLRequest(url));
			}catch (error:Error) {
				dispatchError(new ErrorEvent(ErrorEvent.ERROR, false, false, error.message));
			}
		}

		/**
		 * Gets previously saved data from the local machine's shared
		 * object and returns it
		 * @return The data saved by the last call to setLocal.
		 */
		public function getLocal(id:String = null):* {
			if (!id) id = localSOID;
			try {
				var localAvatars:SharedObject = SharedObject.getLocal(id, "/");
				var avatarData:* = localAvatars.data.avatarData;
				localAvatars = null;
				return avatarData;
			}catch(error:Error) {}
			return null;
		}

		/**
		 * Saves avatar data, such as an array of hex codes, to the local
		 * shared object specific to this machine.
		 * @param	data A structure containing avatar data.
		 * @return True if the save was successful, false if not.
		 */
		public function setLocal(data:*, id:String = null):Boolean {
			if (!id) id = localSOID;
			if (!data) return false;
			try {
				var localAvatars:SharedObject = SharedObject.getLocal(id, "/");
				localAvatars.data.avatarData = data;
				localAvatars = null;
			}catch(error:Error) {
				return false;
			}
			
			return true;
		}
		
		protected function selectHandler(event:Event):void {
			if (_operation != LOAD_OPERATION) return;
			
			try {
				ref.load();
			}catch (error:Error) {
				dispatchError(new ErrorEvent(ErrorEvent.ERROR, false, false, error.message));
			}
		}
		
		protected function completeHandler(event:Event):void {
			// only care about completion events
			// for load _operations
			if (_operation != LOAD_OPERATION) return;
			
			_data = event.currentTarget.data;
			
			// For FileReference data, convert the returned binary data
			// to a string if the file is recognized as being a string format
			if (_data is ByteArray && event.currentTarget is FileReference){
				var ref:FileReference = FileReference(event.currentTarget);
				if (getDataFormat(ref.name) == URLLoaderDataFormat.TEXT){
					var bytes:ByteArray = ByteArray(_data);
					_data = bytes.readUTFBytes(bytes.length);
				}
			}
			
			dispatchEvent(event);
		}
		
		protected function dispatchError(event:ErrorEvent):void {
			_data = null;
			dispatchEvent(event);
		}
	}
}