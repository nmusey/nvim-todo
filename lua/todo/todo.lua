local M = {}

local json = require('todo.json')

local TODO_FILE = os.getenv("HOME") .. "/.local/nvim_todo.json"
local todo = {}

function M.load_todo()
    local f = io.open(TODO_FILE, "r")
    if f then
        local content = f:read("*a")
        f:close()
        if content and #content > 0 then
            local ok, data = pcall(json.decode, content)
            if ok and type(data) == "table" then
                todo = data
            end
        end
    end
end

function M.save_todo()
    local f = io.open(TODO_FILE, "w")
    if f then
        f:write(json.encode(todo))
        f:close()
    end
end

function M.add_task(task_text)
    if not task_text or #task_text == 0 then
        print("Invalid input. Please enter a valid task.")
        return
    end
    
    for _, task in ipairs(todo) do
        if task.text == task_text then
            print("Task already exists.")
            return
        end
    end
    
    table.insert(todo, {
        text = task_text,
        completed = false,
        priority = 1,
        created_at = os.time()
    })
   M.save_todo()
    print("Task added: " .. task_text)
end

function M.view_todo_list()
    if #todo == 0 then
        print("No tasks in todo list.")
        return
    end
    
    table.sort(todo, function(a, b)
        if a.priority ~= b.priority then
            return a.priority > b.priority
        end
        return a.created_at < b.created_at
    end)
    
    for i, task in ipairs(todo) do
        local status = task.completed and "[✓]" or "[ ]"
        local priority = string.rep("!", task.priority)
        print(string.format("%d. %s %s %s", i, status, task.text, priority))
    end
end

function M.finish_task(task_id)
    task_id = tonumber(task_id)
    if not task_id or task_id < 1 or task_id > #todo then
        print("Invalid task ID.")
        return
    end
    
    todo[task_id].completed = true
   M.save_todo()
    print("Task marked as completed: " .. todo[task_id].text)
end

function M.delete_task(task_id)
    task_id = tonumber(task_id)
    if not task_id or task_id < 1 or task_id > #todo then
        print("Invalid task ID.")
        return
    end
    
    local deleted_task = todo[task_id].text
    table.remove(todo, task_id)
   M.save_todo()
    print("Task deleted: " .. deleted_task)
end

function M.edit_task(task_id, new_text)
    task_id = tonumber(task_id)
    if not task_id or task_id < 1 or task_id > #todo then
        print("Invalid task ID.")
        return
    end
    
    if not new_text or #new_text == 0 then
        print("Invalid input. Please enter valid task text.")
        return
    end
    
    local old_text = todo[task_id].text
    todo[task_id].text = new_text
   M.save_todo()
    print(string.format("Task edited: '%s' -> '%s'", old_text, new_text))
end

function M.prioritize_task(task_id, priority)
    task_id = tonumber(task_id)
    priority = tonumber(priority)
    
    if not task_id or task_id < 1 or task_id > #todo then
        print("Invalid task ID.")
        return
    end
    
    if not priority or priority < 1 or priority > 3 then
        print("Invalid priority. Please use a number between 1 and 3.")
        return
    end
    
    todo[task_id].priority = priority
   M.save_todo()
    print(string.format("Task priority updated: %s (Priority: %d)", todo[task_id].text, priority))
end

function M.todo_menu()
    vim.api.nvim_create_user_command('TodoAdd', function(opts)
        M.add_task(opts.args)
    end, { nargs = 1, desc = 'Add a new todo task' })
    
    vim.api.nvim_create_user_command('TodoList', function()
        M.view_todo_list()
    end, { desc = 'View todo list' })
    
    vim.api.nvim_create_user_command('TodoFinish', function(opts)
        M.finish_task(opts.args)
    end, { nargs = 1, desc = 'Mark a task as completed' })
    
    vim.api.nvim_create_user_command('TodoDelete', function(opts)
        M.delete_task(opts.args)
    end, { nargs = 1, desc = 'Delete a task' })
    
    vim.api.nvim_create_user_command('TodoEdit', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args ~= 2 then
            print("Usage: TodoEdit <task_id> <new_text>")
            return
        end
        M.edit_task(args[1], args[2])
    end, { nargs = 1, desc = 'Edit a task' })
    
    vim.api.nvim_create_user_command('TodoPriority', function(opts)
        local args = vim.split(opts.args, " ", { plain = true })
        if #args ~= 2 then
            print("Usage: TodoPriority <task_id> <priority>")
            return
        end
        M.prioritize_task(args[1], args[2])
    end, { nargs = 1, desc = 'Set task priority (1-3)' })
end

function M.setup()
    M.load_todo()
    M.todo_menu()
end

return M

