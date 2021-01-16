package dev.xavierc.pictural.api.models

import java.util.*

/**
 * Request use to update the profile of an user
 *
 * @param name Updated name of the user
 * @param darkModeEnabled If the dark mode is enabled for the UI
 * @param pictureUuid Updated uuid of the profile picture of the user
 */
data class UserUpdateRequest(val name: String?, val darkModeEnabled: Boolean?, val pictureUuid: UUID?)
