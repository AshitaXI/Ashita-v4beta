/**
 * Ashita SDK - Copyright (c) 2023 Ashita Development Team
 * Contact: https://www.ashitaxi.com/
 * Contact: https://discord.gg/Ashita
 *
 * This file is part of Ashita.
 *
 * Ashita is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ashita is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
 */

#ifndef ASHITA_SDK_CHAT_H_INCLUDED
#define ASHITA_SDK_CHAT_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// ReSharper disable CppInconsistentNaming
// ReSharper disable CppUnusedIncludeDirective

#include <iomanip>
#include <ostream>
#include <string>

namespace Ashita::Chat
{
    /**
     * Warning:
     * 
     * There is a bug with the retail client that can break inline coloring when the client needs to 
     * wrap long lines of text into multiple lines. If the players client is configured where the chat 
     * window is too small to display a single chat line, the client will look for an optimal position 
     * in the text to break it into parts. When this happens it only looks for and stores color codes 
     * that start with 0x1E. Codes that start with 0x1F (color table 2) are ignored and incorrectly 
     * recolored when the split lines begins.
     *
     * It is recommended to avoid 0x1F color codes as much as possible and only use 0x1E codes instead!
     */

    namespace Helpers
    {
        constexpr auto HeaderOpen  = "\x1E\x51[\x1E\x06";
        constexpr auto HeaderClose = "\x1E\x51]\x1E\x01 ";

    } // namespace Helpers

    namespace Colors
    {
        constexpr auto Reset                = "\x1E\x01";
        constexpr auto Normal               = "\x1E\x01";
        constexpr auto White                = "\x1E\x01";
        constexpr auto LawnGreen            = "\x1E\x02";
        constexpr auto MediumSlateBlue      = "\x1E\x03";
        constexpr auto Magenta              = "\x1E\x05";
        constexpr auto Cyan                 = "\x1E\x06";
        constexpr auto Moccasin             = "\x1E\x07";
        constexpr auto Coral                = "\x1E\x08";
        constexpr auto DimGrey              = "\x1E\x41";
        constexpr auto Grey                 = "\x1E\x43";
        constexpr auto Salmon               = "\x1E\x44";
        constexpr auto Yellow               = "\x1E\x45";
        constexpr auto RoyalBlue            = "\x1E\x47";
        constexpr auto DarkMagenta          = "\x1E\x48";
        constexpr auto Violet               = "\x1E\x49";
        constexpr auto Tomato               = "\x1E\x4C";
        constexpr auto MistyRose            = "\x1E\x4D";
        constexpr auto PaleGoldenRod        = "\x1E\x4E";
        constexpr auto Lime                 = "\x1E\x4F";
        constexpr auto PaleGreen            = "\x1E\x50";
        constexpr auto DarkOrchid           = "\x1E\x51";
        constexpr auto Aqua                 = "\x1E\x52";
        constexpr auto SpringGreen          = "\x1E\x53";
        constexpr auto DarkSalmon           = "\x1E\x55";
        constexpr auto MediumSpringGreen    = "\x1E\x58";
        constexpr auto MediumPurple         = "\x1E\x59";
        constexpr auto Azure                = "\x1E\x5A";
        constexpr auto LightCyan            = "\x1E\x5C";
        constexpr auto LightGoldenRodYellow = "\x1E\x60";
        constexpr auto Plum                 = "\x1E\x69";

    } // namespace Colors

    namespace FFXiSymbols
    {
        constexpr auto FireIcon       = "\xEF\x1F";
        constexpr auto IceIcon        = "\xEF\x20";
        constexpr auto WindIcon       = "\xEF\x21";
        constexpr auto EarthIcon      = "\xEF\x22";
        constexpr auto LightningIcon  = "\xEF\x23";
        constexpr auto WaterIcon      = "\xEF\x24";
        constexpr auto LightIcon      = "\xEF\x25";
        constexpr auto DarknessIcon   = "\xEF\x26";
        constexpr auto TranslateOpen  = "\xEF\x27";
        constexpr auto TranslateClose = "\xEF\x28";
        constexpr auto On             = "\xEF\x29";
        constexpr auto Off            = "\xEF\x2A";
        constexpr auto OnFrench       = "\xEF\x2B";
        constexpr auto OffFrench      = "\xEF\x2C";
        constexpr auto OnGerman       = "\xEF\x2D";
        constexpr auto OffGerman      = "\xEF\x2E";

    } // namespace FFXiSymbols

