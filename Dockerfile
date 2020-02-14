FROM xanter/wine:latest

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends procps xvfb \
    && rm -rf /var/lib/apt/lists/*

# get at least error information from wine
ENV WINEDEBUG -all,err+all

# Run virtual X buffer on this port
ENV DISPLAY :99

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin

USER xclient

# Install Inno Setup binaries
RUN curl -SL "http://files.jrsoftware.org/is/6/innosetup-6.0.3.exe" -o is.exe \
    && wine-x11-run wine is.exe /SP- /VERYSILENT /ALLUSERS /SUPPRESSMSGBOXES \
    && rm is.exe

WORKDIR /work
# ENTRYPOINT ["wine-x11-run", "iscc"]
ENTRYPOINT ["iscc"]