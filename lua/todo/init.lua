local M = {}

M.setup = function()
    require('todo.commands').register_commands()
    require('todo.todo').load_todo()
end

M.setup()
return M 
