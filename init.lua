local robot = {}
local explore_steps_wait = 1 -- 5 seconds
local explore_steps_width = 1 -- jump 50 nodes

minetest.register_chatcommand('start',{
    description = 'Begin map exploration',
    privs = {privs=false},
    func = function(name, params)
		local player = minetest.env:get_player_by_name(name)
		local pos = player:getpos()--posiion bestimmen
		table.insert(robot, {name = name, x = pos.x, y = pos.y, z = pos.z, wait = 0, c = 0, l = 0, d = -90})
    end
})

minetest.register_chatcommand('stop',{
    description = 'End map exploration',
    privs = {privs=false},
    func = function(name, params)
		for i,v in ipairs(robot) do
			if v.name == name then 
				local player = minetest.env:get_player_by_name(name)
				player:setpos({x = v.x, y = v.y, z = v.z})
				table.remove(robot, i)
			end
		end
    end
})

minetest.register_globalstep(function(dtime)
	local players  = minetest.get_connected_players()
	for i,player in ipairs(players) do
		local player_name = player:get_player_name()
		for j,v in ipairs(robot) do
			if v.name == player_name then
				if v.wait == 0 then
					v.wait = explore_steps_wait
					-- turn
					if v.c == 0 then
						v.d = v.d + 90
						if v.d == 360 then v.d = 0 end
						if v.d == 0 or v.d == 180 then v.l = v.l + 1 end
						v.c = v.l
					end
					local position_spieler = player:getpos()
					
					position_spieler= tunnel(position_spieler,player)
					v.c = v.c - 1
				end
				v.wait = v.wait - 1
			end
		end
	end
end)

function tunnel (player_pos,spieler)
	      
	      pos = {x = player_pos.x + explore_steps_width , y = player_pos.y, z = player_pos.z }
	      minetest.env:add_node({x=pos.x,   y=pos.y-1, z=pos.z  },{name="default:cobble"})
	      minetest.env:add_node({x=pos.x,   y=pos.y-1, z=pos.z+1  },{name="default:cobble"})
	      minetest.env:add_node({x=pos.x,   y=pos.y-1, z=pos.z+2  },{name="default:cobble"})
	      minetest.env:add_node({x=pos.x,   y=pos.y-1, z=pos.z+3  },{name="default:cobble"})
		for variable_hoehe = 0,2,1 do
			for variable_breite= 0,3,1 do
				--[[ if minetest.env:get_node({x=pos.x, y=pos.y+variable_hoehe, z=pos.z+variable_breite}).name ~= "air" then
				    minetest.env:add_node({x=pos.x,   y=pos.y+variable_hoehe, z=pos.z+variable_breite  },{name="air"})
				 end]]
				minetest.env:remove_node({x=pos.x, y=pos.y+variable_hoehe, z=pos.z+variable_breite})
			 end
		end
		
		if ((pos.x%5) <1) then 
		  minetest.env:add_node({x=pos.x,   y=pos.y+2, z=pos.z+1  },{name="default:torch"})
		  minetest.env:add_node({x=pos.x,   y=pos.y+2, z=pos.z+2  },{name="default:torch"})
		  minetest.env:add_node({x=pos.x,   y=pos.y-1, z=pos.z-1},{name="default:cobble"})
		  minetest.env:add_node({x=pos.x,   y=pos.y-1, z=pos.z+4},{name="default:cobble"})
		  for hoehe1=0,3,1 do
		    if minetest.env:get_node({x=pos.x, y=pos.y+hoehe1, z=pos.z-1}).name == "air" then
		      minetest.env:add_node({x=pos.x,   y=pos.y+hoehe1, z=pos.z-1  },{name="default:fence_wood"})
		    end
		    
		    if minetest.env:get_node({x=pos.x,   y=pos.y+hoehe1, z=pos.z+4  }).name == "air" then
		      minetest.env:add_node({x=pos.x,   y=pos.y+hoehe1, z=pos.z+4  },{name="default:fence_wood"})
		    end
		  end

		  for breite1 =0,3,1 do
		      if minetest.env:get_node({x=pos.x, y=pos.y+3, z=pos.z+breite1}).name == "air" then
		      minetest.env:add_node({x=pos.x,   y=pos.y+3, z=pos.z+breite1 },{name="default:fence_wood"})
		      end
		  end
		  

		  
		end
		spieler:moveto(pos)
		return spieler
 end