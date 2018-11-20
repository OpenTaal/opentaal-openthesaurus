# Installation OpenThesarus

Installation, build and deploy instructions for Ubuntu 18.04 LTS.


# 1 Build on development machine

Log onto the development machine


# 1.1 Install Java

Install system-wide.

    sudo apt-get install openjdk-8-jdk-headless


## 1.2 Install Grails with SDKMAN

Install for current user.

    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install grails 3.3.1


## 1.3 Download OpenThesaurus

    cd ~/workspace
    wget https://github.com/danielnaber/openthesaurus/archive/master.zip
    unzip master.zip
    rm -f master.zip


## 1.4 Build WAR file

QUESTION 1: Should the database connector be added before the grails step?

    cd openthesaurus-master
    vi grails-app/conf/application.yml build/resources/main/application.yml

Search for `org.mariadb.jdbc.Driver` and replace with `com.mysql.jdbc.Driver` (Note that there is no `db` after `mysql` and it is `com` instead of `org`.)

Search for `username: vionto` and replace with `username: openthesaurus`

Search for `password: vionto` and replace with `password: ******`

Search for `url: jdbc:mariadb://127.0.0.1:3306/viontoDevDb` and replace with `url: jdbc:mysql://127.0.0.1:3306/openthesaurus` (Note that there is no `db` after `mysql`.)

Search for `url: jdbc:h2:./prodDb` and replace with `url: jdbc:h2:./openthesaurus`

QUESTION 2: Does this remove the need for datasource.properties later on?

    grails war

Copy the WAR file to the deployment machine

    scp `ls build/libs/openthesaurus-*.war|sort -n|tail -1` thehostname:/tmp


# 2 Installation on deployment machine

Log onto the deployment machine

## 2.1 Create database

This assumes you already have MySQL running.

    mysql -u root -p
    ******
    create database openthesaurus;
    create user 'openthesaurus'@'localhost' identified by '******';
    grant all privileges on openthesaurus.* to 'openthesaurus'@'localhost';
    exit

Test database with

    mysql -D openthesaurus -u openthesaurus -p
    ******
    show tables;
    exit

should report on an empty set of tables.


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

Extract the war file

    sudo unzip -d /var/lib/tomcat8/webapps/ROOT/ `ls /tmp/openthesaurus-*.war|sort -n|tail -1`

Add database access

    sudo vi /var/lib/tomcat8/webapps/ROOT/WEB-INF/classes/datasource.properties

and add

    dataSource.url=jdbc:mysql://127.0.0.1:3306/openthesaurus?useUnicode=true&characterEncoding=utf-8
    dataSource.driverClassName=com.mysql.jdbc.Driver
    dataSource.username=openthesaurus
    dataSource.password=******
    dataSource.dbCreate=update


## 2.4 Install database connector 

Get download link for Ubuntu 18.04 from https://dev.mysql.com/downloads/connector/j/

    cd /tmp
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.13-1ubuntu18.04_all.deb
    dpkg -x mysql-connector-java_8.0.13-1ubuntu18.04_all.deb .
    sudo cp usr/share/java/mysql-connector-java-8.0.13.jar /var/lib/tomcat8/webapps/ROOT/WEB-INF/lib/

QUESTION 3: The package libmysql-java has a file called /usr/share/java/mysql-connector-java-5.1.45.jar Is that also fine the use?


## 2.5 Restart Tomcat

In another terminal, monitor the log file with

    sudo tail -f /var/log/tomcat8/cataline.out

Restart Tomcat

    sudo service tomcat8 restart


