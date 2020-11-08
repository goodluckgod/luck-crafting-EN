fx_version 'adamant'

game 'gta5'

name 'luck-crafing'
description 'esx_inventoryhud based inspired from disc-inventoryhud Inventory for ESX'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
  'config.lua',
}

client_scripts {
  'config.lua',
  'client.lua'
}

ui_page {
	'html/ui.html'
}

files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/*.js",
  "html/img/*.png",
  "html/img/items/*.png",
}

dependencies {
  'es_extended'
}
