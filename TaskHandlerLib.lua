--[[ =================================================================
    Description:
        Basic task handler to queue API calls that otherwise
        would/could cause overloads, disconnects, internal errors,
        etc.

    Contact:
        For questions, bug reports visit the website or send an email
        to the following address: wowaddon@xs4all.nl

    Dependencies:
        None
    ================================================================= --]]

-- Base setup for task handler
    TaskHandlerLib = { tasks = {}           -- Task structure
                     , interval = 0.5       -- OnUpdate interval (in seconds)
                     , fps = 25             -- When FPS (in fps) drops below this value interval will be increased
                     , lag = 200            -- When lag (in ms) rises above this value interval will be increased
                     };

-- Initialize the task handler
    function TaskHandlerLib:Init()
        -- Make sure self is known as TaskHandlerLib
        local self = TaskHandlerLib;

        -- Create frame
        if ( not self.frame ) then
            self.frame = CreateFrame( "Frame" );

            -- Set scripts
            self.frame:SetScript( "OnUpdate", self.OnUpdate );
            self.frame:SetScript( "OnEvent", self.OnEvent );

            -- Register events
            self.frame:RegisterEvent( "PLAYER_ENTERING_WORLD" );

            -- Apply base settings
            self.lastupdate = 0;
            self.active = true;
        end;
    end;

-- Add task to the queue
    function TaskHandlerLib:AddTask( owner, proc, arg1, arg2 )
        -- Make sure self is known as TaskHandlerLib
        local self = TaskHandlerLib;

        -- Create new task
        local newtask = { owner = owner,
                          proc = proc,
                          arg1 = arg1,
                          arg2 = arg2 };

        -- Add task to queue
        self.tasks[#self.tasks + 1] = newtask;
    end;

-- Process task from the queue
    function TaskHandlerLib:ProcessTask()
        -- Make sure self is known as TaskHandlerLib
        local self = TaskHandlerLib;
        local task = self.tasks[1];

        -- Execute task
        pcall( task.proc, task.arg1, task.arg2 );

        -- Remove task from queue
        table.remove( self.tasks, 1 );
    end;

-- Handle OnUpdate event
    function TaskHandlerLib.OnUpdate( self, elapsed )
        -- Make sure self is known as TaskHandlerLib
        local self = TaskHandlerLib;

        -- Get current state of the game
        local fps = GetFramerate();
        local _, _, lag = GetNetStats();

        -- Determine interval to be used
        local interval = self.interval;

        -- Increase interval by 25% if FPS drops below self.fps
        if ( fps < self.fps ) then interval = interval * 1.50; end;

        -- Increase interval by 25% if lag rises above self.lag
        if ( lag > self.lag ) then interval = interval * 1.50; end;

        -- Time since last (handled) update
        self.lastupdate = self.lastupdate + elapsed;

        if ( #self.tasks > 0 ) then
            if ( self.lastupdate > interval ) then
                -- Process a task
                self:ProcessTask();

                -- Reset lastupdate
                self.lastupdate = 0;
            end;

        else
            -- Reset lastupdate
            self.lastupdate = 0;
        end;
    end;

-- Handle OnEvent event
    function TaskHandlerLib.OnEvent( self, event )
        -- Make sure self is known as TaskHandlerLib
        local self = TaskHandlerLib;

        -- Handle PLAYER_ENTERING_WORLD event
        if ( event == "PLAYER_ENTERING_WORLD" ) then
            self.lastupdate = GetTime();
            self.active = true;
        end;
    end;

-- Load the TaskHandlerLib library
    TaskHandlerLib:Init();
