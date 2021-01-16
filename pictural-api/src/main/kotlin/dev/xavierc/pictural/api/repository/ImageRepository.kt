package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.repository.ImagesInfo.references
import org.jetbrains.exposed.sql.Table

object ImagesInfo: Table() {
    val uuid = uuid("uuid").primaryKey()
    val ownerUuid = varchar("ownerUuid", 128) references Users.uuid
}

/**
 * Join table between the ImagesInfo and Users table
 */
object ImagesAuthorizedUsers: Table() {
    val imageUuid = uuid("imageUuid") references ImagesInfo.uuid
    val userUuid = varchar("userUuid", 128) references Users.uuid
}

class ImageRepository {
}
