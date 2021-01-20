# Pictural

Pictural is an image repository to upload and share your pictures with your friends and 
loved ones. 

This project was built to satisfy the shopify Challenge for Summer 2021.

## Details

The project is divided in two parts: the `pictural api` and the `ui`.

### Pictural API (backend)

**Framework**: [Ktor](http://ktor.io/)

**Programming language**: [Kotlin](https://kotlinlang.org/)

**Depends on**: An _MySQL_ database.

**Repository**: Available [here](https://github.com/apomalyn/pictural/tree/main/pictural-api).

**Description**: The API manage the users, pictures, albums and all the links between them.
The API follows the [OpenAPI initiative](https://www.openapis.org/) and so you can find its
contract: [here](https://apomalyn.github.io/pictural/#overview). The authentification 
use OAuth2 with Google Sign In API.

### UI (frontend)

**Framework**: [Flutter](http://flutter.dev)

**Programming language**: [Dart](https://dart.dev)

**Depends on**: the _Pictural API_

**Repository**: Available [here](https://github.com/apomalyn/pictural/tree/main/pictural).

**Description**: This is the interface used by the user to upload and manage its pictures.


## Features

Below you can find the list of general features of the platform. You can also head to the issues/project section to see
the progression of features.

[![GitHub issues](https://img.shields.io/github/issues/Naereen/StrapDown.js.svg)](https://github.com/apomalyn/pictural/issues)


| Name                          	| Description                                                                                                  	| Implemented 	|
|-------------------------------	|--------------------------------------------------------------------------------------------------------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| User sign in/up               	| Allow a user to sign in/up into the UI and be authenticated on the API.                                      	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-Done-green.svg)](https://shields.io/)           |
| User sign out                 	| Allow a user to sign out.                                                                                    	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Upload an image               	| Allow a user to upload an image.                                                                             	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-Done-green.svg)](https://shields.io/)           |
| Share an image                	| Allow a user to share an image with other user of the platform.                                              	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Remove access of an image     	| Allow a user to remove the access of a user for one image.                                                   	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Delete an image               	| Allow a user to delete (definitively) an image.                                                              	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Retrieve images               	| Allow a user to get all the images he owns or that is shared with him..                                      	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-Done-green.svg)](https://shields.io/) |
| Create an album               	| Allow a user to create an album shared with other users and that contains one or multiples images.           	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Manage an album               	| Allow a user to manage an album, changes is title, add/remove images and share/remove access to other users. 	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Delete an album               	| Allow a user to delete (definitively) an album.                                                              	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Retrieve albums               	| Allow to retrieve a specific or all the albums he owns or that is shared with him.                           	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Search a user                 	| Allow a user to search other user on the platform.                                                           	| [![API](https://img.shields.io/badge/API-No-red.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)                   |
| Add a user as a friend        	| Allow a user to add another user on his friends list.                                                        	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Remove a friend from the list 	| Allow a user to remove another user from his friends list.                                                   	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
| Retrieve friends list         	| Allow a user to retrieve his friends list.                                                                   	| [![API](https://img.shields.io/badge/API-Done-green.svg)](https://shields.io/) [![ui](https://img.shields.io/badge/UI-No-red.svg)](https://shields.io/)               |
