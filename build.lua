local prep = require "utils.preprocessor";

IsLua50 = true;
Libs = {
	{ method = "_G",     modname = "extends.base",   input = "src/lua/base.in.lua",   output = "out/lua/base.lua"   },
	{ method = "math",   modname = "extends.math",   input = "src/lua/math.in.lua",   output = "out/lua/math.lua"   },
	{ method = "string", modname = "extends.string", input = "src/lua/string.in.lua", output = "out/lua/string.lua" },
	{ method = "table",  modname = "extends.table",  input = "src/lua/table.in.lua",  output = "out/lua/table.lua"  },
};

os.execute( "mkdir -p out/lua/" );

for i = 1,#Libs do
	local chunk = prep.read( Libs[i].input );
	prep.write( Libs[i].output, chunk );
end

os.execute( "mkdir -p lib/extends/" );

do
	local chunk = prep.read( "src/lua/init.in.lua" );
	prep.write( "lib/extends/lua.lua", chunk );
end
