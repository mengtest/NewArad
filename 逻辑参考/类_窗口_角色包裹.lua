--==============================================================================--
--╭━━╮┏━━╮╭━━╮╭━━╮╭╭╮╮╭━━╮　╭╭╮╮╭━━╮╭╮╭╮╭━━╮
--┃╭━╯┃╭╮┃┃╭━╯┃╭╮┃┃　　┃┃╭━╯　┃　　┃┃╭╮┃┃╰╯┃┃╭━╯
--┃╰━╮┃┃┃┃┃┃╭╮┃╰╯┃┃┃┃┃┃╰━╮　┃┃┃┃┃╰╯┃┃　╭╯┃╰━╮
--┃╭━╯┃┃┃┃┃┃┃┃┃╭╮┃┃╭╮┃┃╭━╯　┃╭╮┃┃╭╮┃┃　╰╮┃╭━╯
--┃╰━╮┃╰╯┃┃╰╯┃┃┃┃┃┃┃┃┃┃╰━╮　┃┃┃┃┃┃┃┃┃╭╮┃┃╰━╮
--╰━━╯┗━━╯╰━━╯╰╯╰╯╰╯╰╯╰━━╯  ╰╯╰╯╰╯╰╯╰╯╰╯╰━━╯
--
-- 作者:  创建:2010年10月16日15时26分2秒
--=============================================================================--

类_窗口_角色包裹  = class()



--=============================================================================--
-- ■ 构造函数
--=============================================================================--
function 类_窗口_角色包裹:初始化(x坐标,y坐标)
	
	self.标识 = "包裹窗口"
	self.面板图片 = 引擎:载入图片("Dat/UI/包裹窗口.png")
	self.面板精灵 = D2D_精灵.创建(self.面板图片,0,0,引擎:取图片宽度(self.面板图片),引擎:取图片高度(self.面板图片))
	
	
	self.触发移动包围盒 = D2D_包围盒.创建(x坐标,y坐标,290,40)
	
	self.关闭按钮 = 类_三层序列图按钮.创建("Dat/ui/面板关闭按钮.png", x坐标 + 261,y坐标+12,false)
	self.整理包裹按钮 = 类_三层序列图按钮.创建("Dat/ui/整理包裹按钮.png", x坐标 + 229,y坐标+341,false)
	
	
	
	self.滑动条_上按钮 = 类_三层序列图按钮.创建("Dat/ui/滑动条_上按钮.png", x坐标 + 271,y坐标+203,false)
	self.滑动条_下按钮 = 类_三层序列图按钮.创建("Dat/ui/滑动条_下按钮.png", x坐标 + 271,y坐标+318,false)
	
	

	self.可视 = false
	self.移动  = true
	self.可移动 = true
	self.事件激活 = false
	self.坐标 = {x=x坐标,y=y坐标}
	self.焦点 = false
	self.临时点= { x=0 , y=0 }
	self.最后激活时间 = 0

	self.GUI布局 = D2D_GUI布局.创建()
	self.滑动条图片  = 引擎:载入图片 ("Dat/ui/滑动条_滑块.png")
	self.滑动条 = D2D_滑动条.创建(1,self.坐标.x + 268,self.坐标.y+227,18,82,self.滑动条图片,0,0,11,16,true)
	self.滑动条:置属性(0,100 ,2)
	self.滑动条:置位置(0)
	
	
	
	self.GUI布局:绑定控件(self.滑动条.p)

	self.包裹格子 = {}
	self.身体格子 = {}
	
	self.行数 = 0
	self.物品总数 = 0
	
	self.本次显示起始 = 0 
	self.本次显示结束 = 0
	
	
	self.身体格子[1] = 格子_包裹格子.创建(self.坐标.x + 158,self.坐标.y + 60,28,28,501,"头饰")
	self.身体格子[2] = 格子_包裹格子.创建(self.坐标.x + 158+41,self.坐标.y  + 60,28,28,502,"上衣")
	self.身体格子[3] = 格子_包裹格子.创建(self.坐标.x+ 158+82,self.坐标.y   + 60,28,28,503,"项链")
	self.身体格子[4] = 格子_包裹格子.创建(self.坐标.x  + 158,self.坐标.y + 101,28,28,504,"武器")
	
	self.身体格子[5] = 格子_包裹格子.创建(self.坐标.x + 157+42,self.坐标.y  + 101,28,28,505,"腰带")
	self.身体格子[6] = 格子_包裹格子.创建(self.坐标.x+ 158+82,self.坐标.y + 101 ,28,28,506,"手镯")
	self.身体格子[7] = 格子_包裹格子.创建(self.坐标.x  + 158,self.坐标.y   + 142,28,28,507,"鞋子")
	self.身体格子[8] = 格子_包裹格子.创建(self.坐标.x + 157+42,self.坐标.y + 142 ,28,28,508,"下装")
	self.身体格子[9] = 格子_包裹格子.创建(self.坐标.x+ 158+82,self.坐标.y  + 142,28,28,509,"戒指")
	
	
	

	
