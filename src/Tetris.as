package  
{
import data.TetrominoesVo;
/**
 * ...俄罗斯方块
 * @author Kanon
 */
public class Tetris 
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
				this._map[i][j] = 0;
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
		var arr:Array = vo.getTetrominoe();
		//遍历方块数据
		for (var i:int = 0; i < arr.length; i += 1) 
		{
			//横向数据
			var rowAry:Array = arr[i];
			for (var j:int = 0; j < rowAry.length; j += 1)
			{
				//将有数据的位置设置到大地图上
				if (this._map[vo.posY + i][vo.posX + j] != null)
					this._map[vo.posY + i][vo.posX + j] = rowAry[j];
			}
		}
	}
	
	/**
	 * 判断左边界
	 * @return	是否再移动一步到边界
	 */
	private function checkLeft():Boolean
	{
		if (!this.tetrominoesVo) return false;
		if (this.tetrominoesVo.posX - 1 < 0)
			return false;
		return true;
	}
	
	/**
	 * 判断右边界
	 * @return	是否再移动一步到边界
	 */
	private function checkRight():Boolean
	{
		if (!this.tetrominoesVo) return false;
		if (this.tetrominoesVo.posX + this.tetrominoesVo.width + 1 > this.rows)
			return false
		return true;
	}
	
	/**
	 * 向下
	 */
	public function down():void 
	{
		if (!this.tetrominoesVo) return;
		this.tetrominoesVo.posY++;
		this.updateTetrominoes(this.tetrominoesVo);
	}
	
	/**
	 * 向左
	 */
	public function left():void
	{
		if (!this.tetrominoesVo) return;
		if (!this.checkLeft()) return;
		this.tetrominoesVo.posX--;
		this.updateTetrominoes(this.tetrominoesVo);
	}
	
	/**
	 * 向右
	 */
	public function right():void
	{
		if (!this.tetrominoesVo) return;
		if (!this.checkRight()) return;
		this.tetrominoesVo.posX++;
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
		this.tetrominoesVo.posX = int((this.rows - this.tetrominoesVo.getTetrominoe().length) / 2);
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
		for (var i:int = 0; i < this.columns; i += 1) 
		{
			for (var j:int = 0; j < this.rows; j += 1) 
			{
				this._map[i][j] = 0;
			}
		}
	}
	
	/**
	 * 打印地图
	 */
	public function print():void
	{
		var str:String = "";
		for (var i:int = 0; i < this.columns; i += 1) 
		{
			for (var j:int = 0; j < this.rows; j += 1) 
			{
				str += this._map[i][j];
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