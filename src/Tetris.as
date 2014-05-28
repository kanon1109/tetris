package  
{
import data.NodeVo;
import data.TetrominoesVo;
import event.TetrisEvent;
import flash.events.EventDispatcher;
/**
 * ...俄罗斯方块
 * @author Kanon
 */
public class Tetris extends EventDispatcher
{
	//地图数组
	private var _map:Array
	//行数
	private var rows:int;
	//列数
	private var columns:int;
	//最小行数
	private static const MIN_ROWS:int = 6;
	//最小列数
	private static const MIN_COLUMNS:int = 6;
	//当前下落的方块数据
	private var tetrominoesVo:TetrominoesVo;
	public function Tetris(rows:int, columns:int) 
	{
		this.rows = rows;
		this.columns = columns;
		//限制最小行列
		if (this.rows < Tetris.MIN_ROWS)
			this.rows = Tetris.MIN_ROWS;
		if (this.columns < Tetris.MIN_COLUMNS)
			this.columns = Tetris.MIN_COLUMNS;
		this.initMap();
	}
	
	/**
	 * 初始化地图
	 */
	private function initMap():void
	{
		this._map = [];
		for (var i:int = 0; i < this.columns; i += 1) 
		{
			this._map[i] = [];
			for (var j:int = 0; j < this.rows; j += 1) 
			{
				var node:NodeVo = new NodeVo();
				this._map[i][j] = node;
			}
		}
	}
	
	/**
	 * 更新方块数据到地图数组中
	 * @param	vo		方块数据
	 */
	private function updateTetrominoes(vo:TetrominoesVo):void
	{
		if (!vo) return;
		this.clearMap();
		var arr:Array = vo.map;
		var length:int = arr.length;
		var node:NodeVo;
		//遍历方块数据
		for (var i:int = 0; i < length; i += 1) 
		{
			//横向数据
			var rowAry:Array = arr[i];
			var len:int = rowAry.length;
			for (var j:int = 0; j < len; j += 1)
			{
				//将有数据的位置设置到大地图上
				if (this._map[vo.posY + i] != null &&
					this._map[vo.posY + i][vo.posX + j] != null)
				{
					node = this._map[vo.posY + i][vo.posX + j];
					if (rowAry[j] == 1) 
					{
						node.status = NodeVo.UNSTABLE;
						node.color = vo.color;
					}
				}
			}
		}
	}
	
	/**
	 * 判断左边界
	 * @return	是否再移动一步到边界
	 */
	private function checkLeftRange():Boolean
	{
		if (!this.tetrominoesVo) return true;
		if (this.tetrominoesVo.posX + this.tetrominoesVo.left - 1 < 0)
			return true;
		return false;
	}
	
	/**
	 * 判断右边界
	 * @return	是否再移动一步到边界
	 */
	private function checkRightRange():Boolean
	{
		if (!this.tetrominoesVo) return true;
		if (this.tetrominoesVo.posX + 
			this.tetrominoesVo.left + 
			this.tetrominoesVo.width + 1 > this.rows)
			return true
		return false;
	}
	
	/**
	 * 判断是否出底界
	 * @return	是否出底界
	 */
	private function checkDownRange():Boolean
	{
		if (!this.tetrominoesVo) return false;
		if (this.tetrominoesVo.posY + 
			this.tetrominoesVo.top + 
			this.tetrominoesVo.height >= this.columns)
			return true;
		return false;
	}
	
	/**
	 * 固定方块不动
	 * @param	vo	方块数据
	 */
	private function fixedTetrominoes(vo:TetrominoesVo):void
	{
		if (!vo) return;
		var arr:Array = vo.map;
		var length:int = arr.length;
		var node:NodeVo;
		//遍历方块数据
		for (var i:int = 0; i < length; i += 1) 
		{
			//横向数据
			var rowAry:Array = arr[i];
			var len:int = rowAry.length;
			for (var j:int = 0; j < len; j += 1)
			{
				//将有数据的位置设置到大地图上
				if (this._map[vo.posY + i] != null &&
					this._map[vo.posY + i][vo.posX + j] != null)
				{
					node = this._map[vo.posY + i][vo.posX + j];
					if (rowAry[j] == 1) 
						node.status = NodeVo.STABLE;
				}
			}
		}
	}
	
	/******************public**********************************/
	/**
	 * 向下
	 */
	public function down():void 
	{
		if (!this.tetrominoesVo) return;
		this.tetrominoesVo.posY++;
		this.updateTetrominoes(this.tetrominoesVo);
		if (this.checkDownRange())
		{
			//固定下落方块数据
			this.fixedTetrominoes(this.tetrominoesVo);
			//将地图数据设置成长久类型数据，每帧不擦除数据。
			this.dispatchEvent(new TetrisEvent(TetrisEvent.TETRIS_DOWN));
		}
	}
	
	/**
	 * 向左
	 */
	public function left():void
	{
		if (!this.tetrominoesVo) return;
		if (this.checkLeftRange()) return;
		this.tetrominoesVo.posX--;
		this.updateTetrominoes(this.tetrominoesVo);
	}
	
	/**
	 * 向右
	 */
	public function right():void
	{
		if (!this.tetrominoesVo) return;
		if (this.checkRightRange()) return;
		this.tetrominoesVo.posX++;
		this.updateTetrominoes(this.tetrominoesVo);
	}
	
	/**
	 * 旋转
	 */
	public function rotation():void
	{
		if (!this.tetrominoesVo) return;
		this.tetrominoesVo.dir++;
		this.updateTetrominoes(this.tetrominoesVo);
		if (this.tetrominoesVo.posX + this.tetrominoesVo.left < 0)
		{
			//左边变形时超过边界
			//如果旋转后位置超过边界则加上相差的位置 并重新渲染
			this.tetrominoesVo.posX += 
				Math.abs(this.tetrominoesVo.posX + this.tetrominoesVo.left);
			this.updateTetrominoes(this.tetrominoesVo);
		}
		if (this.tetrominoesVo.posX + this.tetrominoesVo.width > this.rows)
		{
			//右边变形时超过边界
			this.tetrominoesVo.posX -= 
				Math.abs(this.rows - (this.tetrominoesVo.posX + this.tetrominoesVo.width));
			this.updateTetrominoes(this.tetrominoesVo);
		}
	}
	
	/**
	 * 创建新方块数据
	 * @param	type	方块类型
	 */
	public function createTetrominoesVo(type:int):void
	{
		this.tetrominoesVo = new TetrominoesVo();
		this.tetrominoesVo.type = type;
		this.tetrominoesVo.dir = 0;
		this.tetrominoesVo.posX = int((this.rows - this.tetrominoesVo.map.length) / 2);
		this.tetrominoesVo.posY = 0;
	}
	
	/**
	 * 更新方法
	 */
	public function update():void
	{
		this.down();
	}
	
	/**
	 * 清空整个数组
	 */
	public function clearMap():void
	{
		var node:NodeVo;
		for (var i:int = 0; i < this.columns; i += 1) 
		{
			for (var j:int = 0; j < this.rows; j += 1) 
			{
				node = this._map[i][j];
				if (node.status != NodeVo.STABLE)
				{
					node.color = 0;
					node.status = NodeVo.EMPTY;
				}
			}
		}
	}
	
	/**
	 * 打印地图
	 */
	public function print():void
	{
		var node:NodeVo;
		var str:String = "";
		for (var i:int = 0; i < this.columns; i += 1) 
		{
			for (var j:int = 0; j < this.rows; j += 1) 
			{
				node = this._map[i][j];
				str += node.status;
			}
			str += "\n";
		}
		trace(str);
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this._map = null;
		this.tetrominoesVo = null;
	}
	
	public function get map():Array{ return _map; }
}
}