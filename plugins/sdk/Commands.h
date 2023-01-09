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

#ifndef ASHITA_SDK_COMMANDS_H_INCLUDED
#define ASHITA_SDK_COMMANDS_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// ReSharper disable CppInconsistentNaming
// ReSharper disable CppRedundantControlFlowJump
// ReSharper disable CppUnusedIncludeDirective

#include <algorithm>
#include <string>
#include <vector>

/**
 * Helper Macros
 */
#define HANDLECOMMAND(...) \
    if (args.size() > 0 && Ashita::Commands::CommandCheck(args[0], std::vector<std::string>({__VA_ARGS__})))

namespace Ashita::Commands
{
    /**
     * Checks if the command exists in the given list of command strings.
     *
     * @param {std::string&} cmd - The command to compare against.
     * @param {std::vector&} cmds - The list of commands available to try and compare against.
     * @return {bool} True if found, false otherwise.
     */
    static __forceinline bool CommandCheck(const std::string& cmd, const std::vector<std::string>& cmds)
    {
        if (cmd.size() == 0 || cmds.size() == 0)
            return false;

        return std::ranges::any_of(cmds, [&cmd](const std::string& s) -> bool {
            return _stricmp(cmd.c_str(), s.c_str()) == 0;
        });
    }

    /**
     * Checks if the given character is considered a white-space character.
     * ' ', (escaped) t, n, v, f, r
     *
     * @param {char} c - The character to check.
     * @return {bool} True if whitespace, false otherwise.
     */
    static __forceinline bool _isspace(const char c)
    {
        return c == ' ' || c == '\t' || c == '\n' || c == '\v' || c == '\f' || c == '\r';
    }

    /**
     * Parses a command string for quoted sub-arguments.
     *
     * @param {const char*} command - The command to parse.
     * @param {std::vector*} args - The return container to hold the found arguments.
     * @return {uint32_t} The number of arguments parsed from the command.
     */
    static uint32_t GetCommandArgs(const char* command, std::vector<std::string>* args)
    {
        enum class cState
        {
            None,
            InWord,
            InString
        };

        // Prepare the needed variables..
        char curr[2048]{};
        auto p       = command;
        char* pStart = nullptr;
        auto state   = cState::None;

        // Walk the command and parse for quoted arguments..
        for (; *p != 0; ++p)
        {
            const auto c = (char)*p;

            // Handle the current state..
            switch (state)
            {
                /**
                 * No current state, look for quotes to start a string..
                 */
                case cState::None:
                    if (Ashita::Commands::_isspace(c))
                        continue;
                    if (c == '"')
                    {
                        state  = cState::InString;
                        pStart = (char*)p + 1;
                        continue;
                    }
                    state  = cState::InWord;
                    pStart = (char*)p;
                    continue;

                /**
                 * String state, look for ending quote to complete a string..
                 */
                case cState::InString:
                    if (c == '"')
                    {
                        strncpy_s(curr, pStart, p - pStart);
                        args->push_back(std::string(curr));
                        state  = cState::None;
                        pStart = nullptr;
                    }
                    continue;

                /**
                 * Word state, look for a space to end the word..
                 */
                case cState::InWord:
                    if (Ashita::Commands::_isspace(c))
                    {
                        strncpy_s(curr, pStart, p - pStart);
                        args->push_back(std::string(curr));
                        state  = cState::None;
                        pStart = nullptr;
                    }
                    continue;
            }
        }

        // Add any left-over words to the args container..
        if (pStart != nullptr)
        {
            strncpy_s(curr, pStart, p - pStart);
            args->push_back(std::string(curr));
        }

        // Return the amount of found arguments..
        return args->size();
    }

} // namespace Ashita::Commands

#endif // ASHITA_SDK_COMMANDS_H_INCLUDED