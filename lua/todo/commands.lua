local function register_commands()
    local todo = require('todo.todo')
    vim.api.nvim_create_command('TodoAdd', todo.add_task, { desc = 'Add a new task' })
    vim.api.nvim_create_command('TodoList', todo.view_todo_list, { desc = 'View the list of tasks' })
    vim.api.nvim_create_command('TodoFinish', todo.finish_task, { desc = 'Mark a task as finished' })
    vim.api.nvim_create_command('TodoDelete', todo.delete_task, { desc = 'Delete a task' })
    vim.api.nvim_create_command('TodoEdit', todo.edit_task, { desc = 'Edit a task' })
    vim.api.nvim_create_command('TodoPrioritize', todo.prioritize_task, { desc = 'Prioritize a task' })
    vim.api.nvim_create_command('Todotodo.nu', M.todo_menu, { desc = 'Open the todo menu' })
end

return {
  register_commands = register_commands,
}
