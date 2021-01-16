package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.models.Friend
import dev.xavierc.pictural.api.models.User
import dev.xavierc.pictural.api.utils.UuidDontExistException
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.transactions.transaction
import java.lang.Exception
import java.util.*

object Users : Table() {
    val uuid: Column<String> = varchar("uuid", 128).primaryKey()
    val name: Column<String> = varchar("name", 128)
    val darkModeEnabled: Column<Boolean> = bool("darkModeEnabled").default(false)
    val pictureUuid: Column<UUID?> = (uuid("pictureUuid") references ImagesInfo.uuid).nullable()
}

object Friends : Table() {
    val userUuid: Column<String> = varchar("userUuid", 128) references Users.uuid
    val friendUuid: Column<String> = varchar("friendUuid", 128) references Users.uuid
}

class UserRepository {
    /**
     * Get the information of the user corresponding to [uuid]
     */
    fun getUserInfo(uuid: String): User? {
        var user: User? = null
        transaction {
            val results = Users.select { Users.uuid eq uuid }.singleOrNull()

            if (results != null) {
                user = User(uuid, results[Users.name], results[Users.darkModeEnabled], results[Users.pictureUuid])
            }
        }

        return user
    }

    /**
     * Update the user info of [uuid]
     */
    fun updateUserInfo(uuid: String, name: String?, darkModeEnabled: Boolean?, pictureUuid: UUID?) {
        transaction {
            Users.update(where = { Users.uuid eq uuid }, limit = 1) {
                if (name != null) {
                    it[Users.name] = name
                }

                if (darkModeEnabled != null) {
                    it[Users.darkModeEnabled] = darkModeEnabled
                }

                if (pictureUuid != null) {
                    it[Users.pictureUuid] = pictureUuid
                }
            }
        }
    }

    /**
     * Create an user
     */
    fun addUserInfo(uuid: String, name: String, pictureUuid: UUID?) {
        transaction {
            Users.insert {
                it[Users.uuid] = uuid
                it[Users.name] = name

                if (pictureUuid != null) {
                    it[Users.pictureUuid] = pictureUuid
                }
            }
        }
    }

    /**
     * Return the list of friends for [userUuid]
     */
    fun getFriendsList(userUuid: String): List<Friend> {
        val friendList: MutableList<Friend> = mutableListOf()

        transaction {
            Friends.join(Users, JoinType.LEFT, additionalConstraint = { Friends.friendUuid eq Users.uuid })
                .slice(Friends.friendUuid, Users.name, Users.pictureUuid)
                .select { Friends.userUuid eq userUuid }.forEach {
                    friendList.add(Friend(it[Friends.friendUuid], it[Users.name], it[Users.pictureUuid]))
                }
        }

        return friendList.toList()
    }

    /**
     * Creation a friendship between [userUuid] and [friendUuid]
     */
    fun addFriend(userUuid: String, friendUuid: String): Boolean {
        try {
            transaction {
                if (Users.select(Users.uuid.eq(userUuid) or Users.uuid.eq(friendUuid)).count() != 2) {
                    throw UuidDontExistException()
                }
                Friends.insert {
                    it[Friends.userUuid] = userUuid
                    it[Friends.friendUuid] = friendUuid
                }
                // Do the friendship on the other side.
                // TODO improve schema
                Friends.insert {
                    it[Friends.userUuid] = friendUuid
                    it[Friends.friendUuid] = userUuid
                }
            }
        } catch (e: UuidDontExistException) {
            // TODO improve login
            print("userUuid or friendUuid not found inside the database")
            return false
        }
        return true
    }

    /**
     * Remove the friendship between [userUuid] and [friendUuid]
     */
    fun deleteFriend(userUuid: String, friendUuid: String): Boolean {
        try {
            transaction {
                Friends.deleteWhere { Friends.userUuid.eq(userUuid) or Friends.userUuid.eq(friendUuid) }
            }
        } catch (e: Exception) {
            print(e.message)
            return false
        }
        return true
    }
}
