/**
 * Pictural API
 * This API is part of my project for the Shopify Developer intern challenge. This API manage the users, pictures and links between accounts of Pictural.
 *
 * The version of the OpenAPI document: 0.1.0
 * Contact: chretienxavier42@gmail.com
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */
package dev.xavierc.pictural.api.apis

import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.HttpTransport
import com.google.api.client.http.apache.v2.ApacheHttpTransport
import com.google.api.client.json.gson.GsonFactory
import dev.xavierc.pictural.api.HTTP
import io.ktor.application.call
import io.ktor.http.HttpStatusCode
import io.ktor.response.respond
import io.ktor.routing.Route

import dev.xavierc.pictural.api.Paths
import dev.xavierc.pictural.api.repository.UserRepository


import io.ktor.client.request.*
import io.ktor.features.*
import io.ktor.locations.*
import io.ktor.request.*
import io.ktor.sessions.*
import org.kodein.di.instance
import org.kodein.di.ktor.di
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken
import com.google.gson.Gson
import dev.xavierc.pictural.api.models.*
import dev.xavierc.pictural.api.settings
import io.ktor.client.features.json.*
import io.ktor.util.*

@KtorExperimentalAPI
@KtorExperimentalLocationsAPI
fun Route.UserApi() {

    val userRepository by di().instance<UserRepository>()

    val verifier = GoogleIdTokenVerifier.Builder(ApacheHttpTransport(), GsonFactory())
        .setAudience(listOf(settings.property("auth.oauth.google_oauth2.clientId").getString()))
        .build()

    // Search a user
    post { _: Paths.UserSearch ->
        val partialName = call.request.queryParameters["partialName"]

        if(partialName == null) {
            call.respond(HttpStatusCode.BadRequest)
        } else {
            val usersMatch = userRepository.searchUsers(partialName)

            call.respond(HttpStatusCode.OK, SearchResponse(usersMatch))
        }
    }

    // Get the friends list of the user
    get { _: Paths.UserFriendsGet ->
        val user = call.sessions.get<UserSession>()

        if (user == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val friendsList = userRepository.getFriendsList(user.uid)

            call.respond(HttpStatusCode.OK, FriendsListResponse(friendsList))
        }
    }

    // Add friend
    post { request: Paths.UserFriendsAdd ->
        val user = call.sessions.get<UserSession>()

        if (user == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            if (userRepository.addFriend(user.uid, request.friendUuid)) {
                call.respond(HttpStatusCode.OK)
            } else {
                call.respond(HttpStatusCode.NotFound)
            }
        }
    }

    // Delete a friend
    delete { request: Paths.UserFriendsDelete ->
        val user = call.sessions.get<UserSession>()

        if (user == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            if (userRepository.deleteFriend(user.uid, request.friendUuid)) {
                call.respond(HttpStatusCode.OK)
            } else {
                call.respond(HttpStatusCode.NotFound)
            }
        }
    }

    // Get user info
    get { _: Paths.UserInfoGet ->
        val user = call.sessions.get<UserSession>()

        if (user == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val results = userRepository.getUserInfo("tet")
            if (results != null) {
                call.respond(results)
            } else {
                call.respond(HttpStatusCode.NotFound)
            }
        }
    }

    // Update user info
    put { _: Paths.UserInfoUpdate ->
        val user = call.sessions.get<UserSession>()

        if (user == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val request = call.receive<UserUpdateRequest>()

            userRepository.updateUserInfo(user.uid, request.name, request.darkModeEnabled, request.pictureUrl)

            call.respond(HttpStatusCode.OK)
        }
    }

    // Add user info (create a new user)
    post { _: Paths.UserInfoAdd ->
        val user = call.sessions.get<UserSession>()

        when {
            user == null -> {
                call.respond(HttpStatusCode.OK)
            }
            userRepository.getUserInfo(user.uid) != null -> {
                // User already exists
                call.respond(HttpStatusCode.Conflict)
            }
            else -> {
                val request = call.receive<UserAddRequest>()

                userRepository.addUserInfo(user.uid, request.name, request.pictureUrl)
                call.respond(HttpStatusCode.Created)
            }
        }
    }

    // Login with oauth
    post { _: Paths.UserLogin ->
        val tokenId = call.receiveText().substringAfter("=")

        val idToken: GoogleIdToken = verifier.verify(tokenId)
        if (idToken != null) {
            val payload: GoogleIdToken.Payload = idToken.payload

            // Print user identifier
            val userId: String = payload.getSubject()

            // Get profile information from payload
            val name = payload.get("name")
            val pictureUrl = payload.get("picture")


            val results = userRepository.getUserInfo(userId)
            if (results != null) {
                call.sessions.set(UserSession(results.uuid))
                call.respond(HttpStatusCode.OK, results)
            } else {
                call.sessions.set(UserSession(userId))
                userRepository.addUserInfo(userId, name as String, pictureUrl as String?)
                call.respond(HttpStatusCode.OK, userRepository.getUserInfo(userId)!!)
            }

        } else {
            println("Invalid ID token.")
            call.respond(HttpStatusCode.BadRequest)
        }
    }

    // Log out the user
    post { _: Paths.UserLogout ->
        call.sessions.clear("userUuid")
        call.respond(HttpStatusCode.OK)
    }
}
