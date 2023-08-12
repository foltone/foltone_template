fx_version 'cerulean'

games { 'gta5' };

client_scripts {
	"src/RageUI.lua",
	"src/Menu.lua",
	"src/MenuController.lua",
	"src/components/*.lua",
	"src/elements/*.lua",
	"src/items/*.lua"
}

client_scripts {
    '@es_extended/locale.lua',
    'client/*.lua',
	'Config.lua'
}

server_script {
    'server/*.lua',
}