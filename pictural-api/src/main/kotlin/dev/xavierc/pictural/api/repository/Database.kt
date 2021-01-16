package dev.xavierc.pictural.api.repository

import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SchemaUtils
import org.jetbrains.exposed.sql.transactions.transaction

fun initDB() {
    // Initialize DB connection
    Database.connect(url = "jdbc:mysql://root:root_pass@localhost:3306/pictural_db", driver = "com.mysql.cj.jdbc.Driver")

    transaction {
        SchemaUtils.createMissingTablesAndColumns(Users, Friends, ImagesInfo, ImagesAuthorizedUsers, Albums, AlbumsAuthorizedUsers, AlbumsImages)
    }
}
