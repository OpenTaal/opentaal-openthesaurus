if [ `basename $PWD` != 'opentaal-openthesaurus' ]; then
	echo 'ERROR: Start this script from the directory opentaal-openthesaurus'
	echo 'See https://github.com/OpenTaal/opentaal-openthesaurus'
	exit 1
fi

if [ ! -e ../opentaal-artwork ]; then
	echo 'ERROR: Missing artwork directory ../opentaal-artwork'
	echo 'See https://github.com/OpenTaal/opentaal-artwork'
	exit 1
fi

if [ ! -e ../openthesaurus ]; then
	echo 'ERROR: Missing desitination directory ../openthesaurus'
	echo 'See https://github.com/danielnaber/openthesaurus'
	exit 1
fi

if [ ! -e password ]; then
	echo 'ERROR: Missing file ./password containing the password'
	exit 1
fi

cp -f conf/* ../openthesaurus/grails-app/conf/
sed -i -e 's/\*\*\*\*\*\*/'`cat password`'/g' ../openthesaurus/grails-app/conf/application.yml

cp -f i18n/* ../openthesaurus/grails-app/i18n/

cp -f ../opentaal-openthesaurus/1804/mysql-connector-java-8.0.13.jar ../openthesaurus/lib/

cp -f ../opentaal-artwork/png/logo-shape-trans-341x192.png ../openthesaurus/grails-app/assets/images/openthesaurus-logo.png
cp -f ../opentaal-artwork/png/icon-shape-trans-200x200.png ../openthesaurus/grails-app/assets/images/favicon_200x200.png
cp -f ../opentaal-artwork/png/icon-shape-trans-64x64.png ../openthesaurus/grails-app/assets/images/favicon_64x64.png
cp -f ../opentaal-artwork/ico/icon-shape-trans-64-48-32-16.ico ../openthesaurus/grails-app/assets/images/favicon_openthesaurus.ico

sed -i -e 's/height="93"/height="192"/g' ../openthesaurus/grails-app/views/_searchform.gsp
sed -i -e 's/Neue Suche testen/Nieuwe zoekmethode testen/g' ../openthesaurus/grails-app/views/_searchform.gsp
sed -i -e 's/Diese neue Suche öffnet beim Tippen kein Pop-up mit einer Vorschau, sondern/Deze nieuwe manier van zoeken opent tijdens typen geen pop-up met voorbeelden, behalve/g' ../openthesaurus/grails-app/views/_searchform.gsp
sed -i -e 's/direkt das Suchergebnis/direct het zoekresultaat/g' ../openthesaurus/grails-app/views/_searchform.gsp
sed -i -e 's/Schreibt uns/Laat ons weten/g' ../openthesaurus/grails-app/views/_searchform.gsp
sed -i -e 's/wie Euch diese Suche gefällt/hoe deze manier van zoeken bevalt/g' ../openthesaurus/grails-app/views/_searchform.gsp
sed -i -e 's/alte Suche/oud zoeken/g' ../openthesaurus/grails-app/views/_searchform.gsp

sed -i -e 's/"Diese Website nutzt Cookies, um bestmögliche Funktionalität bieten zu können und für Werbung."/"Deze website gebruikt cookies om een zo goed mogelijke functionaliteit te bieden."/g' ../openthesaurus/grails-app/views/layouts/_scripts.gsp
sed -i -e 's/dismiss: "Okay",/dismiss: "Oké",/g' ../openthesaurus/grails-app/views/layouts/_scripts.gsp
sed -i -e 's/learnMore: "Datenschutzerklärung",/learnMore: "Privacybeleid",/g' ../openthesaurus/grails-app/views/layouts/_scripts.gsp

sed -i -e 's/http:\/\/twitter\.com\/openthesaurus/https:\/\/twitter.com\/opentaal/g' ../openthesaurus/grails-app/views/_footer.gsp
sed -i -e 's/https:\/\/github\.com\/danielnaber\/openthesaurus/https:\/\/github.com\/opentaal\/opentaal-openthesaurus/g' ../openthesaurus/grails-app/views/_footer.gsp

sed -i -e 's/letzte 365 Tage/laatste 365 dagen/g' ../openthesaurus/grails-app/views/statistics/index.gsp

sed -i -e 's/Stand: <g:formatDate format="dd.MM.yyyy HH:mm/Situatie op <g:formatDate format="yyyy-MM-dd HH.mm/g' ../openthesaurus/grails-app/views/statistics/index.gsp
