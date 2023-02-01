# Config

Config is an addon that allows you to directly interact with FFXI's in-game configurations with slash commands.

# Commands

Config exposes the following commands:

  * **/config help** - _Displays the addons help information._
  * **/config get \<id\>** - _Prints the configurations current value._
  * **/config set \<id\> \<value\>** - _Sets the configuration value._
  * **/config info \<id\>** - _Prints the configuration entries information._

# Configuration Ids

The following table contains information related to the available configuration options that are used with the get/set functions this addon calls. Please be sure to read the notes carefully when making any edits to a configurations value.

_**Note:** Not all options treat `0` as `off` or `1` as `on`. SE did not seem to follow any kind of consistent pattern with their options, so be sure to adjust things carefully!_

| Id | Type | Min | Max | Default | Proc | Notes |
| :---: | :---: | :---: | :---: | :---: | :---: |--- |
| `0` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | _This id is not used._ |
| `1` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | _This id is not used._ |
| `2` | `1` | `0` | `1` | `0` | `0` | _Unknown. (Keyboard related.)_ |
| `3` | `1` | `0` | `1` | `0` | `0` | _Unknown. (Keyboard IME related.)_ |
| `4` | `4` | `0` | `0` | `0` | `0` | _Unknown._ |
| `5` | `1` | `0` | `1` | `1` | `1` | _Unknown. (Keyboard related.)_ |
| `6` | `1` | `0` | `1` | `0` | `0` | _Unknown._ |
| `7` | `4` | `0` | `1` | `0` | `1` | _Main Menu > Config > Gameplay > Controls: Auto-target during battle_ |
| `8` | `1` | `0` | `1` | `0` | `0` | _Unknown._ |
| `9` | `4` | `0` | `100` | `100` | `1` | _Main Menu > Config > Gameplay > Sound > Sound Effects Volume_ |
| `10` | `4` | `0` | `100` | `100` | `1` | _Main Menu > Config > Gameplay > Sound > Music Volume_ |
| `11` | `4` | `0` | `127` | `60` | `0` | _Unknown._ |
| `12` | `4` | `0` | `512` | `0` | `0` | _Unknown._ |
| `13` | `4` | `0` | `7` | `0` | `0` | _Unknown._ |
| `14` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Windows > Window 1 > Log Window > Reactive Window Sizing_ |
| `15` | `4` | `4` | `20` | `8` | `0` | _Main Menu > Config > Windows > Window 1 > Log Window > Maximum Lines Displayed_ |
| `16` | `4` | `0` | `20` | `0` | `0` | _Main Menu > Config > Windows > Window 1 > Log Window > Minimum Lines Displayed_ |
| `17` | `4` | `3` | `30` | `5` | `0` | _Main Menu > Config > Windows > Window 1 > Log Window > Resize Time_ |
| `18` | `4` | `0` | `7` | `0` | `0` | _Main Menu > Config > Windows > Shared > Window Type_ |
| `19` | `4` | `0` | `2` | `0` | `0` | _Main Menu > Config > Misc. > Damage Display > On-Screen Damage Display_ |
| `20` | `5` | `0` | `1` | `0` | `0` | _Unknown._ |
| `21` | `4` | `0` | `1` | `1` | `0` | _Unknown._ |
| `22` | `4` | `0` | `100` | `100` | `0` | _Unknown._ |
| `23` | `4` | `0` | `1` | `0` | `1` | _Unknown. (Used with an old job change menu screen.)_ |
| `24` | `1` | `0` | `1` | `0` | `0` | _Main Menu > Config > Global > Language Filter > Chat Language Filter_ |
| `25` | `5` | `0` | `1` | `0` | `0` | _Unknown. (Used with POL status system.)_ |
| `26` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | _This id is not used._ |
| `27` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > Chat > Say_ |
| `28` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80A05040` | `0` | _Main Menu > Config > Font Colors > Chat > Shout_ |
| `29` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80A040A0` | `0` | _Main Menu > Config > Font Colors > Chat > Tell_ |
| `30` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x8020C0A0` | `0` | _Main Menu > Config > Font Colors > Chat > Party_ |
| `31` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x8050FF60` | `0` | _Main Menu > Config > Font Colors > Chat > Linkshell_ |
| `32` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x806050A0` | `0` | _Main Menu > Config > Font Colors > Chat > Emotes_ |
| `33` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80A0D0D0` | `0` | _Main Menu > Config > Font Colors > Chat > Message_ |
| `34` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > Chat > NPC Conversations_ |
| `35` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x806090C0` | `0` | _Main Menu > Config > Font Colors > For Self > HP/MP You Recover_ |
| `36` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80A04040` | `0` | _Main Menu > Config > Font Colors > For Self > HP/MP You Lose_ |
| `37` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > For Self > Beneficial Effects You Receive_ |
| `38` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > For Self > Detrimental Effects You Receive_ |
| `39` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808050` | `0` | _Main Menu > Config > Font Colors > For Self > Effects You Resist_ |
| `40` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > For Self > Effects You Evade_ |
| `41` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x8090C0F0` | `0` | _Main Menu > Config > Font Colors > For Others > HP/MP Others Recover_ |_ |
| `42` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80C08080` | `0` | _Main Menu > Config > Font Colors > For Others > HP/MP Others Lose_ |_ |
| `43` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > For Others > Beneficial Effects Others Are Granted_ |_ |
| `44` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808080` | `0` | _Main Menu > Config > Font Colors > For Others > Detrimental Effects Others Receive_ |_ |
| `45` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80A08040` | `0` | _Main Menu > Config > Font Colors > For Others > Effects Others Resist_ |_ |
| `46` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80707070` | `0` | _Main Menu > Config > Font Colors > For Others > Effects Others Evade_ |_ |
| `47` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80808010` | `0` | _Main Menu > Config > Font Colors > System > Standard Battle Messages_ |
| `48` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80C060D0` | `0` | _Main Menu > Config > Font Colors > System > Calls For Help_ |
| `49` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80C0C050` | `0` | _Main Menu > Config > Font Colors > System > Basic System Messages_ |
| `50` | `5` | `0` | `-1` | `0` | `1` | _Main Menu > Config > Chat Filters (See notes below.)_ |
| `51` | `5` | `0` | `-1` | `0` | `1` | _Main Menu > Config > Chat Filters (See notes below.)_ |
| `52` | `4` | `0` | `-1` | `0` | `0` | _Main Menu > Config > Chat Filters (See notes below.)_ |
| `53` | `5` | `0` | `3` | `0` | `1` | _Main Menu > Config > Chat Filters (See notes below.)_ |
| `54` | `1` | `0` | `1` | `0` | `1` | _Unknown._ |
| `55` | `4` | `0` | `100` | `50` | `0` | _Main Menu > Config > Gameplay > Gamma Adjustment > R_ |
| `56` | `4` | `0` | `100` | `50` | `0` | _Main Menu > Config > Gameplay > Gamma Adjustment > G_ |
| `57` | `4` | `0` | `100` | `50` | `0` | _Main Menu > Config > Gameplay > Gamma Adjustment > B_ |
| `58` | `4` | `0` | `2` | `0` | `0` | _Main Menu > Config > Misc. > Shadows_ |
| `59` | `4` | `0` | `1` | `1` | `0` | _Main Menu > Config > Misc. > Weather Effects_ |
| `60` | `4` | `25` | `51` | `50` | `0` | _Main Menu > Config > Misc. > Character Models Displayed_ |
| `61` | `4` | `0` | `255` | `128` | `0` | _Unknown._ |
| `62` | `4` | `0` | `25` | `25` | `0` | _Main Menu > Config > Misc. 2 > Clipping Plane_ |
| `63` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. 2 > Footstep Effects_ |
| `64` | `4` | `0` | `3` | `3` | `0` | _Main Menu > Config > Misc. 2 > Animation Frame Rate_ |
| `65` | `1` | `-1` | `60` | `-1` | `0` | _Main Menu > Config > Global > Auto-Disconnect > Idle time (min.) until auto-disconnect_ |
| `66` | `4` | `0` | `2` | `2` | `0` | _Main Menu > Config > Misc. 2 > Keyboard Size_ |
| `67` | `4` | `0` | `5` | `0` | `1` | _Main Menu > Config > Misc. 2 > Background Aspect Ratio_ |
| `68` | `4` | `0` | `1` | `0` | `0` | _Unknown. (Keyboard related.)_ |
| `69` | `4` | `0` | `1` | `1` | `0` | _Unknown. (Used to control the style of list shown when searching specific areas via `/sea`.)_ |
| `70` | `4` | `0` | `1` | `1` | `0` | _Unknown. (Used to prevent standing up with keyboard from `/sit` or `/heal.`)_ |
| `71` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Chat Filters (See notes below.)_ |
| `72` | `4` | `0` | `1` | `1` | `0` | _Enables/Disables playing the new message sound effect when receiving a friends list message._ |
| `73` | `4` | `242` | `902` | `350` | `0` | _Current Camera Zoom (Third-Person)_ |
| `74` | `4` | `0` | `255` | `17` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Up_ |
| `75` | `4` | `0` | `255` | `31` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Down_ |
| `76` | `4` | `0` | `255` | `30` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Left_ |
| `77` | `4` | `0` | `255` | `32` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Right_ |
| `78` | `4` | `0` | `255` | `23` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu Cursor & Camera Up_ |
| `79` | `4` | `0` | `255` | `37` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu Cursor & Camera Down_ |
| `80` | `4` | `0` | `255` | `36` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu Cursor & Camera Left_ |
| `81` | `4` | `0` | `255` | `38` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu Cursor & Camera Right_ |
| `82` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Camera Up_ |
| `83` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Camera Down_ |
| `84` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Camera Left_ |
| `85` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Move Camera Right_ |
| `86` | `4` | `0` | `255` | `52` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Zoom In_ |
| `87` | `4` | `0` | `255` | `51` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Zoom Out_ |
| `88` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu/Target Cursor Up_ |
| `89` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu/Target Cursor Down_ |
| `90` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu/Target Cursor Left_ |
| `91` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Menu/Target Cursor Right_ |
| `92` | `4` | `0` | `255` | `21` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Confirm_ |
| `93` | `4` | `0` | `255` | `49` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Cancel_ |
| `94` | `4` | `0` | `255` | `47` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Change View_ |
| `95` | `4` | `0` | `255` | `19` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Autorun_ |
| `96` | `4` | `0` | `255` | `35` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Heal_ |
| `97` | `4` | `0` | `255` | `33` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Select Window_ |
| `98` | `4` | `0` | `255` | `12` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Open Main Menu_ |
| `99` | `4` | `0` | `255` | `44` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Toggle Walk/Run_ |
| `100` | `4` | `0` | `255` | `27` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Hide/Show Window_ |
| `101` | `4` | `0` | `255` | `26` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > Take Screenshot_ |
| `102` | `4` | `0` | `255` | `18` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > ???_ |
| `103` | `4` | `0` | `255` | `16` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > ???_ |
| `104` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > ???_ |
| `105` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Movement > ???_ |
| `106` | `4` | `0` | `255` | `30` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Attack_ |
| `107` | `4` | `0` | `255` | `23` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Items_ |
| `108` | `4` | `0` | `255` | `50` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Magic_ |
| `109` | `4` | `0` | `255` | `36` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Abilities_ |
| `110` | `4` | `0` | `255` | `17` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Weapon Skills_ |
| `111` | `4` | `0` | `255` | `48` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Pet Commands_ |
| `112` | `4` | `0` | `255` | `21` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Confirm_ |
| `113` | `4` | `0` | `255` | `49` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Cancel_ |
| `114` | `4` | `0` | `255` | `12` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Open Main Menu_ |
| `115` | `4` | `0` | `255` | `33` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Select Window_ |
| `116` | `4` | `0` | `255` | `27` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Hide/Show Window_ |
| `117` | `4` | `0` | `255` | `26` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Take Screenshot_ |
| `118` | `4` | `0` | `255` | `44` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Toggle Walk/Run_ |
| `119` | `4` | `0` | `255` | `52` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Zoom In_ |
| `120` | `4` | `0` | `255` | `51` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Zoom Out_ |
| `121` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Ranged Attack_ |
| `122` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Call For Help_ |
| `123` | `4` | `0` | `255` | `18` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Equipment_ |
| `124` | `4` | `0` | `255` | `47` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Change View_ |
| `125` | `4` | `0` | `255` | `35` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Heal_ |
| `126` | `4` | `0` | `255` | `46` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Check_ |
| `127` | `4` | `0` | `255` | `31` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /say_ |
| `128` | `4` | `0` | `255` | `25` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /party_ |
| `129` | `4` | `0` | `255` | `20` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /tell_ |
| `130` | `4` | `0` | `255` | `38` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /linkshell_ |
| `131` | `4` | `0` | `255` | `19` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /reply_ |
| `132` | `4` | `0` | `255` | `22` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /unity_ |
| `133` | `4` | `0` | `255` | `45` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /linkshell2_ |
| `134` | `4` | `0` | `255` | `16` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > Chat: /assiste or /assistj_ |
| `135` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > ???_ |
| `136` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > ???_ |
| `137` | `4` | `0` | `255` | `0` | `0` | _Main Menu > Config > Misc. 2 > Key Assignment > Commands > ???_ |
| `138` | `4` | `1000` | `4000` | `2000` | `0` | _Menu View Zoom Amount (ie. Maps, Main Menu > Help Desk > Adventuring Primer pictures etc.)_ |
| `139` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > Third-Person Camera > X Axis_ |
| `140` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > Third-Person Camera > Y Axis_ |
| `141` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > First-Person Camera > X Axis_ |
| `142` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > First-Person Camera > Y Axis_ |
| `143` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > Screen Edge Panning_ |
| `144` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > Mouse Control_ |
| `145` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Mouse/Cam. > Camera View_ |
| `146` | `4` | `0` | `-1` | `0` | `0` | _Main Menu > Config > Effects > Effects Filtering (See notes below.)_ |
| `147` | `1` | `-255` | `255` | `0` | `0` | _Unknown._ |
| `148` | `1` | `-255` | `255` | `0` | `0` | _Unknown._ |
| `149` | `2` | `0` | `255` | `0` | `1` | _Unknown._ |
| `150` | `2` | `0` | `255` | `0` | `1` | _Unknown._ |
| `151` | `4` | `0` | `1` | `0` | `0` | _Commands > `/ignorepet`_ |
| `152` | `4` | `0` | `65535` | `0` | `0` | _Main Menu > Party > Languages > Languages (See notes below.)_ |
| `153` | `4` | `0x00000000` | `0x7FFFFFFF` | `0x00000000` | `0` | _See notes below._ |
| `154` | `4` | `0` | `1` | `0` | `1` | _Main Menu > Config > Gameplay > Inventory > Sort_ |
| `155` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80A04030` | `0` | _Main Menu > Config > Font Colors > Chat > Yell_ |
| `156` | `4` | `0` | `100` | `100` | `0` | _Main Menu > Config > Windows > Window 1 > Log Window > Window Width_ |
| `157` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. 2 > Macro Palette Size_ |
| `158` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. 2 > Macro Palette Position_ |
| `159` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | _This id is not used._ |
| `160` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | _This id is not used._ |
| `161` | `4` | `0x6B617473` | `0x6B617473` | `0x6B617473` | `0` | _Unknown._ |
| `162` | `4` | `0` | `3` | `0` | `0` | _Unknown. (Set to 0 then 2 when character configs are being saved.)_ |
| `163` | `4` | `0x7368696E` | `0x7368696E` | `0x7368696E` | `0` | _Unknown._ |
| `164` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Windows > Shared > Window Effect_ |
| `165` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. > PC Armor Display_ |
| `166` | `4` | `0` | `1` | `0` | `0` | _Unknown._ |
| `167` | `4` | `0` | `1` | `0` | `0` | _Unknown._ |
| `168` | `6` | `0` | `100` | `100` | `1` | _Title Screen Configurations > Title Music and Sound Effects Volume_ |
| `169` | `4` | `0` | `1` | `0` | `0` | _Unknown._ |
| `170` | `4` | `0` | `1` | `0` | `0` | _Commands > `/ignorefaith`_ |
| `171` | `6` | `0` | `5` | `0` | `1` | _Title Screen Configurations > Aspect Ratio_ |
| `172` | `6` | `0` | `1` | `0` | `1` | _Title Screen Configurations > Logout Destination_ |
| `173` | `6` | `0` | `1` | `0` | `1` | _Title Screen Configurations > Unknown_ |
| `174` | `4` | `0` | `1` | `0` | `0` | _Commands > `/partyinfo showtp`_ |
| `175` | `6` | `0` | `7` | `0` | `1` | _Title Screen Configurations > Title Music_ |
| `176` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x80FFAF3F` | `0` | _Main Menu > Config > Font Colors > Chat > Unity_ |
| `177` | `4` | `0` | `1` | `0` | `0` | _Unknown._ |
| `178` | `4` | `0` | `1` | `1` | `0` | _Main Menu > Status > Unity > Unity Info > Unity Chat Settings_ |
| `179` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x8000CC00` | `0` | _Main Menu > Config > Font Colors > Chat > Linkshell 2_ |
| `180` | `4` | `0` | `2` | `0` | `0` | _Main Menu > Config > Windows > Shared > Log Window > Multi-Window_ |
| `181` | `4` | `0` | `2` | `0` | `0` | _Main Menu > Config > Windows > Shared > Log Window > Timestamp_ |
| `182` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Windows > Window 2 > Log Window > Reactive Window Sizing_ |
| `183` | `4` | `4` | `20` | `8` | `0` | _Main Menu > Config > Windows > Window 2 > Log Window > Maximum Lines Displayed_ |
| `184` | `4` | `0` | `20` | `0` | `0` | _Main Menu > Config > Windows > Window 2 > Log Window > Minimum Lines Displayed_ |
| `185` | `4` | `0` | `-1` | `0` | `0` | _Main Menu > Config > Log > Window 1 > Chat (See notes below.)_ |
| `186` | `4` | `0` | `-1` | `-1` | `0` | _Main Menu > Config > Log > Window 1 > For Self, For Others, System (See notes below.)_ |
| `187` | `4` | `0` | `-1` | `-1` | `0` | _Main Menu > Config > Log > Window 2 > Chat (See notes below.)_ |
| `188` | `4` | `0` | `-1` | `0` | `0` | _Main Menu > Config > Log > Window 2 > For Self, For Others, System (See notes below.)_ |
| `189` | `4` | `0` | `1` | `0` | `0` | _Unknown._ |
| `190` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. 3 > Weapon Effect_ |
| `191` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. 3 > Style Lock_ |
| `192` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Misc. 3 > Area Display_ |
| `193` | `4` | `0` | `1` | `0` | `0` | _Commands > `/layoutctrl`_ |
| `194` | `4` | `1` | `1` | `0` | `0` | _Main Menu > Config > Misc. 3 > Status Icons > Party Icon Display_ |
| `195` | `4` | `1` | `1` | `0` | `0` | _Main Menu > Config > Misc. 3 > Status Icons > Timer Display_ |
| `196` | `4` | `1` | `100` | `10` | `0` | _Commands > `/groundtargetst`_ |
| `197` | `4` | `-1` | `100` | `-1` | `0` | _Main Menu > Config > Windows > Window 2 > Log Window > Window Width_ |
| `198` | `4` | `-1` | `30` | `-1` | `0` | _Main Menu > Config > Windows > Window 2 > Log Window > Resize Time_ |
| `199` | `4` | `0` | `65535` | `0` | `0` | _Main Menu > Party > Alarm Type_ |
| `200` | `4` | `0` | `1` | `1` | `0` | _Commands > `/localsettings blureffect`_ |
| `201` | `4` | `0` | `2` | `0` | `0` | _Main Menu > Config > Misc. 4 > Software Keyboard_ |
| `202` | `4` | `0` | `1` | `0` | `0` | _Main Menu > Config > Gameplay > Inventory > Type_ |
| `203` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x800050FF` | `0` | _Main Menu > Config > Font Colors > Chat > Assist J_ |
| `204` | `4` | `0x00000000` | `0xFFFFFFFF` | `0x800070FF` | `0` | _Main Menu > Config > Font Colors > Chat > Assist E_ |
| `205` | `4` | `0` | `1` | `0` | `0` | _Unknown._ |
| `206` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | _This id is not used._ |

## Configuration Id's `153`, `174`

These configuration values are unique in that they are handled using extra shifting to allow more than a single option to be stored in the value. The game has a separate wrapper to get and set the values that make use of these configuration ids based on the bit shifting being done.

The wrappers look like this:

```cpp
// GetConfig Wrapper
int32_t GetConfigEx(int32_t id, int32_t bit)
{
    auto val = FUNC_GetConfig(id);
    return ((1 << bit) & id) != 0;
}