end





--=============================================================================--
-- ■ 更新
--=============================================================================--
function 类_窗口_角色包裹:更新()

	if(self.可视 ) then
	
		if (Q_屏幕.鼠标窗口全id ~= 0 and Q_屏幕.界面_窗口_数组[Q_屏幕.鼠标窗口全id].标识 == "包裹窗口" ) then
			self.焦点 = true
		else 
			self.焦点 = false 
		end
		
		
		self.关闭按钮:更新(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y)
		self.整理包裹按钮:更新(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y)
		self.滑动条_上按钮:更新(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y)
		self.滑动条_下按钮:更新(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y)
		self.GUI布局:更新(dt)
		
		
		if ( self.焦点) then 
			if(self.关闭按钮:取是否单击())then
				self:开关()
			end
		end 
		
		
		for n= self.本次显示起始  ,self.本次显示结束   do 
			self.包裹格子[n]:更新( )
		end 
	
		for n=1,9 do
			self.身体格子[n]:更新( )
		end

		
		
	end 
	

end





--=============================================================================--
-- ■ 显示
--=============================================================================--
function 类_窗口_角色包裹:显示()


	if(self.可视 ) then
		
		self.面板精灵:显示(self.坐标.x,self.坐标.y)
		
		for n=1,#Q_主角.纸娃娃组_展示 do
			Q_主角.纸娃娃组_展示[n].动画:更新(20, 114,117)
			Q_主角.纸娃娃组_展示[n].动画:显示( self.坐标.x + 80, self.坐标.y +170 )
		end
		
		
		
		self.滑动条_上按钮:显示()
		self.滑动条_下按钮:显示()
		
		self.关闭按钮:显示()
		self.整理包裹按钮:显示()
		
		self.GUI布局:显示()
		
		
		if ( 引擎:取滚轮事件() >0 ) then  -- 如果鼠标滚轮滚动 改变滑动条位置
			self.滑动条:置位置 (self.滑动条:取位置 () - 100 / (self.行数 - 4))
		end 
	
		if ( 引擎:取滚轮事件() <0 ) then 
			self.滑动条:置位置 (self.滑动条:取位置 () + 100 / (self.行数 - 4))
		end 

		t = 取整 (self.滑动条:取位置 () / (100 / (self.行数+1 - 4))) -- 更加滑动条位置 再得出当前应该显示哪一行
		
		if ( t  <= 0 ) then 
			t   = 1
		end 
		
		
		self.本次显示起始 = t * 8 -7
		self.本次显示结束 = self.本次显示起始 + 4 * 8 -1
		
		
		
		
		if (self.本次显示结束 > self.物品总数) then 
			self.本次显示结束 = self.物品总数
		end 
		
		
		
		
		for n= self.本次显示起始  ,self.本次显示结束   do 
			self.包裹格子[n]:显示(- (t-1) *32 )
		end 
		
		for n=1,9 do
			self.身体格子[n]:显示( )
		end
		
		
		
		
		
		文字_描边显示(文字,self.坐标.x+38,self.坐标.y+348,string.format( "%s", 数值到格式文本(Q_游戏数据.金币,0,true)),颜色_白,颜色_黑)--颜色_黄
		
		
--	self.包裹格子[n] = 格子_包裹格子.创建(j * 32 + self.坐标.x -17,i * 32 +self.坐标.y+174 ,28,28,n,"包裹")
		
		
		
		
		
		if (Q_调试) then 
			self.触发移动包围盒:显示()
		end 
		
	end 
	
	
	
	
	
	
	


end



--=============================================================================--
-- ■ 初始化
--=============================================================================--

function 类_窗口_角色包裹:重置(行数)

	self.包裹格子 = nil 
	self.包裹格子 = {}
	self.行数 = 行数

	local n = 0

	for i=1,self.行数 do
		for j=1,8 do
			n = n + 1
			self.包裹格子[n] = 格子_包裹格子.创建(j * 32 + self.坐标.x -18,i * 32 +self.坐标.y+174 ,28,28,n,"包裹")
		end
	end
	

	self.物品总数 = table.getn(self.包裹格子)
	
	
	self.本次显示起始 = 1
	self.本次显示结束 = 32
	
	

