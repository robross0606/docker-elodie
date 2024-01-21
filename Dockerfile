FROM python:3.9-alpine AS builder
ENV PYTHONUNBUFFERED 1

# Install runtime dependencies
RUN apk --update upgrade && \
  apk add --update inotify-tools exiftool zlib jpeg lcms2 tiff openjpeg su-exec && \
  rm -rf /var/cache/apk/*

# Install build dependencies
RUN apk --update upgrade && \
  apk add --update git \
  build-base \
  jpeg-dev \
  zlib-dev \
  lcms2-dev \
  openjpeg-dev \
  tiff-dev && \
  rm -rf /var/cache/apk/*

WORKDIR /wheels
RUN git clone https://github.com/D3Zyre/Elodie.git /elodie && \
  pip wheel --no-cache-dir -r /elodie/requirements.txt && \
  rm -rf /elodie/.git

#Using internal modified copy of file for now
#RUN git clone https://github.com/javanile/inotifywait-polling.git /inotifywait-polling && \
#  chmod +x /inotifywait-polling/inotifywait-polling.sh

FROM python:3.9-alpine
LABEL maintainer="pierre@buyle.org"
ENV PYTHONUNBUFFERED 1

# Install runtime dependencies
RUN apk --update upgrade && \
  apk add --update inotify-tools exiftool zlib jpeg lcms2 tiff openjpeg su-exec bash findutils && \
  rm -rf /var/cache/apk/*

COPY --from=builder /wheels /wheels
COPY --from=builder /elodie /elodie
#COPY --from=builder /inotifywait-polling/inotifywait-polling.sh /usr/local/bin/inotifywait-polling

WORKDIR /elodie
RUN pip install --no-cache-dir -r requirements.txt -f /wheels && \
  rm -rf /wheels

COPY entrypoint.sh /entrypoint.sh
COPY --chown=root:root --chmod=0777 inotifywait-polling.sh /usr/local/bin/inotifywait-polling

ENV SOURCE=/source
ENV DESTINATION=/destination
ENV ELODIE_APPLICATION_DIRECTORY=~/.elodie
ENV ELODIE_DEFAULT_COMMAND=watch

ENTRYPOINT ["/entrypoint.sh"]