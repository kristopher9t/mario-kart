--Player Id Recovery
file = io.open("data/player.spl" , "r")
player = file:read()
file:close()
----------------------------------------------------
----------------------------------------------------
--Player Sprites Loading
p1 = Image.load("Sprites/select/"..player.."/1.png")
p2 = Image.load("Sprites/select/"..player.."/2.png")
p3 = Image.load("Sprites/select/"..player.."/3.png")
p4 = Image.load("Sprites/select/"..player.."/4.png")
-----------------------------------------------------
-----------------------------
--CountDown Images Loading
bl = Image.load("Sprites/Countdown/blank.png")
rm3 = Image.load("Sprites/Countdown/1.png")
rm2 = Image.load("Sprites/Countdown/2.png")
rm1 = Image.load("Sprites/Countdown/3.png")
rm = Image.load("Sprites/Countdown/4.png")
-----------------------------
-------------------------------------------
--Racetrack Images Loading
tr1 = Image.load("Sprites/Tracks/Mushroom Cup/Moo Moo Farm/1.png")
tr2 = Image.load("Sprites/Tracks/Mushroom Cup/Moo Moo Farm/2.png")
tr3 = Image.load("Sprites/Tracks/Mushroom Cup/Moo Moo Farm/3.png")
final = Image.load("Sprites/Final_Lap.png")
-------------------------------------------

tr1 = {
  x = 0;
  img = tr1;
}

tr2 = {
  x = 480;
  img = tr2;
}

tr3 = {
  x = 960;
  img = tr3;
}

function collisionType1(object)
  if (player.x + player.width > object.x) and 
     (player.x < object.x + object.width) and 
     (player.y + player.height > object.y) and 
     (player.y < object.y + object.height) then
        player.x = player.x - 2
  end
end

function collisionType2(object)
  if (player.x + player.width > object.x) and 
     (player.x < object.x + object.width) and 
     (player.y + player.height > object.y) and 
     (player.y < object.y + object.height) then
        player.x = player.x + 4
  end
end

----------------------------------------------------
--Race Track Objects
shell = Image.load("Sprites/Object/Shell.png")
star = Image.load("Sprites/Object/Star.png")
banana = Image.load("Sprites/Object/Banana.png")
mushroom = Image.load("Sprites/Object/mushroom.png")
----------------------------------------------------
----------------------
--Tables for Collisions with race Track Objects
shell = {
  height = 17;
  width = 17;
  x = 1500;
  y = math.random(66,186) ;
  img = shell;
}

star = {
  height = 16;
  width = 17;
  x = 500;
  y = math.random(66,186) ;
  img = star;
}


banana = {
  height = 15;
  width = 17;
  x = 1000;
  y = math.random(66,186) ;
  img = banana;
}

mushroom = {
  height = 17;
  width = 17;
  x = 2000;
  y = math.random(66,186) ;
  img = mushroom;
}

------------------------------------------
--Current lap Display
current_lap = 1
-----------------------
--------------------------
font = Font.load("fonts/mario.ttf")
font:setPixelSizes(20,20)
------------------------

Olpad = Controls.read()
minuteur = Timer.new()
minuteur:start()

player = {
  x = 60;
  y = 120;
  height = 44;
  width = 44;
  img = p1;
  walk = 1;
}

countdown = {
img = bl;
}

finalx = 480

--Boost Setup
boost = 250

race = false

