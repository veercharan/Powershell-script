param (
    [string] $param1,
    [String] $param2,
    [string] $param3
)

function main {
    Write-Host
    $ExecutionPolicy = Get-ExecutionPolicy
    Write-Host Your PowerShell Script Execution Policy is set to $ExecutionPolicy -ForegroundColor Yellow -BackgroundColor Black
    Write-Host
    if ($param1 -eq "help") {
        PrintMan
        usage
        Exit 0
    }
    else {
        PrintMan
    }
    Write-Host "The local users on the machine are: "
    $users = Get-LocalUser
    $users | Format-Table -AutoSize | Write-Output
    $choice = 0
    while ($choice -ne 6) {
        Write-Host "Please enter a number to choose an option: "
        Write-Host "1. Search for a user"
        Write-Host "2. Create a local group"
        Write-Host "3. Add user to a local group"
        Write-Host "4. Remove a user from a local group"
        Write-Host "5. Create a new user"
        Write-Host "6. Exit"
        $choice = Read-Host "Please enter a number: "
        switch ($choice) {
            1 {searchUser}
            2 {createGroup}
            3 {usertoGroup}
            4 {removeUser}
            5 {createUser}
            6 {exit}
            default {Write-Host "Invalid input"}
        }
    }
}
function searchUser
{
    #This will prompt the user to enter a user name
    $username = Read-Host "Please enter a user name to search for: "
    
    #This will search for the user name in the list of local users
    $found = $users | Where-Object {$_.Name -eq $username}
    
    #If the user is found, it will print out the user name and more information about the user
    if ($found) {
        Write-Host "The user was found"
        Write-Host "The user name is: " $username
        userInfo -username $username        
    } 
    #If the user is not found, it will print out a message saying that the user was not found
    else 
    {
        Write-Host
        Write-Host "The user was not found"
        Write-Host
    } 

}
function createGroup 
{
    $groupName = Read-Host "Please enter a group name: "
    New-LocalGroup -Name $groupName
    Write-Host "The group has been created"
    Write-Host ""
}

function usertoGroup {
    Write-Host "The local groups on the machine are: "
    $groups = Get-LocalGroup
    $groups | Format-Table -AutoSize | Write-Output
    Write-Host ""
    $groupName = Read-Host "Please enter a group name to add a user to: "
    $users = Get-LocalUser
    Write-Host "The local users on the machine are: "
    $users | Format-Table -AutoSize | Write-Output
    Write-Host ""
    $user1 = Read-Host "Please enter a user name to add to the group: "
    Add-LocalGroupMember -Group $groupName -Member $User1
    Write-Host "The user has been added to the group"
    Write-Host ""
    net localgroup $groupName
    Write-Host ""
}

function removeUser
{
    Write-Host "The local groups on the machine are: "
    $groups = Get-LocalGroup
    $groups | Format-Table -AutoSize | Write-Output
    Write-Host ""
    $groupName = Read-Host "Please enter a group name to remove a user from: "
    Write-Host "The local users in the group are: "
    net localgroup $groupName
    Write-Host ""
    $user = Read-Host "Please enter a user name to remove from the group: "
    Remove-LocalGroupMember -Group $groupName -Member $user
    Write-Host "The user has been removed from the group"
}

function createUser {
    $username = Read-Host "Please enter a username: "
    $fullname = Read-Host "Please enter the full name of the user: "
    $password = Read-Host "Please enter a password: "
    New-LocalUser -Name $username -FullName $fullname -Password (ConvertTo-SecureString $password -AsPlainText -Force)
    Write-Host "The user $username has been created"
    Write-Host ""
}

function userInfo ($username) 
{
    Get-LocalUser -Name $username
    #This will print out the user's full name
    $fullname = Get-LocalUser -Name $username | Select-Object -ExpandProperty FullName
    Write-Host "The user's full name is: " $fullname
    #This will print out the user's last password set date
    $lastpasswordset = Get-LocalUser -Name $username | Select-Object -ExpandProperty PasswordLastSet
    Write-Host "The user's last password set date is: " $lastpasswordset
    Write-Host ""
}

function PrintMan
{
    Write-Host""
    Write-Host "       ===============================================" -ForegroundColor Green
    Write-Host "      | Welcome to the Assignment 4 PowerShell Script |" -ForegroundColor Green
    Write-Host "       ===============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "This script will print out all the local users on the machine"
    Write-Host "Then will prompt the user to enter a user name"
    Write-Host "It will take that username and search for it in the list of local users"
    Write-Host "If the user is found, it will print out the user name and more information about the user"
    Write-Host "If the user is not found, it will print out a message saying that the user was not found"
    Write-Host ""

}
function usage
{
    Write-Host "Usage: Assignment4.ps1 [help]" -ForegroundColor Green
    Write-Host "help: Prints this message"  -ForegroundColor Green
    Write-Host ""
}

main
