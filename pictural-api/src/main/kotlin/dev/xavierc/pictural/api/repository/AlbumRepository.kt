package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.repository.ImagesInfo.references
import org.jetbrains.exposed.sql.Table

object Albums: Table() {
    val uuid = uuid("uuid").primaryKey()
    val title = varchar("title", 128)
    val ownerUuid = varchar("ownerUuid", 128) references Users.uuid
}

/**
 * Join table between the Albums and ImagesInfo table
 */
object AlbumsImages: Table() {
    val albumUuid = uuid("albumUuid") references Albums.uuid
    val imageUuid = uuid("imageUuid") references ImagesInfo.uuid
}

/**
 * Join table between the Albums and Users table
 */
object AlbumsAuthorizedUsers: Table() {
    val albumUuid = uuid("albumUuid") references Albums.uuid
    val userUuid = varchar("userUuid", 128) references Users.uuid
}

class AlbumRepository {
}
