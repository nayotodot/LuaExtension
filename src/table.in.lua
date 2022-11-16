local _M = {};
local _G = require "_G";
local math = require "math";
local table = require "table";

local ipairs, next, pairs, setmetatable, tostring, type = _G.ipairs, _G.next, _G.pairs, _G.setmetatable, _G.tostring, _G.type;
local math_floor, math_random = math.floor, math.random;
#if UseLua50 then
local table_getn, table_insert = table.getn, table.insert;
#else
local table_insert = table.insert;
#end

_M.__index = table;

function _M.empty( tbl )
	return type(tbl) ~= "table" or not next(tbl);
end

function _M.keys( tbl )
	local res = {};
	for k,v in pairs(tbl) do
		table_insert( res, k );
	end
	return res;
end

function _M.values( tbl )
	local res = {};
	for k,v in pairs(tbl) do
		table_insert( res, v );
	end
	return res;
end

function _M.haskey( tbl, key )
	for k,v in pairs(tbl) do
		if k == key then
			return true;
		end
	end
	return false;
end

function _M.hasvalue( tbl, value )
	for k,v in pairs(tbl) do
		if v == value then
			return true;
		end
	end
	return false;
end

function _M.each( tbl, func )
	for k,v in pairs(tbl) do
		func( v, k );
	end
end

function _M.eachi( tbl, func )
	for i,v in ipairs(tbl) do
		func( v, i );
	end
end

function _M.map( tbl, func )
	local res = {};
	for k,v in pairs(tbl) do
		res[k] = func( v, k );
	end
	return res;
end

function _M.filter( tbl, func )
	local res = {};
	for k,v in pairs(tbl) do
		if func(v,k) then
			if type(k) == "number" then
				table_insert( res, v );
			else
				res[k] = v;
			end
		end
	end
	return res;
end

function _M.pluck( tbl, key )
	local function func( v, k )
		return type(v) == "table" and v[key];
	end
	return _M.map(tbl, func);
end

function _M.reduce( tbl, func, value )
	for k,v in pairs(tbl) do
		value = func( value, v, k );
	end
	return value;
end

function _M.reject( tbl, func )
	local function func( v, k )
		return not func(v, k);
	end
	return _M.filter(tbl, func);
end

function _M.merge( dst, src )
	for k,v in pairs(src) do
		if type(dst[k]) == "table" and type(v) == "table" then
			_M.merge( dst[k], v );
		elseif type(k) == "number" then
			table_insert( dst, v );
		else
			dst[k] = v;
		end
	end
	return dst;
end

function _M.min( tbl, key )
	local function func( value, v, k )
		local x = type(v) == "table" and v[key] or v;
		if tostring(value) > tostring(x) then
			return x;
		end
		return value;
	end
	return _M.reduce(tbl, func);
end

function _M.max( tbl, key )
	local function func( value, v, k )
		local x = type(v) == "table" and v[key] or v;
		if tostring(value) < tostring(x) then
			return x;
		end
		return value;
	end
	return _M.reduce(tbl, func);
end

function _M.push( tbl, ... )
#if not UseLua50 then
	local arg = { ... };
#end
	for i,v in ipairs(arg) do
		table_insert( tbl, v );
	end
	return tbl;
end

function _M.reverse( tbl )
#if UseLua50 then
	local n = table_getn( tbl );
#else
	local n = #tbl;
#end
	for i = 1, math_floor(n/2) do
		local j = n - i + 1;
		tbl[i], tbl[j] = tbl[j], tbl[i];
	end
	return tbl;
end

function _M.shuffle( tbl )
#if UseLua50 then
	for i = 2, table_getn(tbl) do
#else
	for i = 2, #tbl do
#end
		local r = math_random( i );
		tbl[i], tbl[r] = tbl[r], tbl[i];
	end
	return tbl;
end

return setmetatable( _M, _M );
