//
//  PersonTable.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

//  version1: id, name, age
//  version2: id, name, age, email, address

import UIKit
import FMDB

struct Person {
    var id: Int = 0
    var name: String = ""
    var age: Int = 0
    var email: String = ""
    var address: String = ""
    var tel: String = ""
    var son: Int = 0
}

extension Person: DBProtocol {
    
    static var tableName: String {
        return "person"
    }

    static var columns: [[String: String]] {
//        return [["id": "integer"],["name": "text"],["age": "integer"]]
        return [["id": "integer"],
                ["name": "text"],
                ["age": "integer"],
                ["email": "text"],
                ["address": "text"],
                ["tel": "text"],
                ["son": "integer"]]
    }
    
    static var createSql: String {
//        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, age integer)"
        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, age integer, email text, address text, tel text, son integer)"
    }
    
    var insertSql: String {
//        return "insert into \(Person.tableName) (name, age) values ('\(name)', \(age))"
        return "insert or replace into \(Person.tableName) (name, age, email, address, tel, son) values ('\(name)', \(age), '\(email)', '\(address)', '\(tel)', \(son))"
    }
        
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        var person = Person()
        person.id = Int(resultSet.int(forColumn: "id"))
        person.name = resultSet.string(forColumn: "name") ?? ""
        person.age = Int(resultSet.int(forColumn: "age"))
        person.email = resultSet.string(forColumn: "email") ?? ""
        person.address = resultSet.string(forColumn: "address") ?? ""
        person.tel = resultSet.string(forColumn: "tel") ?? ""
        person.son = Int(resultSet.int(forColumn: "son"))
        return person
    }
}
