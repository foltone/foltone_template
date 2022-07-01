fx_version 'cerulean'

author 'Foltone#6290'

games { 'gta5' };

client_scripts {
	"src/Keys.lua",
}

client_scripts {
    'client/*.lua',
	'@es_extended/locale.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
	'es_extended'
}