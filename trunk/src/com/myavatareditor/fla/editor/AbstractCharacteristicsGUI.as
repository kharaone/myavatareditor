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
	
	import com.myavatareditor.data.parsers.HexCodeString;
	import com.myavatareditor.fla.character.AvatarCharacter;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Base class for Avatar characteristic pages.  A
	 * Avatar characteristic page is the content found
	 * in each tab of the Avatar Editor interface and
	 * any sub page within each of those pages.
	 */
	public class AbstractCharacteristicsGUI {
		
		public static const ZOOM_FULL:String = "zoomFull";
		public static const ZOOM_FACE:String = "zoomFace";
		
		public var editor:EditorSWF;
		
		public var pageCount:int	= 0;
		public var itemCount:int	= 0;
		public var pageIndex:int	= 0;
		public var currProp:String;
		public var colorID:String;
		public var optionIDs:Array;
		public var zoomStyle:String = ZOOM_FACE;
			
		// zoom out
		public var sizingFootingY:Number	= 350;
		public var zoomFullScale:Number		= .53;
		
		public function AbstractCharacteristicsGUI(editor:EditorSWF){
			this.editor = editor;
		}
		
		
		/**
		 * The init method is called upon page initialization
		 * and sets up navigation defaults for the page
		 * relating to the accessible features available in
		 * the page.
		 */
		public function init():void {
			
			if (itemCount){
				openSelectedItemPage();
				assignItemListeners();
			}
			
			if (colorID)
				setupColors(colorID);
				
			if (optionIDs)
				assignOptionListeners(optionIDs);
			
			updateZoom();
				
			drawGUI();
		}
		
		/**
		 * The drawGUI method is called at the completion
		 * of a frame when all child display instances have
		 * been instantiated and are accessible or for just
		 * general page updates.
		 */
		public function drawGUI(quickDraw:Boolean = false):void {
			if (!quickDraw){
				updateURLText(editor.avatarHex);
			}
			
			if (itemCount)
				drawItemsPage();	
		}
		
		/**
		 * The fini method is called when a page
		 * is navigated away from. It is used
		 * to cleanup actions left behind when going
		 * to a new frame.
		 */
		public function fini():void {
			
			if (itemCount)
				unassignItemListeners();
				
			if (colorID)
				cleanupColors(colorID);
				
			if (optionIDs)
				unassignOptionListeners(optionIDs);
		}
		
		
		/****************************************************
		 * FEATURE ITEMS
		 ****************************************************/
		// init
		public function openSelectedItemPage():void {
			// pageIndex is initially based on selected
			// property so that when navigating to a page,
			// the current item is visible in the page
			var name:String	= currProp + "Type";
			var value:int	= int(editor.avatarData[name]);
			if (name in AvatarCharacter.valueToFrameLookup){
				
				// the order of the items in the selection are
				// based on the frame order of the characteristic
				value = AvatarCharacter.valueToFrame(name, value) - 1;
			}
			
			if (value)
				pageIndex = int(value / itemCount);
		}
		
		public function assignItemListeners():void {
			var i:int = itemCount;
			var item:MovieClip;
			while(i--) {
				item			= MovieClip(editor.getChildByName("item" + i));
				item.buttonMode	= true;
				item.index		= i;
				item.addEventListener(MouseEvent.CLICK, selectItemHandler, false, 0, true);
			}
			assignPageListeners();
		}
		
		public function assignPageListeners():void {
			if (editor.page_prev)
				editor.page_prev.addEventListener(MouseEvent.CLICK, prevItemsPageHandler, false, 0, true);
			if (editor.page_next)
				editor.page_next.addEventListener(MouseEvent.CLICK, nextItemsPageHandler, false, 0, true);
		}
		
		protected function selectItemHandler(event:MouseEvent):void {
			var name:String	= currProp + "Type";
			var value:int	= int(event.currentTarget.index) + itemCount * pageIndex;
			value			= AvatarCharacter.frameToValue(name, value + 1);
			editor.avatarData[name] = value;
			updateSelectedItem();
			drawCharacter();
		}
		
		public function drawItemsPage():void {
			if (!itemCount) return;
			
			var item:MovieClip;
			var icon:MovieClip;
			var iconFrame:int;
			var IconSet:Class = Class(getDefinitionByName("Icons_" + currProp));
			
			var i:int = itemCount;
			while (i--) {
				item = MovieClip(editor.getChildByName("item" + i));
				while (item.numChildren > 1){
					item.removeChildAt(1);
				}
					
				icon		= new IconSet();
				iconFrame	= 1 + item.index + itemCount * pageIndex;
				icon.gotoAndStop(iconFrame);
				item.addChildAt(icon, 1);
			}
			
			// display the correct page number
			if (editor.pageText)
				editor.pageText.text = (pageIndex + 1) + "/" + pageCount;
			
			updateSelectedItem();
		}
		
		public function updateSelectedItem():void {
			var item:MovieClip;
			var hilite:DisplayObject;
			var iconFrame:int;
			var name:String	= currProp + "Type";
			var value:int	= int(editor.avatarData[name]);
			
			var i:int = itemCount;
			while (i--) {
				item		= MovieClip(editor.getChildByName("item" + i));
				iconFrame	= 1 + item.index + itemCount * pageIndex;
				hilite		= item.getChildByName("hilite");
				
				if (value == AvatarCharacter.frameToValue(name, iconFrame)){
					if (!hilite){
						hilite		= new ItemSelected(); // defined in FLA Library
						hilite.name	= "hilite";
						item.addChildAt(hilite, 1);
					}
				}else if (hilite){
					item.removeChild(hilite);
				}
			}
		}
		
		protected function prevItemsPageHandler(event:MouseEvent):void {
			if (pageIndex > 0) {
				pageIndex--;
				drawItemsPage();
			}
		}
		
		protected function nextItemsPageHandler(event:MouseEvent):void {
			if (pageIndex < pageCount-1) {
				pageIndex++;
				drawItemsPage();
			}
		}
		
		// fini
		public function unassignItemListeners():void {
			var i:int = itemCount;
			var item:MovieClip;
			while(i--) {
				item = MovieClip(editor.getChildByName("item" + i));
				item.removeEventListener(MouseEvent.CLICK, selectItemHandler, false);
			}
			unassignPageListeners();
		}
		public function unassignPageListeners():void {
			if (editor.page_prev)
				editor.page_prev.removeEventListener(MouseEvent.CLICK, prevItemsPageHandler, false);
			if (editor.page_next)
				editor.page_next.removeEventListener(MouseEvent.CLICK, nextItemsPageHandler, false);
		}
		
		/****************************************************
		 * FEATURE COLORS
		 ****************************************************/
		// init
		public function setupColors(type:String):void {
			var list:Array = AvatarCharacter[type + "Colors"];
			var colorItem:MovieClip;
			var i:int = list.length;
			while (i--) {
				colorItem				= MovieClip(editor.getChildByName("color" + i));
				colorItem.buttonMode	= true;
				colorItem.type			= type;
				colorItem.well.transform.colorTransform = list[i];
				colorItem.addEventListener(MouseEvent.CLICK, selectColorHandler, false, 0, true);
			}
			updateSelectedColor(type);
		}
		
		protected function selectColorHandler(event:MouseEvent):void {
			var type:String = event.currentTarget.type;
			editor.avatarData[type + "Color"] = int(event.currentTarget.name.slice(5));
			updateSelectedColor(type);
			drawCharacter();
		}
		
		public function updateSelectedColor(type:String):void {
			var value:int = int(editor.avatarData[type + "Color"]);
			var hilite:DisplayObject;
			var colorItem:MovieClip;
			
			var list:Array	= AvatarCharacter[type + "Colors"];
			var i:int		= list.length;
			while (i--) {
				colorItem	= MovieClip(editor.getChildByName("color" + i));
				hilite		= colorItem.getChildByName("hilite");
				
				if (value == i){
					if (!hilite){
						hilite		= new ColorSelected(); // from FLA Library
						hilite.name	= "hilite";
						colorItem.addChild(hilite);
					}
				}else if (hilite){
					colorItem.removeChild(hilite);
				}
			}
		}
		
		// fini
		public function cleanupColors(type:String){
			var list:Array = AvatarCharacter[type + "Colors"];
			var colorItem:MovieClip;
			var i:int = list.length;
			while (i--) {
				colorItem = MovieClip(editor.getChildByName("color" + i));
				colorItem.removeEventListener(MouseEvent.CLICK, selectColorHandler, false);
			}
		}
		
		/****************************************************
		 * FEATURE OPTIONS
		 ****************************************************/
		// init
		public function assignOptionListeners(strings:Array):void {
			var optionName:String;
			for each (var elem:* in strings) {
				optionName = currProp + elem;
				assignOptionListener(MovieClip(editor.getChildByName("option_" + elem + "_1")), optionName, 1);
				assignOptionListener(MovieClip(editor.getChildByName("option_" + elem + "_0")), optionName, -1);
			}
		}
		private function assignOptionListener(option:MovieClip, optionName:String, change:int):void {
			// forcing in dynamic properties optionName and
			// change into the option MovieClip instance
			option.optionName	= optionName;
			option.change		= change;
			
			option.buttonMode	= true;
			option.addEventListener(MouseEvent.CLICK, selectOptionHandler, false, 0, true);
		}
		
		protected function selectOptionHandler(event:MouseEvent):void {
			var name:String	= event.currentTarget.optionName;
			var change:int	= int(event.currentTarget.change);
			var value:int	= int(editor.avatarData[name]);
			editor.avatarData[name] = AvatarCharacter.clampValue(name, value + change);
			drawCharacter();
		}
		
		// fini
		public function unassignOptionListeners(strings:Array):void {
			var option:MovieClip;
			for each (var elem:* in strings) {
				option = MovieClip(editor.getChildByName("option_" + elem + "_1"));
				if (option)
					option.removeEventListener(MouseEvent.CLICK, selectOptionHandler, false);		
				
				option = MovieClip(editor.getChildByName("option_" + elem + "_0"));
				if (option)
					option.removeEventListener(MouseEvent.CLICK, selectOptionHandler, false);
				
			}
		}
		
		
		/****************************************************
		 * GENERIC HANDLERS
		 ****************************************************/
		
		protected function changeToggleHandler(event:MouseEvent):void {
			var name:String			= event.currentTarget.name.slice(7);
			editor.avatarData[name]	= editor.avatarData[name] ? 0 : 1;
			drawCharacter();
			drawGUI();
		}
		
		
		/****************************************************
		 * CHARACTER RENDERING
		 ****************************************************/
		
		public function drawCharacter(quickDraw:Boolean = false):void {
			
			// visually update character
			if (editor.avatarSWF)
				editor.avatarSWF.draw(quickDraw);
				
			updateZoom();
		}
		public function updateURLText(hex:String):void {
			var hexURL:String = editor.editorURL + "/?avatar=" + hex;
			if (editor.urlText.text != hexURL)
				editor.urlText.text = hexURL;
		}
		
		// zooming
		/**
		 * Zooms the character preview out so that the whole
		 * character, including the body, can be fully visible.
		 */
		public function zoomCharacterFull():void {
			if (!editor.avatarSWF) return;
			editor.graphicsContainer.scaleX = zoomFullScale;
			editor.graphicsContainer.scaleY = zoomFullScale;
			
			editor.graphicsContainer.x = editor.graphicsFootingBase.x;
			editor.graphicsContainer.y = editor.graphicsFootingBase.y;
		}
		
		/**
		 * Restores the character preview zoom setting to the default which 
		 * is a close view of the character's face.  To see the entire
		 * body, you would want to zoomCharacterFull.
		 */
		public function zoomCharacterFace():void {
			if (!editor.avatarSWF) return;
			editor.graphicsContainer.scaleX = 1;
			editor.graphicsContainer.scaleY = 1;
			
			var coordSpace:DisplayObjectContainer = editor.graphicsContainer.parent;
			var headLocation:Point = coordSpace.globalToLocal(editor.avatarSWF.globalHeadCenter);
			
			var offset:Point = editor.graphicsFaceBase.subtract(headLocation);
			editor.graphicsContainer.x += offset.x;
			editor.graphicsContainer.y += offset.y;
		}
		
		public function updateZoom():void {
			switch (zoomStyle){
				case ZOOM_FACE:
					zoomCharacterFace();
					break;
					
				case ZOOM_FULL:
					zoomCharacterFull();
					break;
					
				default:
					break;
			}
		}
	}
}