#!/bin/bash


makeDB(){
# DBname DBowner DBpassword
    mysql_command="CREATE DATABASE IF NOT EXISTS $1; GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost' IDENTIFIED BY '$3'; GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%' IDENTIFIED BY '$3';"
    echo "MySQL DB Command is: ""$mysql_command" 
    sleep 3
    mysql -u "$2" -p"$3" -e "$mysql_command"
}

GeneratePassWord(){
    # Define the length of the password
    length=12

    # Generate a random password using /dev/urandom
    echo "(tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' < /dev/urandom | head -c $length)"
}

