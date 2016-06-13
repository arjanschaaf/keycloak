FROM jboss/keycloak:1.9.7.Final

ADD changeDatabase.jq /opt/jboss/keycloak/
ADD keycloak-entrypoint.sh keycloak-entrypoint.sh

RUN INPUT=`cat /opt/jboss/keycloak/standalone/configuration/keycloak-server.json` && echo $INPUT | jq -f /opt/jboss/keycloak/changeDatabase.jq > /opt/jboss/keycloak/standalone/configuration/keycloak-server.json &&\
  sed -i '/<socket-binding name="txn-status-manager"/a <socket-binding name="proxy-https" port="443"/>' keycloak/standalone/configuration/standalone.xml &&\
  sed -i 's/redirect-socket="https"/redirect-socket="proxy-https" proxy-address-forwarding="true"/g' keycloak/standalone/configuration/standalone.xml &&\
  curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip &&\
  unzip newrelic-java.zip && rm newrelic-java.zip &&\
  echo 'JAVA_OPTS="$JAVA_OPTS -javaagent:/opt/jboss/newrelic/newrelic.jar"' >> /opt/jboss/keycloak/bin/standalone.conf

ENTRYPOINT [ "/opt/jboss/keycloak-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]