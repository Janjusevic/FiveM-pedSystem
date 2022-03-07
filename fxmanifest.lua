fx_version 'adamant'

games {'gta5'}

author 'Janjusevic'

description 'For ESX framework'

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

client_script {
    'client.lua'
}

dependency {
    'mysql-async'
}
