FROM golang:1.24

WORKDIR /app

COPY main.go .

RUN go build -o server main.go

EXPOSE 4444

HEALTHCHECK --interval=10s --timeout=2s CMD wget -qO- http://localhost:4444/ || exit 1

CMD ["./server"]
