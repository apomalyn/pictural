package dev.xavierc.pictural.api.repository

import dev.xavierc.pictural.api.settings
import io.ktor.config.*
import io.ktor.util.*
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SchemaUtils
import org.jetbrains.exposed.sql.transactions.transaction

@KtorExperimentalAPI
fun initDB(dbConfig: ApplicationConfig) {

    val username = dbConfig.property("username").getString()
    val password = dbConfig.property("password").getString()
    val url = dbConfig.property("url").getString()
    val dbName = dbConfig.property("db_name").getString()

    // Initialize DB connection
    Database.connect(url = "jdbc:mysql://$username:$password@$url/$dbName", driver = "com.mysql.cj.jdbc.Driver")

    transaction {
        SchemaUtils.createMissingTablesAndColumns(Users, Friends, ImagesInfo, ImagesAuthorizedUsers, Albums, AlbumsAuthorizedUsers, AlbumsImages)
    }
}