    namespace UnicodeSymbols
    {
        /**
         * The names of these symbols are taken from the following sources:
         * 
         * https://en.wikipedia.org/wiki/Hiragana
         * https://en.wikipedia.org/wiki/Kanji
         * https://en.wikipedia.org/wiki/Katakana
         * https://en.wikipedia.org/wiki/List_of_Japanese_typographic_symbols
         * https://www.ssec.wisc.edu/~tomw/java/unicode.html
         * https://www.key-shortcut.com/en/writing-systems/%E3%81%B2%E3%82%89%E3%81%8C%E3%81%AA-japanese
         * https://en.wikipedia.org/wiki/List_of_logic_symbols
         */

        constexpr auto IdeographicComma            = "\x81\x41";
        constexpr auto IdeographicFullStop         = "\x81\x42";
        constexpr auto Comma                       = "\x81\x43";
        constexpr auto FullStop                    = "\x81\x44";
        constexpr auto MiddleDot                   = "\x81\x45";
        constexpr auto Colon                       = "\x81\x46";
        constexpr auto SemiColon                   = "\x81\x47";
        constexpr auto QuestionMark                = "\x81\x48";
        constexpr auto ExclamationMark             = "\x81\x49";
        constexpr auto VoicedSoundMark             = "\x81\x4A";
        constexpr auto SemiVoicedSoundMark         = "\x81\x4B";
        constexpr auto Apostrophe                  = "\x81\x4C";
        constexpr auto Accent                      = "\x81\x4D";
        constexpr auto CircumflexAccent            = "\x81\x4F";
        constexpr auto Macron                      = "\x81\x50";
        constexpr auto LowLine                     = "\x81\x51";
        constexpr auto KatakanaIterationMark       = "\x81\x52";
        constexpr auto KatakanaVoicedIterationMark = "\x81\x53";
        constexpr auto HiraganaIterationMark       = "\x81\x54";
        constexpr auto HiraganaVoicedIterationMark = "\x81\x55";
        constexpr auto Ditto                       = "\x81\x56";
        constexpr auto Repetition                  = "\x81\x57";
        constexpr auto Unknown8158                 = "\x81\x58";
        constexpr auto Unknown8159                 = "\x81\x59";
        constexpr auto Maru                        = "\x81\x5A";
        constexpr auto Unknown815B                 = "\x81\x5B";
        constexpr auto Unknown815C                 = "\x81\x5C";
        constexpr auto Unknown815D                 = "\x81\x5D";
        constexpr auto Solidus                     = "\x81\x5E";
        constexpr auto ReverseSolidus              = "\x81\x5F";
        constexpr auto Tilde                       = "\x81\x60";
        constexpr auto Wave                        = "\x81\x60";
        constexpr auto ParallelVerticalLines       = "\x81\x61";
        constexpr auto VerticalLine                = "\x81\x62";
        constexpr auto Pipe                        = "\x81\x62";
        constexpr auto HorizontalEllipsis          = "\x81\x63";
        constexpr auto TwoDotLeader                = "\x81\x64";
        constexpr auto Unknown8165                 = "\x81\x65";
        constexpr auto Unknown8166                 = "\x81\x66";
        constexpr auto Unknown8167                 = "\x81\x67";
        constexpr auto Unknown8168                 = "\x81\x68";
        constexpr auto LeftParenthesis             = "\x81\x69";
        constexpr auto RightParenthesis            = "\x81\x6A";
        constexpr auto LeftTortoiseBracket         = "\x81\x6B";
        constexpr auto RightTortoiseBracket        = "\x81\x6C";
        constexpr auto LeftSquareBracket           = "\x81\x6D";
        constexpr auto RightSquareBracket          = "\x81\x6E";
        constexpr auto LeftCurlyBracket            = "\x81\x6F";
        constexpr auto RightCurlyBracket           = "\x81\x70";
        constexpr auto LeftAngleBracket            = "\x81\x71";
        constexpr auto RightAngleBracket           = "\x81\x72";
        constexpr auto LeftDoubleAngleBracket      = "\x81\x73";
        constexpr auto RightDoubleAngleBracket     = "\x81\x74";
        constexpr auto LeftCornerBracket           = "\x81\x75";
        constexpr auto RightCornerBracket          = "\x81\x76";
        constexpr auto LeftWhiteCornerBracket      = "\x81\x77";
        constexpr auto RightWhiteCornerBracket     = "\x81\x78";
        constexpr auto LeftBlackLenticularBracket  = "\x81\x79";
        constexpr auto RightBlackLenticularBracket = "\x81\x7A";
        constexpr auto Plus                        = "\x81\x7B";
        constexpr auto Minus                       = "\x81\x7C";
        constexpr auto PlusMinus                   = "\x81\x7D";
        constexpr auto Multiply                    = "\x81\x7E";
        constexpr auto Divide                      = "\x81\x7F";
        constexpr auto Unknown8180                 = "\x81\x80"; // Copy of 817F
        constexpr auto Equals                      = "\x81\x81";
        constexpr auto NotEquals                   = "\x81\x82";
        constexpr auto LessThan                    = "\x81\x83";
        constexpr auto GreaterThan                 = "\x81\x84";
        constexpr auto LessThanOrEquals            = "\x81\x85";
        constexpr auto GreaterThanOrEquals         = "\x81\x86";
        constexpr auto Infinite                    = "\x81\x87";
        constexpr auto Therefore                   = "\x81\x88";
        constexpr auto Male                        = "\x81\x89";
        constexpr auto Female                      = "\x81\x8A";
        constexpr auto Degree                      = "\x81\x8B";
        constexpr auto Arcminute                   = "\x81\x8C";
        constexpr auto Arcsecond                   = "\x81\x8D";
        constexpr auto DegreeCelsius               = "\x81\x8E";
        constexpr auto Unknown818F                 = "\x81\x8F"; // Copy of 815F
        constexpr auto Dollar                      = "\x81\x90";
        constexpr auto Cent                        = "\x81\x91";
        constexpr auto Pounds                      = "\x81\x92";
        constexpr auto Percent                     = "\x81\x93";
        constexpr auto Pound                       = "\x81\x94";
        constexpr auto Hashtag                     = "\x81\x94";
        constexpr auto Ampersand                   = "\x81\x95";
        constexpr auto Asterisk                    = "\x81\x96";
        constexpr auto At                          = "\x81\x97";
        constexpr auto Section                     = "\x81\x98";
        constexpr auto WhiteStar                   = "\x81\x99"; // Colors inversed, but proper naming based on look.
        constexpr auto BlackStar                   = "\x81\x9A"; // Colors inversed, but proper naming based on look.
        constexpr auto WhiteCircle                 = "\x81\x9B"; // Colors inversed, but proper naming based on look.
        constexpr auto BlackCircle                 = "\x81\x9C"; // Colors inversed, but proper naming based on look.
        constexpr auto Bullseye                    = "\x81\x9D";
        constexpr auto CircleJot                   = "\x81\x9D";
        constexpr auto WhiteDiamond                = "\x81\x9E"; // Colors inversed, but proper naming based on look.
        constexpr auto BlackDiamond                = "\x81\x9F"; // Colors inversed, but proper naming based on look.
        constexpr auto WhiteSquare                 = "\x81\xA0";
        constexpr auto BlackSquare                 = "\x81\xA1";
        constexpr auto WhiteTriangleUp             = "\x81\xA2";
        constexpr auto BlackTriangleUp             = "\x81\xA3";
        constexpr auto WhiteTriangleDown           = "\x81\xA4";
        constexpr auto BlackTriangleDown           = "\x81\xA5";
        constexpr auto ReferenceMark               = "\x81\xA6";
        constexpr auto PostalMark                  = "\x81\xA7";
        constexpr auto RightArrow                  = "\x81\xA8";
        constexpr auto LeftArrow                   = "\x81\xA9";
        constexpr auto UpArrow                     = "\x81\xAA";
        constexpr auto DownArrow                   = "\x81\xAB";
        constexpr auto Geta                        = "\x81\xAC";
        constexpr auto ElementOf                   = "\x81\xAD";
        constexpr auto ContainsAsMember            = "\x81\xAE";
        constexpr auto SubsetOrEquals              = "\x81\xAF";
        constexpr auto SupersetOrEquals            = "\x81\xB0";
        constexpr auto Subset                      = "\x81\xB1";
        constexpr auto Superset                    = "\x81\xB2";
        constexpr auto Union                       = "\x81\xB3";
        constexpr auto Intersection                = "\x81\xB4";
        constexpr auto LogicalAnd                  = "\x81\xB5";
        constexpr auto LogicalOr                   = "\x81\xB6";
        constexpr auto Not                         = "\x81\xB7";
        constexpr auto Unknown81B8                 = "\x81\xB8"; // Copy of 81AD
        constexpr auto Unknown81B9                 = "\x81\xB9"; // Copy of 81AE
        constexpr auto Unknown81BA                 = "\x81\xBA"; // Copy of 81AF
        constexpr auto Unknown81BB                 = "\x81\xBB"; // Copy of 81B0
        constexpr auto Unknown81BC                 = "\x81\xBC"; // Copy of 81B1
        constexpr auto Unknown81BD                 = "\x81\xBD"; // Copy of 81B2
        constexpr auto Unknown81BE                 = "\x81\xBE"; // Copy of 81B3
        constexpr auto Unknown81BF                 = "\x81\xBF"; // Copy of 81B4
        constexpr auto Unknown81C0                 = "\x81\xC0"; // Copy of 81B5
        constexpr auto Unknown81C1                 = "\x81\xC1"; // Copy of 81B6
        constexpr auto Unknown81C2                 = "\x81\xC2"; // Copy of 81B7
        constexpr auto Implies                     = "\x81\xC3";
        constexpr auto Iif                         = "\x81\xC4";
        constexpr auto ForAll                      = "\x81\xC5";
        constexpr auto ForEach                     = "\x81\xC5";
        constexpr auto Exists                      = "\x81\xC6";
        constexpr auto Angle                       = "\x81\xC7";
        constexpr auto Unknown81C8                 = "\x81\xC8"; // Copy of 81B5
        constexpr auto Unknown81C9                 = "\x81\xC9"; // Copy of 81B6
        constexpr auto Unknown81CA                 = "\x81\xCA"; // Copy of 81B7
        constexpr auto Unknown81CB                 = "\x81\xCB"; // Copy of 81C3
        constexpr auto Unknown81CC                 = "\x81\xCC"; // Copy of 81C4
        constexpr auto Unknown81CD                 = "\x81\xCD"; // Copy of 81C5
        constexpr auto Unknown81CE                 = "\x81\xCE"; // Copy of 81C6
        constexpr auto Unknown81CF                 = "\x81\xCF"; // Copy of 81C7
        constexpr auto Bot                         = "\x81\xD0";
        constexpr auto Falsum                      = "\x81\xD0";
        constexpr auto UpTack                      = "\x81\xD0";
        constexpr auto Tie                         = "\x81\xD1";
        constexpr auto Partial                     = "\x81\xD2";
        constexpr auto Nabla                       = "\x81\xD3";
        constexpr auto IdenticalTo                 = "\x81\xD4";
        constexpr auto ApproximatelyEqual          = "\x81\xD5";
        constexpr auto MuchLessThan                = "\x81\xD6";
        constexpr auto MuchGreaterThan             = "\x81\xD7";
        constexpr auto SquareRoot                  = "\x81\xD8";
        constexpr auto InvertedLazyS               = "\x81\xD9";
        constexpr auto Unknown81DA                 = "\x81\xDA"; // Copy of 81CF
        constexpr auto Unknown81DB                 = "\x81\xDB"; // Copy of 81D0
        constexpr auto Unknown81DC                 = "\x81\xDC"; // Copy of 81D1
        constexpr auto Unknown81DD                 = "\x81\xDD"; // Copy of 81D2
        constexpr auto Unknown81DE                 = "\x81\xDE"; // Copy of 81D3
        constexpr auto Unknown81DF                 = "\x81\xDF"; // Copy of 81D4
        constexpr auto Unknown81E0                 = "\x81\xE0"; // Copy of 81D5
        constexpr auto Unknown81E1                 = "\x81\xE1"; // Copy of 81D6
        constexpr auto Unknown81E2                 = "\x81\xE2"; // Copy of 81D7
        constexpr auto Unknown81E3                 = "\x81\xE3"; // Copy of 81D8
        constexpr auto Unknown81E4                 = "\x81\xE4"; // Copy of 81D9
        constexpr auto Proportional                = "\x81\xE5";
        constexpr auto Because                     = "\x81\xE6";
        constexpr auto Integral                    = "\x81\xE7";
        constexpr auto DoubleIntegral              = "\x81\xE8";
        constexpr auto AWithOverRing               = "\x81\xE9";
        constexpr auto PerMil                      = "\x81\xEA";
        constexpr auto PerMile                     = "\x81\xEA";
        constexpr auto MusicSharp                  = "\x81\xEB";
        constexpr auto MusicFlat                   = "\x81\xEC";
        constexpr auto MusicEighthNote             = "\x81\xED";
        constexpr auto Dagger                      = "\x81\xEE";
        constexpr auto DoubleDagger                = "\x81\xEF";

    } // namespace UnicodeSymbols

