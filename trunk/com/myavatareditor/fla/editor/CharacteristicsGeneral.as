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
package com.myavatareditor.fla.editor {
	
	import com.myavatareditor.data.AvatarData;
	import com.myavatareditor.data.AvatarUtils;
	import com.myavatareditor.data.parsers.ConsoleBinary;
	import com.myavatareditor.fla.character.AvatarCharacter;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CharacteristicsGeneral extends AbstractCharacteristicsGUI {
			
		public function CharacteristicsGeneral(editor:EditorSWF){
			super(editor);
			colorID = "favorite";
			zoomStyle = ZOOM_FULL;
		}

		public override function init():void {
			super.init();
			
			editor.toggle_gender.addEventListener(MouseEvent.CLICK, changeToggleHandler, false, 0, true);
			editor.toggle_mingles.addEventListener(MouseEvent.CLICK, changeToggleHandler, false, 0, true);
			editor.nameText.addEventListener(Event.CHANGE, changeTextHandler, false, 0, true);
			editor.creatorNameText.addEventListener(Event.CHANGE, changeTextHandler, false, 0, true);
			editor.birthDayText.addEventListener(Event.CHANGE, changeTextAsIntHandler, false, 0, true);
			editor.birthMonthText.addEventListener(Event.CHANGE, changeTextAsIntHandler, false, 0, true);
			editor.idText.addEventListener(Event.CHANGE, changeHexHandler, false, 0, true);
			editor.clientIDText.addEventListener(Event.CHANGE, changeHexHandler, false, 0, true);
			editor.randomButton.addEventListener(MouseEvent.CLICK, randomCharacterHandler, false, 0, true);
			
			editor.nameText.addEventListener(FocusEvent.FOCUS_OUT, updateHandler, false, 0, true);
			editor.creatorNameText.addEventListener(FocusEvent.FOCUS_OUT, updateHandler, false, 0, true);
			editor.birthDayText.addEventListener(FocusEvent.FOCUS_OUT, updateHandler, false, 0, true);
			editor.birthMonthText.addEventListener(FocusEvent.FOCUS_OUT, updateHandler, false, 0, true);
			editor.idText.addEventListener(FocusEvent.FOCUS_OUT, updateHandler, false, 0, true);
			editor.clientIDText.addEventListener(FocusEvent.FOCUS_OUT, updateHandler, false, 0, true);

			editor.status_mingles.mouseEnabled	= false;
			editor.status_gender.mouseEnabled	= false;
			
			editor.nameText.maxChars			= ConsoleBinary.NAME_MAX;
			editor.creatorNameText.maxChars		= ConsoleBinary.CREATOR_NAME_MAX;
			
			editor.birthDayText.restrict		= "0-9";
			editor.birthDayText.maxChars		= 2;
			editor.birthMonthText.restrict		= "0-9";
			editor.birthMonthText.maxChars		= 2;
			
			editor.idText.restrict				= "0-9a-fA-F\\-";
			editor.idText.maxChars				= 11;
			editor.clientIDText.restrict		= "0-9a-fA-F\\-";
			editor.clientIDText.maxChars		= 11;

			setupColors(colorID);
		}
		
		public override function fini():void {
			cleanupColors(colorID);
			
			editor.toggle_gender.removeEventListener(MouseEvent.CLICK, changeToggleHandler, false);
			editor.toggle_mingles.removeEventListener(MouseEvent.CLICK, changeToggleHandler, false);
			editor.nameText.removeEventListener(Event.CHANGE, changeTextHandler, false);
			editor.creatorNameText.removeEventListener(Event.CHANGE, changeTextHandler, false);
			editor.birthDayText.removeEventListener(Event.CHANGE, changeTextAsIntHandler, false);
			editor.birthMonthText.removeEventListener(Event.CHANGE, changeTextAsIntHandler, false);
			editor.idText.removeEventListener(Event.CHANGE, changeHexHandler, false);
			editor.clientIDText.removeEventListener(Event.CHANGE, changeHexHandler, false);
			editor.randomButton.removeEventListener(MouseEvent.CLICK, randomCharacterHandler, false);
			
			editor.nameText.removeEventListener(FocusEvent.FOCUS_OUT, updateHandler, false);
			editor.creatorNameText.removeEventListener(FocusEvent.FOCUS_OUT, updateHandler, false);
			editor.birthDayText.removeEventListener(FocusEvent.FOCUS_OUT, updateHandler, false);
			editor.birthMonthText.removeEventListener(FocusEvent.FOCUS_OUT, updateHandler, false);
			editor.idText.removeEventListener(FocusEvent.FOCUS_OUT, updateHandler, false);
			editor.clientIDText.removeEventListener(FocusEvent.FOCUS_OUT, updateHandler, false);
			
			super.fini();
		}

		public override function drawGUI(quickDraw:Boolean = false):void {
			super.drawGUI(quickDraw);
			
			var avatarData:AvatarData = editor.avatarData;
			editor.status_gender.gotoAndStop(avatarData.gender + 1);
			editor.status_mingles.gotoAndStop(avatarData.mingles + 1);
			
			editor.nameText.text		= avatarData.name;
			editor.creatorNameText.text	= avatarData.creatorName;
			editor.idText.text			= getHex(avatarData.id);
			editor.clientIDText.text	= getHex(avatarData.clientID);
			editor.birthDayText.text	= String(avatarData.birthDay || "");
			editor.birthMonthText.text	= String(avatarData.birthMonth || "");
			
			updateSelectedColor("favorite");
			
			drawCharacter();
		}
		
		protected function changeTextHandler(event:Event):void {
			var name:String			= event.currentTarget.name.slice(0,-4);
			var value:String		= event.currentTarget.text;
			editor.avatarData[name]	= value;
			drawCharacter();
		}
		
		protected function changeTextAsIntHandler(event:Event):void {
			if (event.currentTarget.text && isNaN(event.currentTarget.text)) return;
			var name:String			= event.currentTarget.name.slice(0,-4);
			var value:int			= int(event.currentTarget.text);
			editor.avatarData[name]	= AvatarCharacter.clampValue(name, value);
			drawCharacter();
		}
		
		protected function changeHexHandler(event:Event):void {
			var name:String			= event.currentTarget.name.slice(0, -4);
			var text:String			= event.currentTarget.text.replace(/-/g, "");
			var value:uint			= uint(parseInt(text, 16));
			editor.avatarData[name]	= value;
			drawCharacter();
		}
		
		protected function updateHandler(event:Event):void {
			drawGUI();
		}
		
		protected function randomCharacterHandler(event:MouseEvent):void {
			AvatarUtils.smartRandomize(editor.avatarData);
			drawCharacter();
			drawGUI();
		}
		
		public function getHex(value:uint):String {
			var hex:String = value.toString(16);
			while (hex.length < 8) hex = "0" + hex;
			var parts:Array = hex.match(/[0-9a-fA-F]{1,2}/g);
			return parts.join("-");
		}
	}
}