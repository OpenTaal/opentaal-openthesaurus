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

Compare the shipped configuration files with the custom configuration files.

    diff -Nup grails-app/conf/application.yml ../opentaal-openthesaurus/conf/application.yml
    diff -Nup grails-app/conf/application-development.properties ../opentaal-openthesaurus/conf/application-development.properties
    diff -Nup grails-app/conf/application-production.properties ../opentaal-openthesaurus/conf/application-production.properties
    diff -Nup grails-app/i18n/messages_nl.properties ../opentaal-openthesaurus/i18n/messages.properties

Note that the last filename is without `_nl` and needs to be as such.

If no changes need to be made to the custom configuration files, copy these to overwrite the default configuration.

    cp -f ../opentaal-openthesaurus/conf/* grails-app/conf/
    cp -f ../opentaal-openthesaurus/i18n/* grails-app/i18n/

Set the email user and database user password where `******` is found.

    vi grails-app/conf/application.yml

(TODO Set sender email address in messages.properties.)

Add the database connector.

    cp -f ../opentaal-openthesaurus/1804/mysql-connector-java-8.0.13.jar lib/

Note that installation of the database connection via a package from the operating system will not be available for Tomcat.

This file was retrieved for Ubuntu 18.04 from https://dev.mysql.com/downloads/connector/j/ by doing the following. These steps are only needed when getting a newer version of the database adapter! **Hence, skip the following.**

    cd /tmp
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.13-1ubuntu18.04_all.deb
    dpkg -x mysql-connector-java_8.0.13-1ubuntu18.04_all.deb .
    cp usr/share/java/mysql-connector-java-8.0.13.jar ~/workspace/opentaal-openthesaurus/1804/
    cd ~/workspace/opentaal-openthesaurus/

(For Ubuntu 18.10, download via https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.13-1ubuntu18.10_all.deb or directly use `../opentaal-openthesaurus/1810/mysql-connector-java-8.0.13.jar` from this repository.)


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


## 2.2 Install Tomcat

Assuming, Tomcat is not yet installed.

    sudo apt-get install tomcat8

Test page should appear on http://thehostname:8080/

Ony if realy needed, add an existing user to the Tomcat group

    sudo vi /etc/group

and add the username after the line with `tomcat8:x:`


## 2.3 Deploy on Tomcat

Remove the contents of Tomcat's `ROOT` directory

    sudo rm -rf /var/lib/tomcat8/webapps/ROOT/*

Extract the war file.

    sudo unzip -d /var/lib/tomcat8/webapps/ROOT/ `ls /tmp/openthesaurus-*.war|sort -n|tail -1`

Note that no extra configuration is needed, even though some old documentation might suggest that.


## 2.4 Restart Tomcat

In another terminal, monitor the log file.

    sudo tail -f /var/log/tomcat8/catalina.out

Restart Tomcat.

    sudo service tomcat8 restart


## 2.5 Create in-memory database

Create in-memory database, otherwise the website will result directly in errors.

    curl -I http://localhost:8080/synset/createMemoryDatabase


## 2.6 Visit the website

Visit the instance of OpenThesaurus which is at http://thehostname:8080/
