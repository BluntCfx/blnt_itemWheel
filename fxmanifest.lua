fx_version 'cerulean'
game 'gta5'
name "blnt_itemWheel"
description "item wheel for ox_inventory"
author "Blunt"
version "1.0.0"

ui_page 'ui/dist/index.html'

files {
	'ui/dist/index.html',
	'ui/dist/assets/*.*',
	'ui/dist/images/*.*',
	'ui/dist/**/*.*'
}

shared_scripts {
	'shared/*.lua',
}

client_scripts {
	'client/*.lua',
}

dependencies {
	'ox_inventory'
}
