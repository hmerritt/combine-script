
function List_files
{
    setenv
    ls ${list_dir}
}

function Sensitive_task
{
    setenv

    confirm_continue

    success "Success. Sensitive task is good to go!"
}
