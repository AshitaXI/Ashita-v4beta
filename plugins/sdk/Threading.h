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

#ifndef ASHITA_SDK_THREADING_H_INCLUDED
#define ASHITA_SDK_THREADING_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// ReSharper disable CppExpressionWithoutSideEffects
// ReSharper disable CppInconsistentNaming
// ReSharper disable CppUnusedIncludeDirective

#include <Windows.h>
#include <eh.h>
#include <string>

namespace Ashita::Threading
{
    /**
     * Implements a basic synchronization object backed by Win32 event API.
     *
     */
    class Event
    {
        HANDLE m_EventHandle;

    public:
        explicit Event(const bool manualReset = true)
        {
            this->m_EventHandle = ::CreateEventA(nullptr, manualReset, FALSE, nullptr);
        }
        ~Event(void)
        {
            if (this->m_EventHandle != nullptr)
                ::CloseHandle(this->m_EventHandle);

            this->m_EventHandle = nullptr;
        }

        /**
         * Resets the event to its default state.
         *
         * @return {bool} True on success, false otherwise.
         */
        bool Reset(void) const
        {
            if (this->m_EventHandle == nullptr)
                return false;

            return ::ResetEvent(this->m_EventHandle) ? true : false;
        }

        /**
         * Sets the event to the signaled state.
         *
         * @return {bool} True on success, false otherwise.
         */
        bool Raise(void) const
        {
            if (this->m_EventHandle == nullptr)
                return false;

            return ::SetEvent(this->m_EventHandle) ? true : false;
        }

        /**
         * Checks and returns if the event is signaled.
         *
         * @param {bool} True if signaled, false otherwise.
         */
        bool IsSignaled(void) const
        {
            if (this->m_EventHandle == nullptr)
                return false;

            return ::WaitForSingleObject(this->m_EventHandle, 0) == WAIT_OBJECT_0;
        }

        /**
         * Waits for the event to be signaled.
         *
         * @param {uint32_t} milliseconds - The amount of time, in milliseconds, to wait.
         * @return {bool} True on success, false otherwise.
         */
        bool WaitFor(const uint32_t milliseconds) const
        {
            return ::WaitForSingleObject(this->m_EventHandle, milliseconds) == WAIT_OBJECT_0;
        }
    };

    /**
     * Implements a basic locking mechanism backed by a critical section.
     *
     * For faster and modern locking, it is recommended to use the newer std::lock_guard
     * scheme with a std::mutex object instead. (Performance will vary based on compiler
     * versions. Recommended for use with VC++ 2015 Update 3 or newer.)
     */
    class LockableObject
    {
        CRITICAL_SECTION m_CriticalSection;

        // Delete Copy and Assignment Operators
        LockableObject(LockableObject const&) = delete;            // Delete Copy Constructor
        LockableObject(LockableObject&&)      = delete;            // Delete Move Constructor
        LockableObject& operator=(LockableObject const&) = delete; // Delete Copy Assignment Constructor
        LockableObject& operator=(LockableObject&&) = delete;      // Delete Move Assignment Constructor

    public:
        LockableObject(void)
        {
            ::InitializeCriticalSection(&this->m_CriticalSection);
        }
        ~LockableObject(void)
        {
            ::DeleteCriticalSection(&this->m_CriticalSection);
        }

        /**
         * Locks the critical section.
         */
        void Lock(void)
        {
            ::EnterCriticalSection(&this->m_CriticalSection);
        }

        /**
         * Unlocks the critical section.
         */
        void Unlock(void)
        {
            ::LeaveCriticalSection(&this->m_CriticalSection);
        }
    };

    /**
     * Thread Priority Enumeration
     */
    enum class ThreadPriority : int32_t
    {
        Lowest      = -2,
        BelowNormal = -1,
        Normal      = 0,
        AboveNormal = 1,
        Highest     = 2
    };

    /**
     * Implements a basic threading object. Backed by events using the above Event class object.
     *
     * This class is based on code from a private threading library:
     * Copyright(C) 1995-2006 Anton S. Yemelyanov
     *
     * Full permission was granted to use his code via email.
     * This is losely based on v1.4 of his code from GAPI_Thread.hpp/.cpp.
     */
    class Thread
    {
        HANDLE m_Handle;
        DWORD m_Id;
        Ashita::Threading::Event m_EventStart;
        Ashita::Threading::Event m_EventEnd;

