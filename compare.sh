if [ `basename $PWD` != 'opentaal-openthesaurus' ]; then
	echo 'ERROR: Start this script from the directory opentaal-openthesaurus'
	echo 'See https://github.com/OpenTaal/opentaal-openthesaurus'
	exit 1
fi

if [ ! -e ../openthesaurus ]; then
	echo 'ERROR: Missing desitination directory ../openthesaurus'
	echo 'See https://github.com/danielnaber/openthesaurus'
	exit 1
fi

diff -Nup ../openthesaurus/grails-app/conf/application.yml conf/application.yml
diff -Nup ../openthesaurus/grails-app/conf/application-development.properties conf/application-development.properties
diff -Nup ../openthesaurus/grails-app/conf/application-production.properties conf/application-production.properties

# note that only one of the next files has _nl
diff -Nup ../openthesaurus/grails-app/i18n/messages_nl.properties \
i18n/messages.properties
