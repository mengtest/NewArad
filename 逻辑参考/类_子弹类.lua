--==============================================================================--
--╭━━╮┏━━╮╭━━╮╭━━╮╭╭╮╮╭━━╮　╭╭╮╮╭━━╮╭╮╭╮╭━━╮
--┃╭━╯┃╭╮┃┃╭━╯┃╭╮┃┃　　┃┃╭━╯　┃　　┃┃╭╮┃┃╰╯┃┃╭━╯
--┃╰━╮┃┃┃┃┃┃╭╮┃╰╯┃┃┃┃┃┃╰━╮　┃┃┃┃┃╰╯┃┃　╭╯┃╰━╮
--┃╭━╯┃┃┃┃┃┃┃┃┃╭╮┃┃╭╮┃┃╭━╯　┃╭╮┃┃╭╮┃┃　╰╮┃╭━╯
--┃╰━╮┃╰╯┃┃╰╯┃┃┃┃┃┃┃┃┃┃╰━╮　┃┃┃┃┃┃┃┃┃╭╮┃┃╰━╮
--╰━━╯┗━━╯╰━━╯╰╯╰╯╰╯╰╯╰━━╯  ╰╯╰╯╰╯╰╯╰╯╰╯╰━━╯
--
-- 作者:  创建:2010年7月9日15时14分32秒
--=============================================================================--

子弹类   = class()



--=============================================================================--
-- ■ 构造函数
--=============================================================================--
function 子弹类:初始化(发射点x,发射点y,角度,速度,射程,类型,方向,地平线,发射者,目标类型)
	
	
	
	self.标识类型 = "屏幕子弹"
	self.起始点 = {x=发射点x,y=发射点y}
	self.目标点 = {x=目标点x,y=目标点y}
	self.坐标 = {x=发射点x,y=发射点y}
	
	self.速度 = 速度 
	self.射程 = 射程 
	self.类型 = 类型
	self.方向 = 方向
	self.发射者 = 发射者
	
	self.排序参照点 = 地平线
	self.状态 = 发射者.状态
	self.排序参照点落差 = self.排序参照点 - self.起始点.y
	
	--self.弧度 = math.atan2( self.目标点.y - self.起始点.y , self.目标点.x - self.起始点.x )
	self.角度 = 角度
	self.目标类型 = 目标类型
	
	self.弧度 =  3.14/180 * 角度 --  math.atan2( self.目标点.y - self.起始点.y , self.目标点.x - self.起始点.x )

	
	self.步幅 = {x=0,y=0}
	self.步幅.x,self.步幅.y = 取移动步幅(self.角度)


	if (self.方向 <0 )then 
		self.步幅.x = - self.步幅.x
		self.步幅.y = - self.步幅.y
	end 


	self.已经消失 = false 

	if (self.类型 == "子弹_A") then 

		self.子弹精灵 = D2D_精灵.创建(Q_主角.武器图片,0,0,18,5)
		self.子弹精灵:置中心点(9,2)
		
	
	elseif (self.类型 == "浮空弹") then 
		self.子弹精灵 = D2D_精灵.创建(Q_主角.浮空弹图片,0,0,39,14)
		self.子弹精灵:置中心点(20,7)	
		self.子弹精灵:置混合模式(混合_颜色乘)
		self.目标类型 = "怪物"
		
	elseif (self.类型 == "哥布林石块") then 
		
		self.子弹动画 = D2D_动画.创建(Q_游戏数据.图片组.投掷圆球图片,4,16,0,0,17,17)
		self.子弹动画:置中心点(8,8)
		self.子弹动画:播放()
		
	elseif (self.类型 == "格林机枪子弹") then 
		self.子弹精灵 = D2D_动画.创建(Q_主角.格林机枪子弹图片,4,16,0,0,55,16)
		self.子弹精灵:播放()
		self.子弹精灵:置中心点(27,8)	
		self.子弹精灵:置混合模式(混合_颜色乘)
		self.目标类型 = "怪物"
	
	elseif (self.类型 == "银弹") then 
		self.子弹精灵 = D2D_动画.创建(Q_主角.银弹技能子弹图片,3,8,0,0,93,15)
		self.子弹精灵:播放()
		self.子弹精灵:置中心点(46,8)	
		self.子弹精灵:置混合模式(混合_颜色乘)
		self.目标类型 = "怪物"
		
	elseif (self.类型 == "魔法星弹") then 
		self.子弹精灵 = D2D_精灵.创建(魔法星弹粒子图片,0,0,34,34)
		self.子弹精灵:置中心点(17,17)	
		self.子弹精灵:置混合模式(混合_颜色乘)
		self.目标类型 = "怪物"
		self.粒子特效 = 粒子特效(self.坐标.x,self.坐标.y ,"魔法星弹")
		self.粒子特效.地平线 = self.排序参照点
	end 
	




	



	
