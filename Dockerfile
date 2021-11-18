# Alpine and 1.16 in go because is the "newer"
FROM golang:1.16-alpine AS builder

ARG MONGODB_URI
ARG DB
ARG COLLECTION
ENV MONGODB_URI $MONGODB_URI
ENV DB $DB
ENV COLLECTION $COLLECTION

WORKDIR /app

# Set the work destination


#copy the files
COPY app .


RUN go mod download
RUN go mod tidy

# creating the server object
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /server .

FROM alpine:latest 

ARG MONGODB_URI
ARG DB
ARG COLLECTION
ENV MONGODB_URI $MONGODB_URI
ENV DB $DB
ENV COLLECTION $COLLECTION

COPY --from=builder server .
COPY --from=builder /app/public.crt .
COPY --from=builder /app/private.key .
RUN mkdir public
COPY --from=builder app/public /public

#Exposing the port
EXPOSE 443

CMD [ "/server" ]