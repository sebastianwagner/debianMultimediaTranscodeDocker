FROM debian:testing
MAINTAINER Sebastian Wagner <2000sw@gmail.com>


# gnupg2 won't work because it needs dirmngr
# deb-multimedia-mirrors(in germany) are missing current pulse-packages needed
# apt-key won't allow adding keys by fingerprint other than that
# deb-multimedia-keyring is not available within normal debian repos(why?)

RUN export DEBIAN_FRONTEND='noninteractive' && \
 export DEB_MULTIMEDIA_KEYSERVER='hkp://pgp.mit.edu' && \
 export DEB_MULTIMEDIA_FINGERPRINT='A401FF99368FA1F98152DE755C808C2B65558117' && \
 echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/49custom && \
 apt update -q && \
 apt install -qqy gnupg && \
 echo 'deb http://www.deb-multimedia.org testing main non-free' \
   >> /etc/apt/sources.list.d/deb-multimedia.org.list && \
 apt-key --keyring /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg adv --keyserver "$DEB_MULTIMEDIA_KEYSERVER" --recv-keys "$DEB_MULTIMEDIA_FINGERPRINT" && \
 apt update -qq && \
 apt install -qqy --option Dpkg::Options::="--force-confnew" \
   deb-multimedia-keyring && \
 apt install -qqy transcode && \
 apt autoremove -qqy && \
 apt remove -qqy gnupg && \
 apt clean -q && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/* /var/tmp/*

# build with  docker build --tag sebastianwagner/debiantranscode:latest .
# run with  docker run --net=none --rm --interactive --tty --volume=$(pwd)/data/:/data/ sebastianwagner/debiantranscode
