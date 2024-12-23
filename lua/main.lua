package.path=package.path..';./lua/?.lua'

local resources = "../thirdparty/resources/resources_data/"

local items = require(resources.."items")
local item_descs = require(resources.."item_descriptions")

local gears = require("gears")
local util = require("util")

row = gears.rows(items, item_descs)

row:exportToJson()

-- util.printTable(gears.rows(items, item_descs).toReadables())
