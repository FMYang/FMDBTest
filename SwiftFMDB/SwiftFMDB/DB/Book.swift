//
//  Book.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/23.
//

import Foundation
import FMDB

struct Book {
    var name: String = ""
    var author: String = ""
    var pushlishDate: String = ""
}

extension Book: DBProtocol {
    static var tableName: String {
        return "book"
    }
    
    var insertSql: String {
        return "insert into \(Book.tableName) (name, author, publishTime) values ('\(name)', '\(author)', '\(pushlishDate)')"
    }
    
    static var createSql: String {
        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, author text, pushlishDate text)"

    }
    
    static var querySql: String {
        return "select * from \(tableName) order by id DESC"
    }
    
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        var book = Book()
        book.name = resultSet.string(forColumn: "name") ?? ""
        book.author = resultSet.string(forColumn: "author") ?? ""
        book.pushlishDate = resultSet.string(forColumn: "pushlishDate") ?? ""
        return book
    }
    
    
}
