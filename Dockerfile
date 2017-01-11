FROM aem-base:latest
MAINTAINER Siva Chedde "sivakumar.chedde@gmail.com"
ENV REFRESHED_AT 2016-01-04

#AEM COMMANDS
ENV CQ_RUNMODE author
ENV CQ_PORT 4502
ENV PUBLISH_HOST publish

#RUN sudo mkdir -p /var/jenkins_home/jobs/AEMDemo_default/workspace
COPY aemdemo-project /opt/aem

#ENV DEMOAPP_PATH /var/jenkins_home/jobs/AEMDemo_default/workspace/aemdemo-project
ENV DEMOAPP_PATH /opt/aem/aemdemo-project
ENV DEMOAPP_BUNDLE_JAR $DEMOAPP_PATH/core/target/aemdemo.core-0.0.1-SNAPSHOT.jar
ENV DEMOAPP_CONTENT_PACKAGE $DEMOAPP_PATH/ui.content/target/aemdemo.ui.content-0.0.1-SNAPSHOT.zip
ENV DEMOAPP_UI_PACKAGE $DEMOAPP_PATH/ui.apps/target/aemdemo.ui.apps-0.0.1-SNAPSHOT.zip

RUN echo sling.run.modes=${CQ_RUNMODE} >> crx-quickstart/conf/sling.properties && \
    crx-quickstart/bin/start && \
    until $(curl -u admin:admin --output /dev/null --silent --head --fail http://localhost:$CQ_PORT); do printf '.'; sleep 5; done && \
    curl -u admin:admin --output /dev/null -F action=install -F bundlestart=start -F bundlestartlevel=20 -F bundlefile=$DEMOAPP_BUNDLE_JAR http://localhost:$CQ_PORT/system/console/bundles && \
    curl -u admin:admin --output /dev/null -F file=@"$DEMOAPP_CONTENT_PACKAGE" -F name="aemdemo.ui.content-0.0.1-SNAPSHOT" -F force=true -F install=true http://localhost:$CQ_PORT/crx/packmgr/service.jsp && \
    curl -u admin:admin --output /dev/null -F file=@"$DEMOAPP_UI_PACKAGE" -F name="aemdemo.ui.apps-0.0.1-SNAPSHOT" -F force=true -F install=true http://localhost:$CQ_PORT/crx/packmgr/service.jsp && \
    sleep 10 && \
    crx-quickstart/bin/stop

RUN sleep 20

EXPOSE $CQ_PORT

CMD java -XX:MaxPermSize=256M -Xmx1536m -jar $AEM_QUICKSTART_FILE -p $CQ_PORT -r $CQ_RUNMODE
