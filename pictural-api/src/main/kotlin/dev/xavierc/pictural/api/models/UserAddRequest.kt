package dev.xavierc.pictural.api.models

import java.util.*

/**
 * Request use to add the profile of an user
 *
 * @param name Name of the user
 * @param pictureUrl Url of the user profile picture
 */
data class UserAddRequest(val name: String, val pictureUrl: String?)
