fx_version "cerulean"

author "Foltone#6290"

games { "gta5" };

lua54 "yes"

client_scripts {
	"src/RageUI.lua",
	"src/Menu.lua",
	"src/MenuController.lua",
	"src/components/*.lua",
	"src/elements/*.lua",
	"src/items/*.lua",
	"src/panels/*.lua",

	"config.lua",
    "trad.lua",
    "locales/*.lua",
	"client/cl_main.lua"
}

server_script {
    "server/sv_main.lua",
}
