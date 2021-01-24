package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.settings
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SchemaUtils
import org.jetbrains.exposed.sql.transactions.transaction

fun initDB() {
    val username = settings.property("pictural.database.username").getString()
    val password = settings.property("pictural.database.password").getString()
    val url = settings.property("pictural.database.url").getString()
    val db_name = settings.property("pictural.database.db_name").getString()

    // Initialize DB connection
    Database.connect(url = "jdbc:mysql://$username:$password@$url/$db_name", driver = "com.mysql.cj.jdbc.Driver")

    transaction {
        SchemaUtils.createMissingTablesAndColumns(Users, Friends, ImagesInfo, ImagesAuthorizedUsers, Albums, AlbumsAuthorizedUsers, AlbumsImages)
    }
}
