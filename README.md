# opentaal-openthesaurus
OpenTaal's installation of OpenThesaurus

# Installation OpenThesarus

Installation, build and deploy instructions for Ubuntu 18.04 LTS.


# 1 On build or development machine


# 1.1 Install Java

Install for complete system.

    sudo apt-get install openjdk-8-jdk-headless


## 1.2 Install Grails with SDKMAN

Install for normal user.

    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install grails 3.3.1

See also https://sdkman.io/install


## 1.3 Download OpenThesaurus

    cd ~/workspace
    wget https://github.com/danielnaber/openthesaurus/archive/master.zip
    unzip master.zip
    rm -f master.zip
    mv openthesaurus-master/ openthesaurus


### 3.2 Build WAR file

    cd openthesaurus
    grails war

TODO


# 2 On development or deployment machine


## 2.1 Create database

This assumes you already have MySQL running.

    mysql -u root -p
    ******
    create database openthesaurus;
    create user 'openthesaurus'@'localhost' identified by '******';
    grant all privileges on openthesaurus.* to 'openthesaurus'@'localhost';





## 2.1 Install Tomcar

    sudoapt-get install tomcat8


