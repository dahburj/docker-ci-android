FROM debian:stretch

# Init
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm

RUN apt-get --quiet update --yes

# Git
RUN apt-get --quiet install --yes git

# OpenJDK
RUN apt-get --quiet install --yes openjdk-8-jdk

# Android SDK
ARG ANDROID_COMPILE_SDK="28"
ARG ANDROID_BUILD_TOOLS="28.0.3"
ARG ANDROID_SDK_TOOLS="4333796"
ARG ANDROID_HOME="/usr/local/android-sdk-linux"

RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN wget --quiet --output-document=/tmp/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -d ${ANDROID_HOME} /tmp/android-sdk.zip
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" >/dev/null
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null
RUN /bin/bash -c \
    set +o pipefail &&\
    yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN rm /tmp/android-sdk.zip


ENV ANDROID_HOME=${ANDROID_HOME}
ENV PATH=$PATH:${ANDROID_HOME}/platform-tools/

# Fastlane

ARG FASTLANE_VERSION=2.112

RUN apt-get -y install build-essential ruby ruby-dev && gem install fastlane -NV -v ${FASTLANE_VERSION}

ENV LANG=en_US.UTF-8

# Clean
RUN apt-get autoremove -y
RUN apt-get clean

# Common
WORKDIR /root
