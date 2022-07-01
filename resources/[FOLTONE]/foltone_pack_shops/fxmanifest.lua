fx_version 'cerulean'

author 'Foltone#6290'

games { 'gta5' };

client_scripts {
	"src/RageUI.lua",
	"src/Menu.lua",
	"src/MenuController.lua",
	"src/components/*.lua",
	"src/elements/*.lua",
	"src/items/*.lua",
	"src/panels/*.lua",
	"src/windows/*.lua"
}

client_scripts {
    'client/*.lua',
	'@es_extended/locale.lua',
	'config.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/sv_main.lua'
}

dependencies {
	'es_extended'
}