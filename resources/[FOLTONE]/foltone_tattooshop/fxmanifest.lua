fx_version "cerulean"

author "Foltone#6290"

games { "gta5" };

lua54 "yes"

shared_scripts {
    "config.lua",
    "trad.lua",
    "locales/*.lua"
}

client_scripts {
    "src/RageUI.lua",
	"src/Menu.lua",
	"src/MenuController.lua",
	"src/components/*.lua",
	"src/elements/*.lua",
	"src/items/*.lua",
	"src/panels/*.lua",
	
	"client/client.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
    "server/server.lua"
}

dependencies {
	"es_extended"
}
