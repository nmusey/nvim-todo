local function add_task(task_text)
  -- Check if the task is already in the list
  local task_found = false
  for _, task in pairs(todo) do
    if task.text == task_text then
      task_found = true
      -- Add the task to the list
      task.completed = true
      return
  end
  -- Add the task to the list
  task = {
    text = task_text,
    completed = false,
    -- Add other relevant data (e.g., priority, due date)
  }
  todo: add_task(task)
end

local function view_task(task)
  -- Display the task details
  print("Task: " .. task.text)
  print("Completed: " .. task.completed)
  print("Priority: " .. task.priority)
end

local function mark_task(task, mark)
  -- Mark the task as complete
  task.completed = true
  task.marked = true
  -- Update the todo list
  todo: mark_task(task, mark)
end

-- Function to display the todo list
local function display_todo_list()
  -- Clear the existing todo list
  todo: clear_todo()

  -- Display the list
  for _, task in pairs(todo) do
    print("Task: " .. task.text)
    print("Completed: " .. task.completed)
    print("Priority: " .. task.priority)
    print("Marked: " .. task.marked)
  end
end

-- Function to add a new task
local function add_new_task(task_text)
  add_task(task_text)
end

-- Function to mark a task as complete
local function mark_task(task, mark)
  mark_task(task, mark)
end

-- Function to clear the todo list
local function clear_todo()
  todo: clear_todo()
end

-- Example usage (you'll need to call these from your Neovim configuration)
--  You can add a command to run these functions when you press a key.
