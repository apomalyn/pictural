/**
* Pictural API
* This API is part of my project for the Shopify Developer intern challenge. This API manage the users, pictures and links between accounts of Pictural.
*
* The version of the OpenAPI document: 0.1.0
* Contact: chretienxavier42@gmail.com
*
* NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
* https://openapi-generator.tech
* Do not edit the class manually.
*/
package dev.xavierc.pictural.api

import io.ktor.locations.KtorExperimentalLocationsAPI
import io.ktor.locations.Location

object Paths {
    /**
     * Delete an existing album
     * 
     * @param albumUuid  
     */
    @KtorExperimentalLocationsAPI
    @Location("/album/{albumUuid}") class AlbumDelete(val albumUuid: java.util.UUID)

    /**
     * Get the list of albums of the current user
     * 
     */
    @KtorExperimentalLocationsAPI
    @Location("/albums") class AlbumsGet()

    /**
     * Delete an image
     * 
     * @param imageUuid UUID of the image to delete 
     * @param friendUuid  
     */
    @KtorExperimentalLocationsAPI
    @Location("/image/{imageUuid}/{friendUuid}") class ImageAccessDelete(val imageUuid: java.util.UUID, val friendUuid: java.util.UUID)

    /**
     * Delete an image
     * 
     * @param imageUuid UUID of the image to delete 
     */
    @KtorExperimentalLocationsAPI
    @Location("/image/{imageUuid}") class ImageDelete(val imageUuid: java.util.UUID)

    /**
     * Get an image
     * 
     * @param imageUuid  
     */
    @KtorExperimentalLocationsAPI
    @Location("/image/{imageUuid}") class ImageGet(val imageUuid: java.util.UUID)

    /**
     * Get the information of an image
     * 
     * @param imageUuid  
     */
    @KtorExperimentalLocationsAPI
    @Location("/image/{imageUuid}/info") class ImageInfoGet(val imageUuid: java.util.UUID)

    /**
     * Get the list of images info of the current user
     * 
     */
    @KtorExperimentalLocationsAPI
    @Location("/images") class ImagesGet()

    /**
     * Remove a friend from the list
     * 
     * @param friendUuid UUID of the friend to remove 
     */
    @KtorExperimentalLocationsAPI
    @Location("/user/friends/{friendUuid}") class UserFriendsDelete(val friendUuid: java.util.UUID)

    /**
     * Get the list of friend for this user.
     * 
     */
    @KtorExperimentalLocationsAPI
    @Location("/user/friends") class UserFriendsGet()

    /**
     * Get the information of the user.
     * Will return the user information which include his name, his list of friends and if the dark mode is activated
     */
    @KtorExperimentalLocationsAPI
    @Location("/user") class UserInfoGet()

    @KtorExperimentalLocationsAPI
    @Location("/user/login") class UserLogin()
}