end





--=============================================================================--
-- ■ 更新
--=============================================================================--
function 子弹类:更新()
	
	if (self.已经消失 == false) then 

		
		if (  取两点间距离(self.起始点.x,self.起始点.y,self.坐标.x,self.坐标.y) > self.射程 ) then 
			
			self.已经消失 = true 
			
			if ( self.类型 == "哥布林石块" ) then 
				
				Q_系统:增加屏幕特效_物理("石块爆炸",self.坐标.x,self.坐标.y-10,self.排序参照点)
				
--				
			elseif ( self.类型 == "魔法星弹" ) then 
				self.粒子特效.已经消失 = true 
			
			end 
			
			
		else
		
			self.坐标.x = self.坐标.x + self.步幅.x * self.速度 * dt 
			self.坐标.y = self.坐标.y + self.步幅.y * self.速度 * dt

			
			if ( self.目标类型 == "怪物" ) then 
			
				for n=1,#Q_屏幕.屏幕怪物组 do
				
					local 击中 =  Q_屏幕.屏幕怪物组[n].参照动画.动画包围盒:检测_点(self.坐标.x + Q_游戏数据.画面偏移.x,self.坐标.y + Q_游戏数据.画面偏移.y) 
				
					if(not Q_屏幕.屏幕怪物组[n].已经死亡 and  math.abs(self.排序参照点  - Q_屏幕.屏幕怪物组[n].排序参照点)<20	and	击中) then 
						Q_游戏数据.音效组.石头击中:播放()
						Q_屏幕.屏幕怪物组[n]:被击中(self.发射者,self.发射者:伤害计算(0,Q_屏幕.屏幕怪物组[n]))
						Q_系统:增加屏幕特效_物理("石块爆炸",self.坐标.x,self.坐标.y-10,self.排序参照点)
						self.已经消失 = true
						break
						
					end 
					
					
					--Q_屏幕.屏幕怪物组[n].身体.动画包围盒:检测_点(self.子弹动画.坐标.x + Q_游戏数据.画面偏移.x,self.子弹动画.坐标.y + Q_游戏数据.画面偏移.y) 
		
--					if ( self.类型 == "魔法星弹" ) then 
--						if(Q_屏幕.屏幕怪物组[n].状态 ~= "死亡" and  math.abs(self.排序参照点  - Q_屏幕.屏幕怪物组[n].地平线)<40	and	击中) then 
--							self:攻击判断校正(n)
--						end 
--						

--					else 
--						if(Q_屏幕.屏幕怪物组[n].状态 ~= "死亡" and  math.abs(self.排序参照点  - Q_屏幕.屏幕怪物组[n].地平线)<20	and	击中) then 
--							self:攻击判断校正(n)
--						end 
--						