--Main Loop
while true do
  currentTime = minuteur:time()
  timer = currentTime/1000
  m_timer = (math.floor(timer)-6)
  
  screen:clear()
  pad = Controls.read()

  --Player Animation
  if player.walk >= 0 then player.img = p1 end
  if player.walk >= 5 then player.img = p2 end
  if player.walk >= 10 then player.img = p3 end
  if player.walk >= 15 then player.img = p4 end
  if player.walk >= 20 then player.walk = 0 end

  --Player Should Not Go out of Window Screen
  if player.x <= 0 then player.x = 0 
  elseif player.x >= 480 - player.width then player.x = 480 - player.width end
  if player.y <= 0 then player.y = 0
  elseif player.y >= 272 - player.height then player.y = 272 - player.height end

  if tr1.x == -480 then
    tr1.x = 960
  end

  if tr2.x == -480 then
    tr2.x = 960
  end
  
  if tr3.x == -480 then
    tr3.x = 960
    current_lap = current_lap + 1
  end

  --Start CountDown Animation
  if currentTime >= 1000 then countdown.img = bl end
  if currentTime >= 2000 then countdown.img = rm3 end
  if currentTime >= 3000 then countdown.img = rm2 end
  if currentTime >= 4000 then countdown.img = rm1 end
  if currentTime >= 5000 then countdown.img = rm end
  if currentTime >= 6000 then 
    countdown.img = bl
    race = true
  end

  if race == true  then
    tr1.x = tr1.x - 6 
    tr2.x = tr2.x - 6
    tr3.x = tr3.x - 6
    player.walk = player.walk + 1.5
    --Moving Race Objects
    banana.x = banana.x - 4.5
    if banana.x <= - 50 then 
      banana.x = 1100
      banana.y = math.random(66,186)
    end

    shell.x = shell.x - 3.5
    if shell.x <= - 60 then 
      shell.x = 750
      shell.y = math.random(66,186)
    end

    star.x = star.x - 4.9
    if star.x <= - 60 then 
      star.x = 900
      star.y = math.random(66,186)
    end

    mushroom.x = mushroom.x - 5
    if mushroom.x <= 70 then
      mushroom.x = 700
      mushroom.y = math.random(66,186)
    end
  ---------------------------------------------
    collisionType1(banana)
    collisionType1(shell)
    collisionType2(mushroom)
    collisionType2(star)
  -----------------------------------------------

    if pad:up() then player.y = player.y - 1.2 end
    if pad:down() then player.y = player.y + 1.2 end

    if pad:square() then 
      player.x = player.x - 0.2
    end

    if pad:cross() and boost > 0 then 
      player.x = player.x + 0.2
      boost = boost - 0.8
      if boost <= 0 then boost = 0 end
    end
    
    if current_lap == 8 then
      finalx = finalx - 5
      screen:blit(finalx,30,final)
    end

    if current_lap == 9  then
      minuteur:stop()
      file = io.open("results/temp.spl" , "w")
      file:write(m_timer)
      file:close()
      file = io.open("results/5temp.spl" , "w")
      file:write(m_timer)
      file:close()
      screen:clear()
      dofile("race_results.lua")
    end
    --Custom Track Collisions
    if player.y <= 66 - player.height then player.y = 66 - player.height
    elseif player.y >= 186 - player.height then player.y = 186 - player.height end
  end

  --Lap Scrolling Animation
  screen:blit(tr1.x,0,tr1.img)
  screen:blit(tr2.x,0,tr2.img)
  screen:blit(tr3.x,0,tr3.img)

  screen:blit(player.x,player.y,player.img)
  screen:blit(shell.x, shell.y, shell.img)
  screen:blit(banana.x, banana.y, banana.img)
  screen:blit(star.x, star.y, star.img)
  screen:blit(mushroom.x,mushroom.y,mushroom.img)

  --Rece Events
  screen:fillRect(95,17.5,boost,15,Color.new(255,255,0,255))
  if m_timer >= 0 then screen:fontPrint(font,50,250,"Time: "..m_timer.." Seconds",Color.new(0,255,0)) end
  screen:fontPrint(font,10,35,"Boost: ",Color.new(0,255,0))
  screen:blit(10,10,countdown.img)
  screen:fontPrint(font,400,250,""..current_lap.."/8",Color.new(0,255,0))

  oldpad = pad
  
  screen.waitVblankStart()
  screen.flip()
end