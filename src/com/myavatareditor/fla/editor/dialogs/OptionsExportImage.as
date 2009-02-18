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
	
	import com.myavatareditor.display.BitmapUtils;
	import com.myavatareditor.fla.controls.CheckBox;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * Manager for the Export screen in the file menu. This manages
	 * all of the operations and screen updates of the file menu
	 * content while in the export screen.
	 */
	public class OptionsExportImage extends AbstractOptionsGUI {
		
		// saved values, defaults
		private var bgColorValue:String				= "FFF3C9";
		private var sizeValue:Number				= 250;
		private var zoomValue:Number				= 15;
		private var exportAsJPEG:Boolean			= true;
		private var exportWithBackground:Boolean	= true;
		private var showBody:Boolean				= true;
		private var showShadow:Boolean				= true;
		private var exportPreviewOffset:Point		= new Point(0,0);
		
		// base values
		private var zoomPercentMin:Number			= 0.15;
		private var zoomPercentMax:Number			= 2.0;
		private var exportImageSizeMin:Number		= 10;
		private var exportImageSizeMax:Number		= 800;
		
		// persistent data for mouse dragging
		private var repositionOffset:Point;
		
		// display
		public var exportBitmap:Bitmap;
		
		public function OptionsExportImage(options:FileOptions) {
			super(options);
		}
		
		public override function init():void {
			
			addImagePreview();
			
			options.actionImage.addEventListener(MouseEvent.CLICK, exportImageHandler, false, 0, true);
			options.bgColor.addEventListener(Event.CHANGE, bgColorChangeHandler, false, 0, true);
			options.bgColor.restrict	= "a-fA-F0-9";
			options.bgColor.text		= bgColorValue.toUpperCase();
			
			options.colorSlider.addEventListener(Event.CHANGE, bgSliderChangeHandler, false, 0, true);
			options.colorSlider.value = parseInt(bgColorValue, 16);
			
			options.sizeScale.minValue	= exportImageSizeMin;
			options.sizeScale.maxValue	= exportImageSizeMax;
			options.sizeScale.value		= sizeValue;
			options.zoomScale.value		= zoomValue;
			options.sizeScale.addEventListener(Event.CHANGE, sliderChangedHandler, false, 0, true);
			options.zoomScale.addEventListener(Event.CHANGE, sliderChangedHandler, false, 0, true);
			
			options.exportPreview.buttonMode = true;
			options.exportPreview.addEventListener(MouseEvent.MOUSE_DOWN, startRepositioningHandler, false, 0, true);
			
			// checkboxes
			options.backgroundCheck.label.text	= "Background";
			options.backgroundCheck.checked		= exportWithBackground;
			options.bodyCheck.label.text		= "Body";
			options.bodyCheck.checked			= showBody;
			options.shadowCheck.label.text		= "Shadow";
			options.shadowCheck.checked			= showShadow;
			options.jpegCheck.label.text		= "JPEG";
			options.jpegCheck.style				= CheckBox.BOX_STYLE;
			options.jpegCheck.checked			= exportAsJPEG;
			options.pngCheck.label.text			= "PNG";
			options.pngCheck.style				= CheckBox.BOX_STYLE;
			options.pngCheck.checked			= !exportAsJPEG;
			
			options.jpegCheck.addEventListener(MouseEvent.CLICK, selectFileTypeHandler, false, 0, true);
			options.pngCheck.addEventListener(MouseEvent.CLICK, selectFileTypeHandler, false, 0, true);
			options.bodyCheck.addEventListener(MouseEvent.CLICK, updateImagePreviewHandler, false, 0, true);
			options.shadowCheck.addEventListener(MouseEvent.CLICK, updateImagePreviewHandler, false, 0, true);
			options.backgroundCheck.addEventListener(MouseEvent.CLICK, selectTransparencyHandler, false, 0, true);
			
			options.sizeOutput.addEventListener(FocusEvent.FOCUS_OUT, imageTextChangedHandler, false, 0, true);
			options.zoomOutput.addEventListener(FocusEvent.FOCUS_OUT, imageTextChangedHandler, false, 0, true);
			options.sizeOutput.addEventListener(KeyboardEvent.KEY_DOWN, imageTextChangedHandler, false, 0, true);
			options.zoomOutput.addEventListener(KeyboardEvent.KEY_DOWN, imageTextChangedHandler, false, 0, true);
			
			bgColorChangeHandler(null);
			sliderChangedHandler(null);
			selectExportCheck(exportAsJPEG ? "JPEG" : "PNG");
		}
		
		public override function fini():void {
			options.actionImage.removeEventListener(MouseEvent.CLICK, exportImageHandler, false);
			options.bgColor.removeEventListener(Event.CHANGE, bgColorChangeHandler, false);
			options.colorSlider.removeEventListener(Event.CHANGE, bgSliderChangeHandler, false);
			options.sizeScale.removeEventListener(Event.CHANGE, sliderChangedHandler, false);
			options.zoomScale.removeEventListener(Event.CHANGE, sliderChangedHandler, false);
			
			options.exportPreview.removeEventListener(MouseEvent.MOUSE_DOWN, startRepositioningHandler, false);
			options.jpegCheck.removeEventListener(Event.CHANGE, selectFileTypeHandler, false);
			options.pngCheck.removeEventListener(Event.CHANGE, selectFileTypeHandler, false);
			options.bodyCheck.removeEventListener(Event.CHANGE, updateImagePreviewHandler, false);
			options.shadowCheck.removeEventListener(Event.CHANGE, updateImagePreviewHandler, false);
			options.backgroundCheck.removeEventListener(Event.CHANGE, selectTransparencyHandler, false);
			
			options.sizeOutput.removeEventListener(FocusEvent.FOCUS_OUT, imageTextChangedHandler, false);
			options.zoomOutput.removeEventListener(FocusEvent.FOCUS_OUT, imageTextChangedHandler, false);
			options.sizeOutput.removeEventListener(KeyboardEvent.KEY_DOWN, imageTextChangedHandler, false);
			options.zoomOutput.removeEventListener(KeyboardEvent.KEY_DOWN, imageTextChangedHandler, false);
			
			if (exportBitmap){
				options.exportPreview.removeChild(exportBitmap);
				exportBitmap.bitmapData.dispose();
				exportBitmap = null;
			}
			
			super.fini();
		}
		
		protected function selectTransparencyHandler(event:MouseEvent):void {
			exportWithBackground = options.backgroundCheck.checked;
			updateColor();
		}
		
		protected function selectFileTypeHandler(event:MouseEvent):void {
			switch(event.target) {
				
				case options.jpegCheck:
					selectExportCheck("JPEG");
					break;
					
				case options.pngCheck:
					selectExportCheck("PNG");
					break;
			}
		}
		
		private function selectExportCheck(exportType:String):void {
			switch(exportType) {
				
				case "PNG":
					exportAsJPEG = false;
					// enable transparent checkbox
					options.backgroundCheck.mouseEnabled = true;
					options.backgroundCheck.transform.colorTransform = new ColorTransform();
					break;
					
				case "JPEG":
					exportAsJPEG = true;
					// disapble transparent checkbox
					options.backgroundCheck.mouseEnabled = false;
					options.backgroundCheck.transform.colorTransform = new ColorTransform(.5, .5, .5);
					break;
			}
			
			options.jpegCheck.checked	= exportAsJPEG;
			options.pngCheck.checked	= !exportAsJPEG;
			updateColor();
		}
		
		private function addImagePreview():void {
			exportBitmap			= new Bitmap(new BitmapData(options.exportPreview.width, options.exportPreview.height, true, 0));
			exportBitmap.smoothing	= true;
			options.exportPreview.addChild(exportBitmap);
		}
		
		protected function updateImagePreviewHandler(event:Event):void {
			
			// update display
			options.oversizeTimes.text = "x" + String(Math.round(100 * sizeValue/options.exportPreview.width)/100);
			
			// update character
			if (!editor.avatarSWF) return;
			
			var bodyClip:MovieClip		= editor.avatarSWF.avatarCharacter.body;
			var shadowClip:MovieClip	= editor.avatarSWF.avatarCharacter.shadow;
			
			showBody	= options.bodyCheck.checked;
			showShadow	= options.shadowCheck.checked;
			
			// apply alterations to preview
			var scale:Number	= zoomPercentMin + (zoomPercentMax - zoomPercentMin) * zoomValue/100;
			bodyClip.visible	= showBody;
			shadowClip.visible	= showShadow;
			
			// take snapshot
			BitmapUtils.drawCenteredIn(editor.avatarSWF, exportBitmap.bitmapData, scale, exportPreviewOffset);
			
			// restore all visuals
			shadowClip.visible	= true;
			bodyClip.visible	= true;
		}
		
		protected function exportImageHandler(event:MouseEvent):void {
			if (!editor.avatarSWF) return;
			
			var bodyClip:MovieClip		= editor.avatarSWF.avatarCharacter.body;
			var shadowClip:MovieClip	= editor.avatarSWF.avatarCharacter.shadow;
				
			// setup bitmap transformations for export
			var scale:Number	= zoomPercentMin + (zoomPercentMax - zoomPercentMin) * zoomValue/100;
			var sizeDiff:Number	= sizeValue/options.exportPreview.width;
			var newScale:Number	= scale * sizeDiff;
			var newOffset:Point	= new Point(exportPreviewOffset.x*sizeDiff, exportPreviewOffset.y*sizeDiff);
			
			// apply alterations to preview
			bodyClip.visible	= showBody;
			shadowClip.visible	= showShadow;
			
			// take export snapshot
			var hasTransparentBG:Boolean	= Boolean(!exportWithBackground && !exportAsJPEG);
			var bgColor:Number				= hasTransparentBG ? 0x00FFFFFF : parseInt(bgColorValue, 16);
			var bmp:BitmapData				= BitmapUtils.createCenteredBitmapData(editor.avatarSWF, sizeValue, sizeValue, newScale, newOffset, hasTransparentBG, bgColor);
			
			// restore all visuals
			shadowClip.visible	= true;
			bodyClip.visible	= true;
			
			// export
			var meta:Object	= getMetadata();
			meta.type		= (exportAsJPEG) ? "jpg" : "png";
			editor.fileManager.save(bmp, meta);
			bmp.dispose(); // cleanup
		}
		
		protected function sliderChangedHandler(event:Event):void {
			sizeValue = options.sizeScale.value;
			zoomValue = options.zoomScale.value;
			options.sizeOutput.text = String(Math.round(options.sizeScale.value));
			options.zoomOutput.text = String(Math.round(options.zoomScale.value));
			updateImagePreviewHandler(event);
		}
		
		protected function startRepositioningHandler(event:MouseEvent):void {
			options.stage.addEventListener(MouseEvent.MOUSE_MOVE, whileRepositioningHandler, false, 0, true);
			options.stage.addEventListener(MouseEvent.MOUSE_UP, stopRepositioningHandler, false, 0, true);
			repositionOffset = new Point(options.mouseX, options.mouseY);
		}
		
		protected function whileRepositioningHandler(event:MouseEvent):void {
			var mousePosition:Point = new Point(options.mouseX, options.mouseY);
			exportPreviewOffset = exportPreviewOffset.add(mousePosition.subtract(repositionOffset));
			updateImagePreviewHandler(null);
			repositionOffset = mousePosition;
		}
		
		protected function stopRepositioningHandler(event:MouseEvent):void {
			options.stage.removeEventListener(MouseEvent.MOUSE_MOVE, whileRepositioningHandler, false);
			options.stage.removeEventListener(MouseEvent.MOUSE_UP, stopRepositioningHandler, false);
		}
		
		protected function imageTextChangedHandler(event:Event):void {
			
			// if a keyboard event, only continue if ENTER is pressed
			if (event is KeyboardEvent){
				var kevent:KeyboardEvent = KeyboardEvent(event);
				if (kevent.keyCode != Keyboard.ENTER) return;
			}
			
			// export scaling
			var value:Number = Number(options.sizeOutput.text);
			if (isNaN(value)){
				options.sizeOutput.text = String(sizeValue);
			}else{
				options.sizeScale.value = value;
				sizeValue = options.sizeScale.value;
				options.sizeOutput.text = String(Math.round(options.sizeScale.value));
			}
			
			// view zoom
			value = Number(options.zoomOutput.text);
			if (isNaN(value)){
				options.zoomOutput.text = String(zoomValue);
			}else{
				options.zoomScale.value = value;
				zoomValue = options.zoomScale.value;
				options.zoomOutput.text = String(Math.round(zoomValue));
			}
			
			updateImagePreviewHandler(event);
		}
		
		// Avatar and Images
		protected function bgSliderChangeHandler(event:Event):void {
			options.bgColor.text = options.colorSlider.hexValue.toUpperCase();
			bgColorChangeHandler(null);
			updateColor();
		}
		protected function bgColorChangeHandler(event:Event):void {
			if (!options.bgColor.text) return;
			options.colorSlider.value = parseInt(options.bgColor.text, 16);
			updateColor();
		}
		public function updateColor():void {
			var bg:MovieClip = options.exportPreview.background;
			
			if (!exportWithBackground && !exportAsJPEG){
				bg.visible 					= false;
			}else{
				bg.visible 					= true;
				var text:String				= options.bgColor.text;
				var col:ColorTransform		= bg.transform.colorTransform;
				col.color					= (!exportWithBackground && !exportAsJPEG)
											? 0xFFFFFF
											: parseInt(text, 16);
				bg.transform.colorTransform	= col;
			}
			bgColorValue = text;
		}
	}
}