end 







--=============================================================================--
-- ■ 显示包裹装备属性
--=============================================================================--

function 类_窗口_角色包裹:显示包裹装备属性()
	
	if (self.焦点==false) then 
		return 
	end 
		--- self.焦点
	local 显示偏移 = 0
	local 显示偏移Y = 0
		

	
	for n=1,9 do
	
		if (self.身体格子[n].道具标识 ~= 0 and self.身体格子[n].包围盒:检测_点(Q_游戏数据.鼠标坐标.x, Q_游戏数据.鼠标坐标.y) and Q_屏幕.信息框.焦点 == false) then
			
			if (Q_游戏数据.鼠标坐标.x < Q_游戏数据.屏幕宽度 / 2) then 
				显示偏移 = 30
			else 
				显示偏移 = - self.身体格子[n].风格提示.宽度 - 20
			end 
			
			显示偏移Y = self.身体格子[n].y-self.身体格子[n].风格提示.高度/2 
			
		
			显示风格提示(self.身体格子[n].x + 显示偏移,显示偏移Y,
							self.身体格子[n].风格提示.风格文字组, 
							self.身体格子[n].风格提示.宽度, 
							self.身体格子[n].风格提示.高度,220,1,2,1,self.身体格子[n].道具) 
			
--			if (self.身体格子[n].道具.分类 == "手镯") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,7)
--			elseif (self.身体格子[n].道具.分类 == "项链") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,5)
--			elseif (self.身体格子[n].道具.分类 == "戒指") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,8)
--			elseif (self.身体格子[n].道具.分类 == "武器") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,2)
--			elseif (self.身体格子[n].道具.分类 == "衣服") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,1)
--			elseif (self.身体格子[n].道具.分类 == "腰带") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,3)
--			elseif (self.身体格子[n].道具.分类 == "鞋子") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,4)
--			elseif (self.身体格子[n].道具.分类 == "副手") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,6)
--			end 
			
			
			
			return 
		end
		
		
		
		
		
	end

	

	for n= self.本次显示起始  ,self.本次显示结束   do 
	
		if (self.包裹格子[n].道具标识 ~= 0 and self.包裹格子[n].包围盒:检测_点(Q_游戏数据.鼠标坐标.x, Q_游戏数据.鼠标坐标.y) ) then
			
			if (Q_游戏数据.鼠标坐标.x < Q_游戏数据.屏幕宽度 / 2) then 
				显示偏移 = 30
			else 
				显示偏移 = - self.包裹格子[n].风格提示.宽度 - 20
			end 
			
			显示偏移Y = self.包裹格子[n].y-self.包裹格子[n].风格提示.高度/2 
			
		
			显示风格提示(self.包裹格子[n].x + 显示偏移,显示偏移Y,
							self.包裹格子[n].风格提示.风格文字组, 
							self.包裹格子[n].风格提示.宽度, 
							self.包裹格子[n].风格提示.高度,220,1,2,1,self.包裹格子[n].道具) 
			
--			if (self.包裹格子[n].道具.分类 == "手镯") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,7)
--			elseif (self.包裹格子[n].道具.分类 == "项链") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,5)
--			elseif (self.包裹格子[n].道具.分类 == "戒指") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,8)
--			elseif (self.包裹格子[n].道具.分类 == "武器") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,2)
--			elseif (self.包裹格子[n].道具.分类 == "衣服") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,1)
--			elseif (self.包裹格子[n].道具.分类 == "腰带") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,3)
--			elseif (self.包裹格子[n].道具.分类 == "鞋子") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,4)
--			elseif (self.包裹格子[n].道具.分类 == "副手") then 
--				self:对比显示属性(n,显示偏移,显示偏移Y,6)
--			end 
			
			
			
			return 
		end
		
	end

	
end 









--=============================================================================--
-- ■ 取物品数()
--=============================================================================--

function 类_窗口_角色包裹:取物品数(道具信息,道具数量)
	
	local n1 = 0
	  
	for n=1, self.物品总数 do
		
		if (道具信息.可叠加 == false) then --不是可叠加的物品
		
			if ( self.包裹格子[n].道具标识  ~= 0  ) then
				n1 = n1 + 1
			end 
			
		else 
		
			if ( self.包裹格子[n].道具标识  ~= 0 ) then
				
				if (self.包裹格子[n].道具.可叠加) then -- 先判断是否是可叠加的物品
				
					if ( self.包裹格子[n].道具.数量 ==100 ) then 
						n1 = n1 + 1
						
					else
						if (self.包裹格子[n].道具标识 == 道具信息.id ) then 
							
							if (self.包裹格子[n].道具.数量 + 道具数量 > 100) then 
								n1 = n1 + 1
								
							end 
						else 
							n1 = n1 + 1
						end 
						
					end 
				else 
					n1 = n1 + 1
				end 
				
			end
			
		end 
		
	end

	
	return  n1

	
