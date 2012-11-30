local robot = {}
local explore_steps_wait = 10 -- 5 seconds
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

minetest.register_chatcommand('end',{
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
					--local dx = math.sin(math.rad(v.d))
					--local dz = math.cos(math.rad(v.d))
					local player_pos = player:getpos()
					--pos = {x = player_pos.x + explore_steps_width * dx, y = player_pos.y, z = player_pos.z + explore_steps_width * dz}
					pos = {x = player_pos.x + explore_steps_width , y = player_pos.y, z = player_pos.z }
					-- player:setpos(pos)
					minetest.env:add_node({x=pos.x,   y=pos.y, z=pos.z  },{name="default:cobble"})
					minetest.env:add_node({x=pos.x,   y=pos.y, z=pos.z+1  },{name="default:cobble"})
					minetest.env:add_node({x=pos.x,   y=pos.y, z=pos.z+2  },{name="default:cobble"})
					minetest.env:add_node({x=pos.x,   y=pos.y, z=pos.z+3  },{name="default:cobble"})
					for variable_hoehe = 1,3,1 do
					  for variable_breite= 0,3,1 do
					    if minetest.env:get_node({x=pos.x, y=pos.y+1+variable_hoehe, z=pos.z+variable_breite}).name ~= "air" then
					      minetest.env:add_node({x=pos.x,   y=pos.y+1+variable_hoehe, z=pos.z+variable_breite  },{name="air"})
					    end
					  end
					end
					minetest.env:add_node({x=pos.x,   y=pos.y+3, z=pos.z+3  },{name="default:torch"})
					minetest.env:add_node({x=pos.x,   y=pos.y+3, z=pos.z+0  },{name="default:torch"})
					player:moveto(pos)
					v.c = v.c - 1
				end
				v.wait = v.wait - 1
			end
		end
	end
end)