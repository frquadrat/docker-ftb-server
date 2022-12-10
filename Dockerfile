FROM debian:bullseye

ARG packId
ARG versionId

ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:en
ENV LC_ALL de_DE.UTF-8

ENV TZ=Europe/Berlin

USER root

# Use german debian mirror as there currently (november 2022) is an issue with the CDN
RUN sed -i -e 's/deb.debian.org/ftp.de.debian.org/g' /etc/apt/sources.list
RUN sed -i -e 's/security.debian.org/ftp.de.debian.org/g' /etc/apt/sources.list

# install java as well? openjdk-11-jre-headless -> No, the linux installer does that.

RUN rm /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install -y ca-certificates curl vim locales unzip less grep gzip tar bzip2 lsof net-tools --no-install-recommends \
    && apt-get clean \
    && apt-get autoremove \
    && apt-get autoclean \
    && sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && addgroup --system --gid 1000 minecraft \
    && adduser --system --home /home/minecraft --uid 1000 -gid 1000 minecraft


USER minecraft
WORKDIR /home/minecraft

ENV JAVA_OPTS="-Xms1024m -Xmx4096m -XX:MetaspaceSize=256M  "


# download and execute linux installer
RUN curl -L -O https://api.modpacks.ch/public/modpack/$packID/$versionID/server/linux \
    && chmod a+x linux \
    && ./linux $PackID $VersionID --auto \
    && rm ./linux \
    && echo "eula=true" >eula.txt \
    && chmod a+x start.sh \
    && mkdir -p /home/minecraft/backups /home/minecraft/world /home/minecraft/logs

COPY conf/user_jvm_args.txt /home/minecraft/

# Minecraft server port
#EXPOSE 25565


#VOLUME ["/home/minecraft/world"]
#VOLUME ["/home/minecraft/backups"]
#VOLUME ["/home/minecraft/logs"]


# Set the default command to run on boot
ENTRYPOINT ["/home/minecraft/start.sh"]







