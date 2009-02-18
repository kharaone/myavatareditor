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

	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.fileio.IInitialize;
	import com.myavatareditor.fileio.Initializer;
	import com.myavatareditor.fla.AvatarManagerCore;
	import com.myavatareditor.fla.character.AvatarSWF;
	import com.myavatareditor.fla.controls.NavigationButton;
	import com.myavatareditor.fla.editor.dialogs.FileOptions;
	import com.myavatareditor.data.AvatarData;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	// REMINDER: Update version textfields for new builds
	
	/** 
	 * Document class for the Avatar Editor application SWF.
	 * This class represents the main timeline in which the 
	 * Avatar editor runs and handles core operations used
	 * within that interface.
	 */
	public	dynamic
			class		EditorSWF
			extends		AvatarManagerCore
			implements	IHasAvatar {
		
		
		public var editorURL:String		= "http://www.myavatareditor.com"; // URL used in avatar link
		public var isLoaded:Boolean		= false; // true when avatar is loaded
		
		/**
		 * Index of the currently selected tab. Helper API for external calls.
		 */
		public function get currentTab():int {
			return currentFrame - 1;
		}
		public function set currentTab(value:int):void {
			if (value > 0 && value < totalFrames){
				gotoAndStop(value + 1);
			}
		}
		
		/**
		 * Opens the file menu. Helper API for external calls.
		 * @param	screen Optional screen to specify the file menu to
		 * open to.  These include "menu" (default), "xml", and "export".
		 */
		public function openFileMenu(screen:String = "menu"):void {
			var frame:int = fileMenuNameMap.indexOf(screen) + 1;
			if (frame > 0){
				options.gotoAndStop(frame);
			}
		}
		
		/**
		 * Closes the file menu if open. Helper API for external calls.
		 */
		public function closeFileMenu():void {
			options.gotoAndStop(1);
		}
		
		/**
		 * Specifies the current file menu screen. Helper API for external calls.
		 */
		public function get currentFileMenuScreen():String {
			return fileMenuNameMap[options.currentFrame - 1];
		}
		private var fileMenuNameMap:Array = [null, "menu", "xml", "export"];
		
		
		public var pages:Array = [];	// list page controllers
		public var currentPage:AbstractCharacteristicsGUI; // current page controller
			
		
		// elements within the timeline
		// persistent
		public var urlText:TextField;
		public var versionText:TextField;
		public var fileMenuButton:MovieClip;
		public var graphicsContainer:MovieClip;
		public var updateFPMessage:MovieClip;
		public var options:FileOptions;
		public var debug:TextField;
		// intermittent
		public var pageText:TextField;
		public var page_prev:MovieClip;
		public var page_next:MovieClip;
		// general
		public var randomButton:MovieClip;
		public var linkText:TextField;
		
			
		// character positioning
		public var graphicsFootingBase:Point;
		public var graphicsFaceBase:Point;
			
		
		/**
		 * AvatarData used to represent the data for the avatar
		 * character used in the editor.  When set, its value is 
		 * also set as the loaded AvatarSWF's avatarData.
		 */
		public override function get avatarData():AvatarData {
			return _avatarData;
		}
		public override function set avatarData(value:AvatarData):void {
			_avatarData = value;
			
			if (_avatarSWF)
				_avatarSWF.avatarData = _avatarData;
		}
		private var _avatarData:AvatarData = new AvatarData();
		
		// loaded AvatarSWF instance
		public function get avatarSWF():AvatarSWF {
			return _avatarSWF;
		}
		public function set avatarSWF(value:AvatarSWF):void {
			// remove any pre-existing display objects
			while (graphicsContainer.numChildren) {
				graphicsContainer.removeChildAt(0);
			}
			
			_avatarSWF = value;
			
			if (_avatarSWF){
				graphicsContainer.addChild(_avatarSWF);
				
				// provide a reference to the character data
				_avatarSWF.avatarData = avatarData;
				
				// position base footing at container location
				var loc:Point = graphicsContainer.globalToLocal(_avatarSWF.globalFooting);
				_avatarSWF.x = -loc.x;
				_avatarSWF.y = -loc.y;
			}
		}
		private var _avatarSWF:AvatarSWF;
		
		/**
		 * A static reference to the last EditorSWF instance 
		 * initialized in the current application domain.  This
		 * can be useful as a global access point for the
		 * current (if only) editor.
		 */
		public static var lastEditorInitialized:EditorSWF;
		
		public function EditorSWF(){
			super();
			
			lastEditorInitialized = this;
			
			// kill the message that would otherwise prevent
			// flashing when the flash player is not new enough
			// or if for some other reason the SWF broke before
			// this point.
			updateFPMessage.visible = false;
			
			// version from text field
			if (versionText){
				version = versionText.text;
				removeChild(versionText);
			}
			
			// avatar link
			
			// locations where the avatar character preview
			// is presented, one for full preview (footing base)
			// and the other for face shots (face base)
			graphicsFootingBase	= new Point(graphicsContainer.x, graphicsContainer.y);
			graphicsFaceBase	= new Point(graphicsFootingBase.x, graphicsFootingBase.y - 110); // face 110px above feet
			
			// setup page managers
			pages[1]  = new CharacteristicsLoader(this);
			pages[2]  = new CharacteristicsGeneral(this);
			pages[3]  = new CharacteristicsSize(this);
			pages[4]  = new CharacteristicsHead(this);
			pages[5]  = new CharacteristicsFacialFeatures(this);
			pages[6]  = new CharacteristicsHair(this);
			pages[7]  = new CharacteristicsEyebrow(this);
			pages[8]  = new CharacteristicsEye(this);
			pages[9]  = new CharacteristicsGlasses(this);
			pages[10] = new CharacteristicsNose(this);
			pages[11] = new CharacteristicsMouth(this);
			pages[12] = new CharacteristicsMustache(this);
			pages[13] = new CharacteristicsBeard(this);
			pages[14] = new CharacteristicsMole(this);
			pageInit();
			
			// application initializer for loading avatar characters
			// editor auto-initializes
			initialize();
		}
		
		/**
		 * One-time initialization step for when the editor
		 * has loaded.  Assumes that the current frame is >= 2.
		 */
		public function loadInit():void {
			addEventListener(TextEvent.LINK, avatarLinkClickHandler, false, 0, true);
			fileMenuButton.addEventListener(MouseEvent.CLICK, fileMenuHandler, false, 0, true);
			isLoaded = true;
			dispatchEvent(new Event("editorLoaded", true));
		}
		
		// Page updates 
		public function pageInit():void {
			// initialize new page
			currentPage = AbstractCharacteristicsGUI(pages[currentFrame]);
			currentPage.init();
		}
		
		private function pageFini():void {
			// clean up current page
			currentPage.fini();
		}
		
		public override function draw(quickDraw:Boolean = false):void {
			currentPage.drawGUI(quickDraw);
			currentPage.drawCharacter(quickDraw);
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
		public override function play():void {
			// do nothing
		}
		
		protected function avatarLinkClickHandler(event:TextEvent):void {
			switch(event.text){
				
				case "avatarLink":
					try{
						navigateToURL(new URLRequest(urlText.text), "_blank");
					}catch (error:Error){}
					break;
					
				default:
					break;
			}
		}
		
		protected function fileMenuHandler(event:MouseEvent):void {
			options.display();
		}
	}
}