// SetConfig Wrapper
int32_t SetConfigEx(int32_t id, int8_t bit, int8_t is_set)
{

    auto val = FUNC_GetConfig(id);
    if (is_set)
        return FUNC_SetConfig(id, (1 << bit) | val);
    else
        return FUNC_SetConfig(id, ~(1 << bit) & val);
}
```

## Main Menu > Party > Languages Bit Flags

The `Languages` value is handled as bit flags. The following list is valid values:

| Flag | Option |
|--- |--- |
| `0x00000000` | _None (This should never happen.)_ |
| `0x00000001` | _Japanese_ |
| `0x00000002` | _English_ |
| `0x00000004` | _German_ |
| `0x00000008` | _French_ |
| `0x00000010` | _Other_ |
| `0x0000001F` | _(All languages enabled.)_ |

## Main Menu > Config > Chat Filters

_Todo. Makes use of configuration ids: 50, 51, 52, 53, 71_

  - `71` - _Sets tell sound notification on/off._

## Main Menu > Config > Log

_Todo. Makes use of configuration ids: 185, 186, 187, 188_

  - `185` - _Main Menu > Config > Log > Window 1 > Chat_
  - `186` - _Main Menu > Config > Log > Window 1 > For Self, For Others, System_
  - `187` - _Main Menu > Config > Log > Window 2 > Chat_
  - `188` - _Main Menu > Config > Log > Window 2 > For Self, For Others, System_

## Main Menu > Config > Effects > Effects Filtering Bit Flags

The `Effects` filtering window is treated as a single bit flags based value. The following list is valid values:

| Flag | Option |
|--- |--- |
| `0x00000000` | _(All options set to off.)_ |
| `0x00000001` | _All effects during battle_ |
| `0x00000002` | _You -> you_ |
| `0x00000004` | _You -> monster_ |
| `0x00000008` | _You -> party_ |
| `0x00000010` | _You -> non-party PC_ |
| `0x00000020` | _Monster -> you_ |
| `0x00000040` | _Monster -> monster_ |
| `0x00000080` | _Monster -> party_ |
| `0x00000100` | _Monster -> non-party PC_ |
| `0x00000200` | _Party -> you_ |
| `0x00000400` | _Party -> monster_ |
| `0x00000800` | _Party -> party_ |
| `0x00001000` | _Party -> non-party PC_ |
| `0x00002000` | _Non-party PC -> you_ |
| `0x00004000` | _Non-party PC -> monster_ |
| `0x00008000` | _Non-party PC -> party_ |
| `0x00010000` | _Non-party PC -> non-party PC_ |
| `0x00020000` | _Screen shaking_ |
| `0x0003FFFF` | _(All options set to on.)_ |
