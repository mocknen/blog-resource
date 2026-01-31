FROM docker.io/debian:trixie-slim

ARG MOZILLA_KEY_PATH=/etc/apt/keyrings/mozilla.asc
ARG MOZILLA_KEY_DIGEST=sha256:3ecc63922b7795eb23fdc449ff9396f9114cb3cf186d6f5b53ad4cc3ebfbb11f

ADD \
	--checksum=${MOZILLA_KEY_DIGEST:?} \
	--chmod=644 \
	https://packages.mozilla.org/apt/repo-signing-key.gpg \
	${MOZILLA_KEY_PATH:?}

COPY \
	<<-EOF /etc/apt/sources.list.d/mozilla.sources
	Types: deb
	URIs: http://packages.mozilla.org/apt
	Suites: mozilla
	Components: main
	Signed-By: ${MOZILLA_KEY_PATH:?}
EOF

RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt \
	--mount=type=cache,sharing=locked,target=/var/lib/apt \
	set -eux; \
	mv -v /etc/apt/apt.conf.d/docker-clean /tmp/; \
	apt-get update; \
	apt-get -y satisfy --no-install-recommends \
		firefox-nightly \
		libpulse0 \
		; \
	mv -v /tmp/docker-clean /etc/apt/apt.conf.d/; \
	:

ENTRYPOINT ["firefox-nightly"]
