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
		for (var i:int = 0; i < this.rows; i += 1) 
		{
			this._map[i] = [];
			for (var j:int = 0; j < this.columns; j += 1) 
			{
				var node:NodeVo = new NodeVo(i, j);
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
			var len:int = arr[i].length;
			for (var j:int = 0; j < len; j += 1)
			{
				//将有数据的位置设置到大地图上
				if (this._map[vo.posY + i] != null &&
					this._map[vo.posY + i][vo.posX + j] != null)
				{
					node = this._map[vo.posY + i][vo.posX + j];
					//如果地图节点上的数据不是固定数据，将方块地图上数据为1的部位映射到地图节点上
					if (node.status != NodeVo.STABLE && arr[i][j] == 1) 
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
		var column:int = this.tetrominoesVo.left;
		if (column - 1 < 0) return true;
		var length:int = this.tetrominoesVo.map.length;
		var node:NodeVo;
		var leftNode:NodeVo;
		for (var i:int = 0; i < length; i += 1)
		{
			if (this._map[this.tetrominoesVo.posY + i] != null && 
				this._map[this.tetrominoesVo.posY + i][column] != null)
			{
				node = this._map[this.tetrominoesVo.posY + i][column];
				if (node.status == NodeVo.UNSTABLE)
				{
					leftNode = this._map[this.tetrominoesVo.posY + i][column - 1];
					if (leftNode.status == NodeVo.STABLE)
					{
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * 判断右边界
	 * @return	是否再移动一步到边界
	 */
	private function checkRightRange():Boolean
	{
		if (!this.tetrominoesVo) return true;
		var column:int = this.tetrominoesVo.right;
		if (column + 1 >= this.columns) return true;
		var length:int = this.tetrominoesVo.map.length;
		var node:NodeVo;
		var rightNode:NodeVo;
		for (var i:int = 0; i < length; i += 1)
		{
			if (this._map[this.tetrominoesVo.posY + i] != null && 
				this._map[this.tetrominoesVo.posY + i][column + 1] != null &&
				this._map[this.tetrominoesVo.posY + i][column] != null)
			{
				node = this._map[this.tetrominoesVo.posY + i][column];
				if (node.status == NodeVo.UNSTABLE)
				{
					rightNode = this._map[this.tetrominoesVo.posY + i][column + 1];
					if (rightNode.status == NodeVo.STABLE)
					{
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * 判断是否出底界
	 * @return	是否出底界
	 */
	private function checkDownRange():Boolean
	{
		if (!this.tetrominoesVo) return false;
		if (this.tetrominoesVo.down >= this.rows - 1)
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
	
	/**
	 * 判断下落时碰到其他节点
	 * @param	vo	方块数据
	 * @return	是否碰撞
	 */
	private function checkDownHit(vo:TetrominoesVo):Boolean
	{
		if (!vo) return false;
		var arr:Array = vo.map;
		var length:int = arr.length;
		var node:NodeVo;
		//碰到的底下的格子方块
		var downNode:NodeVo;
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
					this._map[vo.posY + i + 1] != null &&
					this._map[vo.posY + i][vo.posX + j] != null)
				{
					node = this._map[vo.posY + i][vo.posX + j];
					downNode = this._map[vo.posY + i + 1][vo.posX + j];
					if (node.status == NodeVo.UNSTABLE && 
						downNode.status == NodeVo.STABLE)
					{
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * 判断全行
	 * @return	为满数据行的列表 格式[[行数，列数，颜色],[行数，列数，颜色]]
	 */
	private function checkFullLine():Array
	{
		var fullRowsList:Array = [];
		var node:NodeVo;
		var color:uint;
		for (var i:int = 0; i < this.rows; i += 1) 
		{
			var isFull:Boolean = true;
			//临时数组
			var temp:Array = [];
			for (var j:int = 0; j < this.columns; j += 1)
			{
				node = this._map[i][j];
				if (node.color == 0) color = 0xFFFFFF;
				else color = node.color;
				temp.push([i, j, color]);
				if (node.status != NodeVo.STABLE)
				{
					isFull = false;
					break;
				}
			}
			if (isFull) fullRowsList.push(temp);
		}
		return fullRowsList;
	}
	
	/**
	 * 消除并下落
	 * @param	fullRowsList	被消除的数据列表
	 */
	private function removeFullLine(fullRowsList:Array):void
	{
		if (!fullRowsList) return;
		var length:int = fullRowsList.length;
		var node:NodeVo;
		for (var i:int = 0; i < length; i += 1) 
		{
			var arr:Array = fullRowsList[i];
			var len:int = arr.length;
			for (var j:int = 0; j < len; j += 1) 
			{
				var row:int = arr[j][0];
				var column:int = arr[j][1];
				node = this._map[row][column];
				node.status = NodeVo.EMPTY;
				node.color = 0;
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
		if (this.checkDownRange() || 
			this.checkDownHit(this.tetrominoesVo))
		{
			//固定下落方块数据
			this.fixedTetrominoes(this.tetrominoesVo);
			//判断是否摆满
			var rowLineAry:Array = this.checkFullLine();
			if (rowLineAry.length > 0)
			{
				this.dispatchEvent(new TetrisEvent(TetrisEvent.FULL, rowLineAry));
				this.removeFullLine(rowLineAry);
			}
			//将地图数据设置成长久类型数据，每帧不擦除数据。
			this.dispatchEvent(new TetrisEvent(TetrisEvent.TETRIS_DOWN));
		}
		else
		{
			this.tetrominoesVo.posY++;
			this.updateTetrominoes(this.tetrominoesVo);
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
		if (this.tetrominoesVo.left < 0 || 
			this.tetrominoesVo.right >= this.columns || 
			this.tetrominoesVo.down >= this.rows)
		{
			//左边变形时超过边界
			this.tetrominoesVo.dir--;
		}
		else
		{
			//判断旋转后是否会与之前有数据的节点相接触。
			var length:int = this.tetrominoesVo.map.length;
			var node:NodeVo;
			for (var i:int = 0; i < length; i += 1)
			{
				var rowAry:Array = this.tetrominoesVo.map[i];
				var len:int = rowAry.length;
				var isBreak:Boolean;
				for (var j:int = 0; j < len; j += 1)
				{
					if (this._map[this.tetrominoesVo.posY + i] != null &&
						this._map[this.tetrominoesVo.posY + i][this.tetrominoesVo.posX + j] != null)
					{
						node = this._map[this.tetrominoesVo.posY + i][this.tetrominoesVo.posX + j];
						if (rowAry[j] == 1 && node.status == NodeVo.STABLE)
						{
							this.tetrominoesVo.dir--;
							isBreak = true;
							break;
						}
					}
					if (isBreak) break;
				}
			}
		}
		this.updateTetrominoes(this.tetrominoesVo);
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
		this.tetrominoesVo.posX = int((this.columns - this.tetrominoesVo.map.length) / 2);
		this.tetrominoesVo.posY = 0;
	}
	
	/**
	 * 清空整个数组
	 */
	public function clearMap():void
	{
		var node:NodeVo;
		for (var i:int = 0; i < this.rows; i += 1) 
		{
			for (var j:int = 0; j < this.columns; j += 1) 
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
		for (var i:int = 0; i < this.rows; i += 1) 
		{
			for (var j:int = 0; j < this.columns; j += 1) 
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