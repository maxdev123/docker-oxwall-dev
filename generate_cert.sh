mkdir -p external
openssl req -x509 -newkey rsa:4086 \
-keyout external/key.pem -out external/cert.pem \
-days 3650 -nodes -sha256
