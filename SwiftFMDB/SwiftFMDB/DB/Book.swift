//
//  Book.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/23.
//

import Foundation
import FMDB

struct Book {
    var id: Int = 0
    var name: String = ""
    var author: String = ""
    var publishDate: Date?
}

//extension Book {
//
//    static var tableName: String {
//        return "Book"
//    }
//
//    static var createSql: String {
//        return """
//               create table if not exists \(tableName) (
//                    id integer primary key,
//                    name text,
//                    author text,
//                    publishDate text
//               )
//               """
//    }
//
//    // 插入
//    static func insert(object: Book) {
//        DBManager1.asyncExcute { db in
//            do {
//                try db.executeUpdate("insert or replace into \(tableName) (name, author, publishDate) values (?,?,?)", values: [object.name, object.author, object.publishDate ?? Date()])
//            } catch {
//                print(error)
//            }
//        }
//    }
//
//    //
//    static func query(block: @escaping ([Book])->()) {
//        DBManager1.asyncExcute { db in
//            do {
//                let ret = try db.executeQuery("select * from \(tableName)", values: nil)
//                var result = [Book]()
//                while ret.next() {
//                    var book = Book()
//                    book.id = Int(ret.int(forColumn: "id"))
//                    book.name = ret.string(forColumn: "name") ?? ""
//                    book.author = ret.string(forColumn: "author") ?? ""
//                    book.publishDate = ret.date(forColumn: "publishDate")
//                    result.append(book)
//                }
//                DispatchQueue.main.async {
//                    block(result)
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//
//    static func query(where id: Int, block: @escaping ([Book])->()) {
//        DBManager1.asyncExcute { db in
//            do {
//                let ret = try db.executeQuery("select * from \(tableName) where id = ?", values: [id])
//                var result = [Book]()
//                while ret.next() {
//                    var book = Book()
//                    book.id = Int(ret.int(forColumn: "id"))
//                    book.name = ret.string(forColumn: "name") ?? ""
//                    book.author = ret.string(forColumn: "author") ?? ""
//                    book.publishDate = ret.date(forColumn: "publishDate")
//                    result.append(book)
//                }
//                DispatchQueue.main.async {
//                    block(result)
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//}

//extension Book: DBProtocol {
//    static var tableName: String {
//        return "book"
//    }
//
//    var insertSql: String {
//        return "insert into \(Book.tableName) (name, author, publishTime) values ('\(name)', '\(author)', '\(pushlishDate)')"
//    }
//
//    static var createSql: String {
//        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, author text, pushlishDate text)"
//
//    }
//
//    static var querySql: String {
//        return "select * from \(tableName) order by id DESC"
//    }
//
//    static func toModel(resultSet: FMResultSet) -> DBProtocol {
//        var book = Book()
//        book.name = resultSet.string(forColumn: "name") ?? ""
//        book.author = resultSet.string(forColumn: "author") ?? ""
//        book.pushlishDate = resultSet.string(forColumn: "pushlishDate") ?? ""
//        return book
//    }
//}
