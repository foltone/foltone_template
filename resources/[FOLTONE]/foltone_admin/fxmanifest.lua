fx_version "cerulean"

author "Foltone#6290"

games { "gta5" };

lua54 "yes"

ui_page "client/nui/index.html"

files {
    "client/nui/index.html",
    "client/nui/script.js",
    "client/nui/img/*.png"
}

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
    "client/cl_main.lua"
}

server_script {
    "server/sv_main.lua"
}

dependencies {
    "es_extended"
}
