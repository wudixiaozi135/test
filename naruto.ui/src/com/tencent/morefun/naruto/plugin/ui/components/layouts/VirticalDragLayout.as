package com.tencent.morefun.naruto.plugin.ui.components.layouts 
{
	import com.tencent.morefun.naruto.plugin.ui.components.DragHelper;
	import com.tencent.morefun.naruto.plugin.ui.components.events.DragEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.events.ScrollEvent;
	import com.tencent.morefun.naruto.plugin.ui.components.interfaces.IDragComponent;
	
	import flash.events.Event;
	
	/**
	 * 可拖动垂直列表布局
	 * @author larryhou
	 * @createTime	2010/2/14 22:59
	 */
	public class VirticalDragLayout extends VirticalScrollLayout implements IDragComponent
	{		
		private var _drag:DragHelper = null;
		
		private var _lastPosition:Number = 0;
		
		/**
		 * 构造函数
		 * create a [VirticalDragLayout] object
		 */
		public function VirticalDragLayout(rowCount:int, columnCount:int = 1, hgap:int = 5, vgap:int = 5)
		{
			super(rowCount, columnCount, hgap, vgap);
			
			_drag = new DragHelper(_container);
		}
		
		/**
		 * 添加事件侦听
		 */
		override protected function listen():void 
		{
			_drag.addEventListener(Event.CHANGE, updateHandler);
			_drag.addEventListener(DragEvent.START_DRAG, startDragHandler);
			_drag.addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		override protected function unlisten():void 
		{
			_drag.removeEventListener(Event.CHANGE, updateHandler);
			_drag.removeEventListener(DragEvent.START_DRAG, startDragHandler);
			_drag.removeEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler);
		}
		
		/**
		 * 更新处理
		 * @param	e
		 */
		private function updateHandler(e:Event):void 
		{
			notifyChange(_lastPosition - _drag.offset.y);
		}
		
		/**
		 * 开始拖动处理
		 * @param	e
		 */
		private function startDragHandler(e:DragEvent):void 
		{
			_lastPosition = _scrollRect.y;
			
			_scrolling = true;
			dispatchEvent(new ScrollEvent(ScrollEvent.START_SCROLLING));
		}
		
		/**
		 * 拖动完成处理
		 * @param	e
		 */
		private function dragCompleteHandler(e:DragEvent):void 
		{
			_scrolling = false;
			dispatchEvent(new ScrollEvent(ScrollEvent.STOP_SCROLLING));
		}
		
		/**
		 * 刷新数值
		 */
		private function notifyChange(position:Number):void
		{
			var targetValue:Number = position * 100 / (_itemHeight + _vgap) / (_lineCount - _row);
			
			if (targetValue < 0) targetValue = 0;
			if (targetValue > 100) targetValue = 100;
			
			if (this.value == targetValue) return;
			
			this.value = targetValue;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 拖动后停止所需要的时间
		 * @default 0.5
		 */
		public function get duration():Number { return _drag.duration; }
		public function set duration(value:Number):void 
		{
			_drag.duration = value;
		}
		
		/**
		 * 拖动后列表滚动所使用的缓动函数
		 */
		public function get ease():Function { return _drag.ease; }
		public function set ease(value:Function):void 
		{
			_drag.ease = value;
		}
		
		/**
		 * 如果鼠标移动速度小于此值，则不感应
		 * @default 0.3
		 */
		public function get threshold():Number { return _drag.threshold.y; }
		public function set threshold(value:Number):void 
		{
			_drag.threshold.y = value;
		}
		
		/**
		 * 是否激活控件
		 */
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			
			_drag.enabled = value;
		}
		
	}
	
}