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

#ifndef ASHITA_SDK_SCOPEGUARD_H_INCLUDED
#define ASHITA_SDK_SCOPEGUARD_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// ReSharper disable CppInconsistentNaming
// ReSharper disable CppUnusedIncludeDirective

#include <Windows.h>
#include <functional>
#include <deque>

namespace Ashita
{
    /**
     * Implements a slim and simple scope guard that can have multiple executed callbacks.
     *
     * This can be seen and used as a 'finally' type handler, allowing callbacks to be executed
     * when scope is lost, ensuring certain tasks are executed/cleaned up.
     */
    class ScopeGuard final
    {
        std::deque<std::function<void(void)>> m_Callbacks;

    public:
        ScopeGuard(void);
        ~ScopeGuard(void);

        template<typename Func>
        explicit ScopeGuard(Func&& f);

        ScopeGuard(const ScopeGuard&) = delete;
        ScopeGuard& operator=(const ScopeGuard&) = delete;
        ScopeGuard& operator=(ScopeGuard&&) = delete;

        template<typename Func>
        ScopeGuard& operator+=(Func&& f);

        void Disable(void) noexcept;
    };

} // namespace Ashita

/**
 * Constructor
 */
inline Ashita::ScopeGuard::ScopeGuard(void)
{}

/**
 * Deconstructor
 */
inline Ashita::ScopeGuard::~ScopeGuard(void)
{
    for (auto& f : this->m_Callbacks)
    {
        try
        {
            f();
        }
        catch (...)
        {}
    }
}

/**
 * Overloaded Constructor
 * 
 * @param {Func&&} f - The callback function to add to the callback queue.
 */
template<typename Func>
Ashita::ScopeGuard::ScopeGuard(Func&& f)
{
    // Add the handler to the queue of callbacks..
    this->operator+=<Func>(std::forward<Func>(f));
}

/**
 * Addition Assignment Operator Overload
 * 
 * @param {Func&&} f - The callback function to add to the callback queue.
 * @return {ScopeGuard&} The lhs ScopeGuard object.
 */
template<typename Func>
Ashita::ScopeGuard& Ashita::ScopeGuard::operator+=(Func&& f)
{
    this->m_Callbacks.emplace_front(std::forward<Func>(f));
    return *this;
}

/**
 * Clears the callback queue, preventing any callback from executing.
 */
inline void Ashita::ScopeGuard::Disable(void) noexcept
{
    this->m_Callbacks.clear();
}

#endif // ASHITA_SDK_SCOPEGUARD_H_INCLUDED