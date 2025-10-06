FROM fedora:42 AS builder

RUN dnf install -y tar alien rpm-build wget && dnf clean all

ARG TAR_FILE=tracking-software-linux.tar.gz
ARG TAR_LINK=""
WORKDIR /build

# Copy everything from build context (use .dockerignore to control what gets copied)
COPY . .

# If TAR_LINK is provided, download the file
RUN if [ -n "$TAR_LINK" ]; then \
        echo "Downloading from TAR_LINK: $TAR_LINK"; \
        wget -O ${TAR_FILE} "$TAR_LINK"; \
    else \
        echo "Using local TAR_FILE: ${TAR_FILE}"; \
    fi

RUN tar -xzvf ${TAR_FILE} && \
    alien -rv --scripts LeapDeveloperKit_*/Leap-*-x64.deb

FROM fedora:42

RUN dnf install -y \
        perl \
        dbus-libs \
        libglvnd-glx-1:1.7.0-7.fc42.i686 \
        dbus-x11 \
    && dnf clean all

COPY --from=builder /build/*.rpm .

# Something missing, so force install
RUN rpm -ivh --nodeps --force ./*.rpm

RUN dbus-uuidgen > /var/lib/dbus/machine-id && \
    mkdir -p /var/run/dbus

COPY launch.sh /launch.sh

EXPOSE 6437

ENTRYPOINT ["/launch.sh"]