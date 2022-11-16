local _M = {};
local _G = require "_G";
local math = require "math";

local getmetatable, pairs, setmetatable, type = _G.getmetatable, _G.pairs, _G.setmetatable, _G.type;
local math_abs = math.abs;

_M.__index = _G;

function _M.isnil( n )      return type(n) == "nil";      end
function _M.isboolean( n )  return type(n) == "boolean";  end
function _M.isnumber( n )   return type(n) == "number";   end
function _M.isstring( n )   return type(n) == "string";   end
function _M.istable( n )    return type(n) == "table";    end
function _M.isfunction( n ) return type(n) == "function"; end
function _M.isuserdata( n ) return type(n) == "userdata"; end
function _M.isthread( n )   return type(n) == "thread";   end

function _M.approach( val, other_val, to_move )
	if val ~= other_val then
		local delta = other_val - val;
		local sign = delta / math_abs(delta);
		local tomove = sign * to_move;
		if math_abs(tomove) > math_abs(delta) then
			tomove = delta;
		end
		val = val + tomove;
	end
	return val;
end

function _M.lerp( x, l, h )
	return x * (h - l) + l;
end

function _M.scale( x, l1, h1, l2, h2 )
	return (x - l1) * (h2 - l2) / (h1 - l1) + l2;
end

function _M.ivalues( t )
	local i = 0;
	return function()
		i = i + 1;
		return t[i];
	end;
end

function _M.iif( expr, truepart, falsepart )
	return expr and truepart or falsepart;
end

function _M.shallowcopy( orig )
	if not _M.istable(orig) then
		return orig;
	end
	local copy = {};
	for k,v in pairs(orig) do
		copy[k] = v;
	end
	return copy;
end

function _M.deepcopy( orig, memoize )
	memoize = memoize or {};
	if not _M.istable(orig) then
		return orig;
	elseif memoize[orig] then
		return memoize[orig];
	end
	local copy = {};
	memoize[orig] = copy;
	for k,v in pairs(orig) do
		copy[_M.deepcopy(k, memoize)] = _M.deepcopy( v, memoize );
	end
	return setmetatable( copy, _M.deepcopy(getmetatable(orig), memoize) );
end

return setmetatable( _M, _M );
