local todo = require('todo.todo')

local function add_task_prompt()
    vim.ui.input({ prompt = "Enter task text: " }, function(text) 
        if text and #text > 0 then
            todo.add_task(text)
        else
            print("Task text cannot be empty.")
        end
    end)
end

local function finish_task_prompt()
    vim.ui.input({ prompt = "Enter task ID: " }, function (task_id) 
        if task_id and #task_id > 0 then
            todo.finish_task(task_id)
        else
            print("Task ID cannot be empty.")
        end
    end)
end

local function delete_task_prompt()
    vim.ui.input({ prompt = "Enter task ID: " }, function (task_id)
        if task_id and #task_id > 0 then
            todo.delete_task(task_id)
        else
            print("Task ID cannot be empty.")
        end
    end)
end

local function edit_task_prompt()
    local args = vim.split(opts.args, " ", { plain = true })
    if #args ~= 2 then
        print("Usage: TodoEdit <task_id> <new_text>")
        return
    end
    todo.edit_task(args[1], args[2])
end

local function prioritize_task_prompt()
    local args = vim.split(opts.args, " ", { plain = true })
    if #args ~= 2 then
        print("Usage: TodoPrioritize <task_id> <priority>")
        return
    end
    todo.prioritize_task(args[1], args[2])
end

local function register_commands()
    vim.api.nvim_create_user_command('TodoAdd', function(opts)
        if opts.args and #opts.args > 0 then
            todo.add_task(opts.args)
        else
            add_task_prompt()
        end
    end, { nargs = "?", desc = 'Add a new todo task' })

    vim.api.nvim_create_user_command('TodoList', function()
        todo.view_todo_list()
    end, { desc = 'View the list of tasks' })

    vim.api.nvim_create_user_command('TodoFinish', function(opts)
        if opts.args and #opts.args > 0 then
            todo.finish_task(opts.args)
        else
            finish_task_prompt()
        end
    end, { nargs = "?", desc = 'Mark a task as finished' })

    vim.api.nvim_create_user_command('TodoDelete', function(opts)
        if opts.args and #opts.args > 0 then
            todo.delete_task(opts.args)
        else
            delete_task_prompt()
        end
    end, { nargs = "?", desc = 'Delete a task' })

    vim.api.nvim_create_user_command('TodoEdit', function(opts)
        if opts.args and #opts.args == 2 then
            todo.edit_task(opts.args[1], opts.args[2])
        else
            edit_task_prompt()
        end
    end, { nargs = "?", desc = 'Edit a task' })

    vim.api.nvim_create_user_command('TodoPrioritize', function(opts)
        if opts.args and #opts.args == 2 then
            todo.prioritize_task(opts.args[1], opts.args[2])
        else
            prioritize_task_prompt()
        end
    end, { nargs = "?", desc = 'Set task priority (1-3)' })

    vim.api.nvim_create_user_command('TodoMenu', function()
        local choices = {
            ["Add Task"] = add_task_prompt,
            ["View List"] = todo.view_todo_list,
            ["Finish Task"] = finish_task_prompt,
            ["Delete Task"] = delete_task_prompt,
            ["Edit Task"] = edit_task_prompt,
            ["Prioritize Task"] = prioritize_task_prompt
        }

        vim.ui.select(choices, { prompt = "Select an option: " }, function(choice)
            if choice then
                tasks_dict[choice]()
            end
        end)
    end, { desc = 'Open the todo menu' })
end

return {
  register_commands = register_commands,
}