end 






--=============================================================================--
-- ■ 增加物品()
--=============================================================================--


function 类_窗口_角色包裹:增加物品(道具信息,道具数量,是否提示)

	if ( 道具信息.总类 == "金币" ) then 
		Q_系统:增加金币(道具数量)
		--Q_屏幕:入包提示动画 (道具信息.精灵)
		return true
	end 
	
     if (self:取物品数(道具信息,道具数量) == self.物品总数 ) then         
		--Q_屏幕.信息框:提示(Q_鼠标坐标.x,Q_鼠标坐标.y,"包裹已满！","确认")
		--MSG(1,"包裹已满！"  ,颜色_白,颜色_蓝)
		return false
     end
     
     if (是否提示 == nil) then
		MSG(1,string.format("获得[%s]" ,道具信息.名称),-1652581 ,颜色_全透明)
     end
	

	local 已经存在 = false
	local 剩余数量 = 0
	
	
	if (道具信息.可叠加 == false) then  --不可叠加的物品 只有1个
		for n=1, self.物品总数 do
		     if ( self.包裹格子[n].道具标识 == 0) then
			    self.包裹格子[n]:置道具(道具信息,1,true)
--				if (是否播放入包动画) then 
--					Q_屏幕:入包提示动画 (道具信息.精灵)
--			      end 
--				Q_屏幕:更新负重()
			   return true
		     end
		end
	else
		
		for n=1, self.物品总数  do
		     if ( self.包裹格子[n].道具标识 == 道具信息.id and  self.包裹格子[n].道具.可叠加) then
			    剩余数量 = self.包裹格子[n].道具.数量 + 道具数量 - 100
			   if (剩余数量 <= 0) then 
				已经存在 = true 
				self.包裹格子[n].道具.数量 = self.包裹格子[n].道具.数量 + 道具数量
				播放道具音效(self.包裹格子[n].道具)
				
				
--				self.包裹格子[n]:播放音效()
--				if (是否播放入包动画) then 
--					Q_屏幕:入包提示动画 (道具信息.精灵)
--				end 
--				Q_屏幕:更新负重()
				 return true 
			   end 
 
		     end
		end
		
		if ( 已经存在 == false ) then 
			for n=1, self.物品总数 do
			     if ( self.包裹格子[n].道具标识 == 0) then
				    self.包裹格子[n]:置道具(道具信息,道具数量,true)
--					if (是否播放入包动画) then 
--						Q_屏幕:入包提示动画 (道具信息.精灵)
--					end 
--					Q_屏幕:更新负重()
				    return true
			     end
			end
			
		end 
		
		
		
	end 
	
	
	


end



--=============================================================================--
-- ■ 开始移动()
--=============================================================================--

function 类_窗口_角色包裹:开始移动()
	
	if (self.可视 and self.焦点 and self.可移动) then
		self.坐标.x =  Q_游戏数据.鼠标坐标.x - self.临时点.x
		self.坐标.y =  Q_游戏数据.鼠标坐标.y - self.临时点.y
		self.触发移动包围盒:置位置(self.坐标.x,self.坐标.y)
		self.关闭按钮:置位置(self.坐标.x + 261,self.坐标.y+12)
		self.整理包裹按钮:置位置( self.坐标.x + 229,self.坐标.y+341)
		self.滑动条_上按钮:置位置(self.坐标.x + 271,self.坐标.y+203)
		self.滑动条_下按钮:置位置( self.坐标.x + 271,self.坐标.y+318)
		
		self.GUI布局:移动控件(1,self.坐标.x + 268,self.坐标.y+227)
		
			
		self.身体格子[1]:置位置(self.坐标.x + 158,self.坐标.y + 60)
		self.身体格子[2]:置位置(self.坐标.x + 158+41,self.坐标.y  + 60)
		self.身体格子[3]:置位置(self.坐标.x+ 158+82,self.坐标.y   + 60)
		self.身体格子[4]:置位置(self.坐标.x  + 158,self.坐标.y + 101 )
		self.身体格子[5]:置位置(self.坐标.x + 157+42,self.坐标.y  + 101)
		self.身体格子[6]:置位置(self.坐标.x+ 158+82,self.坐标.y + 101)
		self.身体格子[7]:置位置(self.坐标.x  + 158,self.坐标.y   + 142)
		self.身体格子[8]:置位置(self.坐标.x + 157+42,self.坐标.y + 142)
		self.身体格子[9]:置位置(self.坐标.x+ 158+82,self.坐标.y  + 142)
		

		
		
		
		
		
		local n = 0
	
		for i=1,self.行数 do
			for j=1,8 do
				n = n + 1
				self.包裹格子[n]:置位置(j * 32 + self.坐标.x -18,i * 32 +self.坐标.y+174)
			end
		end
			
		

		
		
	end


