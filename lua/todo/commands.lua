local function register_commands()
    local todo = require('todo.todo')

    vim.api.nvim_create_user_command('TodoAdd', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args == 0 then
            print("Usage: TodoAdd <task_text>")
            return
        end
        todo.add_task(table.concat(args, " "))
    end, { nargs = "*", desc = 'Add a new todo task' })

    vim.api.nvim_create_user_command('TodoList', function()
        todo.view_todo_list()
    end, { desc = 'View the list of tasks' })

    vim.api.nvim_create_user_command('TodoFinish', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args == 0 then
            print("Usage: TodoFinish <task_id>")
            return
        end
        todo.finish_task(args[1])
    end, { nargs = "*", desc = 'Mark a task as finished' })

    vim.api.nvim_create_user_command('TodoDelete', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args == 0 then
            print("Usage: TodoDelete <task_id>")
            return
        end
        todo.delete_task(args[1])
    end, { nargs = "*", desc = 'Delete a task' })

    vim.api.nvim_create_user_command('TodoEdit', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args == 0 then
            print("Usage: TodoEdit <task_id> <new_task_text>")
            return
        end
        todo.edit_task(args[1], table.concat(args, " ", 2))
    end, { nargs = "*", desc = 'Edit a task' })

    vim.api.nvim_create_user_command('TodoPrioritize', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args == 0 then
            print("Usage: TodoPrioritize <task_id> <priority_level>")
            return
        end
        todo.prioritize_task(args[1], args[2])
    end, { nargs = "*", desc = 'Prioritize a task' })

    vim.api.nvim_create_user_command('TodoMenu', function()
        todo.todo_menu()
    end, { desc = 'Open the todo menu' })
end

return {
  register_commands = register_commands,
}
