# Gif-boostingdealer
If you need any help or have a suggestion feel free to contact me on discord https://discord.gg/Rx5yJsyYCE 
## Requirements
1. qb-core
2. qb-management
3. qb-menu
4. qb-target

## How to install 

1. Extract and place the folder in your resources folder

2. Import the database file stock.sql

3. add the job to your qb-core/shared/jobs.lua 
 ['boostdealer'] = {
		label = 'Illegal car dealer',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
        },
	},

4. add the job to qb-management/client/cl_config.lua
['boostdealer'] = {
        { coords = vector3(725.07, -1070.76, 28.31), length = 1.8, width = 1, heading = 0.0, minZ = 27.46, maxZ = 28.26 },
    },

5. If you want the tablet and the hacking device to be a item you need to add it to qb-core/shared/items.lua and add images for them into your inventoryscript/html/images
	['tablet'] 				 		 = {['name'] = 'tablet', 			  	  		['label'] = 'Tablet', 					['weight'] = 2000, 		['type'] = 'item', 		['image'] = 'tablet.png', 				['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Expensive tablet'},

    ['hacking_device']			  = {['name'] = "hacking_device",					['label'] = "Hacking device",			['weight'] = 500,		['type'] = 'item', 		['image'] = 'hacking_device.png',			['unique'] = true,		['useable']	= true,		['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = "Hacking device"},


that's it 

# Configuration

On default the hacking is disabled you need to add your own hack. I can recommend the lion boosting hack but you can use whatever you like (https://github.com/Lionh34rt/boostinghack) I have a example of how to setup the lionhack in cl_utils.lua you can just uncomment it if you want to use it 


