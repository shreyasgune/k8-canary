FROM alpine:latest
MAINTAINER Shreyas Gune

ARG version
COPY source/$version/app /app
EXPOSE 8080
ENTRYPOINT ["/app"]
