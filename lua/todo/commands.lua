local function register_commands()
    local todo = require('todo.todo')

    vim.api.nvim_create_user_command('TodoAdd', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args == 0 then
            print("Usage: TodoAdd <task_text>")
            return
        end
        M.add_task(table.concat(args, " "))
    end, { nargs = "*", desc = 'Add a new todo task' })

    vim.api.nvim_create_user_command('TodoList', todo.view_todo_list, { desc = 'View the list of tasks' })
    vim.api.nvim_create_user_command('TodoFinish', todo.finish_task, { desc = 'Mark a task as finished' })
    vim.api.nvim_create_user_command('TodoDelete', todo.delete_task, { desc = 'Delete a task' })
    vim.api.nvim_create_user_command('TodoEdit', todo.edit_task, { desc = 'Edit a task' })
    vim.api.nvim_create_user_command('TodoPrioritize', todo.prioritize_task, { desc = 'Prioritize a task' })
    vim.api.nvim_create_user_command('TodoMenu', todo.todo_menu, { desc = 'Open the todo menu' })
end

return {
  register_commands = register_commands,
}