    public:
        Thread(void)
            : m_Handle(nullptr)
            , m_Id(0)
            , m_EventStart(true)
            , m_EventEnd(true)
        {}
        virtual ~Thread(void)
        {
            if (this->m_Handle != nullptr)
                this->Stop();
        }

        /**
         * Thread entry function. (Inheriting classes must implement this.)
         *
         * @return {uint32_t} Thread specific return value.
         */
        virtual uint32_t ThreadEntry(void) = 0;

        /**
         * Internal thread entry used to signal the thread and run the inheriting entry.
         *
         * @return {uint32_t} Thread specific return value.
         */
        uint32_t InternalEntry(void)
        {
            if (this->IsTerminated())
                return 0;

            // Reset and raise the events..
            this->m_EventEnd.Reset();
            ::Sleep(10);
            this->m_EventStart.Raise();

            // Run the thread..
            return this->ThreadEntry();
        }

        /**
         * Starts the thread.
         */
        void Start(void)
        {
            this->m_EventStart.Reset();
            this->m_EventEnd.Reset();
            this->m_Handle = ::CreateThread(nullptr, 0, (LPTHREAD_START_ROUTINE)ThreadCallback, this, 0, &this->m_Id);
        }

        /**
         * Stops the thread.
         */
        void Stop(void)
        {
            // Raise the end signal..
            this->RaiseEnd();

            // Wait for the thread to end then cleanup..
            if (this->WaitFor(INFINITE))
            {
                ::CloseHandle(this->m_Handle);
                this->m_Handle = nullptr;
                this->m_Id     = 0;
            }
        }

        /**
         * Returns if the end event is signaled telling the thread to terminate.
         */
        bool IsTerminated(void) const
        {
            return this->m_EventEnd.IsSignaled();
        }

        /**
         * Waits for the given amount of time for the thread to response.
         *
         * @param {uint32_t} milliseconds - The amount of time, in milliseconds, to wait.
         * @return {bool} True on success, false otherwise.
         */
        bool WaitFor(const uint32_t milliseconds = INFINITE) const
        {
            if (this->m_Handle == nullptr)
                return false;

            return ::WaitForSingleObject(this->m_Handle, milliseconds) != WAIT_TIMEOUT;
        }

        /**
         * Returns the threads current priority.
         *
         * @return {ThreadPriority} The threads priority.
         */
        ThreadPriority GetPriority(void) const
        {
            if (this->m_Handle == nullptr)
                return ThreadPriority::Normal;

            return (ThreadPriority)::GetThreadPriority(this->m_Handle);
        }

        /**
         * Sets the threads priority.
         *
         * @param {ThreadPriority} p - The new priority to set the thread to.
         */
        void SetPriority(ThreadPriority p) const
        {
            if (this->m_Handle != nullptr)
                ::SetThreadPriority(this->m_Handle, (int32_t)p);
        }

        /**
         * Signals the end event telling the thread to stop.
         */
        void RaiseEnd(void) const
        {
            this->m_EventEnd.Raise();
        }

        /**
         * Resets the end event signal.
         */
        void ResetEnd(void) const
        {
            this->m_EventEnd.Reset();
        }

        /**
         * Returns the thread handle.
         *
         * @return {HANDLE} The thread handle.
         */
        HANDLE GetHandle(void) const
        {
            return this->m_Handle;
        }

        /**
         * Returns the thread id.
         *
         * @return {DWORD} The thread id.
         */
        DWORD GetId(void) const
        {
            return this->m_Id;
        }

        /**
         * Returns the thread exit code.
         *
         * @return {DWORD} The thread exit code.
         */
        DWORD GetExitCode(void) const
        {
            if (this->m_Handle == nullptr)
                return 0;

            DWORD exitCode = 0;
            ::GetExitCodeThread(this->m_Handle, &exitCode);

            return exitCode;
        }

    private:
        /**
         * Internal thread callback to invoke the inheriting parents handler.
         *
         * @param {LPVOID} param - The thread object passed to the callback.
         * @return {uint32_t} The internal threads return value, 0 otherwise.
         */
        static uint32_t __stdcall ThreadCallback(const LPVOID param)
        {
            if (const auto thread = (Ashita::Threading::Thread*)param; thread != nullptr)
                return thread->InternalEntry();

            return 0;
        }
    };

} // namespace Ashita::Threading

#endif // ASHITA_SDK_THREADING_H_INCLUDED