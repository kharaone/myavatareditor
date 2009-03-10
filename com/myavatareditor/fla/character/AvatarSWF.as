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
package com.myavatareditor.fla.character {
	
	import com.myavatareditor.data.AvatarData;
	import com.myavatareditor.data.IHasAvatar;
	import com.myavatareditor.data.Range;
	import com.myavatareditor.fla.AvatarManagerCore;
	import com.myavatareditor.fla.controls.LogoLink;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * Document class for the avatar character graphics - the graphics
	 * that represent the actual avatar.  These graphics exist as a 
	 * separate SWF that can be viewed in a standalone mode or loaded
	 * into other SWFs to be viewed in their context, as is the case
	 * with the avatar editor; it loads the AvatarSWF SWF into the
	 * editor act as the avatar character preview for the data being
	 * edited.
	 */
	public	class		AvatarSWF
			extends		AvatarManagerCore
			implements	IHasAvatar {
		
		// timeline instances
		public var avatarCharacter:AvatarCharacter;
		public var versionText:TextField;
		public var updateFPMessage:MovieClip;
		public var logoLink:LogoLink;
		public var isNested:Boolean = false;
		public var isHosted:Boolean = false;
		
		public var logoSizeFactor:Number = 0.9; // scale ratio of logo in relation to avatar
		public var logoAlpha:Number = 0.25; // how visible logo is on screen
		
		/**
		 * In standalone mode, this is the padding between
		 * the character and the edge of the screen. Actual
		 * pixel distance determined by this value times the
		 * size of the area being viewed (full body or face).
		 */
		public var viewPadding:Number = .05; // percent
		
		/**
		 * The ratio of width/height for the view in standalone
		 * mode to change before the view switches over to show
		 * a closeup of the face rather than the full body.  Any
		 * ratio at or below this value will show the face (tall
		 * shows body, less tall shows face).
		 */
		public var showFaceRatio:Number = 1.25; // percent
		
		/**
		 * Avatar data relating to the avatar being displayed.
		 */
		public override function get avatarData():AvatarData {
			return avatarCharacter.avatarData;
		}
		public override function set avatarData(value:AvatarData):void {
			avatarCharacter.avatarData = value;
		}
		
		/**
		 * Position of the point of footing (the point between
		 * the feet on which the shadow sits) in global coordinate
		 * space.
		 */
		public function get globalFooting():Point {
			var loc:Point = new Point(avatarCharacter.shadow.x, avatarCharacter.shadow.y);
			return avatarCharacter.localToGlobal(loc);
		}
		
		/**
		 * Position of the center of the head in global coordinate
		 * space.
		 */
		public function get globalHeadCenter():Point {
			var loc:Point = new Point(avatarCharacter.head.x, avatarCharacter.head.y);
			return avatarCharacter.localToGlobal(loc);
		}
		
		/**
		 * The rectangle bounds of the entire character in
		 * global coordinate space.
		 */
		public function get globalCharacterRect():Rectangle {
			var scope:DisplayObjectContainer = getGlobalScope();
			return avatarCharacter.getRect(scope);
		}
		
		/**
		 * The rectangle bounds of the character head, including all
		 * of its hair, in global coordinate space.
		 */
		public function get globalCharacterHeadRect():Rectangle {
			var scope:DisplayObjectContainer = getGlobalScope();
			var headRect:Rectangle = avatarCharacter.head.getRect(scope);
			return headRect.union(avatarCharacter.headback.getRect(scope));
		}
			
		/**
		 * Constructor for creating new AvatarSWF instances.
		 * Generally this is not used directly. Instead, AvatarSWF
		 * is used as the document class of a character SWF and that
		 * SWF is displayed by web sites or other client SWFs.
		 */
		public function AvatarSWF() {
			super();
			
			updateFPMessage.visible = false;
			
			// version from text field
			if (versionText){
				version = versionText.text;
				removeChild(versionText);
			}
			
			determineHosting();
			
			// standalone mode if displaying just this SWF
			if (isHosted){
				initAsComponent();
			}else{
				initAsStandalone();
			}
			
			// initialize the character if not nested
			if (!isNested){
				initialize();
			}
		}
		
		protected function determineHosting():void {
			// if loaderInfo is not accessible, or a loader
			// is defined within it, the SWF is being hosted
			// by another SWF
			if (!loaderInfo || loaderInfo.loader != null){
				isNested = true;
			}else{
				isNested = false;
			}
			
			
			// nested SWFs are forced to have hosted true
			if (isNested){
				isHosted = true;
			}else{
				// set isHosted to false unless otherwise overrided
				// by the query variable hosted
				switch(loaderInfo.parameters.hosted){
					
					case "1":
					case "true":
					case "yes":
					case "on":
						isHosted = true;
						break;
						
					default:
						isHosted = false;
						break;
				}
			}
		}
		
		/**
		 * Renders the visible character to match the data
		 * currently present in avatarData.
		 */
		public override function draw(quickDraw:Boolean = false):void {
			
			if (!quickDraw){
				// Update local data with character
				fileManager.setLocal([avatarXML]);
			}
			
			avatarCharacter.draw();
			if (!isHosted){
				fitCharacter();
			}
		}
		
		/**
		 * Initialize properties and set up events needed
		 * for the SWF to run in standalone mode.  When loaded
		 * into another SWF, these responsibilities are left
		 * to the loader SWF, not this one.
		 */
		private function initAsStandalone():void {
			
			stage.scaleMode	= StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			
			// draw
			avatarCharacter.draw();
			fitCharacter();
			logoLink.alpha	= logoAlpha;
		}
		/**
		 * Initialize properties needed for the SWF to run as a component
		 * loaded inside of another SWF.
		 */
		private function initAsComponent():void {
			// ditch logoLink
			removeChild(logoLink);
			logoLink = null;
		}
		
		/**
		 * Handler for changes in screen size.
		 */
		protected function stageResizeHandler(event:Event):void {
			fitCharacter();
		}
		/**
		 * Function responsible for positioning and scaling the character to
		 * fit in the screen if in standalone mode.
		 */
		public function fitCharacter():void {
			
			// Fit character to screen
			var targetRect:Rectangle;
			var stageRatio:Number = stage.stageHeight/stage.stageWidth;
			
			// get rect to fit into the view
			targetRect = (stageRatio <= showFaceRatio)
				? globalCharacterHeadRect
				: globalCharacterRect;
			
			// scale [first]
			var scaleRatio:Number = getFitRectScale(targetRect);
			avatarCharacter.scaleX *= scaleRatio;
			avatarCharacter.scaleY *= scaleRatio;
			
			// rect has changed, re-acquire given new scale
			targetRect = (stageRatio <= showFaceRatio)
				? globalCharacterHeadRect
				: globalCharacterRect;
			
			// reposition [last]
			var offset:Point = getFitRectOffset(targetRect);
			avatarCharacter.x += offset.x;
			avatarCharacter.y += offset.y;
			
			// logo link resize and position
			logoLink.scaleX = avatarCharacter.scaleX * logoSizeFactor;
			logoLink.scaleY = logoLink.scaleX;
			logoLink.x = 0;
			logoLink.y = 0;
		}
		
		/**
		 * Returns the scale needed to fit a rectangle to the
		 * rectangular area of the screen.
		 * @param	rect The Rectangle to get a scale value for.
		 * @return A scale value to multiply the rect size by to
		 * have it be able to fit into the area of the screen.
		 */
		private function getFitRectScale(rect:Rectangle):Number {
			if (!stage) return 1;
			
			var padding:Number = Math.max(rect.width, rect.height) * viewPadding;
			rect.inflate(2*padding, 2*padding);
			rect.offset(-padding, -padding);
			
			var placementRect:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			var widthRatio:Number = placementRect.width/rect.width;
			var heightRatio:Number = placementRect.height/rect.height;
			return Math.min(widthRatio, heightRatio);
			
		}
		
		/**
		 * Returns an offset of a rectangle from the center
		 * of the screen.
		 * @param	rect Rectangle to get an offset for.
		 * @return The offset Point representing how far away
		 * the provided Rectangle is from the center of the screen.
		 */
		private function getFitRectOffset(rect:Rectangle):Point {
			if (!stage) return new Point();
			var placementCenter:Point = new Point(stage.stageWidth/2, stage.stageHeight/2);
			var rectCenter:Point = new Point(rect.x + rect.width/2, rect.y + rect.height/2);
			
			return placementCenter.subtract(rectCenter);
		}
		
		/**
		 * Returns the global scope. This normally means stage, but
		 * in the case that stage cannot be accessed, the parent
		 * of this display object is recursed until there are no
		 * more parents to be found.  The top-most parent assumes
		 * the role of global scope in that case.
		 */
		private function getGlobalScope():DisplayObjectContainer {
			var scope:DisplayObjectContainer = stage;
			if (!scope){
				scope = this;
				while (scope.parent){
					scope = scope.parent;
				}
			}
			return scope;
		}
	}
}