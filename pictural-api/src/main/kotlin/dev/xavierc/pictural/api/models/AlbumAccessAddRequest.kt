package dev.xavierc.pictural.api.models

/**
 * Request body used to add access to an album
 *
 * @param friends list of the uuid to add access
 */
data class AlbumAccessAddRequest(val friends: List<String>)
