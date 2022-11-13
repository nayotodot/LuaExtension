#if UseLua50 then
assert( _LOADED, "'_LOADED' is not found" );
_LOADED["_G"]     = pcall(require,"_G")     and _LOADED["_G"]     or _G;
_LOADED["math"]   = pcall(require,"math")   and _LOADED["math"]   or math;
_LOADED["string"] = pcall(require,"string") and _LOADED["string"] or string;
_LOADED["table"]  = pcall(require,"table")  and _LOADED["table"]  or table;
#end
local _G = require "_G";
local math = require "math";
local string = require "string";
local table = require "table";

local pairs, rawset = _G.pairs, _G.rawset;

local function merge( dst, src )
	for k,v in pairs(src) do
		rawset( dst, k, v );
	end
	return dst;
end
#for i = 1,#Libs do
merge( $(Libs[i].method), require "$(Libs[i].modname)" );
#end
