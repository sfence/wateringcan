if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
else
	S = function ( s ) return s end
end

minetest.register_tool("wateringcan:wateringcan_water", {
	description = S("watering can with water"),
	inventory_image = "wateringcan_wateringcan_water.png",
	wield_image = "wateringcan_wateringcan_wield.png",
	liquids_pointable = true,
	stack_max = 1,
	tool_capabilities = {
		full_punch_interval = 2.0,
	},
	on_place = function(itemstack, user, pointed_thing)
		if(pointed_thing.type == "node") then
			local pos = pointed_thing.under
			local node = minetest.get_node_or_nil(pos)
			if node ~= nil then
				local name, nodedef
				local watered = true
				local wear, newtool
				local underunder
				if minetest.get_item_group(node.name, "plant") > 0 or minetest.get_item_group(node.name, "flora") > 0 or minetest.get_item_group(node.name, "seed") > 0 then
					pos = {x=pos.x, y=pos.y-1, z=pos.z}
					underunder = minetest.get_node_or_nil(pos)
					if(underunder ~= nil) then
						name = underunder.name
						nodedef = minetest.registered_nodes[name]
					else
						return itemstack
					end
				else
					name = node.name
					nodedef = minetest.registered_nodes[name]
				end
				if minetest.get_item_group(name, "water") > 0 then
					newtool = { name = "wateringcan:wateringcan_water" }
					watered = false
				elseif name == "farming:soil" and minetest.get_modpath("farming") ~= nil then
					minetest.set_node(pos, { name = "farming:soil_wet" })
				elseif name == "farming:desert_sand_soil" and minetest.get_modpath("farming") ~= nil then
					minetest.set_node(pos, { name = "farming:desert_sand_soil_wet" })

				elseif minetest.get_item_group(name, "sucky") > 0 and minetest.get_item_group(name, "wet") < 2 and minetest.get_modpath("pedology") ~= nil then
					pedology.wetten(pos)
				end

				if watered then
					wear = itemstack:get_wear()
					wear = wear + 2849	 -- 24 uses
					if(wear > 65535) then
						newtool = { name = "wateringcan:wateringcan_empty" }
					else
						newtool = { name = "wateringcan:wateringcan_water", wear = wear }
					end
				end
				return newtool
			end
		end
	end

	}
)

minetest.register_tool("wateringcan:wateringcan_empty", {
	description = S("empty watering can"),
	inventory_image = "wateringcan_wateringcan_empty.png",
	wield_image = "wateringcan_wateringcan_wield.png",
	liquids_pointable = true,
	stack_max = 1,
	tool_capabilities = {
		full_punch_interval = 2.0,
	},
	on_place = function(itemstack, user, pointed_thing)
		local node = minetest.get_node_or_nil(pointed_thing.under)
		if node ~= nil then
			local name = node.name
			local nodedef = minetest.registered_nodes[name]
			if minetest.get_item_group(name, "water") > 0 then
				return { name = "wateringcan:wateringcan_water" }
			end
		end
	end
})
