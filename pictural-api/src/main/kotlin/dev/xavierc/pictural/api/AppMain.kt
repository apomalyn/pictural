package dev.xavierc.pictural.api

import com.codahale.metrics.Slf4jReporter
import com.typesafe.config.ConfigFactory
import io.ktor.client.HttpClient
import io.ktor.client.engine.apache.Apache
import io.ktor.config.HoconApplicationConfig
import io.ktor.gson.GsonConverter
import io.ktor.http.ContentType
import io.ktor.auth.Authentication
import io.ktor.auth.oauth
import dev.xavierc.pictural.api.apis.AlbumApi
import dev.xavierc.pictural.api.apis.ImageApi
import dev.xavierc.pictural.api.apis.UserApi
import dev.xavierc.pictural.api.models.User
import dev.xavierc.pictural.api.repository.ImageRepository
import dev.xavierc.pictural.api.repository.UserRepository
import dev.xavierc.pictural.api.repository.initDB
import io.ktor.application.*
import io.ktor.client.features.json.*
import io.ktor.features.*
import io.ktor.locations.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.sessions.*
import io.ktor.util.*
import org.kodein.di.bind
import org.kodein.di.ktor.di
import org.kodein.di.singleton
import java.io.File
import java.util.*


@KtorExperimentalAPI
internal val settings = HoconApplicationConfig(ConfigFactory.defaultApplication(HTTP::class.java.classLoader))

object HTTP {
    val client = HttpClient(Apache) {
        install(JsonFeature) {
            serializer = JacksonSerializer()
        }
    }
}

@KtorExperimentalAPI
@KtorExperimentalLocationsAPI
fun Application.main() {
    install(DefaultHeaders)
    install(ContentNegotiation) {
        register(ContentType.Application.Json, GsonConverter())
    }
    install(AutoHeadResponse) // see http://ktor.io/features/autoheadresponse.html
    install(HSTS, ApplicationHstsConfiguration()) // see http://ktor.io/features/hsts.html
    install(Compression, ApplicationCompressionConfiguration()) // see http://ktor.io/features/compression.html
    install(DataConversion) {
        convert<UUID> {
            decode { values, _ -> values.singleOrNull()?.let { UUID.fromString(it) }

            }
            encode {
                when(it) {
                    null -> listOf()
                    is UUID -> listOf(it.toString())
                    else -> throw DataConversionException("Cannot convert to UUID")
                }
            }
        }
    }
    install(Locations) // see http://ktor.io/features/locations.html
    install(CallLogging)
    install(Sessions) {
        cookie<String>("userUuid")
    }
    install(Authentication) {
        oauth("google_oauth2") {
            client = HttpClient(Apache)
            providerLookup = { ApplicationAuthProviders["google_oauth2"] }
            urlProvider = { _ ->
            redirectUrl(Paths.UserLogin())
            }
        }
    }
    install(Routing) {
        AlbumApi()
        ImageApi()
        UserApi()
        routing {
            get("/") { call.respondText("HELLO") }
        }
    }

    // Initialize database
    initDB()

    di {
        bind<UserRepository>() with singleton { UserRepository() }
        bind<ImageRepository>() with singleton { ImageRepository() }
    }

    environment.monitor.subscribe(ApplicationStopping)
    {
        HTTP.client.close()
    }
}

@KtorExperimentalLocationsAPI
private fun <T : Any> ApplicationCall.redirectUrl(t: T, secure: Boolean = true): String {
    val hostPort = request.host() + request.port().let { port -> if (port == 80) "" else ":$port" }
    val protocol = when {
        secure -> "https"
        else -> "http"
    }
    return "$protocol://$hostPort${application.locations.href(t)}"
}