--					end 
		
					
					
				end 
				
			else 
			
			
				local 击中 =  Q_主角.参照动画.动画包围盒:检测_点(self.坐标.x + Q_游戏数据.画面偏移.x,self.坐标.y + Q_游戏数据.画面偏移.y) 
				
				if(not Q_主角.已经死亡 and  math.abs(self.排序参照点  - Q_主角.排序参照点)<20	and	击中) then 
					Q_游戏数据.音效组.石头击中:播放()
					Q_主角.方向 = -self.方向
					Q_主角:被击中(self.发射者,self.发射者:伤害计算(0,Q_主角))
					Q_主角:被击退(7,1,-Q_主角.方向)
					Q_系统:增加屏幕特效("打击" .. 引擎:取随机整数(1,3), "地图坐标",Q_主角.坐标.x,Q_主角.坐标.y - 40,-self.方向 *0.8,0.8,0,1)

					Q_系统:增加屏幕特效_物理("石块爆炸",self.坐标.x,self.坐标.y-10,self.排序参照点)
					self.已经消失 = true
				end 
				
			end 
				

			
		
		end 
		
		
		if (self.类型 == "格林机枪子弹" or  self.类型 == "银弹") then 
			self.子弹精灵:更新(dt)
			
			
		elseif ( self.类型 == "魔法星弹" ) then 
			
			self.粒子特效:移动到(self.坐标.x,self.坐标.y)
			
			self.排序参照点  = self.坐标.y  + self.排序参照点落差
			self.粒子特效.地平线  = self.排序参照点 
		end 
		
		
		
		
		

		if (self.类型 == "子弹_A" or self.类型 == "浮空弹" or  self.类型 == "银弹") then 
			if (self.坐标.y >= self.排序参照点) then 
				Q_系统:显示特效(Q_神枪手_特效_管理器,"子弹射向地面效果",self.坐标.x,self.坐标.y,1,"普通",self.方向,1)
				self.已经消失 = true 
	
			end 

		elseif (self.类型 == "哥布林石块") then 
			
			self.子弹动画:更新(dt)
			
--			for n=1 , table.getn(Q_地图.矩形_障碍层) do
--				if(Q_地图.矩形_障碍层[n].包围盒:检测_点(self.坐标.x + Q_游戏数据.画面偏移.x - self.方向*15,self.排序参照点 ) ) then
--					self.已经消失 = true 
--					self.子弹特效.已经消失 = true
--					local test物理 = 特效_物理行为类.创建("石块爆炸",self.坐标.x,self.坐标.y-20,self.排序参照点)
--					加入屏幕物件组(test物理)
--					table.insert(Q_屏幕特效组,test物理)
--					break
--				end
--			end
	
		end 
		
	
	end 
	
	




end

--=============================================================================--
-- ■ 更新
--=============================================================================--
function 子弹类:显示()


	--引擎:画圆(self.坐标.x + Q_游戏数据.画面偏移.x,self.排序参照点 + Q_游戏数据.画面偏移.y,5,50,颜色_白)
	
	if (self.已经消失 == false ) then 
		if (self.类型 == "子弹_A" or self.类型 == "浮空弹" or  self.类型 == "格林机枪子弹" or  self.类型 == "银弹"  or  self.类型 == "魔法星弹") then 
			self.子弹精灵:显示_高级(self.坐标.x+ Q_游戏数据.画面偏移.x ,self.坐标.y+ Q_游戏数据.画面偏移.y ,self.弧度,self.方向,1)
			

			
			
			
		elseif (self.类型 == "哥布林石块") then 
			self.子弹动画:显示(self.坐标.x+ Q_游戏数据.画面偏移.x ,self.坐标.y+ Q_游戏数据.画面偏移.y)
			
		end 
		
	end 
	
	
end 



