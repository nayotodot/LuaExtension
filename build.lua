#!/usr/bin/env lua
local preproc = require "utils.preprocessor";
local function ParseQuery( query )
	local res = {};
	for i = 1,#query do
		local k, v = (query[i]):match("(%w+)=(%w+)");
		if tonumber(v) then
			res[k] = tonumber(v);
		elseif v == "true" then
			res[k] = true;
		elseif v == "false" then
			res[k] = false;
		else
			res[k] = v;
		end
	end
	return res;
end

local defines = ParseQuery( arg );
local Libs = {
	{ method = "_G",     modname = "extends.base",   input = "src/lua/base.in.lua",   output = "lib/extends/base.lua"   },
	{ method = "math",   modname = "extends.math",   input = "src/lua/math.in.lua",   output = "lib/extends/math.lua"   },
	{ method = "string", modname = "extends.string", input = "src/lua/string.in.lua", output = "lib/extends/string.lua" },
	{ method = "table",  modname = "extends.table",  input = "src/lua/table.in.lua",  output = "lib/extends/table.lua"  },
};
defines.Libs = Libs;

os.execute( "mkdir -p lib/extends/" );

for i = 1,#Libs do
	local chunk = preproc.read( Libs[i].input, defines );
	preproc.write( Libs[i].output, chunk );
end

do
	local chunk = preproc.read( "src/lua/init.in.lua", defines );
	preproc.write( "lib/extends/init.lua", chunk );
end
