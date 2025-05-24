local json = require('nvim_todo.json')

local todo_file = os.getenv("HOME") .. "/.local/nvim_todo.json"
local todo = {}

local function load_todo()
  local f = io.open(todo_file, "r")
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

local function save_todo()
  local f = io.open(todo_file, "w")
  if f then
    f:write(json.encode(todo))
    f:close()
  end
end

local function add_task(task_text)
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
  table.insert(todo, { text = task_text, completed = false, priority = 1, marked = false })
  save_todo()
  print("Task added: " .. task_text)
end

local function view_todo_list()
  if #todo == 0 then
    print("No tasks in todo list.")
    return
  end
  for i, task in ipairs(todo) do
    print(string.format("%d. %s [Completed: %s] [Priority: %s] [Marked: %s]", i, task.text, tostring(task.completed), tostring(task.priority), tostring(task.marked)))
  end
end

local function finish_task(idx)
  idx = tonumber(idx)
  if not idx or not todo[idx] then
    print("Invalid task number.")
    return
  end
  todo[idx].completed = true
  save_todo()
  print("Task marked as completed: " .. todo[idx].text)
end

local function delete_task(idx)
  idx = tonumber(idx)
  if not idx or not todo[idx] then
    print("Invalid task number.")
    return
  end
  local removed = table.remove(todo, idx)
  save_todo()
  print("Task deleted: " .. removed.text)
end

local function edit_task(idx, ...)
  idx = tonumber(idx)
  local new_text = table.concat({...}, " ")
  if not idx or not todo[idx] or new_text == "" then
    print("Invalid usage. Usage: :TodoEdit {number} {new text}")
    return
  end
  todo[idx].text = new_text
  save_todo()
  print("Task updated: " .. new_text)
end

local function prioritize_task(idx, priority)
  idx = tonumber(idx)
  priority = tonumber(priority)
  if not idx or not todo[idx] or not priority then
    print("Invalid usage. Usage: :TodoPriority {number} {priority}")
    return
  end
  todo[idx].priority = priority
  save_todo()
  print(string.format("Task %d priority set to %d", idx, priority))
end

local function todo_menu()
  local menu_lines = {
    'TODO MAIN MENU',
    '',
    '[a] Add Task',
    '[l] List Tasks',
    '[f] Finish Task',
    '[d] Delete Task',
    '[e] Edit Task',
    '[p] Prioritize Task',
    '[q] Quit Menu',
    '',
    'Press the corresponding key...'
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu_lines)
  local width = 40
  local height = #menu_lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })
  local function close_menu()
    vim.api.nvim_win_close(win, true)
  end
  local function prompt_and_run(prompt, callback)
    vim.ui.input({ prompt = prompt }, function(input)
      if input then callback(input) end
      close_menu()
    end)
  end
  local function prompt_and_run2(prompt, prompt2, callback)
    vim.ui.input({ prompt = prompt }, function(input1)
      if input1 then
        vim.ui.input({ prompt = prompt2 }, function(input2)
          if input2 then callback(input1, input2) end
          close_menu()
        end)
      else
        close_menu()
      end
    end)
  end
  local keymap = {
    a = function() prompt_and_run('Task to add: ', add_task) end,
    l = function() close_menu() view_todo_list() end,
    f = function() prompt_and_run('Task number to finish: ', finish_task) end,
    d = function() prompt_and_run('Task number to delete: ', delete_task) end,
    e = function() prompt_and_run2('Task number to edit: ', 'New text: ', edit_task) end,
    p = function() prompt_and_run2('Task number to prioritize: ', 'New priority: ', prioritize_task) end,
    q = close_menu,
  }
  for k, fn in pairs(keymap) do
    vim.keymap.set('n', k, fn, { buffer = buf, nowait = true, silent = true })
  end
  vim.keymap.set('n', '<Esc>', close_menu, { buffer = buf, nowait = true, silent = true })
end

-- Load todo list on startup
load_todo()

-- Neovim user commands
vim.api.nvim_create_user_command('TodoAdd', function(opts)
  add_task(opts.args)
end, { nargs = 1, desc = 'Add a new todo task' })

vim.api.nvim_create_user_command('TodoList', function()
  view_todo_list()
end, { desc = 'View the todo list' })

vim.api.nvim_create_user_command('TodoDone', function(opts)
  finish_task(opts.args)
end, { nargs = 1, desc = 'Mark a task as completed' })

vim.api.nvim_create_user_command('TodoDelete', function(opts)
  delete_task(opts.args)
end, { nargs = 1, desc = 'Delete a task' })

vim.api.nvim_create_user_command('TodoEdit', function(opts)
  local args = {}
  for word in string.gmatch(opts.args, "[^ ]+") do
    table.insert(args, word)
  end
  local idx = table.remove(args, 1)
  edit_task(idx, unpack(args))
end, { nargs = "+", desc = 'Edit a task text' })

vim.api.nvim_create_user_command('TodoPriority', function(opts)
  local args = {}
  for word in string.gmatch(opts.args, "[^ ]+") do
    table.insert(args, word)
  end
  local idx = args[1]
  local priority = args[2]
  prioritize_task(idx, priority)
end, { nargs = "+", desc = 'Set a task priority' })

vim.api.nvim_create_user_command('TodoMenu', function()
  todo_menu()
end, { desc = 'Open the Todo main menu' })

-- Example usage:
-- add_task("Test task")
-- view_todo_list()