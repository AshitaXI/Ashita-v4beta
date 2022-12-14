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

local function_mt = {};

--[[
* Returns a table containing the two given tables joined together.
*
* @param {table} t1 - The first table to append.
* @param {table} t2 - The second table to append.
* @return {table} The appended table.
--]]
local function append(t1, t2)
    local ret = T{ };

    for k, v in ipairs(t1) do ret[k] = v; end
    for _, v in ipairs(t2) do ret[#ret + 1] = v; end

    return ret;
end

--[[
* Returns the time it takes for the function to execute.
*
* @param {function} self - The parent function.
* @param {any} ... - Any arguments to pass to the function.
* @return {number, ...} The time it took to execute and any additional returns from the function.
--]]
function_mt.bench = function (self, ...)
    local start = os.clock();
    local ret = {self(...)};

    return os.clock() - start, unpack(ret);
end

function_mt.benchmark   = function_mt.bench;
function_mt.time        = function_mt.bench;

--[[
* Returns a function that attachs the given value to the first argument when invoked.
*
* @param {function} self - The parent function.
* @param {any} arg - The argument to attach to the function.
* @return {function} The bound function.
--]]
function_mt.bind1 = function (self, arg)
    return function (...)
        return self(arg, ...);
    end
end

function_mt.bind    = function_mt.bind1;
function_mt.curry   = function_mt.bind1;

--[[
* Returns a function that attachs the given value to the second argument when invoked.
*
* @param {function} self - The parent function.
* @param {any} arg - The argument to attach to the function.
* @return {function} The bound function.
--]]
function_mt.bind2 = function (self, arg)
    return function (a, ...)
        return self(a, arg, ...);
    end
end

--[[
* Returns a function that attachs the given values to the n-th argument when invoked.
*
* @param {function} self - The parent function.
* @param {any} ... - The arguments to attach to the function.
* @return {function} The bound function.
--]]
function_mt.bindn = function (self, ...)
    local args = T{...};

    return function (...)
        return self(unpack(append(args, T{...})));
    end
end

--[[
* Invokes the function and returns.
*
* @param {function} self - The parent function.
* @param {any} ... - The arguments to pass to the function.
* @return {...} The function returns.
--]]
function_mt.call = function (self, ...)
    return self(...);
end

--[[
* Returns a function that when invoked, will invoke the parent and return the logical complement of its return value.
*
* @param {function} self - The parent function.
* @return {function} The wrapped function.
--]]
function_mt.complement = function (self)
    return function (...)
        return not self(...);
    end
end

function_mt.negate = function_mt.complement;

--[[
* Returns a function that when invoked, will invoke all passed functions (right-to-left) and pipe the returns to each following function.
* (Similar to reducing a table.)
*
* @param {...} ... - Any number of functions to pipe together.
* @return {function} The piped functions wrapped into one.
--]]
function_mt.compose = function (...)
    local funcs = T{...};

    return function (...)
        local ret = T{funcs[#funcs](...)};
        for n = #funcs - 1, 1, -1 do
            ret = T{funcs[n](unpack(ret))};
        end
        return unpack(ret);
    end
end

function_mt.pipe = function_mt.compose;

--[[
* Returns a function that, when invoked will only invoke the parent function if the condition function passes.
*
* @param {function} self - The parent function.
* @param {function} cond - The condition function to invoked first to determine if the parent function is invoked.
* @return {nil|...} Nil if the condition fails, any returns from the parent function otherwise.
--]]
function_mt.cond = function (self, cond)
    return function (...)
        if (cond(...)) then
            return self(...);
        end
        return nil;
    end
end

function_mt.condition   = function_mt.cond;
function_mt.execif      = function_mt.cond;

--[[
* Returns a function that, when invoked will always return the passed value.
*
* @param {any} val - The value to return.
* @return {any} The value passed.
*
* @note     The return here is not guaranteed to actually be constant for certain things. For example if a table is
*           passed, that table can still be altered elsewhere and cause the return to change. For those instances, it's
*           best to pass a copy/clone of the object that will not be referenced/used elsewhere.
--]]
function_mt.constant = function (val)
    return function ()
        return val;
    end
end

function_mt.const = function_mt.constant;

--[[
* Returns a function that, when invoked will join the passed functions into the parent as parameters into one function.
*
* @param {function} self - The parent function.
* @param {function} f1 - The first function to converge.
* @param {function} f2 - The second function to converge.
* @return {function} The converged function.
--]]
function_mt.converge = function (self, f1, f2)
    return function (...)
        return self(f1(...), f2(...));
    end
end

--[[
* Returns a function that, when invoked will invoke each function passed (in-order) and will return when the first function has a non-nil evaluation.
*
* @param {...} ... - The functions to dispatch.
* @return {function} The dispatched function.
--]]
function_mt.dispatch = function (...)
    local funcs = T{...};

    return function (...)
        for _, v in ipairs(funcs) do
            local ret = T{v(...)};
            if (#ret > 0) then
                return unpack(ret);
            end
        end
    end
end

--[[
* Returns a function that, when invoked will invoke the parent function and return an iterator of its return values.
*
* @param {function} self - The parent function.
* @return {function} The return value iterator.
--]]
function_mt.it = function (self, ...)
    local ret = T{self(...)};
    local n = 0;

    return function ()
        n = n + 1;
        return ret[n];
    end
end

function_mt.iter = function_mt.it;

--[[
* Returns a function that when invoked, will invoke all passed functions (left-to-right) and pipe the returns to each following function.
*
* @param {...} ... - Any number of functions to pipe together.
* @return {function} The piped functions wrapped into one.
--]]
function_mt.lcompose = function (...)
    local funcs = T{...}:reverse();

    return function (...)
        local ret = T{funcs[#funcs](...)};
        for n = #funcs - 1, 1, -1 do
            ret = T{funcs[n](unpack(ret))};
        end
        return unpack(ret);
    end
end

function_mt.lpipe = function_mt.lcompose;

--[[
* Returns a function that when invoked, will cache return values of all future calls to help speed up slow functions.
*
* @param {function} self - The parent function.
* @return {function} The memoized function.
--]]
function_mt.memoize = function (self)
    local f_cache = setmetatable({}, { __mode = 'kv' });

    return function (...)
        local k = T{...}:join('_');
        if (f_cache[k] == nil) then
            f_cache[k] = self(...);
        end
        return f_cache[k];
    end
end

--[[
* Returns a function that when invoked, will return the functions returns, packed into a table.
*
* @param {function} self - The parent function.
* @param {any} ... - The arguments to pass to the function.
* @return {function} The wrapped function.
--]]
function_mt.packed = function (self, ...)
    return function (...)
        return T{ self(...) };
    end
end

--[[
* Returns a function that when invoked, will apply the arguments passed to it on creation first, then any additional parameters at the time of invocation after.
*
* @param {function} self - The parent function.
* @param {...} ... - The initial arguments to attach to the function.
* @return {function} The partial function.
--]]
function_mt.partial = function (self, ...)
    local c_args = T{...};

    return function (...)
        local i_args = T{...};
        local args = append(c_args, i_args);

        return self(unpack(args));
    end
end

function_mt.apply = function_mt.partial;

--[[
* Returns a function that when invoked, will apply the arguments passed to it on invocation first, then any parameters at the time of creation after.
*
* @param {function} self - The parent function.
* @param {...} ... - The arguments to attach to the function on invocation.
* @return {function} The partial function.
--]]
function_mt.partialend = function (self, ...)
    local c_args = T{...};

    return function (...)
        local i_args = T{...};
        local args = append(i_args, c_args);

        return self(unpack(args));
    end
end

function_mt.applyend = function_mt.partialend;

--[[
* Returns a function that when invoked, will apply the arguments passed to it on creation first, then any additional parameters at the time of invocation after. Skipping n number of arguments passed at invokation.
*
* @param {function} self - The parent function.
* @param {number} n - The number of arguments to skip from the invokation call.
* @param {...} ... - The initial arguments to attach to the function.
* @return {function} The partial function.
--]]
function_mt.partialskip = function (self, n, ...)
    local c_args = T{...};

    return function (...)
        local i_args = T{...};
        i_args = i_args:slice(n + 1, #i_args);

        local args = append(c_args, i_args);

        return self(unpack(args));
    end
end

function_mt.skip = function_mt.partialskip;

--[[
* Returns a function that when invoked, will call the parent with the arguments passed at its creation.
*
* @param {function} self - The parent function.
* @param {...} ... - The arguments to attach to the function.
* @return {function} The prepared function.
--]]
function_mt.prepare = function (self, ...)
    local args = T{...};

    return function ()
        return self(unpack(args));
    end
end

--[[
* Returns a function that when invoked, will call the parent with the given arguments reordered based on the passed indices at creation.
*
* @param {function} self - The parent function.
* @param {...} ... - The argument indices to be used when invoking the parent.
* @return {function} The wrapped function.
--]]
function_mt.rearg = function (self, ...)
    local indices = T{...};

    return function (...)
        local args = T{ };
        for k, v in ipairs(indices) do
            rawset(args, k, (select(v, ...)));
        end
        return self(unpack(args));
    end
end

function_mt.args = function_mt.rearg;

--[[
* Returns a function that when invoked, will return the selected return value specifically.
*
* @param {function} self - The parent function.
* @param {number} n - The index of the return to return specifically.
* @return {function} The wrapped function.
--]]
function_mt.select = function (self, n)
    return function (...)
        return (select(n, self(...)));
    end
end

--[[
* Returns a function that can only be invoked a single time. Additional invocation s will yield the original result.
*
* @param {function} self - The parent function.
* @return {function} The wrapped function.
--]]
function_mt.single = function (self)
    local invoked = false;
    local ret = nil;

    return function (...)
        if (not invoked) then
            invoked = true;
            ret = self(...);
        end
        return ret;
    end
end

function_mt.onetime = function_mt.single;
function_mt.static  = function_mt.single;

--[[
* Invokes the parent function n-times and returns a table of its results.
*
* @param {function} self - The parent function.
* @param {number} n - The number of times to invoke the function.
* @return {table} The return values from the function.
--]]
function_mt.times = function (self, n, ...)
    local ret = T{ };
    for i = 1, (n or 1) do
        ret[i] = self(...);
    end
    return ret;
end

--[[
* Returns the functions string representation. [tostring forward.]
*
* @param {function} self - The parent function.
* @return {string} The functions string representation.
--]]
function_mt.tostring = function (self)
    return tostring(self);
end

function_mt.str     = function_mt.tostring;
function_mt.tostr   = function_mt.tostring;

--[[
* Returns the functions type. [type forward.]
*
* @param {function} self - The parent function.
* @return {string} The functions type string.
--]]
function_mt.type = function (self)
    return type(self);
end

--[[
* Returns a function that when invoked, will call the wrapper function passing the parent as the first parameter.
*
* @param {function} self - The parent function.
* @param {function} fwrap - The wrapper function.
* @return {function} The wrapped function.
--]]
function_mt.wrap = function (self, fwrap)
    return function (...)
        return fwrap(self, ...);
    end
end

----------------------------------------------------------------------------------------------------
--
-- Functional Helpers
--
----------------------------------------------------------------------------------------------------

--[[
* Returns a function that when invoked, will call all passed functions and return true if all functions return true.
*
* @param {...} ... - Any functions to be tested.
* @return {function} The wrapped function.
--]]
function_mt.all = function (...)
    local funcs = T{...};

    return function (...)
        for _, v in ipairs(funcs) do
            if (not v(...)) then
                return false;
            end
        end
        return true;
    end
end

function_mt.both = function_mt.all;

--[[
* Returns a function that when invoked, will call all passed functions and return true if any function return true.
*
* @param {...} ... - Any functions to be tested.
* @return {function} The wrapped function.
--]]
function_mt.any = function (...)
    local funcs = T{...};

    return function (...)
        for _, v in ipairs(funcs) do
            if (v(...)) then
                return true;
            end
        end
        return false;
    end
end

function_mt.either = function_mt.any;

--[[
* Returns a function that when invoked, will increment a counter and return true until the given value is met.
*
* @param {number} cnt - The value to count up to.
* @return {function} The wrapped function.
--]]
function_mt.count = function (cnt)
    local c = cnt;
    local n = 0;

    return function ()
        n = n + 1;
        return n <= c;
    end
end

function_mt.counter = function_mt.count;

--[[
* Returns a function that when invoked, will compare the value passed at creation to the one passed at invocation to test that they are equal.
*
* @param {any} val - The value to compare.
* @return {function} The wrapped function.
--]]
function_mt.equals = function (val)
    return function (val2)
        return val == val2;
    end
end

function_mt.eq = function_mt.equals;

--[[
* Returns a function that when invoked, will call all passed functions and return true if all functions return false.
*
* @param {...} ... - Any functions to be tested.
* @return {function} The wrapped function.
--]]
function_mt.none = function (...)
    local funcs = T{...};

    return function (...)
        for _, v in ipairs(funcs) do
            if (v(...)) then
                return false;
            end
        end
        return true;
    end
end

function_mt.neither = function_mt.none;

--[[
* Returns a function that when invoked, will compare the value passed at creation to the one passed at invocation to test that they are not equal.
*
* @param {any} val - The value to compare.
* @return {function} The wrapped function.
--]]
function_mt.notequals = function (val)
    return function (val2)
        return val ~= val2;
    end
end

function_mt.neq = function_mt.notequals;

----------------------------------------------------------------------------------------------------
--
-- Functional Helpers (Coroutine Forwards via Ashita Tasks)
--
----------------------------------------------------------------------------------------------------

--[[
* Schedules the function to repeat until the condition is met. (Delay in seconds.)
*
* @param {function} self - The parent function.
* @param {number} delay - The delay, in seconds, to wait between each call to the function.
* @param {function|number} cond - If function, a function that returns true or false to continue looping. If number, the number of times to loop the function.
* @param {function} cb - Callback function to invoke when the loop has finished.
* @param {...} ... - Any arguments to pass to the function.
--]]
function_mt.loop = function (self, delay, cond, cb, ...)
    -- Ensure the delay is not going to kill the cpu..
    if (delay <= 0) then
        error('Invalid delay given. Must be greater than 0.');
        return;
    end

    -- Account for nil or number based conditions..
    cond = cond or function_mt.const(true);
    if (type(cond) == 'number') then
        cond = function_mt.counter(cond);
    end

    -- Create the coroutine based task..
    ashita.tasks.once(0, function (...)
        while (cond()) do
            self(...);
            coroutine.sleep(delay);
        end
        if (cb) then
            cb();
        end
    end, ...);
end

--[[
* Schedules the function to repeat until the condition is met. (Delay in frames.)
*
* @param {function} self - The parent function.
* @param {number} delay - The delay, in frames, to wait between each call to the function.
* @param {function|number} cond - If function, a function that returns true or false to continue looping. If number, the number of times to loop the function.
* @param {function} cb - Callback function to invoke when the loop has finished.
* @param {...} ... - Any arguments to pass to the function.
--]]
function_mt.loopf = function (self, delay, cond, cb, ...)
    -- Ensure the delay is not going to kill the cpu..
    if (delay <= 0) then
        error('Invalid delay given. Must be greater than 0.');
        return;
    end

    -- Account for nil or number based conditions..
    cond = cond or function_mt.const(true);
    if (type(cond) == 'number') then
        cond = function_mt.counter(cond);
    end

    -- Create the coroutine based task..
    ashita.tasks.oncef(0.0, function (...)
        while (cond()) do
            self(...);
            coroutine.sleepf(delay);
        end
        if (cb) then
            cb();
        end
    end, ...);
end

--[[
* Schedules the function to be called after the given delay. (Delay in seconds.)
*
* @param {function} self - The parent function.
* @param {number} delay - The delay, in seconds, to wait before invoking the function.
* @param {...} ... - Any arguments to pass to the function.
--]]
function_mt.once = function (self, delay, ...)
    ashita.tasks.once(delay, self, ...);
end

--[[
* Schedules the function to be called after the given delay. (Delay in frames.)
*
* @param {function} self - The parent function.
* @param {number} delay - The delay, in frames, to wait before invoking the function.
* @param {...} ... - Any arguments to pass to the function.
--]]
function_mt.oncef = function (self, delay, ...)
    ashita.tasks.oncef(delay, self, ...);
end

--[[
* Schedules the function to be called repeatedly after the given delay. (Delay in seconds.)
*
* @param {function} self - The parent function.
* @param {number} delay - The delay, in seconds, to wait before invoking the function.
* @param {number} repeats - The number of times to invoke the function.
* @param {number} repeat_delay - The delay, in seconds, to wait between invoking the function.
* @param {...} ... - Any arguments to pass to the function.
--]]
function_mt.repeating = function (self, delay, repeats, repeat_delay, ...)
    ashita.tasks.repeating(delay, repeats, repeat_delay, self, ...);
end

--[[
* Schedules the function to be called repeatedly after the given delay. (Delay in frames.)
*
* @param {function} self - The parent function.
* @param {number} delay - The delay, in frames, to wait before invoking the function.
* @param {number} repeats - The number of times to invoke the function.
* @param {number} repeat_delay - The delay, in frames, to wait between invoking the function.
* @param {...} ... - Any arguments to pass to the function.
--]]
function_mt.repeatingf = function (self, delay, repeats, repeat_delay, ...)
    ashita.tasks.repeatingf(delay, repeats, repeat_delay, self, ...);
end

--[[
* Function Metatable Overrides
*
* Overrides the default metatable of a function value.
* Metatable overrides:
*
*   __add       = Calls function_mt.partial. (Expects a table of arguments.)
*   __concat    = Uses function_mt.compose.
*   __index     = Custom indexing. [function_mt.select -> function_mt -> error]
*   __mul       = Uses function_mt.times.
*   __pow       = Uses function_mt.times.
*   __sub       = Calls function_mt.partialend. (Expects a table of arguments.)
*   __unm       = Uses function_mt.complement.
*
* Note:
*
*   Indexing a function with a number will call function_mt.select, which will select a specific return
*   value from the function after it is called.
--]]
debug.setmetatable(function () end, {
    __add = function (self, t)
        return self:partial(unpack(t));
    end,
    __concat = function_mt.compose,
    __index = function (self, k)
        return
            type(k) == 'number' and self:select(k) or
            rawget(function_mt, k) and function (...) return function_mt[k](...); end or
            error(string.format('Lua object \'function\' does not contain a define for: \'%s\'', k));
    end,
    __mul = function_mt.times,
    __pow = function_mt.times,
    __sub = function (self, t)
        return self:partialend(unpack(t));
    end,
    __unm = function_mt.complement,
});

-- Return the modules metatable and functions table.
return function ()
    return function_mt, {
        const       = function_mt.constant,
        constant    = function_mt.constant,
        count       = function_mt.count,
        counter     = function_mt.count,
        eq          = function_mt.equals,
        equals      = function_mt.equals,
        neq         = function_mt.notequals,
        notequals   = function_mt.notequals,
    };
end