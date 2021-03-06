package dev.xavierc.pictural.api

// Use this file to hold package-level internal functions that return receiver object passed to the `install` method.
import io.ktor.auth.OAuthServerSettings
import io.ktor.util.KtorExperimentalAPI
import java.time.Duration
import java.util.concurrent.Executors

import dev.xavierc.pictural.api.settings
import io.ktor.features.*
import io.ktor.http.*


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
            excludeContentType(ContentType.Image.Any)
        }
    }
}

// Provides an application-level fixed thread pool on which to execute coroutines (mainly)
internal val ApplicationExecutors = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors() * 4)
