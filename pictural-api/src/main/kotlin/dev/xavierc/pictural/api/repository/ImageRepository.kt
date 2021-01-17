package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.models.Friend
import dev.xavierc.pictural.api.models.ImageInfo
import dev.xavierc.pictural.api.repository.ImagesInfo.references
import dev.xavierc.pictural.api.utils.UuidDontExistException
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*

object ImagesInfo : Table() {
    val uuid: Column<UUID> = uuid("uuid").autoGenerate().primaryKey()
    val ownerUuid: Column<String> = varchar("ownerUuid", 128) references Users.uuid
    val extensionType: Column<String> = varchar("type", length = 12)
}

/**
 * Join table between the ImagesInfo and Users table
 */
object ImagesAuthorizedUsers : Table() {
    val imageUuid: Column<UUID> = uuid("imageUuid") references ImagesInfo.uuid
    val userUuid: Column<String> = varchar("userUuid", 128) references Users.uuid
}

class ImageRepository {
    /**
     * Add an image linked to [ownerUuid]
     */
    fun addImageInfo(ownerUuid: String, extension: String): UUID? {
        var uuid: UUID? = null
        transaction {
            uuid = ImagesInfo.insert {
                it[ImagesInfo.ownerUuid] = ownerUuid
                it[ImagesInfo.extensionType] = extension
            } get ImagesInfo.uuid
        }

        return uuid
    }

    /**
     * Get the info for the image [imageUuid]
     */
    fun getImageInfo(imageUuid: UUID): ImageInfo? {
        var imageInfo: ImageInfo? = null

        transaction {
            val imageInfoResult = ImagesInfo.select { ImagesInfo.uuid eq imageUuid }.singleOrNull()

            if (imageInfoResult != null) {
                val authorizedUsers = ImagesAuthorizedUsers.rightJoin(Users).slice(Users.uuid, Users.name, Users.pictureUuid)
                    .select { ImagesAuthorizedUsers.imageUuid.eq(imageUuid) and Users.uuid.eq(ImagesAuthorizedUsers.userUuid)}
                    .mapIndexed { _, it -> Friend(it[Users.uuid], it[Users.name], it[Users.pictureUuid]) }

                imageInfo = ImageInfo(
                    imageInfoResult[ImagesInfo.uuid],
                    imageInfoResult[ImagesInfo.ownerUuid],
                    authorizedUsers,
                    imageInfoResult[ImagesInfo.extensionType]
                )
            }
        }

        return imageInfo
    }

    /**
     * Delete the info on the image [imageUuid]
     */
    fun deleteImageInfo(imageUuid: UUID) {
        transaction {
            ImagesInfo.deleteWhere { ImagesInfo.uuid eq imageUuid }
        }
    }

    /**
     * Get all the images owned and shared by the user [userUuid]
     */
    fun getImagesByUser(userUuid: String): List<ImageInfo> {
        val images: MutableList<ImageInfo> = mutableListOf()

        transaction {
            ImagesInfo.leftJoin(ImagesAuthorizedUsers).slice(ImagesInfo.uuid)
                // Add images owned by the user OR shared with it
                .select { ImagesAuthorizedUsers.userUuid.eq(userUuid) or ImagesInfo.ownerUuid.eq(userUuid) }.forEach {
                    val image = getImageInfo(it[ImagesInfo.uuid])

                    if (image != null) {
                        images.add(image)
                    }
                }
        }

        return images.toList()
    }

    /**
     * Share the image [imageUuid] with the user [userUuid]
     */
    fun shareImageWith(imageUuid: UUID, userUuid: String): Boolean {
        var shared = true
        try {
            transaction {
                // Check if the image exist
                ImagesInfo.select { ImagesInfo.uuid eq imageUuid }.singleOrNull() ?: throw UuidDontExistException()

                // Share the image
                ImagesAuthorizedUsers.insert {
                    it[ImagesAuthorizedUsers.imageUuid] = imageUuid
                    it[ImagesAuthorizedUsers.userUuid] = userUuid
                }
            }
        } catch (e: UuidDontExistException) {
            shared = false
        } catch (e: Exception) {
            // Something wrong happened
            shared = false
        }
        return shared
    }

    /**
     * Remove the access of the user [userUuid] to image [imageUuid]
     */
    fun deleteAccess(imageUuid: UUID, userUuid: String): Boolean {
        var accessRemoved = true

        try {
            transaction {
                ImagesAuthorizedUsers.deleteWhere { ImagesAuthorizedUsers.imageUuid.eq(imageUuid) and ImagesAuthorizedUsers.userUuid.eq(userUuid) }
            }
        } catch (e: Exception) {
            print(e.message)
            accessRemoved = false
        }

        return accessRemoved
    }
}
