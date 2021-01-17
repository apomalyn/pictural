package dev.xavierc.pictural.api.models

import java.util.UUID

/**
 * Request body to add an album
 *
 * @param title of the album
 * @param images list of the image uuid that compose the album
 * @param friends list of the users with who the album is shared
 */
data class AlbumAddRequest(val title: String, val images: List<UUID>, val friends: List<String>)
