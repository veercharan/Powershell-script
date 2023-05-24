function main {
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

function searchUser {
    $username = Read-Host "Please enter a username to search for: "
    $found = $users | Where-Object { $_.Name -eq $username }
    if ($found) {
        Write-Host "The user was found"
        userInfo -username $username
    } else {
        Write-Host "The user was not found"
    }
}

function createGroup {
    $groupName = Read-Host "Please enter a group name: "
    New-LocalGroup -Name $groupName
    Write-Host "The group has been created"
}

function usertoGroup {
    $groups = Get-LocalGroup
    Write-Host "The local groups on the machine are: "
    $groups | Format-Table -AutoSize | Write-Output
    $groupName = Read-Host "Please enter a group name to add a user to: "
    $users = Get-LocalUser
    Write-Host "The local users on the machine are: "
    $users | Format-Table -AutoSize | Write-Output
    $user1 = Read-Host "Please enter a username to add to the group: "
    Add-LocalGroupMember -Group $groupName -Member $user1
    Write-Host "The user has been added to the group"
}

function removeUser {
    $groups = Get-LocalGroup
    Write-Host "The local groups on the machine are: "
    $groups | Format-Table -AutoSize | Write-Output
    $groupName = Read-Host "Please enter a group name to remove a user from: "
    Write-Host "The local users in the group are: "
    net localgroup $groupName
    $user = Read-Host "Please enter a username to remove from the group: "
    Remove-LocalGroupMember -Group $groupName -Member $user
    Write-Host "The user has been removed from the group"
}

function createUser {
    $username = Read-Host "Please enter a username: "
    $fullname = Read-Host "Please enter the full name of the user: "
    $password = Read-Host "Please enter a password: "
    New-LocalUser -Name $username -FullName $fullname -Password (ConvertTo-SecureString $password -AsPlainText -Force)
    Write-Host "The user $username has been created"
}

function userInfo($username) {
    Get-LocalUser -Name $username
    $fullname = Get-LocalUser -Name $username | Select-Object -ExpandProperty FullName
    Write-Host "The user's full name is: $fullname"
}

function PrintMan {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "| Welcome to the Assignment 4 PowerShell Script |" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "This script will print out all the local users on the machine"
    Write-Host "Then it will prompt the user to enter a username"
    Write-Host "It will take that username and search for it in the list of local users"
    Write-Host "If the user is found, it will print out the username and more information about the user"
    Write-Host "If the user is not found, it will print out a message saying that the user was not found"
    Write-Host ""
}

function usage {
    Write-Host "Usage: Assignment4.ps1 [help]" -ForegroundColor Green
    Write-Host "help: Prints this message"  -ForegroundColor Green
    Write-Host ""
}

# Entry point of the script
param (
    [string] $param1,
    [string] $param2,
    [string] $param3
)

if ($param1 -eq "help") {
    PrintMan
    usage
    Exit 0
} else {
    PrintMan
}

main
