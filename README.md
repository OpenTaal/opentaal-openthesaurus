# Installation OpenThesarus

Installation, build and deploy instructions for Ubuntu 18.04 LTS.


# 1 Build on development machine

Log onto the development machine.


# 1.1 Install Java

Install system-wide.

    sudo apt-get install openjdk-8-jdk-headless


## 1.2 Install Grails with SDKMAN

Install for current user.

    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install grails 3.3.1


## 1.3 Download OpenThesaurus

Navigate to a directory to perform the configuration and build.

    cd ~/workspace/

If previously, a `git clone` was done, do the following to update the repo.

    cd openthesaurus/
    git checkout .
    git pull -r

Note that this will undo all custom configuration!

Otherwise, clone the repo.

    git clone https://github.com/danielnaber/openthesaurus.git
    cd openthesaurus/


## 1.4 Apply custom configuration

Compare the shipped configuration files with the custom configuration files by
running the following.

    cd ../opentaal-openthesaurus/
    ./compare.sh
    more customize.sh

Set the database and email user password in a file that is excluded by version
control.

    vi password

If no more changes need to be made, apply the custom configurtation.

    ./customize.sh
    cd ../openthesaurus/


## 1.5 Build WAR file

Do the actual build.

    grails war

Copy the WAR file to the deployment machine.

    scp `ls build/libs/openthesaurus-*.war|sort -n|tail -1` thehostname:/tmp


# 2 Installation on deployment machine

Log onto the deployment machine with SSH.

## 2.1 Create database

If needed, install MySQL.

    sudo apt-get install mysql-server

Create databsae and user.

    mysql -u root -p
    ******
    create database openthesaurus;
    create user 'openthesaurus'@'localhost' identified by '******';
    grant all privileges on openthesaurus.* to 'openthesaurus'@'localhost';
    exit

Test database and user. This should report an empty set of tables.

    mysql -D openthesaurus -u openthesaurus -p
    ******
    show tables;
    exit


## 2.2 Create email account

If needed, install an email service, snmp, such as postfix. Also install a way
to easily test this, e.g. mailutils.

    sudo apt-get install postfix mailutils

Create user for email account.

    sudo adduser openthesaurus


## 2.3 Install Tomcat

Assuming, Tomcat is not yet installed.

    sudo apt-get install tomcat8

Note that any dependencies such as openjdk-8-jre-headless will be installed
automatically. Test page should appear on http://thehostname:8080/

Ony if realy needed, add an existing user to the Tomcat group

    sudo vi /etc/group

and add the username after the line with `tomcat8:x:`


## 2.4 Deploy on Tomcat

Remove the contents of Tomcat's `ROOT` directory

    sudo rm -rf /var/lib/tomcat8/webapps/ROOT/*

Extract the war file.

    sudo unzip -d /var/lib/tomcat8/webapps/ROOT/ `ls /tmp/openthesaurus-*.war|sort -n|tail -1`

Note that no extra configuration is needed, even though some old documentation might suggest that.


## 2.5 Restart Tomcat

In another terminal, monitor the log file.

    sudo tail -f /var/log/tomcat8/catalina.out

Restart Tomcat.

    sudo service tomcat8 restart


## 2.6 Create in-memory database

Create in-memory database, otherwise the website will result directly in errors.

    curl -I http://localhost:8080/synset/createMemoryDatabase


## 2.7 Visit the website

Visit the instance of OpenThesaurus which is at http://thehostname:8080/


# 3 Downloading newer database connector

This repository contains the proper database connections. When a new version
needs to be downloaded, go to https://dev.mysql.com/downloads/connector/j/ to
get the latest download link to get the proper package. Then do the following.

    cd /tmp
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.13-1ubuntu18.04_all.deb
    dpkg -x mysql-connector-java_8.0.13-1ubuntu18.04_all.deb .
    cp usr/share/java/mysql-connector-java-8.0.13.jar ~/workspace/opentaal-openthesaurus/1804/

For Ubuntu 18.10, download via https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.13-1ubuntu18.10_all.deb and copy the JAR file to
~/workspace/opentaal-openthesaurus/1804/

Note that installation of the database connection via a package from the
operating system will not be available for Tomcat.
