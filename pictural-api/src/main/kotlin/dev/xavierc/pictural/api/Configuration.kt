package dev.xavierc.pictural.api

// Use this file to hold package-level internal functions that return receiver object passed to the `install` method.
import io.ktor.auth.OAuthServerSettings
import io.ktor.features.Compression
import io.ktor.features.HSTS
import io.ktor.features.deflate
import io.ktor.features.gzip
import io.ktor.features.minimumSize
import io.ktor.http.HttpMethod
import io.ktor.util.KtorExperimentalAPI
import java.time.Duration
import java.util.concurrent.Executors

import dev.xavierc.pictural.api.settings


/**
 * Application block for [HSTS] configuration.
 *
 * This file may be excluded in .openapi-generator-ignore,
 * and application specific configuration can be applied in this function.
 *
 * See http://ktor.io/features/hsts.html
 */
internal fun ApplicationHstsConfiguration(): HSTS.Configuration.() -> Unit {
    return {
        includeSubDomains = true
        preload = false
        maxAgeInSeconds = Duration.ofDays(365).seconds

        // You may also apply any custom directives supported by specific user-agent. For example:
        // customDirectives.put("redirectHttpToHttps", "false")
    }
}

/**
 * Application block for [Compression] configuration.
 *
 * This file may be excluded in .openapi-generator-ignore,
 * and application specific configuration can be applied in this function.
 *
 * See http://ktor.io/features/compression.html
 */
internal fun ApplicationCompressionConfiguration(): Compression.Configuration.() -> Unit {
    return {
        gzip {
            priority = 1.0
        }
        deflate {
            priority = 10.0
            minimumSize(1024) // condition
        }
    }
}

// Defines authentication mechanisms used throughout the application.
@KtorExperimentalAPI
val ApplicationAuthProviders: Map<String, OAuthServerSettings> = listOf<OAuthServerSettings>(
        OAuthServerSettings.OAuth2ServerSettings(
            name = "google_oauth2",
            authorizeUrl = "https://accounts.google.com/o/oauth2/v2/auth",
            accessTokenUrl = "https://www.googleapis.com/oauth2/v3/token",
            requestMethod = HttpMethod.Post,
            clientId = settings.property("auth.oauth.google_oauth2.clientId").getString(),
            clientSecret = settings.property("auth.oauth.google_oauth2.clientSecret").getString(),
            defaultScopes = listOf("profile", "email")
//            defaultScopes = listOf("profile", "email", "write_user", "read_user", "write_image", "read_image", "write_image_access", "read_image_access")
        )
).associateBy { it.name }

// Provides an application-level fixed thread pool on which to execute coroutines (mainly)
internal val ApplicationExecutors = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors() * 4)
