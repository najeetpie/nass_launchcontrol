fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

description 'nass_launchcontrol'
author 'Nass#1411'
version '1.0.0'

shared_scripts { 'config.lua' }

client_scripts {  'client/*.lua' }

ui_page 'html/index.html'
files { 
  "html/*",
}