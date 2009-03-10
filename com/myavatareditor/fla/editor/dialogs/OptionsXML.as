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
	
	import com.myavatareditor.data.parsers.AvatarEditorXML;
	import com.myavatareditor.data.parsers.GenericData;
	import flash.events.MouseEvent;
	
	/**
	 * Manager for the XML screen in the file menu. This manages
	 * all of the operations and screen updates of the file menu
	 * content while in the XML screen.
	 */
	public class OptionsXML extends AbstractOptionsGUI {
		
		public var xmlVersion:String	= '<?xml version="1.0" ?>';
		public var xmlStylesheet:String	= '<?xml-stylesheet type="text/xsl" href="/xml/avatar.xsl" ?>';
		public var xmlDoctype:String	= '<!DOCTYPE avatar-collection SYSTEM "/xml/avatar.dtd" >';
		
		private var initXMLText:String;
		
		public function OptionsXML(options:FileOptions) {
			super(options);
		}
		
		public override function init():void {
			super.init();
			
			// try to set the XML text failing silently 
			// for any parser errors
			try{
				options.xmlText.text = ""
					+ xmlVersion	+ "\n"
					+ xmlStylesheet	+ "\n"
					+ xmlDoctype	+ "\n"
					+ new AvatarEditorXML().write(editor.avatarData).toXMLString();
				
				// init text is set to the xmlText text to account
				// for any TextField anomalies like new line conversions
				initXMLText = options.xmlText.text;
			}catch (error:Error){}
			
			options.navFile.addEventListener(MouseEvent.CLICK, readXMLHandler, false, 0, true);
			options.actionSaveXML.addEventListener(MouseEvent.CLICK, saveXMLHandler, false, 0, true);
			options.scrollBar.target = options.xmlText;
		}
		
		public override function fini():void {
			options.scrollBar.target = null;
			options.navFile.removeEventListener(MouseEvent.CLICK, readXMLHandler, false);
			options.actionSaveXML.removeEventListener(MouseEvent.CLICK, saveXMLHandler, false);
			super.fini();
		}
		
		/**
		 * Saves the text currently displayed within the XML text field
		 * and, if changed, parses it into the character.
		 */
		protected function readXMLHandler(event:MouseEvent):void {
			
			// only parse XML if it has changed
			var xmlText:String = options.xmlText.text;
			if (initXMLText == xmlText) return;
			
			try {
				// generic data parser is used to differentiate between
				// different XML versions
				new GenericData().parse(xmlText, editor.avatarData);
				editor.draw();
			}catch (error:Error){}
			
		}
		
		/**
		 * Saves the text currently displayed within the XML text field.
		 */
		protected function saveXMLHandler(event:MouseEvent):void {
			try {
				editor.fileManager.save(options.xmlText.text, getMetadata());
			}catch (error:Error){}
		}
	}
	
}