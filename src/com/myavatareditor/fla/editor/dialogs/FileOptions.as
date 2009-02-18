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
package com.myavatareditor.fla.editor.dialogs {
	
	import com.myavatareditor.data.parsers.GenericData;
	import com.myavatareditor.fileio.FileManager;
	import com.myavatareditor.fla.character.AvatarSWF;
	import com.myavatareditor.fla.editor.EditorSWF;
	import com.myavatareditor.fla.controls.CheckBox;
	import com.myavatareditor.fla.controls.ColorSlider;
	import com.myavatareditor.fla.controls.NavigationButton;
	import com.myavatareditor.fla.controls.ScrollBar;
	import com.myavatareditor.fla.controls.RampSlider;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	

	
	/**
	 * The File options of the Avatar Editor which provides
	 * access to file operations such as loading and 
	 * saving Avatar data and exporting the Avatar character
	 * as a bitmap image.
	 *
	 * Unlike the main Avatar interface, each screen within
	 * the File options 'dialog' is handled within this
	 * single class and not in separate related classes.
	 */
	public class FileOptions extends MovieClip {
		
		public var editor:EditorSWF;
		
		public var currentPage:AbstractOptionsGUI;
		public var pages:Array = [];
		
		// elements within the timeline
		// menu
		public var actionLoadAvatar:MovieClip;
		public var actionSaveAvatar:MovieClip;
		public var navXML:NavigationButton;
		public var navClear:NavigationButton;
		public var navImage:NavigationButton;
		public var informationText:TextField;
		public var versions:TextField;
		public var previewHolder:MovieClip;
		// xml
		public var arrowUp:MovieClip;
		public var arrowDown:MovieClip;
		public var navFile:NavigationButton;
		public var actionSaveXML:MovieClip;
		public var xmlText:TextField;
		public var scrollBar:ScrollBar;
		// export image
		public var actionImage:MovieClip;
		public var exportPreview:MovieClip;
		public var oversizeTimes:TextField;
		public var sizeScale:RampSlider;
		public var sizeOutput:TextField;
		public var zoomScale:RampSlider;
		public var zoomOutput:TextField;
		public var bgColor:TextField;
		public var colorSlider:MovieClip;
		public var previewCharGraphics:AvatarSWF;
		public var jpegCheck:CheckBox;
		public var pngCheck:CheckBox;
		public var backgroundCheck:CheckBox;
		public var bodyCheck:CheckBox;
		public var shadowCheck:CheckBox;
		
		public dynamic function FileOptions(){
			stop();
			
			editor = EditorSWF(parent);
			editor.fileManager.addEventListener(Event.COMPLETE, loadAvatarCompleteHandler, false, 0, true);
			editor.fileManager.addEventListener(Event.CANCEL, loadAvatarCompleteHandler, false, 0, true);
			editor.fileManager.addEventListener(ErrorEvent.ERROR, loadAvatarCompleteHandler, false, 0, true);
			
			// setup page managers
			pages[1] = null;
			pages[2] = new OptionsMenu(this);
			pages[3] = new OptionsXML(this);
			pages[4] = new OptionsExportImage(this);
			pageInit();
		}
		
		public function pageInit():void {
			// initialize new page
			currentPage = pages[currentFrame] as AbstractOptionsGUI;
			if (currentPage)
				currentPage.init();
		}
		private function pageFini():void {
			// clean up current page
			if (currentPage)
				currentPage.fini();
		}
		
		// Navigation overrides
		public override function gotoAndStop(frame:Object, scene:String = null):void {
			pageFini();
			super.gotoAndStop(frame, scene);
			pageInit();
		}
		public override function nextFrame():void {
			gotoAndStop(currentFrame + 1);
		}
		public override function prevFrame():void {
			gotoAndStop(currentFrame - 1);
		}
		
		/**
		 * Shows the file menu.
		 */
		public function display():void {
			gotoAndStop("frameFile");
		}
			
		private function loadOpenedAvatar(list:Array):void {
			if (list.length) {
				// for now, only take the first
				editor.fileManager.loadURL(list[0]);
			}
		}
		public function loadAvatarCompleteHandler(event:Event):void {
			
			if (event.type == Event.COMPLETE) {
				
				new GenericData().parse(editor.fileManager.data, editor.avatarData);
				editor.draw();
				
				if (currentPage is OptionsMenu && previewHolder.numChildren) {
					OptionsMenu(currentPage).generateFrontPagePreview();
				}
			}
		}
	}
}