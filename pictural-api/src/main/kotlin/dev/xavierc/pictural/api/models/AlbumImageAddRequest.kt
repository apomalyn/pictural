package dev.xavierc.pictural.api.models

import java.util.*

/**
 * Request body used to add images to an album
 *
 * @param images list of the uuid to add
 */
data class AlbumImageAddRequest(val images: List<UUID>)
