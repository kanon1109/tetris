package  
{
import data.NodeVo;
import event.TetrisEvent;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;
import utils.Random;
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
	//方块的高宽
	private var rectWidth:Number;
	private var rectHeight:Number;
	//方块间隔
	private var gap:int;
	//是否暂停
	private var isPause:Boolean;
	private var rows:int;
	private var columns:int;
	//效果计时器
	private var effectTimer:Timer;
	//闪烁次数
	private var effectTimes:int;
	private var effectCurTimes:int;
	//满行数组
	private var fullRowList:Array;
	public function TetrisTest() 
	{
		this.rows = 18;
		this.columns = 12;
		this.startX = 0;
		this.startY = 0;
		this.rectWidth = 20;
		this.rectHeight = 20;
		this.gap = 2;
		this.effectTimes = 7;
		this.effectCurTimes = 0;
		//默认一秒钟
		this.delay = 500;
		this.timer = new Timer(this.delay);
		this.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		this.timer.start();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		
		this.tetris = new Tetris(this.rows, this.columns);
		//this.tetris.createTetrominoesVo(Random.randint(0, 6));
		this.tetris.createTetrominoesVo(0);
		this.tetris.addEventListener(TetrisEvent.TETRIS_DOWN, tetrisDownHandler);
		this.tetris.addEventListener(TetrisEvent.FULL, fullHandler);
		this.tetris.down();
		this.draw();
	}
	
	private function fullHandler(e:TetrisEvent):void 
	{
		this.fullRowList = e.data as Array;
		var length:int = this.fullRowList.length;
		this.isPause = true;
		//出消除效果
		this.effectTimer = new Timer(50);
		this.effectTimer.addEventListener(TimerEvent.TIMER, effectTimerHandler);
		this.effectTimer.start();
	}
	
	private function effectTimerHandler(e:TimerEvent):void 
	{
		this.effectCurTimes++;
		var node:NodeVo;
		var arr:Array;
		for (var i:int = 0; i < length; i += 1)
		{
			arr = this.fullRowList[i];
			var len:int = arr.length;
			for (var j:int = 0; j < len; j += 1) 
			{
				var row:int = arr[j][0];
				var column:int = arr[j][1];
				var color:int = arr[j][2];
				var y:int = this.startY + (this.rectHeight + this.gap) * row;
				var x:int = this.startX + (this.rectWidth + this.gap) * column;
				if (this.effectCurTimes % 2 == 1) color = 0xFFFFFF;
				this.graphics.beginFill(color);
				this.graphics.drawRect(x, y, this.rectWidth, this.rectHeight);
				this.graphics.endFill();
			}
		}
		if (this.effectCurTimes == this.effectTimes)
		{
			this.effectTimer.removeEventListener(TimerEvent.TIMER, effectTimerHandler);
			this.effectTimer.stop();
			this.effectCurTimes = 0;
			this.isPause = false;
		}
	}
	
	private function tetrisDownHandler(event:TetrisEvent):void
	{
		//this.tetris.createTetrominoesVo(Random.randint(0, 6));
		this.tetris.createTetrominoesVo(0);
	}
	
	private function onKeyDownHandler(evt:KeyboardEvent):void 
	{
		if (this.isPause) return;
		switch (evt.keyCode)
		{
			case Keyboard.A:
				this.tetris.left();
				this.draw();
				break;
			case Keyboard.D:
				this.tetris.right();
				this.draw();
				break;
			case Keyboard.S:
				this.tetris.down();
				this.draw();
				break;
			case Keyboard.W:
				this.tetris.rotation();
				this.draw();
				break;
			case Keyboard.SPACE:
				if (this.timer.running) this.timer.stop();
				else this.timer.start();
				break;
		}
	}
	
	private function timerHandler(event:TimerEvent):void 
	{
		if (this.isPause) return;
		this.tetris.down();
		this.draw();
	}
	
	/**
	 * 绘制
	 */
	public function draw():void
	{
		if (this.isPause) return;
		this.graphics.clear();
		if (this.tetris && this.tetris.map)
		{
			var x:int;
			var y:int;
			var color:uint;
			var value:int;
			var length:int = this.tetris.map.length;
			var node:NodeVo;
			for (var i:int = 0; i < length; i += 1)
			{
				y = this.startY + (this.rectHeight + this.gap) * i;
				var arr:Array = this.tetris.map[i];
				var len:int = arr.length;
				for (var j:int = 0; j < len; j += 1)
				{
					node = arr[j];
					if (node.color == 0) color = 0xFFFFFF;
					else color = node.color;
					x = this.startX + (this.rectWidth + this.gap) * j;
					this.graphics.beginFill(color, node.alpha);
					this.graphics.drawRect(x, y, this.rectWidth, this.rectHeight);
					this.graphics.endFill();
				}
			}
		}
	}
}
}