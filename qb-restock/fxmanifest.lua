fx_version 'cerulean'
game 'gta5'

description 'Boostingdealer'
version '0.8.1'

client_scripts {'client/*.lua'} 
ui_page 'html/index.html'
server_scripts {
    'server/*.lua',
    '@mysql-async/lib/MySQL.lua',
}
shared_script 'config.lua'


escrow_ignore {
    'config.lua',
    'client/cl_utils',
    'server/sv_utils',
    'README.md',
    'stock.sql'
}

lua54 'yes'