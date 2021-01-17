package dev.xavierc.pictural.api.models

import java.util.*

/**
 * Request use to add the profile of an user
 *
 * @param name Name of the user
 * @param pictureUuid pictureUuid of the user
 */
data class UserAddRequest(val name: String, val pictureUuid: UUID?)
