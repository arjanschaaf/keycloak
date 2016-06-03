#! /bin/bash

# newrelic application name is the name visible in the newrelic UI and uniquely identifies a deployment. We often use the base url of the deployment as its app name
if [ -n "${NEWRELIC_APPLICATION_NAME+1}" ]
then
    sed -i "s# My Application# ${NEWRELIC_APPLICATION_NAME}#" newrelic/newrelic.yml
else
    echo "NEWRELIC_APPLICATION_NAME is a required environment variable that needs to be set"
    exit 1;
fi

# newrelic license key makes sure the data is reported to the correct newrelic account
if [ -n "${NEWRELIC_LICENSE_KEY+1}" ]
then
    sed -i "s#<%= license_key %>#${NEWRELIC_LICENSE_KEY}#" newrelic/newrelic.yml
else
    echo "NEWRELIC_LICENSE_KEY is a required environment variable that needs to be set"
    exit 1;
fi


# mongo username is needed for authenticated access to mongo
if [ -n "${MONGO_USERNAME+1}" ]
then
    INPUT=`cat /opt/jboss/keycloak/standalone/configuration/keycloak-server.json` && echo $INPUT | jq '.connectionsMongo.default.user = "${env.MONGO_USERNAME}"' > /opt/jboss/keycloak/standalone/configuration/keycloak-server.json
fi

# mongo password is needed for authenticated access to mongo
if [ -n "${MONGO_PASSWORD+1}" ]
then
    INPUT=`cat /opt/jboss/keycloak/standalone/configuration/keycloak-server.json` && echo $INPUT | jq '.connectionsMongo.default.password = "${env.MONGO_PASSWORD}"' > /opt/jboss/keycloak/standalone/configuration/keycloak-server.json

fi

/opt/jboss/docker-entrypoint.sh "$@"