/**
 * Pictural API
 * This API is part of my project for the Shopify Developer intern challenge. This API manage the users, pictures and links between accounts of Pictural.
 *
 * The version of the OpenAPI document: 0.1.0
 * Contact: chretienxavier42@gmail.com
 *
 */
package dev.xavierc.pictural.api.apis

import io.ktor.application.call
import io.ktor.routing.Route
import io.ktor.routing.post
import io.ktor.routing.route

import dev.xavierc.pictural.api.Paths
import dev.xavierc.pictural.api.models.ImageInfo
import dev.xavierc.pictural.api.models.ImageListResponse
import dev.xavierc.pictural.api.repository.ImageRepository
import dev.xavierc.pictural.api.repository.UserRepository
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.locations.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.sessions.*
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.yield
import org.kodein.di.instance
import org.kodein.di.ktor.di
import java.io.File
import java.io.InputStream
import java.io.OutputStream
import java.util.*

@KtorExperimentalLocationsAPI
fun Route.ImageApi(imageDir: File) {
    val imageRepository by di().instance<ImageRepository>()
    val userRepository by di().instance<UserRepository>()

    // Add access to an image
    post { request: Paths.ImageAccessAdd ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val imageInfo: ImageInfo? = imageRepository.getImageInfo(request.imageUuid)

            // Check if the image exist and the friend is a friend
            if (imageInfo == null) {
                call.respond(HttpStatusCode.NotFound)
            } else if (!userRepository.isFriend(userUuid, request.friendUuid) || imageInfo.ownerUuid != userUuid) {
                // 'Friend' is not a friend OR not the owner of the image
                call.respond(HttpStatusCode.Unauthorized)
            } else if (imageRepository.shareImageWith(request.imageUuid, request.friendUuid)) {
                call.respond(HttpStatusCode.OK)
            } else {
                // Something wrong happened
                call.respond(HttpStatusCode.InternalServerError)
            }
        }
    }

    // Remove access to an image
    delete { request: Paths.ImageAccessDelete ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val imageInfo: ImageInfo? = imageRepository.getImageInfo(request.imageUuid)

            // Check if the image exist and the friend is a friend
            when {
                imageInfo == null -> {
                    call.respond(HttpStatusCode.NotFound)
                }
                imageInfo.ownerUuid != userUuid -> {
                    // Not the owner of the image
                    call.respond(HttpStatusCode.Unauthorized)
                }
                imageRepository.deleteAccess(request.imageUuid, request.friendUuid) -> {
                    call.respond(HttpStatusCode.OK)
                }
                else -> {
                    // Something wrong happened
                    call.respond(HttpStatusCode.InternalServerError)
                }
            }
        }
    }

    // Delete an image
    delete { request: Paths.ImageDelete ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val imageInfo: ImageInfo? = imageRepository.getImageInfo(request.imageUuid)

            // Check if the image exist and the friend is a friend
            when {
                imageInfo == null -> {
                    call.respond(HttpStatusCode.NotFound)
                }
                imageInfo.ownerUuid != userUuid -> {
                    // 'Friend' is not a friend OR not the owner of the image
                    call.respond(HttpStatusCode.Unauthorized)
                }
                else -> {
                    imageRepository.deleteImageInfo(request.imageUuid)
                    // TODO Delete file
                    call.respond(HttpStatusCode.OK)
                }
            }
        }
    }

    // Get an image
    get { request: Paths.ImageGet ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val imageInfo = imageRepository.getImageInfo(request.imageUuid)

            when {
                imageInfo == null -> call.respond(HttpStatusCode.NotFound)
                (!imageInfo.authorized.contains(userUuid) && imageInfo.ownerUuid != userUuid) -> {
                    // Not the owner or one of the authorized users
                    call.respond(HttpStatusCode.Unauthorized)
                }
                else -> {
                    call.respondFile(baseDir = imageDir, fileName = "${imageInfo.uuid}.${imageInfo.extensionType}")
                }
            }
        }
    }

    // Get the info of an image
    get { request: Paths.ImageInfoGet ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            val imageInfo = imageRepository.getImageInfo(request.imageUuid)

            when {
                imageInfo == null -> call.respond(HttpStatusCode.NotFound)
                (!imageInfo.authorized.contains(userUuid) && imageInfo.ownerUuid != userUuid) -> {
                    // Not the owner or one of the authorized users
                    call.respond(HttpStatusCode.Unauthorized)
                }
                else -> call.respond(HttpStatusCode.OK, imageInfo)
            }
        }
    }

    // Upload of an image
    post { _: Paths.ImageUpload ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            var imageUuid: UUID? = null
            val multipart = call.receiveMultipart()
            multipart.forEachPart { part ->
                when (part) {
                    is PartData.FileItem -> {
                        val ext = File(part.originalFileName).extension
                        imageUuid = imageRepository.addImageInfo(userUuid, ext)
                        val file = File(imageDir, "${imageUuid}.$ext")
                        part.streamProvider().use { input -> file.outputStream().buffered().use { output -> input.copyToSuspend(output) } }
                    }
                }

                part.dispose()
            }


            call.respond(HttpStatusCode.OK, imageUuid!!.toString())
        }
    }

    // Get the images for the user.
    get { _: Paths.ImagesGet ->
        val userUuid = call.sessions.get("userUuid") as String?
        call.response.headers.append("Access-Control-Allow-Origin", "*")

        if (userUuid == null) {
            call.respond(HttpStatusCode.Unauthorized)
        } else {
            call.respond(HttpStatusCode.OK, ImageListResponse(imageRepository.getImagesByUser(userUuid)))
        }
    }
}

suspend fun InputStream.copyToSuspend(
    out: OutputStream,
    bufferSize: Int = DEFAULT_BUFFER_SIZE,
    yieldSize: Int = 4 * 1024 * 1024,
    dispatcher: CoroutineDispatcher = Dispatchers.IO
): Long {
    return withContext(dispatcher) {
        val buffer = ByteArray(bufferSize)
        var bytesCopied = 0L
        var bytesAfterYield = 0L
        while (true) {
            val bytes = read(buffer).takeIf { it >= 0 } ?: break
            out.write(buffer, 0, bytes)
            if (bytesAfterYield >= yieldSize) {
                yield()
                bytesAfterYield %= yieldSize
            }
            bytesCopied += bytes
            bytesAfterYield += bytes
        }
        return@withContext bytesCopied
    }
}
