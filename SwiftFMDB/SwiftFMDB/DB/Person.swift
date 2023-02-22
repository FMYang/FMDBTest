//
//  PersonTable.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import FMDB

// https://randomuser.me/api/
struct Person {
    var id: Int = 0
    var name: String = ""
    var age: Int = 0
}

extension Person: DBProtocol {
    
    static var tableName: String {
        return "person"
    }
    
    static var createSql: String {
        return "create table if not exists \(Person.tableName) (id integer primary key autoincrement, name text, age integer)"
    }
    
    var insertSql: String {
        return "insert into \(Person.tableName) (name, age) values ('\(name)','\(age)')"
    }
    
    static var querySql: String {
        return "select * from \(Person.tableName) order by id DESC"
    }
    
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        var person = Person()
        person.id = Int(resultSet.int(forColumn: "id"))
        person.name = resultSet.string(forColumn: "name") ?? ""
        person.age = Int(resultSet.int(forColumn: "age"))
        return person
    }
}