--=============================================================================--
-- ■ 攻击判断校正
--=============================================================================--
function 子弹类:攻击判断校正(n)

	引擎:置随机数种子()
	
	if ( self.状态 == "浮空弹" ) then 
		if(Q_屏幕.屏幕怪物组[n]:被攻击("神枪手",self.状态,引擎:取随机整数(110,150),50,0.2,false))then 
			Q_系统:显示特效(Q_神枪手_特效_管理器,"子弹命中",self.坐标.x ,self.坐标.y ,1,"普通",self.方向,1)
			Q_屏幕.屏幕怪物组[n]:被打飞(7,1,true)
			self.已经消失 = true 
		end 
		return 
	end 
	
	

	if(Q_屏幕.屏幕怪物组[n]:被攻击("神枪手",self.状态,引擎:取随机整数(300,550),550,0.2,false))then 
		

		
		if (self.类型 == "子弹_A" or self.类型 == "格林机枪子弹" ) then 
		
			if (self.方向 > 0) then
				if(self.角度 < 10 ) then 
					Q_系统:显示特效(Q_神枪手_特效_管理器,"子弹命中_横向",self.坐标.x ,self.坐标.y ,1,"普通",self.方向,1)
				else 
					Q_系统:显示特效(Q_神枪手_特效_管理器,"子弹命中",self.坐标.x ,self.坐标.y ,1,"普通",self.方向,1)	
				end 
			else 
				if(self.角度 > -10 ) then 
					Q_系统:显示特效(Q_神枪手_特效_管理器,"子弹命中_横向",self.坐标.x ,self.坐标.y ,1,"普通",self.方向,1)
				else 
					Q_系统:显示特效(Q_神枪手_特效_管理器,"子弹命中",self.坐标.x ,self.坐标.y ,1,"普通",self.方向,1)	
				end 
			end 
			Q_主角.子弹命中音效[引擎:取随机整数(1,2)]:播放()
		
		elseif (self.类型 == "银弹" ) then 
			Q_系统:显示特效(Q_神枪手_特效_管理器,"银弹命中",self.坐标.x 	,self.坐标.y  ,1,"普通",self.方向,1)
			Q_系统:显示特效(Q_神枪手_特效_管理器,"银弹命中",self.坐标.x - self.方向*10 ,self.坐标.y + 10 ,1,"普通",self.方向,1)
			银弹命中音效:播放()
		end 
		


--		self.子弹动画.已经消失 = true
		if (self.类型 == "子弹_A" or  self.类型 == "银弹") then 
			self.已经消失 = true 
		end 
		
		
		
		
		if ( Q_屏幕.屏幕怪物组[n].可击退 and Q_屏幕.屏幕怪物组[n]:是否在跳跃状态()  == false and Q_屏幕.屏幕怪物组[n].跳跃被攻击 == false ) then 
			Q_屏幕.屏幕怪物组[n]:被击退(6,1) 
		end 
		
		if (Q_屏幕.屏幕怪物组[n].可击飞) then 
		
			if (self.状态 == "小砍六") then 
				Q_屏幕.屏幕怪物组[n]:被打飞(4,1,false)
				return 
			end 
			
		
			if (Q_屏幕.屏幕怪物组[n]:是否在跳跃状态() or Q_屏幕.屏幕怪物组[n].状态 == "倒地") then 
					Q_屏幕.屏幕怪物组[n]:被打飞(3,2,false)
					

					--Q_屏幕.屏幕怪物组[n].跳跃被攻击 = true 
					--Q_屏幕.屏幕怪物组[n].跳跃被攻击延迟 = 0
		
					
					
				return
				
				
			end 
		
		end 

		
		
	end 

end 



--=============================================================================--
-- ■ 主角_攻击判断校正
--=============================================================================--
function 子弹类:主角_攻击判断校正(n)

	引擎:置随机数种子()



	if(Q_主角:被攻击("石块",self.状态,引擎:取随机整数(1,5),5,self.方向))then 
	
		self.已经消失 = true 


		if (Q_主角.状态 == "格挡" ) then 
			Q_主角:被击退(6,1,self.方向)
		else 
			
			if (Q_主角:是否在跳跃状态()) then 
				Q_主角:被打飞(6,4,true)
			end 
			
			Q_系统:显示特效(Q_屏幕_特效_管理器,"打击三",self.坐标.x ,self.坐标.y ,1,"普通",self.方向,0.8)
			石头击中音效:播放()
		end 

		
		if ( self.类型 == "哥布林石块" ) then 
			--self.子弹特效.已经消失 = true
--			local test物理 = 特效_物理行为类.创建("石块爆炸",self.坐标.x,self.坐标.y-20,self.排序参照点)
--			加入屏幕物件组(test物理)
--			table.insert(Q_屏幕特效组,test物理)
			
		end 

		
		
	end 

end 


--=============================================================================--
-- ■ 销毁
--=============================================================================--
function 子弹类:	销毁()
	if (self.类型 == "子弹_A" or self.类型 == "浮空弹"  or  self.类型 == "银弹") then 
		self.子弹精灵:销毁()
	end 
end 
