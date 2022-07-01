fx_version 'cerulean'

author 'Foltone#6290'

games { 'gta5' };

client_scripts {
	"src/Keys.lua",
}

client_scripts {
    '@es_extended/locale.lua',
    'Config.lua',
    'client/*.lua',
    'locales/*.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
	'es_extended'
}
