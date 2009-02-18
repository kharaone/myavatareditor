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
	import flash.display.InteractiveObject;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	/**
	 * Manages the saving of Avatar data from a an Avatar
	 * client to the users hard drive.  This data
	 * can be in the form of a binary Avatar file, an XML
	 * file, or a bitmap image file.
	 */
	public class FileDragDrop {
	
		private var target:IHasAvatar;
			
		public function FileDragDrop(target:IHasAvatar){
			this.target = target;
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler, false, 0, true);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler, false, 0, true);
		}
		
		protected function dragEnterHandler(event:NativeDragEvent):void {
			if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)){
				NativeDragManager.acceptDragDrop(InteractiveObject(event.currentTarget));
			}
		}
		
		protected function dragDropHandler(event:NativeDragEvent):void {
			NativeDragManager.dropAction = NativeDragActions.COPY;
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (files && files.length){
				var path:String = File(files[0]).url;
				target.fileManager.loadURL(path);
				NativeApplication.nativeApplication.activate();
			}
		}		
	}
}