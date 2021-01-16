package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.models.Album
import dev.xavierc.pictural.api.models.Friend
import dev.xavierc.pictural.api.repository.ImagesInfo.references
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
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

                    if(album != null) {
                        albums.add(album)
                    }
                }
        }

        return albums
    }
}
