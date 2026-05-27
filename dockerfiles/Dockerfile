FROM golang AS BUILD

WORKDIR /app

COPY go.mod go.sum ./

RUN useradd -u 1000 nonroot

RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  go mod download


COPY . .

RUN go build \
  -ldflags="-linkmode external -extldflags -static" \
  -tags netgo \
  -o api-golang

FROM scratch

COPY --link --from=BUILD  etc/passwd etc/passwd

COPY --link --from=BUILD /app/api-golang api-golang

USER nonroot

EXPOSE 8080

ENTRYPOINT [ "./api-golang" ]