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
package com.myavatareditor.air.fileio {
	
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.fileio.WebInvoke;
	import flash.events.InvokeEvent;
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	/**
	 * Invokes Avatar data from a Desktop application from the
	 * execution of an associated file by the OS.
	 */
	public class FileInvoke extends WebInvoke {
		
		private var dragDropInvoker:FileDragDrop;
		private var fileData:String;
		private var initReady:Boolean = false;
		
		public function FileInvoke(target:IHasAvatar) {
			super(target);
			
			// support for drag and drop file loading
			dragDropInvoker = new FileDragDrop(target);
						
			// get application invoke events (from file exec)
			var app:NativeApplication = NativeApplication.nativeApplication;
			app.addEventListener(InvokeEvent.INVOKE, invokeHandler, false, 0, true);
		}
		
		public override function initialize():void {
			initReady = true;
			
			// if fileData is a valid path, use it to
			// initialize the editor
			if (target && fileData){
				var dataFile:File = new File(fileData);
				if (dataFile.exists){
					
					// initializing handled by loading file url
					target.fileManager.loadURL(fileData);
					NativeApplication.nativeApplication.activate();
					return;
				}
			}
			
			// fallback to inherited version of initialize
			super.initialize();
		}
		
		public override function getCharacterData():* {
			// assume fileData has been set from
			// invokeHandler - this should occur immediately
			// upon instantiation when listener is set
			return fileData || super.getCharacterData();
		}
		
		protected function invokeHandler(event:InvokeEvent):void {
			if (event.arguments.length == 0) return;
			
			// load first argument data
			fileData = event.arguments[0];
			
			// focus the application
			var app:NativeApplication = NativeApplication.nativeApplication;
			app.activate();
			
			// assuming initialize has been called at least once
			// we will auto-initialize during new invoke events
			if (initReady) initialize();
		}
	}
}