end




--=============================================================================--
-- ■ 置焦点()
--=============================================================================--

function 类_窗口_角色包裹:置焦点(是否焦点)
	self.焦点 = 是否焦点
end



--=============================================================================--
-- ■ 移动()
--=============================================================================--

function 类_窗口_角色包裹:初始移动()

	self.最后激活时间 = 引擎:取运行时间()

	if (self.事件激活 == false ) then
		Q_屏幕.移动焦点窗口 = true
		
	end


	if (self.可视 and self.焦点 and self.可移动) then
		self.临时点.x = Q_游戏数据.鼠标坐标.x - self.坐标.x
		self.临时点.y = Q_游戏数据.鼠标坐标.y - self.坐标.y
		
		
	end

end








--=============================================================================--
-- ■ 打开()
--=============================================================================--

function 类_窗口_角色包裹:打开(x,y)
	self.可视 = true
	self.最后激活时间 = 引擎:取运行时间()
	self.焦点 = true
	
	self.坐标.x = x
	self.坐标.y = y

	self.触发移动包围盒:置位置(self.坐标.x,self.坐标.y)
	self.关闭按钮:置位置(self.坐标.x + 261,self.坐标.y+12)
	self.整理包裹按钮:置位置( self.坐标.x + 229,self.坐标.y+341)
	self.滑动条_上按钮:置位置(self.坐标.x + 271,self.坐标.y+203)
	self.滑动条_下按钮:置位置( self.坐标.x + 271,self.坐标.y+318)
	
	self.GUI布局:移动控件(1,self.坐标.x + 268,self.坐标.y+227)
	
		
		self.身体格子[1]:置位置(self.坐标.x + 158,self.坐标.y + 60)
		self.身体格子[2]:置位置(self.坐标.x + 158+41,self.坐标.y  + 60)
		self.身体格子[3]:置位置(self.坐标.x+ 158+82,self.坐标.y   + 60)
		self.身体格子[4]:置位置(self.坐标.x  + 158,self.坐标.y + 101 )
		self.身体格子[5]:置位置(self.坐标.x + 157+42,self.坐标.y  + 101)
		self.身体格子[6]:置位置(self.坐标.x+ 158+82,self.坐标.y + 101)
		self.身体格子[7]:置位置(self.坐标.x  + 158,self.坐标.y   + 142)
		self.身体格子[8]:置位置(self.坐标.x + 157+42,self.坐标.y + 142)
		self.身体格子[9]:置位置(self.坐标.x+ 158+82,self.坐标.y  + 142)
	
	
	local n = 0

	for i=1,self.行数 do
		for j=1,8 do
			n = n + 1
			self.包裹格子[n]:置位置(j * 32 + self.坐标.x -18,i * 32 +self.坐标.y+174)
		end
	end
		
	
	
	Q_游戏数据.音效组.窗口打开:播放()
	
	




end

--=============================================================================--
-- ■ 开关()
--=============================================================================--

function 类_窗口_角色包裹:开关()


	
	if(self.可视) then
		self.可视 = false
		self.焦点 = false 
		Q_游戏数据.音效组.窗口关闭:播放()
	else
		self.可视 = true
		self.最后激活时间 = 引擎:取运行时间()
		self.焦点 = true
		Q_游戏数据.音效组.窗口打开:播放()
	end

	
	
end




--=============================================================================--
-- ■ 检测点()
--=============================================================================--

function 类_窗口_角色包裹:检测点()

	if (self.事件激活) then
		self.可移动 = false
	else
		self.可移动 = true
	end

	
	if (self.可视 and self.关闭按钮:是否有焦点() == false ) then
		if (self.触发移动包围盒:检测_点(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y)) then 
			return true
		end 
	end

	return false

end


--=============================================================================--
-- ■ 检测点_全局()
--=============================================================================--

function 类_窗口_角色包裹:检测点_全局()
		
	if (self.面板精灵:取包围盒():检测_点(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y) or 
	     self.触发移动包围盒:检测_点(Q_游戏数据.鼠标坐标.x,Q_游戏数据.鼠标坐标.y)
	     
		) then 
		return  true 
	end 
	
	return false
		
end 








