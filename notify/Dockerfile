FROM fluent/fluentd:latest

MAINTAINER Seigo Uchida <spesnova@gmail.com>

RUN gem install fluent-plugin-grep fluent-plugin-slack fluent-plugin-rewrite

CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
