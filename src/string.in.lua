local _M = {};
local _G = require "_G";
local string = require "string";
local table = require "table";

local setmetatable = _G.setmetatable;
local string_find, string_sub = string.find, string.sub;
local table_insert = table.insert;

_M.__index = string;

function _M.split( s, separator, limit )
	local t = {};
	local i = 1;
	limit = limit or -1;
	while limit ~= 0 do
		local from, to = string_find( s, separator, i );
		if not from then
			break;
		end
		table_insert( t, string_sub(s, i, from-1) );
		i = to + 1;
		limit = limit - 1;
	end
	return t;
end

return setmetatable( _M, _M );
