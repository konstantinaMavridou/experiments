--effects
bg={}
bg.col=1
movespeed=3
message="pointz"
shadowcol=0
ang=0
texty=0
transition=0
counting=false
auto=false
currentscore=0

heartsx=60
heartsy=60
heartw=1
hearth=1
wacc=0

function textmiddle(s)
 return 64-flr((#s*4)/2)
end
 
function textmiddley(s)
 return 64-flr(5/2)
end

function make_smoke(x,y,init_size,col)
 local s={}
 s.x=x
 s.y=y
 s.col=col
 s.width=init_size
 s.width_final=1
 --init_size+rnd(3)+1
 s.t=0
 s.max_t=30+rnd(10)
 s.dx=rnd(0.8)*0.4
 s.dy=rnd(0.05)
 s.ddy=.02
 add(smoke,s)
 return s
end

function makescore(x,y,val)
 local s={}
 s.x=x
 s.y=y
 s.t=0
 s.max_t=15
 s.col=rnd(16)
 s.val=val
 add(scores,s)
 return s
end

function _init()
 mode=0
 bars={}
 smoke={}
 scores={}
 drops={}
 cursorx=50
 cursory=50
 cursorxdir=(flr(rnd(3)-1))*5
 cursorydir=(flr(rnd(3)-1))*5
 --cursorxdir=5
 --cursorydir=-3
 color=7

end

function move_smoke(sp)
 if (sp.t>sp.max_t)then
  del(smoke,sp)
 end
 if (sp.t>sp.max_t) then
  sp.width+=1
  sp.width=min(sp.width,sp.width_final)
 end
 local minus=0
 minus=flr(rnd(2))
 if minus==0 then
  sp.x=sp.x-sp.dx
 elseif minus==1 then
  sp.x=sp.x+sp.dx
 end
 sp.y=sp.y+sp.dy
 sp.dy=sp.dy+sp.ddy
 sp.t=sp.t+1
end

function movescore(sp)
 if (sp.t>sp.max_t)then
  del(scores,sp)
 end
 sp.x+=1
 sp.y-=1
 sp.t=sp.t+1
 sp.col=rnd(16)+1
end

function _update()
if mode==1 then
 if auto==true then
 cursorx=cursorx+cursorxdir
 cursory=cursory+cursorydir
 end
 foreach(smoke,move_smoke)
 foreach(scores,movescore)
 foreach(bars,updatebars)
 foreach(drops,updatedrops)
 if btn(0,0) then
  cursorx-=movespeed
  make_smoke(cursorx,cursory,rnd(5),color)
 end
 if btn(1,0) then 
  cursorx+=movespeed 
  make_smoke(cursorx,cursory,rnd(5),color)
 end
 if btn(2,0) then
  cursory-=movespeed
  make_smoke(cursorx,cursory,rnd(5),color)
 end
 if btn(3,0) then
  cursory+=movespeed
  make_smoke(cursorx,cursory,rnd(5),color)
 end
 if btn(4,0) then color=flr(rnd(16))end
 if btnp(4,0) then
  if auto==false then
   auto=true
  else
   auto=false
  end
 end
 if btnp(5,0) then makescore(cursorx,cursory,message) end
 if btnp(5,0) then 
 local p=rnd(128)
 local q=rnd(128)
 for i=1,4 do
  makedrops(p,q)
 end 
 end
  if cursorx>127 or cursorx<0 then
   cursorxdir=-cursorxdir
  end
 if cursory>127 or cursory<0 then
  cursorydir=-cursorydir
 end
elseif mode==0 then
 foreach(bars,updatebars)
 if ang<1 then
  ang+=0.01
 else ang=0
 end
 texty=5*sin(ang)
 if counting==false then
  if btnp(4) then
   counting=true
   for j=1,127,127/7 do
    makebars(0,j,rnd(16)+1)
   end
  end
 end
 if counting==true then
  transition+=1
 end
 if transition>30*(3/4) then
  mode=1
 end
 if btnp(5) then
  heart=true
 end
 if heart==true then
  if wacc==0 then
   bigger=true
  elseif wacc==20 then
   bigger=false
  end
  if bigger==true then
   wacc+=1
   heartsx-=1*wacc
   heartsy-=1*wacc
   heartw+=2*wacc
   hearth+=2*wacc
  else 
   --wacc-=1
   heartsx+=1*wacc
   heartsy+=1*wacc
   heartw-=2*wacc
   hearth-=2*wacc
  end
 end
 end
end

function draw_smoke(s)
 circfill(s.x,s.y,s.width,s.col)
end

function draw_smokeshadow(s)
 circfill(s.x+2,s.y+2,s.width,shadowcol)
end

function drawscores(s)
 print(s.val,s.x+1,s.y+1,0)
 print(s.val,s.x,s.y,s.col)
end
 
function _draw()
 cls()
if mode==1 then
 rectfill(0,0,127,127,bg.col)
 foreach(smoke,draw_smokeshadow)
 foreach(smoke,draw_smoke)
 foreach(scores,drawscores)
 foreach(drops,drawdrops)
 circfill(cursorx,cursory,2,11)
 f="score: "..currentscore
 print(f,textmiddle(f),127-7,7)
 foreach(bars,drawbars)
 
elseif mode==0 then
 cls()
 rectfill(0,0,127,127,bg.col)
 tx="press z to start"
 if transition<15 then
 print(tx,textmiddle(tx),64+texty,7)
 end
 foreach(bars,drawbars)
 end
 if heart==true then
  drawheart(heartsx,heartsy,heartw,hearth)
 end
 --print(wacc,64,64,11)
end 


function makebars(x,y,col)
 bar={}
 bar.col=col
 --bar.col=rnd(16)+1
 bar.t=0
 bar.t_max=30
 bar.x=x+127
 bar.y=y
 add(bars,bar)
 return bar
end

function updatebars(br)
 if br.t>br.t_max then
  del(bars,br)
 end
 br.t+=1
 br.x-=127/(15)
end

function drawbars(br)
 rectfill(br.x,br.y,br.x+127,br.y+127,br.col)
end

function drawheart(sx,sy,w,h)
 palt(0,false)
 palt(11,true)
 --pal(o,rnd(16)+1)
 sspr(8,0,8,7,sx,sy,w,h)
 pal()
 palt()
end

function makedrops(x,y)
 local d={}
 d.x=x
 d.y=y
 d.t=0
 d.xdir=flr(rnd(3)-1)
 d.ydir=flr(rnd(3)-1)
 d.rad=rnd(2)+1
 d.col=rnd(16)+1
 d.speed=1
 add(drops,d)
 return d
end

function updatedrops(dr)
 dr.t+=1
 dr.x=dr.x+dr.xdir
 dr.y=dr.y+dr.ydir
 if dr.t > 15 then
  dr.speed+=0.1
  if flr(dr.x) < cursorx-1 then
   dr.xdir=dr.speed
  end
  if flr(dr.x) > cursorx+1 then 
   dr.xdir=-dr.speed
  end
  if flr(dr.y) < cursory-1 then
   dr.ydir=dr.speed
  end
  if flr(dr.y) > cursory+1 then 
   dr.ydir=-dr.speed
  end
  if flr(dr.x)==cursorx then
   dr.xdir=0
  end
  if flr(dr.y)==cursory then
   dr.ydir=0
  end
 end
 dr.col=rnd(16)+1
 if dr.x > cursorx-dr.speed and dr.x < cursorx+dr.speed then
  if dr.y > cursory-dr.speed and dr.y < cursory+dr.speed then
   del(drops,dr)
   currentscore+=10
   makescore(cursorx,cursory,"picked up")
  end
 end
end

function drawdrops(dr)
 circfill(dr.x,dr.y,dr.rad,dr.col)
end



