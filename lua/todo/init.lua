local M = {}

M.setup = function()
    require('todo.commands').register_commands()
    require('todo.todo').load_todo()
end

return M {
    setup = M.setup,
}
