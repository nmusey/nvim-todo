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
    todo[task_id].completed = true
   M.save_todo()
    print("Task marked as completed: " .. todo[task_id].text)
end

function M.delete_task(task_id)
    local deleted_task = todo[task_id].text
    table.remove(todo, task_id)
   M.save_todo()
    print("Task deleted: " .. deleted_task)
end

function M.edit_task(task_id, new_text)
    local old_text = todo[task_id].text
    todo[task_id].text = new_text
   M.save_todo()
    print(string.format("Task edited: '%s' -> '%s'", old_text, new_text))
end

function M.prioritize_task(task_id, priority)
    todo[task_id].priority = tonumber(priority)
   M.save_todo()
    print(string.format("Task priority updated: %s (Priority: %d)", todo[task_id].text, tonumber(priority)))
end

return M
