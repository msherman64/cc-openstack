ARG PYTHON_VER=3.9
FROM python:${PYTHON_VER}-slim as builder

ENV XDG_CACHE_HOME="/tmp/.cache/"
RUN --mount=type=cache,target=$XDG_CACHE_HOME \
  apt-get update && apt-get install -f -y \
  gcc \
  git \
  jq \
  make

RUN --mount=type=cache,target=$XDG_CACHE_HOME \
  pip3 install poetry

# Provide a volume-mount for a current working directory (of the host)
VOLUME ["/host"]
WORKDIR /host

COPY pyproject.toml poetry.lock ./
RUN --mount=type=cache,target=$XDG_CACHE_HOME \
  poetry config virtualenvs.create false && \
  poetry install --no-interaction --no-root

ENTRYPOINT ["cc-openstack"]
