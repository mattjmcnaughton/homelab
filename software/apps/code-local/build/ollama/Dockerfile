FROM docker.io/ollama/ollama:0.6.6

# Need to prefetch, because won't have network access.
COPY ./pull-models.sh /tmp/pull-models.sh
RUN chmod +x /tmp/pull-models.sh && \
  /tmp/pull-models.sh

RUN cp -r /root/.ollama /.ollama
RUN chown -R 1000:1000 /.ollama
