package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.models.Album
import dev.xavierc.pictural.api.models.Friend
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import java.lang.Exception
import java.util.*

object Albums : Table() {
    val uuid = uuid("uuid").autoGenerate().primaryKey()
    val title = varchar("title", 128)
    val ownerUuid = varchar("ownerUuid", 128) references Users.uuid
}

/**
 * Join table between the Albums and ImagesInfo table
 */
object AlbumsImages : Table() {
    val albumUuid = uuid("albumUuid") references Albums.uuid
    val imageUuid = uuid("imageUuid") references ImagesInfo.uuid
}

/**
 * Join table between the Albums and Users table
 */
object AlbumsAuthorizedUsers : Table() {
    val albumUuid = uuid("albumUuid") references Albums.uuid
    val userUuid = varchar("userUuid", 128) references Users.uuid
}

class AlbumRepository {

    /**
     * Get the album [uuid]
     */
    fun getAlbum(uuid: UUID): Album? {
        var album: Album? = null

        transaction {
            // Get basic info
            val albumInfo = Albums.select { Albums.uuid eq uuid }.singleOrNull()

            if (albumInfo != null) {
                // Get image list
                val imagesUuid: List<UUID> =
                    AlbumsImages.slice(AlbumsImages.imageUuid).select { AlbumsImages.albumUuid eq uuid }.mapIndexed { _, it -> it[AlbumsImages.imageUuid] }

                // Get authorized users
                val authorized: List<Friend> =
                    AlbumsAuthorizedUsers.rightJoin(Users).slice(Users.uuid, Users.name, Users.pictureUuid)
                        .select { AlbumsAuthorizedUsers.albumUuid.eq(uuid) and AlbumsAuthorizedUsers.userUuid.eq(Users.uuid) }
                        .mapIndexed { _, it -> Friend(it[Users.uuid], it[Users.name], it[Users.pictureUuid]) }

                album = Album(albumInfo[Albums.uuid], albumInfo[Albums.ownerUuid], albumInfo[Albums.title], imagesUuid, authorized)
            }
        }

        return album
    }

    /**
     * Get the albums owned and shared by the user [userUuid]
     */
    fun getAlbums(userUuid: String): List<Album> {
        val albums: MutableList<Album> = mutableListOf()

        transaction {
            Albums.leftJoin(AlbumsAuthorizedUsers).slice(Albums.uuid)
                .select { Albums.ownerUuid.eq(userUuid) or AlbumsAuthorizedUsers.userUuid.eq(userUuid) }.forEach {
                    val album = getAlbum(it[Albums.uuid])

                    if (album != null) {
                        albums.add(album)
                    }
                }
        }

        return albums
    }

    /**
     * Add an album named [title], owned by [ownerUuid] with [images] on it and shared with [authorizedUsers]
     */
    fun addAlbum(ownerUuid: String, title: String, images: List<UUID>, authorizedUsers: List<String>): UUID? {
        var uuid: UUID? = null

        transaction {
            // Add album
            uuid = Albums.insert {
                it[Albums.title] = title
                it[Albums.ownerUuid] = ownerUuid
            } get Albums.uuid

            // Add the images
            AlbumsImages.batchInsert(images) {
                this[AlbumsImages.albumUuid] = uuid!!
                this[AlbumsImages.imageUuid] = it
            }

            // Add the authorized user.
            AlbumsAuthorizedUsers.batchInsert(authorizedUsers) {
                this[AlbumsAuthorizedUsers.albumUuid] = uuid!!
                this[AlbumsAuthorizedUsers.userUuid] = it
            }
        }

        return uuid
    }

    /**
     * Update the album [uuid]
     */
    fun updateAlbum(uuid: UUID, title: String): Boolean {
        try {
            transaction {
                Albums.update({ Albums.uuid eq uuid }, limit = 1) {
                    it[Albums.title] = title
                }
            }
        } catch (e: Exception) {
            print(e)
            return false
        }
        return true
    }

    /**
     * Delete the album [uuid]
     */
    fun deleteAlbum(uuid: UUID): Boolean {
        try {
            transaction {
                Albums.deleteWhere { Albums.uuid eq uuid }
            }
        } catch (e: Exception) {
            print(e)
            return false
        }
        return true
    }

    /**
     * Share the album [uuid] with the [authorizedUsers]. Old access aren't removed.
     */
    fun shareWith(uuid: UUID, authorizedUsers: List<String>): Boolean {
        try {
            transaction {
                AlbumsAuthorizedUsers.batchInsert(data = authorizedUsers) {
                    this[AlbumsAuthorizedUsers.albumUuid] = uuid
                    this[AlbumsAuthorizedUsers.userUuid] = it
                }
            }
        } catch (e: Exception) {
            print(e)
            return false
        }

        return true
    }

    /**
     * Remove the access of the user [userUuid] to the album [uuid]
     */
    fun removeAccessTo(uuid: UUID, userUuid: String): Boolean {
        try {
            transaction {
                AlbumsAuthorizedUsers.deleteWhere { AlbumsAuthorizedUsers.albumUuid.eq(uuid) and AlbumsAuthorizedUsers.userUuid.eq(userUuid) }
            }
        } catch (e: Exception) {
            print(e)
            return false
        }

        return true
    }

    /**
     * Add all the [images] into the album [uuid]
     */
    fun addImages(uuid: UUID, images: List<UUID>): Boolean {
        try {
            transaction {
                AlbumsImages.batchInsert(data = images) {
                    this[AlbumsImages.albumUuid] = uuid
                    this[AlbumsImages.imageUuid] = it
                }
            }
        } catch (e: Exception) {
            print(e)
            return false
        }

        return true
    }

    /**
     * Remove the image [imageUuid] from the album [uuid]
     */
    fun removeImage(uuid: UUID, imageUuid: UUID): Boolean {
        try {
            transaction {
                AlbumsImages.deleteWhere { AlbumsImages.albumUuid.eq(uuid) and AlbumsImages.imageUuid.eq(imageUuid) }
            }
        } catch (e: Exception) {
            print(e)
            return false
        }

        return true
    }
}
