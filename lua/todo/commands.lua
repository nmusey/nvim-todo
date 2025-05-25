local function register_commands()
    local todo = require('todo.todo')

    vim.api.nvim_create_user_command('TodoAdd', function(opts)
        if opts.args then
            todo.add_task(opts.args)
        else
            local task_text = vim.ui.input({ prompt = "Enter task text: " })
            if task_text and #task_text > 0 then
                todo.add_task(task_text)
            else
                print("Task text cannot be empty.")
            end
        end
    end, { nargs = "?", desc = 'Add a new todo task' })

    vim.api.nvim_create_user_command('TodoList', function()
        todo.view_todo_list()
    end, { desc = 'View the list of tasks' })

    vim.api.nvim_create_user_command('TodoFinish', function(opts)
        if opts.args then
            todo.finish_task(opts.args)
        else
            local task_id = vim.ui.input({ prompt = "Enter task ID: " })
            if task_id and #task_id > 0 then
                todo.finish_task(task_id)
            else
                print("Task ID cannot be empty.")
            end
        end
    end, { nargs = "?", desc = 'Mark a task as finished' })

    vim.api.nvim_create_user_command('TodoDelete', function(opts)
        if opts.args then
            todo.delete_task(opts.args)
        else
            local task_id = vim.ui.input({ prompt = "Enter task ID: " })
            if task_id and #task_id > 0 then
                todo.delete_task(task_id)
            else
                print("Task ID cannot be empty.")
            end
        end
    end, { nargs = "?", desc = 'Delete a task' })

    vim.api.nvim_create_user_command('TodoEdit', function(opts)
        if opts.args and #opts.args == 2 then
            todo.edit_task(opts.args[1], opts.args[2])
        else
            local args = vim.split(opts.args, " ", { plain = true })
            if #args ~= 2 then
                print("Usage: TodoEdit <task_id> <new_text>")
                return
            end
            todo.edit_task(args[1], args[2])
        end
    end, { nargs = "?", desc = 'Edit a task' })

    vim.api.nvim_create_user_command('TodoPrioritize', function(opts)
        if opts.args and #opts.args == 2 then
            todo.prioritize_task(opts.args[1], opts.args[2])
        else
            local args = vim.split(opts.args, " ", { plain = true })
            if #args ~= 2 then
                print("Usage: TodoPrioritize <task_id> <priority>")
                return
            end
            todo.prioritize_task(args[1], args[2])
        end
    end, { nargs = "?", desc = 'Set task priority (1-3)' })

    vim.api.nvim_create_user_command('TodoMenu', function()
        local choices = {
            "Add Task",
            "View List",
            "Finish Task",
            "Delete Task",
            "Edit Task",
            "Prioritize Task"
        }

        vim.ui.select(choices, { prompt = "Select an option: " }, function(choice)
            if choice == "Add Task" then
                local task_text = vim.ui.input({ prompt = "Enter task text: " })
                if task_text and #task_text > 0 then
                    todo.add_task(task_text)
                else
                    print("Task text cannot be empty.")
                end
            elseif choice == "View List" then
                todo.view_todo_list()
            elseif choice == "Finish Task" then
                local task_id = vim.ui.input({ prompt = "Enter task ID: " })
                if task_id and #task_id > 0 then
                    todo.finish_task(task_id)
                else
                    print("Task ID cannot be empty.")
                end
            elseif choice == "Delete Task" then
                local task_id = vim.ui.input({ prompt = "Enter task ID: " })
                if task_id and #task_id > 0 then
                    todo.delete_task(task_id)
                else
                    print("Task ID cannot be empty.")
                end
            elseif choice == "Edit Task" then
                local args = vim.split(opts.args, " ", { plain = true })
                if #args ~= 2 then
                    print("Usage: TodoEdit <task_id> <new_text>")
                    return
                end
                todo.edit_task(args[1], args[2])
            elseif choice == "Prioritize Task" then
                local args = vim.split(opts.args, " ", { plain = true })
                if #args ~= 2 then
                    print("Usage: TodoPriority <task_id> <priority>")
                    return
                end
                todo.prioritize_task(args[1], args[2])
            end
        end)
    end, { desc = 'Open the todo menu' })
end

return {
  register_commands = register_commands,
}
