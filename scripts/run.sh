#!/usr/bin/env bash

if [ ! -f config/jwt/private.pem ] || ! echo "$JWT_PASSPHRASE" | openssl pkey -in config/jwt/private.pem -passin stdin -noout > /dev/null 2>&1; then
	echo "Generating public / private keys for JWT"
	mkdir -p config/jwt
	echo "$JWT_PASSPHRASE" | openssl genpkey -out config/jwt/private.pem -pass stdin -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096
	echo "$JWT_PASSPHRASE" | openssl pkey -in config/jwt/private.pem -passin stdin -out config/jwt/public.pem -pubout
fi

php bin/console server:run *:4000
