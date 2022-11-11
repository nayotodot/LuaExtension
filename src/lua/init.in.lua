local _ENV = (function(base) local t = {}; for k,v in base.pairs(base) do base.rawset(t,k,v); end return t; end)(_ENV or _G.getfenv(0));
local pairs, rawget, rawset, require, setfenv, type = _ENV.pairs, _ENV.rawget, _ENV.rawset, _ENV.require, _ENV.setfenv, _ENV.type;
if setfenv then
	setfenv( 1, _ENV );
end
local __cache = {};
local __modules = {};
local function __envcopy( name )
	local f = rawget( _ENV, name );
	if type(f) ~= "table" then
		return f;
	end
	local t = {};
	for k,v in pairs(f) do
		rawset( t, k, v );
	end
	return t;
end
local function __register( modname, chunk )
	rawset( __modules, modname, chunk );
end
local function __require( modname )
	local cached = __cache[modname];
	if cached then
		return cached;
	end
	local module = __modules[modname];
	if module then
		local chunk = type(module) == "function" and module(__require) or module;
		__cache[modname] = chunk;
		return chunk;
	end
	return require( modname );
end
__register( "_G",        __envcopy("_G") );
__register( "coroutine", __envcopy("coroutine") );
__register( "table",     __envcopy("table") );
__register( "io",        __envcopy("io") );
__register( "os",        __envcopy("os") );
__register( "string",    __envcopy("string") );
__register( "utf8",      __envcopy("utf8") );
__register( "bit32",     __envcopy("bit32") );
__register( "math",      __envcopy("math") );
__register( "debug",     __envcopy("debug") );
__register( "package",   __envcopy("package") );
#for i = 1,#Libs do
__register( "$(Libs[i].modname)", function( require )
#	io.input( Libs[i].output );
#	for line in io.lines() do
#		if line ~= "" then
	$(line)
#		end
#	end
end );
#end
local function __main( require )
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
	return {
#for i = 1,#Libs do
		$(Libs[i].method) = $(Libs[i].method),
#end
	};
end
return __main( __require );
