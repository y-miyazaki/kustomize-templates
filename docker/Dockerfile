FROM gcr.io/distroless/static:nonroot

COPY bin/main /main

EXPOSE 8080
STOPSIGNAL SIGINT
ENTRYPOINT ["/main"]
