# dev.xavierc.pictural.api - Kotlin Server library for Pictural API
[![API](https://img.shields.io/badge/API-1.2.4-blue.svg)](https://shields.io/)

This API is part of my project for the Shopify Developer intern challenge. This API manage the users, pictures and links between accounts of Pictural.

Generated by OpenAPI Generator 5.0.0-SNAPSHOT.

## Requires

* Kotlin 1.3.21
* Gradle 4.9
* A MySQL database.

You will also need the following environment variables:
* _DB_USERNAME_: The username needed to connect the service to the database
* _DB_PASSWORD_: Password linked to the username.
* _DB_URL_: Url of the database, including the port (ex: localhost:3306)
* _DB_NAME_: Name of the database.

## Build

First, create the gradle wrapper script:

```
gradle wrapper
```

Then, run:

```
./gradlew check assemble
```

This runs all tests and packages the library.

## Running

The server builds as a fat jar with a main entrypoint. To start the service, run `java -jar ./build/libs/pictural-server.jar`.

You may also run in docker:

```
docker build -t pictural-server .
docker run -p 8080:8080 pictural-server
```

## Features/Implementation Notes

* Supports JSON inputs/outputs, File inputs, and Form inputs (see ktor documentation for more info).
* ~Supports collection formats for query parameters: csv, tsv, ssv, pipes.~
* Some Kotlin and Java types are fully qualified to avoid conflicts with types defined in OpenAPI definitions.

<a name="documentation-for-api-endpoints"></a>
## Documentation for API Endpoints

Head over [here](https://apomalyn.github.io/pictural/#overview) to see the API Endpoints documentation

