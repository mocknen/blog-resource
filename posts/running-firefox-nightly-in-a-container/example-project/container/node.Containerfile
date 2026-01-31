FROM docker.io/node:trixie-slim

RUN \
	--mount=type=cache,sharing=locked,target=/var/cache/apt \
	--mount=type=cache,sharing=locked,target=/var/lib/apt \
	set -eux; \
	mv -v /etc/apt/apt.conf.d/docker-clean /tmp/; \
	apt-get update; \
	apt-get -y satisfy --no-install-recommends \
		ca-certificates \
		git \
		; \
	mv -v /tmp/docker-clean /etc/apt/apt.conf.d/; \
	npm install -g pnpm; \
	:
