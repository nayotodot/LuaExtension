local _M = {};
#if IsLua50 then
local _G = require "_G";
#end
local math = require "math";
local table = require "table";

#if IsLua50 then
local unpack = _G.unpack;
#end
local math_atan2, math_ceil, math_floor, math_random = math.atan2 or math.atan, math.ceil, math.floor, math.random;
#if IsLua50 then
local table_getn = table.getn;
#else
local table_unpack = table.unpack;
#end

function _M.angle( x1, y1, x2, y2 )
	return math_atan2(y2 - y1, x2 - x1);
end

function _M.clamp( x, l, h )
	return (x < l and l) or (x > h and h) or x;
end

function _M.distance( x1, y1, x2, y2 )
	return _M.hypot(x2 - x1, y2 - y1);
end

function _M.frac( x )
	return x - _M.trunc(x);
end

function _M.hypot( ... )
	local l = 0;
#if IsLua50 then
	for i = 1,table_getn(arg) do
#else
	local arg = { ... };
	for i = 1,#arg do
#end
		l = l + (arg[i] * arg[i]);
	end
	return l ^ 0.5;
end

function _M.mod( x, y )
	return x - math_floor(x/y) * y;
end

function _M.normalize( ... )
#if IsLua50 then
	local l = _M.hypot( unpack(arg) );
	for i = 1,table_getn(arg) do
#else
	local l = _M.hypot( ... );
	local arg = { ... };
	for i = 1,#arg do
#end
		arg[i] = (l == 0.0 and 0) or (arg / l);
	end
#if IsLua50 then
	return unpack(arg), l;
#else
	return table_unpack(arg), l;
#end
end

function _M.prandom( m, n )
	return math_random() * (n - m) + m;
end

function _M.round( num, ndp )
	local mult = 10 ^ (ndp or 0);
	local func = num < 0 and math_ceil or math_floor;
	return func(num * mult + _M.sign(num) * 0.5) / mult;
end

function _M.rsign()
	return math_random() < 0.5 and -1 or 1;
end

function _M.sign( x )
	return (x < 0 and -1) or (x > 0 and 1) or 0;
end

function _M.smoothstep( e1, e2, x )
	local t = _M.clamp( (x - e1) / (e2 - e1), 0, 1 );
	return (t * t) * (3 - 2 * t);
end

function _M.trunc( x )
	return x < 0 and math_ceil(x) or math_floor(x);
end

return _M;
