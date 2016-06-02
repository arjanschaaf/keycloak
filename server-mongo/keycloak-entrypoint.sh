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
    echo "NEWRELIC_LICENSE_KEY is a requered environment variable that needs to be set"
    exit 1;
fi

/opt/jboss/docker-entrypoint.sh "$@"
