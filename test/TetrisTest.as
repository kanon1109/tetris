package  
{
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;
/**
 * ...俄罗斯方块测试
 * @author Kanon
 */
public class TetrisTest extends Sprite 
{
	//下落计时器
	private var timer:Timer;
	private var tetris:Tetris;
	private var delay:int;
	private var startX:Number;
	private var startY:Number;
	private var rectWidth:Number;
	private var rectHeight:Number;
	private var gap:int;
	public function TetrisTest() 
	{
		this.startX = 0;
		this.startY = 0;
		this.rectWidth = 20;
		this.rectHeight = 20;
		this.gap = 2;
		//默认一秒钟
		this.delay = 1000;
		
		this.timer = new Timer(this.delay);
		this.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		this.timer.start();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		
		this.tetris = new Tetris(12, 18);
		this.tetris.createTetrominoesVo(1);
		this.tetris.update();
		this.draw();
	}
	
	private function onKeyDownHandler(event:KeyboardEvent):void 
	{
		switch (event.keyCode)
		{
			case Keyboard.A:
				this.tetris.left();
				this.draw();
				break;
			case Keyboard.D:
				this.tetris.right();
				this.draw();
				break;
			case Keyboard.W:
				this.tetris.rotation();
				this.draw();
				break;
		}
	}
	
	private function timerHandler(event:TimerEvent):void 
	{
		this.tetris.update();
		//this.tetris.print();
		this.draw();
	}
	
	/**
	 * 绘制
	 */
	public function draw():void
	{
		this.graphics.clear();
		if (this.tetris && this.tetris.map)
		{
			var x:int;
			var y:int;
			var color:uint;
			var value:int;
			var length:int = this.tetris.map.length;
			for (var i:int = 0; i < length; i += 1)
			{
				y = this.startY + (this.rectHeight + this.gap) * i;
				var arr:Array = this.tetris.map[i];
				var len:int = arr.length;
				for (var j:int = 0; j < len; j += 1)
				{
					value = arr[j];
					if (value == 0) color = 0xFFFFFF;
					else color = 0x000000;
					x = this.startX + (this.rectWidth + this.gap) * j;
					this.graphics.beginFill(color);
					this.graphics.drawRect(x, y, this.rectWidth, this.rectHeight);
					this.graphics.endFill();
				}
			}
		}
	}
}
}