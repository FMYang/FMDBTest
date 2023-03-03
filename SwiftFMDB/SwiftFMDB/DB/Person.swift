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

// https://randomuser.me/api/
struct Person {
    var id: Int = 0
    var name: String = ""
    var age: Int = 0
    var email: String = ""
    var address: String = ""
    var tel: String = ""
    
    // 版本1
    static var upgradeVersion1Sql: [String] {
        return ["alter table person add column email text default ''",
                "alter table person add column address text default ''"]
    }
    
    // 版本2
    static var upgradeVersion2Sql: [String] {
        return ["alter table person add column tel text default ''"]
    }
}

extension Person: DBProtocol {
    
    static var tableName: String {
        return "person"
    }
    
    static var createSql: String {
        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, age integer)"
//        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, age integer, email text, address text, tel text)"
    }
    
    var insertSql: String {
        return "insert into \(Person.tableName) (name, age) values ('\(name)','\(age)')"
//        return "insert into \(Person.tableName) (name, age, email, address, tel) values ('\(name)','\(age)', '\(email)', '\(address)', '\(tel)')"
    }
    
    static var querySql: String {
        return "select * from \(tableName) order by id DESC"
    }
    
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        var person = Person()
        person.id = Int(resultSet.int(forColumn: "id"))
        person.name = resultSet.string(forColumn: "name") ?? ""
        person.age = Int(resultSet.int(forColumn: "age"))
//        person.email = resultSet.string(forColumn: "email") ?? ""
//        person.address = resultSet.string(forColumn: "address") ?? ""
//        person.tel = resultSet.string(forColumn: "tel") ?? ""
        return person
    }
}
