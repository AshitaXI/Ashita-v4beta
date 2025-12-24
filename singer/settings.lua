return {
    playlist = {
        -- Example playlist names:
        -- /singer playlist default
        -- /singer playlist haste
        ["default"] = { "Mage's Ballad III", "Advancing March", "Victory March", "Blade Madrigal" },
        ["haste"]   = { "Advancing March", "Victory March", "Blade Madrigal", "Sword Madrigal" },
        ["ongo"] = {"Learned Etude","Sage Etude","Mage's Ballad III","Victory March","Mage's Ballad II",},
        ["test"] = {"Adventurer's Dirge","Warding Round","Wind Carol II","Sword Madrigal","Valor Minuet V",},
        ["haste"] = {'Valor Minuet IV', 'Honor March', 'Blade Madrigal', 'Valor Minuet V',  "Victory March"},
        ["haste4"] = {'Valor Minuet IV', 'Advancing March', 'Valor Minuet V', "Victory March"},
        ["seg"] = {'Valor Minuet III', 'Honor March', "Valor Minuet IV", 'Victory March', "Valor Minuet V"},
        ["seg4"] = {'Advancing March ', 'Victory March', "Valor Minuet IV", "Valor Minuet V"},
        ["sortie"] = {'Blade Madrigal', 'Honor March', 'Valor Minuet III', "Valor Minuet IV", "Valor Minuet V",},
        ["sortie4"] = {'Blade Madrigal', 'Honor March', "Valor Minuet IV", "Valor Minuet V",},
        ["ambuscade"] = {'Blade Madrigal', 'Honor March', 'Valor Minuet III', "Valor Minuet IV", "Valor Minuet V",},
        ["ambuscade4"] = {'Blade Madrigal', 'Honor March',  "Victory March", "Valor Minuet V",},
        ["shinryu"] = {'Blade Madrigal', 'Honor March',  'Valor Minuet V', 'Dark Carol', 'Herculean Etude',},
        ["shinryu4"] = {'Blade Madrigal', 'Honor March',  'Valor Minuet V', 'Dark Carol',},
        -- ody ADD BY Author: Aragan 
        --T1
        ["Dealan-dhe"] = {"Sentinel's Scherzo", 'Honor March',"Valor Minuet IV",  'Valor Minuet V', "Victory March",},
        --Gogmagog BRD: SV March, Honor March, Scherzo, Minuet, Dirge (on DD), Sirvente (on RUN)
        ["Gogmagog"] = {"Adventurer's Dirge",'Honor March',"Sentinel's Scherzo", 'Valor Minuet V', "Victory March",},
        --T2
        ["Procne"] = {"Valor Minuet IV",'Honor March',"Knight's Minne IV", 'Valor Minuet V', "Blade Madrigal",},
        -- Procne BRD: Minx dirge HM DD, Schrezo Sirvantee Ballad once tank Dispel
        ["Procne2"] = {"Adventurer's Dirge",'Honor March',"Sentinel's Scherzo", 'Valor Minuet V', "Blade Madrigal",},
        ["Aristaeus"] = {"Victory March",'Honor March',"Valor Minuet IV", 'Valor Minuet V', "Knight's Minne IV",},
        --Henwen BRD: SV Minuet x2, March, Honor March, Dirge (on DD), Sirvente (on Tank)
        ["Henwen"] = {"Adventurer's Dirge",'Honor March',"Valor Minuet IV", 'Valor Minuet V', "Victory March",},
        --Gigelorum BRD: SV Minuet x2, March, Honor March, Dirge (on DD), Sirvente (on Tank)
        ["Gigelorum"] = {"Adventurer's Dirge",'Honor March',"Valor Minuet IV", 'Valor Minuet V', "Victory March",},

        --Odyssey V25 ADD BY Author: Aragan 
        ["mboze"] = {'Valor Minuet IV',"Sentinel's Scherzo", 'Honor March', 'Earth Carol II',  'Valor Minuet V'},
        ["mboze2"] = {'Valor Minuet IV',"Sentinel's Scherzo", 'Honor March', 'Blade Madrigal', 'Valor Minuet V',},
        
        --[[MBOZE PLAN BRD: SV Honor March, Minuet x4. HM/Minnes/Ballads for PLD and WHM. 
          WHM will not be taking much damage at all here, 
          but it was easier for us to apply the Ballads to both PLD and WHM at the same time. Savage Blade. ]]
        ["xevioso"] = {'Valor Minuet IV','Honor March',"Sentinel's Scherzo", 'Valor Minuet V', "Wind Carol II",},
        --BRD: Honor March, Scherzo, Minuet x2, Wind Carol 1 for frontline, Honor March, Ballad x2, Minne x2 for WHM.
        -- Melee with Rudra's/Evisceration during aura. Apply Carnage Elegy/Pining Nocturne. 
        ["kalunga"] = {"Adventurer's Dirge", 'Honor March', 'Valor Minuet IV', 'Valor Minuet V', 'Fire Carol II',},
        --[[BRD: Sing slow SV songs at the start. HM Dirge Minuet x2 Fire Carol 1 for melees. Sirvente and Ballad3 the PLD. Ballad 3 / 2 the WHM. Nitro before SV wears so songs last the whole fight.
        Savage Blade. Don't spend a ton of time rebuffing the PLD, this DPS check sucks. ]]
        ["ngai"] = {'Valor Minuet IV','Honor March',"Sentinel's Scherzo", 'Valor Minuet V', 'Water Carol II',},
        --[[BRD: SV Honor March, Minuet x2, Scherzo, Water Carol2 (on MNK WAR)
        Honor March, Scherzo, Minne, Water Carol2, Ballad (on WHM COR BRD) ]]
        ["arebati"] = {'Valor Minuet III', 'Honor March', 'Valor Minuet IV', 'Valor Minuet V', 'Valor Minuet II',},
        --[[BRD: Minuet x4, Honor March (on everyone else)
          Dirge, Honor March, Ballad, Minne x2 (on PLD)
          COR need Scherzo ]]
        ["ongo"] = {'Victory March', 'Sage Etude', 'Learned Etude', "Mage's Ballad III", "Mage's Ballad II",},
        --[[BRD: SV Victory March, Ballad x2, INT Etude x2 (on everyone)
        Minne x3, Paeon, Sirvente (on BRD) ]]
        ["bumba"] = {'Valor Minuet IV',"Sentinel's Scherzo", 'Honor March',  'Valor Minuet V', 'Valor Minuet III',},
        --[[BRD: BRD: SV Scherzo, Honor March, Minuet x3]]

        --NOTE: IF U HAVE SONG Aria of Passion prime horn Loughnashade replaced Minuet
        
        ["cuijatender"] = {"Sentinel's Scherzo","Victory March","Light Carol II","Valor Minuet V",},
        ["volte"] = {"Adventurer's Dirge","Honor March","Blade Madrigal","Sword Madrigal","Valor Minuet V",},
        ["w3"] = {"Adventurer's Dirge","Blade Madrigal","Honor March","Sword Madrigal","Valor Minuet V",},
        ["melee4"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Victory March",},
        ["xevfarm"] = {"Valor Minuet V","Blade Madrigal","Wind Carol II","Honor March","Honor March",},
        ["arewar"] = {"Valor Minuet II","Valor Minuet IV","Valor Minuet V","Honor March","Valor Minuet III",},
        ["sv5"] = {"Valor Minuet III","Valor Minuet IV","Valor Minuet V","Honor March","Valor Minuet II",},
        ["mboze2"]
        ["arebati"] = {"Valor Minuet IV","Valor Minuet V","Knight's Minne IV","Knight's Minne V","Honor March",},
        ["1"] = {"Herculean Etude","Valor Minuet III","Valor Minuet IV","Valor Minuet V",},
        ["melee"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Victory March","Valor Minuet III",},
        ["2"] = {"Herculean Etude","Valor Minuet III","Valor Minuet IV","Valor Minuet V","Honor March",},
        ["mboze"] = {"Valor Minuet V","Valor Minuet IV","Valor Minuet III","Honor March","Valor Minuet II",},
        ["kalunga"] = {"Valor Minuet III","Valor Minuet V","Valor Minuet IV","Honor March","Fire Carol II",},
        ["sortie"] = {"Valor Minuet IV","Valor Minuet V","Blade Madrigal","Honor March","Aria of Passion",},
        ["odin"] = {"Knight's Minne V","Honor March","Valor Minuet V","Valor Minuet IV","Valor Minuet III",},
        ["procne"] = {"Valor Minuet V","Valor Minuet IV","Blade Madrigal","Honor March","Knight's Minne IV",},
        ["11"] = {"Herculean Etude","Valor Minuet III","Valor Minuet IV","Valor Minuet V","Honor March",},
        ["tank"] = {"Knight's Minne V","Honor March","Foe Sirvente","Sentinel's Scherzo","Mage's Ballad III",},
        ["ambu"] = {"Valor Minuet V","Blade Madrigal","Honor March","Knight's Minne V","Valor Minuet IV",},
        ["w2"] = {"Adventurer's Dirge","Blade Madrigal","Honor March","Valor Minuet V","Knight's Minne V",},
        ["ouryu"] = {"Valor Minuet V","Sentinel's Scherzo","Honor March","Earth Carol",},
        ["range"] = {"Honor March","Valor Minuet V","Valor Minuet IV","Archer's Prelude","Valor Minuet III",},
        -- ["ngai"] = {"Honor March","Valor Minuet V","Blade Madrigal","Valor Minuet IV","Sentinel's Scherzo",},
        ["ongo"] = {"Learned Etude","Sage Etude","Mage's Ballad III","Victory March","Mage's Ballad II",},
        ["lilmnk"] = {"Mage's Ballad III","Blade Madrigal","Victory March","Honor March",},
        ["alex"] = {"Mage's Ballad III","Valor Minuet V","Honor March","Blade Madrigal",},
        ["hast4"] = {"Valor Minuet IV","Honor March","Valor Minuet V","Victory March",},
        ["w3boss"] = {"Adventurer's Dirge","Blade Madrigal","Honor March","Valor Minuet IV","Valor Minuet V",},
        ["ody"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Victory March","Valor Minuet III",},
        ["clear"] = {},
        ["cait"] = {"Blade Madrigal","Honor March","Sentinel's Scherzo","Light Carol","Light Carol II",},
        ["xev"] = {"Valor Minuet V","Valor Minuet IV","Wind Carol II","Sentinel's Scherzo","Honor March",},
        ["mage"] = {"Honor March","Victory March","Mage's Ballad II","Mage's Ballad III",},
        ["bumba"] = {"Valor Minuet IV","Valor Minuet V","Knight's Minne V","Honor March","Blade Madrigal",},
        ["pl"] = {"Valor Minuet V","Valor Minuet IV","Adventurer's Dirge","Knight's Minne V","Honor March",},
        ["esortie"] = {"Mage's Ballad III","Mage's Ballad II","Honor March","Blade Madrigal","Valor Minuet IV",},
        ["shin"] = {"Blade Madrigal","Valor Minuet V","Sentinel's Scherzo","Honor March","Valor Minuet IV",},
        ["lilsam"] = {"Blade Madrigal","Sinewy Etude","Herculean Etude","Valor Minuet V","Honor March",},
        ["ody4"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Victory March",},
        ["gige"] = {"Adventurer's Dirge","Honor March","Valor Minuet IV","Valor Minuet V","Valor Minuet III",},
        ["aris"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Knight's Minne V","Knight's Minne IV",},
        ["sortie4"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Blade Madrigal",},
        ["meleeacc"] = {"Valor Minuet V","Blade Madrigal","Honor March","Victory March","Valor Minuet IV",},
        ["peach"] = {"Honor March","Knight's Minne V","Knight's Minne IV","Army's Paeon VI","Knight's Minne III",},
        ["meleehaste2"] = {"Valor Minuet V","Valor Minuet IV","Honor March","Blade Madrigal","Valor Minuet III",},
    }
}
