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
	
	import com.myavatareditor.data.parsers.ConsoleBinary;
	import com.myavatareditor.display.BitmapUtils;
	import com.myavatareditor.fla.controls.NavigationButton;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Manager for the main menu portion of the File Options screen.
	 * This handles both the navigation between the other file screens
	 * as well as core load/save operations for avatar binary files.
	 */
	public class OptionsMenu extends AbstractOptionsGUI {
			
		private var actionLoadAvatarInfo:String	= "Load Avatar characters from your computer into the Avatar Editor. Valid Avatar files include binary files (such as .mae) or Avatar's saved as XML.";
		private var actionSaveAvatarInfo:String	= "Save the current Avatar character to your computer as a .mae binary file. If you ever want to reload your Avatar into the editor, you can use the Load option with this file.";
		private var navXMLInfo:String			= "View the XML for your current Avatar character. You can edit the XML to have its changes affect your Avatar or save the XML to your computer as an .xml file.";
		private var navImageInfo:String			= "Export your Avatar character to your computer as a bitmap image.  You can choose between JPEG or PNG formats.";
			
		public function OptionsMenu(options:FileOptions) {
			super(options);
		}
		
		public override function init():void {
			super.init();
			options.actionLoadAvatar.addEventListener(MouseEvent.CLICK, loadAvatarFileHandler, false, 0, true);
			options.actionSaveAvatar.addEventListener(MouseEvent.CLICK, saveAvatarFileHandler, false, 0, true);
			options.actionLoadAvatar.addEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false, 0, true);
			options.actionSaveAvatar.addEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false, 0, true);
			options.navXML.addEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false, 0, true);
			options.navImage.addEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false, 0, true);
			
			// create preview
			generateFrontPagePreview();
			
			// show versions text
			updateVersions();
		}
		
		public override function fini():void {
			options.actionLoadAvatar.removeEventListener(MouseEvent.CLICK, loadAvatarFileHandler, false);
			options.actionSaveAvatar.removeEventListener(MouseEvent.CLICK, saveAvatarFileHandler, false);
			options.actionLoadAvatar.removeEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false);
			options.actionSaveAvatar.removeEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false);
			options.navXML.removeEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false);
			options.navImage.removeEventListener(MouseEvent.ROLL_OVER, showInformationHandler, false);
			
			// attempt to cleanup preview
			try {
				var bmp:Bitmap = Bitmap(options.previewHolder.removeChildAt(0));
				bmp.bitmapData.dispose();
			}catch (error:Error){}
			
			super.fini();
		}
		
		public function generateFrontPagePreview():void {
			if (!editor.avatarSWF) return;
			if (!options.previewHolder) return;
			var bmp:Bitmap;
			if (options.previewHolder.numChildren) {
				bmp = Bitmap(options.previewHolder.getChildAt(0))
				BitmapUtils.drawCenteredIn(editor.avatarSWF, bmp.bitmapData, .3);
			}else{
				bmp = new Bitmap(BitmapUtils.createCenteredBitmapData(editor.avatarSWF, 120, 260, .3));
				options.previewHolder.addChild(bmp);
			}
		}
		
		public function updateVersions():void {
			var eVersion:String = editor.version;
			var cVersion:String = editor.avatarSWF ? editor.avatarSWF.version : "Unknown";
			
			options.versions.textColor	= (eVersion == cVersion) ? 0x666666 : 0xFF0000;
			options.versions.text		= "Editor: "+eVersion+"\nCharacter: "+cVersion;
		}
		
		protected function showInformationHandler(event:MouseEvent):void {
			var currButton:MovieClip = MovieClip(event.currentTarget);
			currButton.addEventListener(MouseEvent.ROLL_OUT, clearInformationHandler, false, 0, true);
			options.informationText.text = String(this[currButton.name+"Info"]);
		}
		protected function clearInformationHandler(event:MouseEvent):void {
			var currButton:MovieClip = MovieClip(event.currentTarget);
			currButton.removeEventListener(MouseEvent.ROLL_OUT, clearInformationHandler, false);
			if (options.informationText)
				options.informationText.text = "";
		}
		
		// file ops
		protected function loadAvatarFileHandler(event:MouseEvent):void {
			editor.fileManager.load();
		}
		
		protected function saveAvatarFileHandler(event:MouseEvent):void {
			editor.fileManager.save(new ConsoleBinary().write(editor.avatarData), getMetadata());
		}
	}
	
}