fx_version 'cerulean'
game 'gta5'

author 'Flakey'
description 'Basic FiveM Framework with oxmysql'
version '1.0.0'

dependency 'oxmysql'
server_script '@oxmysql/lib/MySQL.lua'

server_script "server/**/*"
client_script "client/**/*"
client_script "stream/**/*"