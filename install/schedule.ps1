# Define task details
$taskName = "IvaAutoPoliteness (morning)"
$scriptPath = "$env:ProgramFiles\main.py"
$triggerTime = "09:00"  # Start time
$daysOfWeek = "Monday, Tuesday, Wednesday, Thursday, Friday"

# Create a new trigger
$trigger = New-ScheduledTaskTrigger -Daily -At $triggerTime -DaysOfWeek $daysOfWeek

# Create an action to run the script
$action = New-ScheduledTaskAction -Execute "python.exe" -Argument "`"$scriptPath`""

# Register the task
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -User "SYSTEM" -RunLevel Highest

Write-Host "Task '$taskName' created successfully!"