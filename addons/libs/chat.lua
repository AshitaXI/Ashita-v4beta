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

local chat = { };

--[[
* Returns the string wrapped in the given color tag. (Color table 1.)
*
* @param {number} n - The color code to use.
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.color1 = function (n, str)
    return ('\30%c%s\30\01'):fmt(n, str);
end

--[[
* Returns the string wrapped in the given color tag. (Color table 2.)
*
* @param {number} n - The color code to use.
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.color2 = function (n, str)
    return ('\31%c%s\30\01'):fmt(n, str);
end

--[[
* Returns the string wrapped in a colored header tag.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.header = function (str)
    return ('\30\81[\30\06%s\30\81]\30\01 '):fmt(str);
end

--[[
* Returns the string wrapped in a red color for critical errors.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.critical = function (str)
    return chat.color1(76, str);
end

--[[
* Returns the string wrapped in a red color for general errors.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.error = function (str)
    return chat.color1(68, str);
end

--[[
* Returns the string wrapped in a cream/yellow color for general messages.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.message = function (str)
    return chat.color1(106, str);
end

--[[
* Returns the string wrapped in a green color for successful messages.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.success = function (str)
    return chat.color1(2, str);
end

--[[
* Returns the string wrapped in a yellow color for warnings.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.warning = function (str)
    return chat.color1(104, str);
end

--[[
* Table of predefined color codes.
--]]
chat.colors = { };
chat.colors.Reset                = '\30\01';
chat.colors.Normal               = '\30\01';
chat.colors.White                = '\30\01';
chat.colors.LawnGreen            = '\30\02';
chat.colors.MediumSlateBlue      = '\30\03';
chat.colors.Magenta              = '\30\05';
chat.colors.Cyan                 = '\30\06';
chat.colors.Moccasin             = '\30\07';
chat.colors.Coral                = '\30\08';
chat.colors.DimGrey              = '\30\65';
chat.colors.Grey                 = '\30\67';
chat.colors.Salmon               = '\30\68';
chat.colors.Yellow               = '\30\69';
chat.colors.RoyalBlue            = '\30\71';
chat.colors.DarkMagenta          = '\30\72';
chat.colors.Violet               = '\30\73';
chat.colors.Tomato               = '\30\76';
chat.colors.MistyRose            = '\30\77';
chat.colors.PaleGoldenRod        = '\30\78';
chat.colors.Lime                 = '\30\79';
chat.colors.PaleGreen            = '\30\80';
chat.colors.DarkOrchid           = '\30\81';
chat.colors.Aqua                 = '\30\82';
chat.colors.SpringGreen          = '\30\83';
chat.colors.DarkSalmon           = '\30\85';
chat.colors.MediumSpringGreen    = '\30\88';
chat.colors.MediumPurple         = '\30\89';
chat.colors.Azure                = '\30\90';
chat.colors.LightCyan            = '\30\92';
chat.colors.LightGoldenRodYellow = '\30\96';
chat.colors.Plum                 = '\30\105';

--[[
* Table of predefined chat symbols.
--]]
chat.symbols = { };
chat.symbols.FireIcon       = '\239\31';
chat.symbols.IceIcon        = '\239\32';
chat.symbols.WindIcon       = '\239\33';
chat.symbols.EarthIcon      = '\239\34';
chat.symbols.LightningIcon  = '\239\35';
chat.symbols.WaterIcon      = '\239\36';
chat.symbols.LightIcon      = '\239\37';
chat.symbols.DarknessIcon   = '\239\38';
chat.symbols.TranslateOpen  = '\239\39';
chat.symbols.TranslateClose = '\239\40';
chat.symbols.On             = '\239\41';
chat.symbols.Off            = '\239\42';
chat.symbols.OnFrench       = '\239\43';
chat.symbols.OffFrench      = '\239\44';
chat.symbols.OnGerman       = '\239\45';
chat.symbols.OffGerman      = '\239\46';

--[[
* Table of predefined chat symbols. (Unicode)
--]]
chat.symbols.unicode = { };
chat.symbols.unicode.IdeographicComma            = '\129\65';
chat.symbols.unicode.IdeographicFullStop         = '\129\66';
chat.symbols.unicode.Comma                       = '\129\67';
chat.symbols.unicode.FullStop                    = '\129\68';
chat.symbols.unicode.MiddleDot                   = '\129\69';
chat.symbols.unicode.Colon                       = '\129\70';
chat.symbols.unicode.SemiColon                   = '\129\71';
chat.symbols.unicode.QuestionMark                = '\129\72';
chat.symbols.unicode.ExclamationMark             = '\129\73';
chat.symbols.unicode.VoicedSoundMark             = '\129\74';
chat.symbols.unicode.SemiVoicedSoundMark         = '\129\75';
chat.symbols.unicode.Apostrophe                  = '\129\76';
chat.symbols.unicode.Accent                      = '\129\77';
chat.symbols.unicode.CircumflexAccent            = '\129\79';
chat.symbols.unicode.Macron                      = '\129\80';
chat.symbols.unicode.LowLine                     = '\129\81';
chat.symbols.unicode.KatakanaIterationMark       = '\129\82';
chat.symbols.unicode.KatakanaVoicedIterationMark = '\129\83';
chat.symbols.unicode.HiraganaIterationMark       = '\129\84';
chat.symbols.unicode.HiraganaVoicedIterationMark = '\129\85';
chat.symbols.unicode.Ditto                       = '\129\86';
chat.symbols.unicode.Repetition                  = '\129\87';
chat.symbols.unicode.Unknown8158                 = '\129\88';
chat.symbols.unicode.Unknown8159                 = '\129\89';
chat.symbols.unicode.Maru                        = '\129\90';
chat.symbols.unicode.Unknown815B                 = '\129\91';
chat.symbols.unicode.Unknown815C                 = '\129\92';
chat.symbols.unicode.Unknown815D                 = '\129\93';
chat.symbols.unicode.Solidus                     = '\129\94';
chat.symbols.unicode.ReverseSolidus              = '\129\95';
chat.symbols.unicode.Tilde                       = '\129\96';
chat.symbols.unicode.Wave                        = '\129\96';
chat.symbols.unicode.ParallelVerticalLines       = '\129\97';
chat.symbols.unicode.VerticalLine                = '\129\98';
chat.symbols.unicode.Pipe                        = '\129\98';
chat.symbols.unicode.HorizontalEllipsis          = '\129\99';
chat.symbols.unicode.TwoDotLeader                = '\129\100';
chat.symbols.unicode.Unknown8165                 = '\129\101';
chat.symbols.unicode.Unknown8166                 = '\129\102';
chat.symbols.unicode.Unknown8167                 = '\129\103';
chat.symbols.unicode.Unknown8168                 = '\129\104';
chat.symbols.unicode.LeftParenthesis             = '\129\105';
chat.symbols.unicode.RightParenthesis            = '\129\106';
chat.symbols.unicode.LeftTortoiseBracket         = '\129\107';
chat.symbols.unicode.RightTortoiseBracket        = '\129\108';
chat.symbols.unicode.LeftSquareBracket           = '\129\109';
chat.symbols.unicode.RightSquareBracket          = '\129\110';
chat.symbols.unicode.LeftCurlyBracket            = '\129\111';
chat.symbols.unicode.RightCurlyBracket           = '\129\112';
chat.symbols.unicode.LeftAngleBracket            = '\129\113';
chat.symbols.unicode.RightAngleBracket           = '\129\114';
chat.symbols.unicode.LeftDoubleAngleBracket      = '\129\115';
chat.symbols.unicode.RightDoubleAngleBracket     = '\129\116';
chat.symbols.unicode.LeftCornerBracket           = '\129\117';
chat.symbols.unicode.RightCornerBracket          = '\129\118';
chat.symbols.unicode.LeftWhiteCornerBracket      = '\129\119';
chat.symbols.unicode.RightWhiteCornerBracket     = '\129\120';
chat.symbols.unicode.LeftBlackLenticularBracket  = '\129\121';
chat.symbols.unicode.RightBlackLenticularBracket = '\129\122';
chat.symbols.unicode.Plus                        = '\129\123';
chat.symbols.unicode.Minus                       = '\129\124';
chat.symbols.unicode.PlusMinus                   = '\129\125';
chat.symbols.unicode.Multiply                    = '\129\126';
chat.symbols.unicode.Divide                      = '\129\127';
chat.symbols.unicode.Unknown8180                 = '\129\128'; -- Copy of 817F
chat.symbols.unicode.Equals                      = '\129\129';
chat.symbols.unicode.NotEquals                   = '\129\130';
chat.symbols.unicode.LessThan                    = '\129\131';
chat.symbols.unicode.GreaterThan                 = '\129\132';
chat.symbols.unicode.LessThanOrEquals            = '\129\133';
chat.symbols.unicode.GreaterThanOrEquals         = '\129\134';
chat.symbols.unicode.Infinite                    = '\129\135';
chat.symbols.unicode.Therefore                   = '\129\136';
chat.symbols.unicode.Male                        = '\129\137';
chat.symbols.unicode.Female                      = '\129\138';
chat.symbols.unicode.Degree                      = '\129\139';
chat.symbols.unicode.Arcminute                   = '\129\140';
chat.symbols.unicode.Arcsecond                   = '\129\141';
chat.symbols.unicode.DegreeCelsius               = '\129\142';
chat.symbols.unicode.Unknown818F                 = '\129\143'; -- Copy of 815F
chat.symbols.unicode.Dollar                      = '\129\144';
chat.symbols.unicode.Cent                        = '\129\145';
chat.symbols.unicode.Pounds                      = '\129\146';
chat.symbols.unicode.Percent                     = '\129\147';
chat.symbols.unicode.Pound                       = '\129\148';
chat.symbols.unicode.Hashtag                     = '\129\148';
chat.symbols.unicode.Ampersand                   = '\129\149';
chat.symbols.unicode.Asterisk                    = '\129\150';
chat.symbols.unicode.At                          = '\129\151';
chat.symbols.unicode.Section                     = '\129\152';
chat.symbols.unicode.WhiteStar                   = '\129\153'; -- Colors inversed, but proper naming based on look.
chat.symbols.unicode.BlackStar                   = '\129\154'; -- Colors inversed, but proper naming based on look.
chat.symbols.unicode.WhiteCircle                 = '\129\155'; -- Colors inversed, but proper naming based on look.
chat.symbols.unicode.BlackCircle                 = '\129\156'; -- Colors inversed, but proper naming based on look.
chat.symbols.unicode.Bullseye                    = '\129\157';
chat.symbols.unicode.CircleJot                   = '\129\157';
chat.symbols.unicode.WhiteDiamond                = '\129\158'; -- Colors inversed, but proper naming based on look.
chat.symbols.unicode.BlackDiamond                = '\129\159'; -- Colors inversed, but proper naming based on look.
chat.symbols.unicode.WhiteSquare                 = '\129\160';
chat.symbols.unicode.BlackSquare                 = '\129\161';
chat.symbols.unicode.WhiteTriangleUp             = '\129\162';
chat.symbols.unicode.BlackTriangleUp             = '\129\163';
chat.symbols.unicode.WhiteTriangleDown           = '\129\164';
chat.symbols.unicode.BlackTriangleDown           = '\129\165';
chat.symbols.unicode.ReferenceMark               = '\129\166';
chat.symbols.unicode.PostalMark                  = '\129\167';
chat.symbols.unicode.RightArrow                  = '\129\168';
chat.symbols.unicode.LeftArrow                   = '\129\169';
chat.symbols.unicode.UpArrow                     = '\129\170';
chat.symbols.unicode.DownArrow                   = '\129\171';
chat.symbols.unicode.Geta                        = '\129\172';
chat.symbols.unicode.ElementOf                   = '\129\173';
chat.symbols.unicode.ContainsAsMember            = '\129\174';
chat.symbols.unicode.SubsetOrEquals              = '\129\175';
chat.symbols.unicode.SupersetOrEquals            = '\129\176';
chat.symbols.unicode.Subset                      = '\129\177';
chat.symbols.unicode.Superset                    = '\129\178';
chat.symbols.unicode.Union                       = '\129\179';
chat.symbols.unicode.Intersection                = '\129\180';
chat.symbols.unicode.LogicalAnd                  = '\129\181';
chat.symbols.unicode.LogicalOr                   = '\129\182';
chat.symbols.unicode.Not                         = '\129\183';
chat.symbols.unicode.Unknown81B8                 = '\129\184'; -- Copy of 81AD
chat.symbols.unicode.Unknown81B9                 = '\129\185'; -- Copy of 81AE
chat.symbols.unicode.Unknown81BA                 = '\129\186'; -- Copy of 81AF
chat.symbols.unicode.Unknown81BB                 = '\129\187'; -- Copy of 81B0
chat.symbols.unicode.Unknown81BC                 = '\129\188'; -- Copy of 81B1
chat.symbols.unicode.Unknown81BD                 = '\129\189'; -- Copy of 81B2
chat.symbols.unicode.Unknown81BE                 = '\129\190'; -- Copy of 81B3
chat.symbols.unicode.Unknown81BF                 = '\129\191'; -- Copy of 81B4
chat.symbols.unicode.Unknown81C0                 = '\129\192'; -- Copy of 81B5
chat.symbols.unicode.Unknown81C1                 = '\129\193'; -- Copy of 81B6
chat.symbols.unicode.Unknown81C2                 = '\129\194'; -- Copy of 81B7
chat.symbols.unicode.Implies                     = '\129\195';
chat.symbols.unicode.Iif                         = '\129\196';
chat.symbols.unicode.ForAll                      = '\129\197';
chat.symbols.unicode.ForEach                     = '\129\197';
chat.symbols.unicode.Exists                      = '\129\198';
chat.symbols.unicode.Angle                       = '\129\199';
chat.symbols.unicode.Unknown81C8                 = '\129\200'; -- Copy of 81B5
chat.symbols.unicode.Unknown81C9                 = '\129\201'; -- Copy of 81B6
chat.symbols.unicode.Unknown81CA                 = '\129\202'; -- Copy of 81B7
chat.symbols.unicode.Unknown81CB                 = '\129\203'; -- Copy of 81C3
chat.symbols.unicode.Unknown81CC                 = '\129\204'; -- Copy of 81C4
chat.symbols.unicode.Unknown81CD                 = '\129\205'; -- Copy of 81C5
chat.symbols.unicode.Unknown81CE                 = '\129\206'; -- Copy of 81C6
chat.symbols.unicode.Unknown81CF                 = '\129\207'; -- Copy of 81C7
chat.symbols.unicode.Bot                         = '\129\208';
chat.symbols.unicode.Falsum                      = '\129\208';
chat.symbols.unicode.UpTack                      = '\129\208';
chat.symbols.unicode.Tie                         = '\129\209';
chat.symbols.unicode.Partial                     = '\129\210';
chat.symbols.unicode.Nabla                       = '\129\211';
chat.symbols.unicode.IdenticalTo                 = '\129\212';
chat.symbols.unicode.ApproximatelyEqual          = '\129\213';
chat.symbols.unicode.MuchLessThan                = '\129\214';
chat.symbols.unicode.MuchGreaterThan             = '\129\215';
chat.symbols.unicode.SquareRoot                  = '\129\216';
chat.symbols.unicode.InvertedLazyS               = '\129\217';
chat.symbols.unicode.Unknown81DA                 = '\129\218'; -- Copy of 81CF
chat.symbols.unicode.Unknown81DB                 = '\129\219'; -- Copy of 81D0
chat.symbols.unicode.Unknown81DC                 = '\129\220'; -- Copy of 81D1
chat.symbols.unicode.Unknown81DD                 = '\129\221'; -- Copy of 81D2
chat.symbols.unicode.Unknown81DE                 = '\129\222'; -- Copy of 81D3
chat.symbols.unicode.Unknown81DF                 = '\129\223'; -- Copy of 81D4
chat.symbols.unicode.Unknown81E0                 = '\129\224'; -- Copy of 81D5
chat.symbols.unicode.Unknown81E1                 = '\129\225'; -- Copy of 81D6
chat.symbols.unicode.Unknown81E2                 = '\129\226'; -- Copy of 81D7
chat.symbols.unicode.Unknown81E3                 = '\129\227'; -- Copy of 81D8
chat.symbols.unicode.Unknown81E4                 = '\129\228'; -- Copy of 81D9
chat.symbols.unicode.Proportional                = '\129\229';
chat.symbols.unicode.Because                     = '\129\230';
chat.symbols.unicode.Integral                    = '\129\231';
chat.symbols.unicode.DoubleIntegral              = '\129\232';
chat.symbols.unicode.AWithOverRing               = '\129\233';
chat.symbols.unicode.PerMil                      = '\129\234';
chat.symbols.unicode.PerMile                     = '\129\234';
chat.symbols.unicode.MusicSharp                  = '\129\235';
chat.symbols.unicode.MusicFlat                   = '\129\236';
chat.symbols.unicode.MusicEighthNote             = '\129\237';
chat.symbols.unicode.Dagger                      = '\129\238';
chat.symbols.unicode.DoubleDagger                = '\129\239';

-- Return the modules table.
return chat;