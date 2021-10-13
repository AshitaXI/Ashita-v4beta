--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

require('common');

--[[
* Returns a table that contains every zones DAT file that contains it's list of npcs/mobs.
*
* Key: The zone id.
* Val: The zone DAT path.
--]]

return T{
    [1] = '/ROM3/2/111.DAT',    -- Phanauet Channel
    [2] = '/ROM3/2/112.DAT',    -- Carpenters' Landing
    [3] = '/ROM3/2/113.DAT',    -- Manaclipper
    [4] = '/ROM3/2/114.DAT',    -- Bibiki Bay
    [5] = '/ROM3/2/115.DAT',    -- Uleguerand Range
    [6] = '/ROM3/2/116.DAT',    -- Bearclaw Pinnacle
    [7] = '/ROM3/2/117.DAT',    -- Attohwa Chasm
    [8] = '/ROM3/2/118.DAT',    -- Boneyard Gully
    [9] = '/ROM3/2/119.DAT',    -- Pso'Xja
    [10] = '/ROM3/2/120.DAT',   -- The Shrouded Maw
    [11] = '/ROM3/2/121.DAT',   -- Oldton Movalpolos
    [12] = '/ROM3/2/122.DAT',   -- Newton Movalpolos
    [13] = '/ROM3/2/123.DAT',   -- Mine Shaft #2716
    [14] = '/ROM3/2/124.DAT',   -- Hall of Transference
    [15] = '/ROM/25/80.DAT',    -- Abyssea - Konschtat
    [16] = '/ROM3/2/126.DAT',   -- Promyvion - Holla
    [17] = '/ROM3/2/127.DAT',   -- Spire of Holla
    [18] = '/ROM3/3/0.DAT',     -- Promyvion - Dem
    [19] = '/ROM3/3/1.DAT',     -- Spire of Dem
    [20] = '/ROM3/3/2.DAT',     -- Promyvion - Mea
    [21] = '/ROM3/3/3.DAT',     -- Spire of Mea
    [22] = '/ROM3/3/4.DAT',     -- Promyvion - Vahzl
    [23] = '/ROM3/3/5.DAT',     -- Spire of Vahzl
    [24] = '/ROM3/3/6.DAT',     -- Lufaise Meadows
    [25] = '/ROM3/3/7.DAT',     -- Misareaux Coast
    [26] = '/ROM3/3/8.DAT',     -- Tavnazian Safehold
    [27] = '/ROM3/3/9.DAT',     -- Phomiuna Aqueducts
    [28] = '/ROM3/3/10.DAT',    -- Sacrarium
    [29] = '/ROM3/3/11.DAT',    -- Riverne - Site #B01
    [30] = '/ROM3/3/12.DAT',    -- Riverne - Site #A01
    [31] = '/ROM3/3/13.DAT',    -- Monarch Linn
    [32] = '/ROM3/3/14.DAT',    -- Sealion's Den
    [33] = '/ROM3/3/15.DAT',    -- Al'Taieu
    [34] = '/ROM3/3/16.DAT',    -- Grand Palace of Hu'Xzoi
    [35] = '/ROM3/3/17.DAT',    -- The Garden of Ru'Hmet
    [36] = '/ROM3/3/18.DAT',    -- Empyreal Paradox
    [37] = '/ROM3/3/19.DAT',    -- Temenos
    [38] = '/ROM3/3/20.DAT',    -- Apollyon
    [39] = '/ROM3/3/21.DAT',    -- Dynamis - Valkurm
    [40] = '/ROM3/3/22.DAT',    -- Dynamis - Buburimu
    [41] = '/ROM3/3/23.DAT',    -- Dynamis - Qufim
    [42] = '/ROM3/3/24.DAT',    -- Dynamis - Tavnazia
    [43] = '/ROM3/3/25.DAT',    -- Diorama Abdhaljs-Ghelsba
    [44] = '/ROM3/3/26.DAT',    -- Abdhaljs Isle-Purgonorgo
    [45] = '/ROM/25/110.DAT',   -- Abyssea - Tahrongi
    [46] = '/ROM4/1/45.DAT',    -- Open Sea Route to Al Zahbi
    [47] = '/ROM4/1/46.DAT',    -- Open Sea Route to Mhaura
    [48] = '/ROM4/1/47.DAT',    -- Al Zahbi
    [49] = '/ROM4/1/48.DAT',    -- (Unused)
    [50] = '/ROM4/1/49.DAT',    -- Aht Urhgan Whitegate
    [51] = '/ROM4/1/50.DAT',    -- Wajaom Woodlands
    [52] = '/ROM4/1/51.DAT',    -- Bhaflau Thickets
    [53] = '/ROM4/1/52.DAT',    -- Nashmau
    [54] = '/ROM4/1/53.DAT',    -- Arrapago Reef
    [55] = '/ROM4/1/54.DAT',    -- Ilrusi Atoll
    [56] = '/ROM4/1/55.DAT',    -- Periqia
    [57] = '/ROM4/1/56.DAT',    -- Talacca Cove
    [58] = '/ROM4/1/57.DAT',    -- Silver Sea Route to Nashmau
    [59] = '/ROM4/1/58.DAT',    -- Silver Sea Route to Al Zahbi
    [60] = '/ROM4/1/59.DAT',    -- The Ashu Talif
    [61] = '/ROM4/1/60.DAT',    -- Mount Zhayolm
    [62] = '/ROM4/1/61.DAT',    -- Halvung
    [63] = '/ROM4/1/62.DAT',    -- Lebros Cavern
    [64] = '/ROM4/1/63.DAT',    -- Navukgo Execution Chamber
    [65] = '/ROM4/1/64.DAT',    -- Mamook
    [66] = '/ROM4/1/65.DAT',    -- Mamool Ja Training Grounds
    [67] = '/ROM4/1/66.DAT',    -- Jade Sepulcher
    [68] = '/ROM4/1/67.DAT',    -- Aydeewa Subterrane
    [69] = '/ROM4/1/68.DAT',    -- Leujaoam Sanctum
    [70] = '/ROM4/1/69.DAT',    -- Chocobo Circuit
    [71] = '/ROM4/1/70.DAT',    -- The Colosseum
    [72] = '/ROM4/1/71.DAT',    -- Alzadaal Undersea Ruins
    [73] = '/ROM4/1/72.DAT',    -- Zhayolm Remnants
    [74] = '/ROM4/1/73.DAT',    -- Arrapago Remnants
    [75] = '/ROM4/1/74.DAT',    -- Bhaflau Remnants
    [76] = '/ROM4/1/75.DAT',    -- Silver Sea Remnants
    [77] = '/ROM4/1/76.DAT',    -- Nyzul Isle
    [78] = '/ROM4/1/77.DAT',    -- Hazhalm Testing Grounds
    [79] = '/ROM4/1/78.DAT',    -- Caedarva Mire
    [80] = '/ROM/26/17.DAT',    -- Southern San d'Oria [S]
    [81] = '/ROM/26/18.DAT',    -- East Ronfaure [S]
    [82] = '/ROM/26/19.DAT',    -- Jugner Forest [S]
    [83] = '/ROM/26/20.DAT',    -- Vunkerl Inlet [S]
    [84] = '/ROM/26/21.DAT',    -- Batallia Downs [S]
    [85] = '/ROM/26/22.DAT',    -- La Vaule [S]
    [86] = '/ROM/26/23.DAT',    -- Everbloom Hollow
    [87] = '/ROM/26/24.DAT',    -- Bastok Markets [S]
    [88] = '/ROM/26/25.DAT',    -- North Gustaberg [S]
    [89] = '/ROM/26/26.DAT',    -- Grauberg [S]
    [90] = '/ROM/26/27.DAT',    -- Pashhow Marshlands [S]
    [91] = '/ROM/26/28.DAT',    -- Rolanberry Fields [S]
    [92] = '/ROM/26/29.DAT',    -- Beadeaux [S]
    [93] = '/ROM/26/30.DAT',    -- Ruhotz Silvermines
    [94] = '/ROM/26/31.DAT',    -- Windurst Waters [S]
    [95] = '/ROM/26/32.DAT',    -- West Sarutabaruta [S]
    [96] = '/ROM/26/33.DAT',    -- Fort Karugo-Narugo [S]
    [97] = '/ROM/26/34.DAT',    -- Meriphataud Mountains [S]
    [98] = '/ROM/26/35.DAT',    -- Sauromugue Champaign [S]
    [99] = '/ROM/26/36.DAT',    -- Castle Oztroja [S]
    [100] = '/ROM/26/37.DAT',   -- West Ronfaure
    [101] = '/ROM/26/38.DAT',   -- East Ronfaure
    [102] = '/ROM/26/39.DAT',   -- La Theine Plateau
    [103] = '/ROM/26/40.DAT',   -- Valkurm Dunes
    [104] = '/ROM/26/41.DAT',   -- Jugner Forest
    [105] = '/ROM/26/42.DAT',   -- Batallia Downs
    [106] = '/ROM/26/43.DAT',   -- North Gustaberg
    [107] = '/ROM/26/44.DAT',   -- South Gustaberg
    [108] = '/ROM/26/45.DAT',   -- Konschtat Highlands
    [109] = '/ROM/26/46.DAT',   -- Pashhow Marshlands
    [110] = '/ROM/26/47.DAT',   -- Rolanberry Fields
    [111] = '/ROM/26/48.DAT',   -- Beaucedine Glacier
    [112] = '/ROM/26/49.DAT',   -- Xarcabard
    [113] = '/ROM2/13/95.DAT',  -- Cape Teriggan
    [114] = '/ROM2/13/96.DAT',  -- Eastern Altepa Desert
    [115] = '/ROM/26/52.DAT',   -- West Sarutabaruta
    [116] = '/ROM/26/53.DAT',   -- East Sarutabaruta
    [117] = '/ROM/26/54.DAT',   -- Tahrongi Canyon
    [118] = '/ROM/26/55.DAT',   -- Buburimu Peninsula
    [119] = '/ROM/26/56.DAT',   -- Meriphataud Mountains
    [120] = '/ROM/26/57.DAT',   -- Sauromugue Champaign
    [121] = '/ROM2/13/97.DAT',  -- The Sanctuary of Zi'Tah
    [122] = '/ROM2/13/98.DAT',  -- Ro'Maeve
    [123] = '/ROM2/13/99.DAT',  -- Yuhtunga Jungle
    [124] = '/ROM2/13/100.DAT', -- Yhoator Jungle
    [125] = '/ROM2/13/101.DAT', -- Western Altepa Desert
    [126] = '/ROM/26/63.DAT',   -- Qufim Island
    [127] = '/ROM/26/64.DAT',   -- Behemoth's Dominion
    [128] = '/ROM2/13/102.DAT', -- Valley of Sorrows
    [129] = '/ROM/26/66.DAT',   -- Ghoyu's Reverie
    [130] = '/ROM2/13/103.DAT', -- Ru'Aun Gardens
    [131] = '/ROM/26/68.DAT',   -- Mordion Gaol
    [132] = '/ROM/26/69.DAT',   -- Abyssea - La Theine
    [133] = '/ROM/26/70.DAT',   -- (unused)
    [134] = '/ROM2/13/104.DAT', -- Dynamis - Beaucedine
    [135] = '/ROM2/13/105.DAT', -- Dynamis - Xarcabard
    [136] = '/ROM/26/73.DAT',   -- Beaucedine Glacier [S]
    [137] = '/ROM/26/74.DAT',   -- Xarcabard [S]
    [138] = '/ROM/26/75.DAT',   -- Castle Zvahl Baileys [S]
    [139] = '/ROM/26/76.DAT',   -- Horlais Peak
    [140] = '/ROM/26/77.DAT',   -- Ghelsba Outpost
    [141] = '/ROM/26/78.DAT',   -- Fort Ghelsba
    [142] = '/ROM/26/79.DAT',   -- Yughott Grotto
    [143] = '/ROM/26/80.DAT',   -- Palborough Mines
    [144] = '/ROM/26/81.DAT',   -- Waughroon Shrine
    [145] = '/ROM/26/82.DAT',   -- Giddeus
    [146] = '/ROM/26/83.DAT',   -- Balga's Dais
    [147] = '/ROM/26/84.DAT',   -- Beadeaux
    [148] = '/ROM/26/85.DAT',   -- Qulun Dome
    [149] = '/ROM/26/86.DAT',   -- Davoi
    [150] = '/ROM/26/87.DAT',   -- Monastic Cavern
    [151] = '/ROM/26/88.DAT',   -- Castle Oztroja
    [152] = '/ROM/26/89.DAT',   -- Altar Room
    [153] = '/ROM2/13/106.DAT', -- The Boyahda Tree
    [154] = '/ROM2/13/107.DAT', -- Dragon's Aery
    [155] = '/ROM/26/92.DAT',   -- Castle Zvahl Keep [S]
    [156] = '/ROM/26/93.DAT',   -- Throne Room [S]
    [157] = '/ROM/26/94.DAT',   -- Middle Delkfutt's Tower
    [158] = '/ROM/26/95.DAT',   -- Upper Delkfutt's Tower
    [159] = '/ROM2/13/108.DAT', -- Temple of Uggalepih
    [160] = '/ROM2/13/109.DAT', -- Den of Rancor
    [161] = '/ROM/26/98.DAT',   -- Castle Zvahl Baileys
    [162] = '/ROM/26/99.DAT',   -- Castle Zvahl Keep
    [163] = '/ROM2/13/110.DAT', -- Sacrificial Chamber
    [164] = '/ROM/26/101.DAT',  -- Garlaige Citadel [S]
    [165] = '/ROM/26/102.DAT',  -- Throne Room
    [166] = '/ROM/26/103.DAT',  -- Ranguemont Pass
    [167] = '/ROM/26/104.DAT',  -- Bostaunieux Oubliette
    [168] = '/ROM2/13/111.DAT', -- Chamber of Oracles
    [169] = '/ROM/26/106.DAT',  -- Toraimarai Canal
    [170] = '/ROM2/13/112.DAT', -- Full Moon Fountain
    [171] = '/ROM/26/108.DAT',  -- Crawlers' Nest [S]
    [172] = '/ROM/26/109.DAT',  -- Zeruhn Mines
    [173] = '/ROM2/13/113.DAT', -- Korroloka Tunnel
    [174] = '/ROM2/13/114.DAT', -- Kuftal Tunnel
    [175] = '/ROM/26/112.DAT',  -- The Eldieme Necropolis [S]
    [176] = '/ROM2/13/115.DAT', -- Sea Serpent Grotto
    [177] = '/ROM2/13/116.DAT', -- Ve'Lugannon Palace
    [178] = '/ROM2/13/117.DAT', -- The Shrine of Ru'Avitau
    [179] = '/ROM2/13/118.DAT', -- Stellar Fulcrum
    [180] = '/ROM2/13/119.DAT', -- La'Loff Amphitheater
    [181] = '/ROM2/13/120.DAT', -- The Celestial Nexus
    [182] = '/ROM/26/119.DAT',  -- Walk of Echoes
    [183] = '/ROM/26/120.DAT',  -- Maquette Abdhaljs-Legion
    [184] = '/ROM/26/121.DAT',  -- Lower Delkfutt's Tower
    [185] = '/ROM2/13/121.DAT', -- Dynamis - San d'Oria
    [186] = '/ROM2/13/122.DAT', -- Dynamis - Bastok
    [187] = '/ROM2/13/123.DAT', -- Dynamis - Windurst
    [188] = '/ROM2/13/124.DAT', -- Dynamis - Jeuno
    [189] = '/ROM/26/126.DAT',  -- Residential Area
    [190] = '/ROM/26/127.DAT',  -- King Ranperre's Tomb
    [191] = '/ROM/27/0.DAT',    -- Dangruf Wadi
    [192] = '/ROM/27/1.DAT',    -- Inner Horutoto Ruins
    [193] = '/ROM/27/2.DAT',    -- Ordelle's Caves
    [194] = '/ROM/27/3.DAT',    -- Outer Horutoto Ruins
    [195] = '/ROM/27/4.DAT',    -- The Eldieme Necropolis
    [196] = '/ROM/27/5.DAT',    -- Gusgen Mines
    [197] = '/ROM/27/6.DAT',    -- Crawlers' Nest
    [198] = '/ROM/27/7.DAT',    -- Maze of Shakhrami
    [199] = '/ROM/27/8.DAT',    -- Residential Area
    [200] = '/ROM/27/9.DAT',    -- Garlaige Citadel
    [201] = '/ROM2/13/125.DAT', -- Cloister of Gales
    [202] = '/ROM2/13/126.DAT', -- Cloister of Storms
    [203] = '/ROM2/13/127.DAT', -- Cloister of Frost
    [204] = '/ROM/27/13.DAT',   -- Fei'Yin
    [205] = '/ROM2/14/0.DAT',   -- Ifrit's Cauldron
    [206] = '/ROM/27/15.DAT',   -- Qu'Bia Arena
    [207] = '/ROM2/14/1.DAT',   -- Cloister of Flames
    [208] = '/ROM2/14/2.DAT',   -- Quicksand Caves
    [209] = '/ROM2/14/3.DAT',   -- Cloister of Tremors
    [210] = '/ROM/27/19.DAT',   -- GM Lobby
    [211] = '/ROM2/14/4.DAT',   -- Cloister of Tides
    [212] = '/ROM2/14/5.DAT',   -- Gustav Tunnel
    [213] = '/ROM2/14/6.DAT',   -- Labyrinth of Onzozo
    [214] = '/ROM/27/23.DAT',   -- Residential Area
    [215] = '/ROM/27/24.DAT',   -- Abyssea - Attohwa
    [216] = '/ROM/27/25.DAT',   -- Abyssea - Misareaux
    [217] = '/ROM/27/26.DAT',   -- Abyssea - Vunkerl
    [218] = '/ROM/27/27.DAT',   -- Abyssea - Altepa
    [219] = '/ROM/27/28.DAT',   -- Residential Area
    [220] = '/ROM/27/29.DAT',   -- Ship Bound For Selbina
    [221] = '/ROM/27/30.DAT',   -- Ship Bound For Mhaura
    [222] = '/ROM/27/31.DAT',   -- Provenance
    [223] = '/ROM/27/32.DAT',   -- San d'Oria-Jeuno Airship
    [224] = '/ROM/27/33.DAT',   -- Bastok-Jeuno Airship
    [225] = '/ROM/27/34.DAT',   -- Windurst-Jeuno Airship
    [226] = '/ROM2/14/7.DAT',   -- Kazham-Jeuno Airship
    [227] = '/ROM/27/36.DAT',   -- Ship Bound For Selbina
    [228] = '/ROM/27/37.DAT',   -- Ship Bound For Mhaura
    [229] = '/ROM/27/38.DAT',   -- (Unused)
    [230] = '/ROM/27/39.DAT',   -- Southern San d'Oria
    [231] = '/ROM/27/40.DAT',   -- Northern San d'Oria
    [232] = '/ROM/27/41.DAT',   -- Port San d'Oria
    [233] = '/ROM/27/42.DAT',   -- Chateau d'Oraguille
    [234] = '/ROM/27/43.DAT',   -- Bastok Mines
    [235] = '/ROM/27/44.DAT',   -- Bastok Markets
    [236] = '/ROM/27/45.DAT',   -- Port Bastok
    [237] = '/ROM/27/46.DAT',   -- Metalworks
    [238] = '/ROM/27/47.DAT',   -- Windurst Waters
    [239] = '/ROM/27/48.DAT',   -- Windurst Walls
    [240] = '/ROM/27/49.DAT',   -- Port Windurst
    [241] = '/ROM/27/50.DAT',   -- Windurst Woods
    [242] = '/ROM/27/51.DAT',   -- Heavens Tower
    [243] = '/ROM/27/52.DAT',   -- Ru'Lude Gardens
    [244] = '/ROM/27/53.DAT',   -- Upper Jeuno
    [245] = '/ROM/27/54.DAT',   -- Lower Jeuno
    [246] = '/ROM/27/55.DAT',   -- Port Jeuno
    [247] = '/ROM2/14/8.DAT',   -- Rabao
    [248] = '/ROM/27/57.DAT',   -- Selbina
    [249] = '/ROM/27/58.DAT',   -- Mhaura
    [250] = '/ROM2/14/9.DAT',   -- Kazham
    [251] = '/ROM2/14/10.DAT',  -- Hall of the Gods
    [252] = '/ROM2/14/11.DAT',  -- Norg
    [253] = '/ROM/27/62.DAT',   -- Abyssea - Uleguerand
    [254] = '/ROM/27/63.DAT',   -- Abyssea - Grauberg
    [255] = '/ROM/27/64.DAT',   -- Abyssea - Empyreal Paradox
    [256] = '/ROM9/6/45.DAT',   -- Western Adoulin
    [257] = '/ROM9/6/46.DAT',   -- Eastern Adoulin
    [258] = '/ROM9/6/47.DAT',   -- Rala Waterways
    [259] = '/ROM9/6/48.DAT',   -- Rala Waterways [U]
    [260] = '/ROM9/6/49.DAT',   -- Yahse Hunting Grounds
    [261] = '/ROM9/6/50.DAT',   -- Ceizak Battlegrounds
    [262] = '/ROM9/6/51.DAT',   -- Foret de Hennetiel
    [263] = '/ROM9/6/52.DAT',   -- Yorcia Weald
    [264] = '/ROM9/6/53.DAT',   -- Yorcia Weald [U]
    [265] = '/ROM9/6/54.DAT',   -- Morimar Basalt Fields
    [266] = '/ROM9/6/55.DAT',   -- Marjami Ravine
    [267] = '/ROM9/6/56.DAT',   -- Kamihr Drifts
    [268] = '/ROM9/6/57.DAT',   -- Sih Gates
    [269] = '/ROM9/6/58.DAT',   -- Moh Gates
    [270] = '/ROM9/6/59.DAT',   -- Cirdas Caverns
    [271] = '/ROM9/6/60.DAT',   -- Cirdas Caverns [U]
    [272] = '/ROM9/6/61.DAT',   -- Dho Gates
    [273] = '/ROM9/6/62.DAT',   -- Woh Gates
    [274] = '/ROM9/6/63.DAT',   -- Outer Ra'Kaznar
    [275] = '/ROM9/6/64.DAT',   -- Outer Ra'Kaznar [U]
    [276] = '/ROM9/6/65.DAT',   -- Ra'Kaznar Inner Court
    [277] = '/ROM9/6/66.DAT',   -- Ra'Kaznar Turris
    [278] = '/ROM9/6/67.DAT',   -- (Unused)
    [279] = '/ROM9/6/68.DAT',   -- Walk of Echoes
    [280] = '/ROM/303/36.DAT',  -- Mog Garden
    [281] = '/ROM/315/114.DAT', -- Leafallia
    [282] = '/ROM/315/115.DAT', -- Mount Kamihr
    [283] = '/ROM9/6/72.DAT',   -- Silver Knife
    [284] = '/ROM/303/37.DAT',  -- Celennia Memorial Library
    [285] = '/ROM/306/61.DAT',  -- Feretory
    [286] = '',                 -- (Unused)
    [287] = '/ROM/362/25.DAT',  -- Maquette Abdhaljs-Legion
    [288] = '/ROM/332/109.DAT', -- Escha - Zi'Tah
    [289] = '/ROM/337/66.DAT',  -- Escha - Ru'Aun
    [290] = '/ROM/342/93.DAT',  -- Desuetia - Empyreal Paradox
    [291] = '/ROM/342/94.DAT',  -- Reisenjima
    [292] = '/ROM/353/61.DAT',  -- Reisenjima Henge
    [293] = '/ROM/342/95.DAT',  -- Reisenjima Sanctorium
    [294] = '/ROM/354/116.DAT', -- Dynamis - San d'Oria [D]
    [295] = '/ROM/355/5.DAT',   -- Dynamis - Bastok [D]
    [296] = '/ROM/355/39.DAT',  -- Dynamis - Windurst [D]
    [297] = '/ROM/355/54.DAT',  -- Dynamis - Jeuno [D]
    [298] = '/ROM/361/92.DAT',  -- Walk of Echoes

    --[[
    * Special Zone Handling
    *
    * FFXI allows for a single zone to have multiple npc lists depending on the zones 'instance' being loaded/used. Internally,
    * the client has a shift for the id based on the zone id and a sub-zone id which is sent in the 0x00A zone enter packet.
    *
    * Packet: Zone Enter (0x000A)
    *   +0x30 = zone id
    *   +0x9E = zone sub id
    *
    * Client Shift Handling
    *
    *   if (subid < 1000 || subid > 1299)
    *   {
    *       if (zoneid < 256)
    *           fileid = zoneid + 6720;
    *       else
    *           fileid = zoneid + 86235;
    *   }
    *   else
    *       fileid = subid + 66911;
    --]]
    [1000] = 'ROM/214/62.DAT',  -- Moblin Maze Mongers
    [1001] = 'ROM/216/50.DAT',  -- Moblin Maze Mongers
    [1002] = 'ROM/216/51.DAT',  -- Moblin Maze Mongers
    [1003] = 'ROM/216/52.DAT',  -- Moblin Maze Mongers
    [1004] = 'ROM/216/53.DAT',  -- Moblin Maze Mongers
    [1005] = 'ROM/216/54.DAT',  -- Moblin Maze Mongers
    [1006] = 'ROM/216/55.DAT',  -- Moblin Maze Mongers
    [1007] = 'ROM/224/117.DAT', -- Moblin Maze Mongers
    [1008] = 'ROM/238/86.DAT',  -- Moblin Maze Mongers
    [1009] = 'ROM/281/80.DAT',  -- Meeble Burrows
    [1010] = 'ROM/281/81.DAT',  -- Meeble Burrows
    [1011] = 'ROM/281/82.DAT',  -- Meeble Burrows
    [1012] = 'ROM/281/83.DAT',  -- Meeble Burrows
    [1013] = 'ROM/286/102.DAT', -- Meeble Burrows
    [1014] = 'ROM/288/41.DAT',  -- Meeble Burrows
    [1015] = 'ROM/288/42.DAT',  -- Meeble Burrows
    [1016] = 'ROM/288/43.DAT',  -- Meeble Burrows
    [1017] = 'ROM/288/44.DAT',  -- Meeble Burrows
    [1018] = 'ROM/288/45.DAT',  -- Meeble Burrows
    [1019] = 'ROM/363/67.DAT',  -- Odyssey
    [1020] = 'ROM/363/68.DAT',  -- Odyssey
    [1021] = 'ROM/363/69.DAT',  -- Odyssey
    [1022] = 'ROM/363/70.DAT',  -- Odyssey
    [1023] = 'ROM/363/71.DAT',  -- Odyssey
    [1024] = 'ROM/363/72.DAT',  -- Odyssey
    [1025] = 'ROM/364/110.DAT', -- Odyssey
    [1026] = 'ROM/364/111.DAT', -- Odyssey
};