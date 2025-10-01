version: "3.8"

services:
  ml-editor-node:
    build: .
    container_name: ml-editor-node
    ports:
      - "9636:9636"
      - "8080:8080"
      - "8000:8000"
      - "30303:30303"
      - "30303:30303/udp"
    environment:
      - NETWORK_ID=999