    /**
     * Displays the given text colored using the 0x1E color table.
     * 
     * @param {uint8_t} n - The number of the color to use.
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Color1(const uint8_t n, const std::string& str)
    {
        std::string res;

        res += "\x1E";
        res += (char)n;
        res += str;
        res += "\x1E\x01";

        return res;
    }

    /**
     * Displays the given text colored using the 0x1F color table.
     * 
     * @param {uint8_t} n - The number of the color to use.
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Color2(const uint8_t n, const std::string& str)
    {
        std::string res;

        res += "\x1F";
        res += (char)n;
        res += str;
        res += "\x1E\x01";

        return res;
    }

    /**
     * Displays the given text surrounded by colored brackets.
     * 
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Header(const std::string& str)
    {
        std::string res;

        res += Helpers::HeaderOpen;
        res += str;
        res += Helpers::HeaderClose;

        return res;
    }

    /**
     * Displays the given text in a dark red color.
     * 
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Critical(const std::string& str)
    {
        return Color1(76, str);
    }

    /**
     * Displays the given text in a red color.
     * 
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Error(const std::string& str)
    {
        return Color1(68, str);
    }

    /**
     * Displays the given text in a plain color.
     * 
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Message(const std::string& str)
    {
        return Color1(106, str);
    }

    /**
     * Displays the given text in a green color.
     * 
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Success(const std::string& str)
    {
        return Color1(2, str);
    }

    /**
     * Displays the given text in a yellow color.
     * 
     * @param {std::string} str - The string to display.
     * @return {std::string} The colorized string.
     */
    inline std::string Warning(const std::string& str)
    {
        return Color1(104, str);
    }

} // namespace Ashita::Chat

#endif // ASHITA_SDK_CHAT_H_INCLUDED