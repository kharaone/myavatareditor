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
	
	import com.myavatareditor.data.parsers.ConsoleBinary;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class CharacteristicsSize extends AbstractCharacteristicsGUI {

		public function CharacteristicsSize(editor:EditorSWF){
			super(editor);
			zoomStyle = ZOOM_FULL;
		}
		
		public override function init():void {
			super.init();
			editor.slider_height.buttonMode = true;
			editor.slider_weight.buttonMode = true;
			editor.slider_height.addEventListener(Event.CHANGE, sliderChangeHandler, false, 0, true);
			editor.slider_weight.addEventListener(Event.CHANGE, sliderChangeHandler, false, 0, true);
			editor.slider_height.addEventListener(Event.COMPLETE, sliderCompleteHandler, false, 0, true);
			editor.slider_weight.addEventListener(Event.COMPLETE, sliderCompleteHandler, false, 0, true);
		}
		
		public override function drawGUI(quickDraw:Boolean = false):void {
			editor.slider_height.setPercent(editor.avatarData.height/ConsoleBinary.HEIGHT_MAX);
			editor.slider_weight.setPercent(editor.avatarData.weight/ConsoleBinary.WEIGHT_MAX);
			super.drawGUI(quickDraw);
		}
		
		public override function fini():void {
			editor.slider_weight.removeEventListener(Event.CHANGE, sliderChangeHandler, false);
			editor.slider_height.removeEventListener(Event.CHANGE, sliderChangeHandler, false);
			super.fini();
		}

		public function sliderChangeHandler(event:Event):void {
			editor.avatarData.height = Math.round(ConsoleBinary.HEIGHT_MAX * editor.slider_height.getPercent());
			editor.avatarData.weight = Math.round(ConsoleBinary.WEIGHT_MAX * editor.slider_weight.getPercent());
			drawCharacter(true);
		}
		
		public function sliderCompleteHandler(event:Event):void {
			drawGUI(false);
			drawCharacter(false);
		}
	}
}