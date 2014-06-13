minetest.register_tool("wateringcan:wateringcan_water", {
	description = "watering can with water",
	inventory_image = "wateringcan_wateringcan_water.png",
	wield_image = "wateringcan_wateringcan_wield.png",
	on_place = function(itemstack, user, pointed_thing)
		if(pointed_thing.type == "node") then
			local node = minetest.get_node_or_nil(pointed_thing.under)
			if node ~= nil then
				local name = node.name
				local nodedef = minetest.registered_nodes[name]
				if name == "farming:soil" and minetest.get_modpath("farming") ~= nil then
					minetest.set_node(pointed_thing.under, { name = "farming:soil_wet" })
				elseif minetest.get_item_group(name, "sucky") > 0 and minetest.get_modpath("pedology") ~= nil then
					pedology.wetten(pointed_thing.under)
				end
			end
		end
	end

	}
)

minetest.register_craftitem("wateringcan:wateringcan_empty", {
	description = "empty watering can",
	inventory_image = "wateringcan_wateringcan_empty.png",
	wield_image = "wateringcan_wateringcan_wield.png",
	}
)
