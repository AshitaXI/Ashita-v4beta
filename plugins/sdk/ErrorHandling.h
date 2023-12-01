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

#ifndef ASHITA_SDK_ERRORHANDLING_H_INCLUDED
#define ASHITA_SDK_ERRORHANDLING_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <Windows.h>
#include <eh.h>
#include <string>

/**
 * Missing Status Code Defines
 */
#ifndef STATUS_POSSIBLE_DEADLOCK
#define STATUS_POSSIBLE_DEADLOCK 0xC0000194
#endif

/**
 * Helper Macros
 */
#define CASE(e)                 \
    case e:                     \
        this->m_Exception = #e; \
        break;

namespace Ashita::ErrorHandling
{
    class Exception
    {
        uint32_t m_Id;
        const char* m_Exception;
        char m_Message[2048];
        _EXCEPTION_POINTERS* m_Pointers;

    public:
        explicit Exception(const uint32_t id, _EXCEPTION_POINTERS* pointers)
            : m_Id(id)
            , m_Exception(nullptr)
            , m_Message{0}
            , m_Pointers(pointers)
        {
            switch (this->m_Id)
            {
                CASE(EXCEPTION_ACCESS_VIOLATION);
                CASE(EXCEPTION_ARRAY_BOUNDS_EXCEEDED);
                CASE(EXCEPTION_BREAKPOINT);
                CASE(EXCEPTION_DATATYPE_MISALIGNMENT);
                CASE(EXCEPTION_FLT_DENORMAL_OPERAND);
                CASE(EXCEPTION_FLT_DIVIDE_BY_ZERO);
                CASE(EXCEPTION_FLT_INEXACT_RESULT);
                CASE(EXCEPTION_FLT_INVALID_OPERATION);
                CASE(EXCEPTION_FLT_OVERFLOW);
                CASE(EXCEPTION_FLT_STACK_CHECK);
                CASE(EXCEPTION_FLT_UNDERFLOW);
                CASE(EXCEPTION_GUARD_PAGE);
                CASE(EXCEPTION_ILLEGAL_INSTRUCTION);
                CASE(EXCEPTION_IN_PAGE_ERROR);
                CASE(EXCEPTION_INT_DIVIDE_BY_ZERO);
                CASE(EXCEPTION_INT_OVERFLOW);
                CASE(EXCEPTION_INVALID_DISPOSITION);
                CASE(EXCEPTION_INVALID_HANDLE);
                CASE(EXCEPTION_NONCONTINUABLE_EXCEPTION);
                CASE(EXCEPTION_POSSIBLE_DEADLOCK);
                CASE(EXCEPTION_PRIV_INSTRUCTION);
                CASE(EXCEPTION_SINGLE_STEP);
                CASE(EXCEPTION_STACK_OVERFLOW);

                default:
                    this->m_Exception = "(Unknown Exception)";
                    break;
            }

            const auto ptr = pointers != nullptr && pointers->ExceptionRecord != nullptr
                                 ? pointers->ExceptionRecord->ExceptionAddress
                                 : nullptr;

            // Create a formatted message of the exception..
            sprintf_s(this->m_Message, 2048, "%s (%08X). [Ptr: %08p]", this->m_Exception, id, ptr);
        }
        ~Exception(void)
        {}

        /**
         * Returns the exception id.
         *
         * @return {uint32_t} The exception id.
         */
        uint32_t GetId(void) const
        {
            return this->m_Id;
        }

        /**
         * Returns the exception type.
         *
         * @return {const char*} The exception type.
         */
        const char* GetException(void) const
        {
            return this->m_Message;
        }

        /**
         * Returns the exception message.
         *
         * @return {const char*} The exception message.
         */
        const char* what(void) const
        {
            return this->m_Message;
        }

        /**
         * Returns the exception pointers information.
         *
         * @return {_EXCEPTION_POINTERS*} The exception pointers.
         */
        _EXCEPTION_POINTERS* GetPointers(void) const
        {
            return this->m_Pointers;
        }
    };

    class ScopedTranslator
    {
        _se_translator_function m_Function;

    public:
        ScopedTranslator(void)
        {
            this->m_Function = ::_set_se_translator(&ScopedTranslator::ScopedTranslatorFunction);
        }
        ~ScopedTranslator(void)
        {
            if (this->m_Function != nullptr)
                ::_set_se_translator(this->m_Function);

            this->m_Function = nullptr;
        }

    private:
        /**
         * Catches and rethrows an exception as an Ashita wrapped exception.
         *
         * @param {uint32_t} id - The id of the exception.
         * @param {_EXCEPTION_POINTERS*} pointers - The pointer information of the exception.
         */
        static void ScopedTranslatorFunction(const uint32_t id, struct _EXCEPTION_POINTERS* pointers)
        {
            throw Ashita::ErrorHandling::Exception(id, pointers);
        }
    };

} // namespace Ashita::ErrorHandling

#endif // ASHITA_SDK_ERRORHANDLING_H_INCLUDED