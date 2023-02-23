//
//  PersonTable.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

//  version1: id, name, age
//  version2: id, name, age, email

import UIKit
import FMDB

// https://randomuser.me/api/
struct Person {
    var id: Int = 0
    var name: String = ""
    var age: Int = 0
    var email: String = ""
    var address: String = ""
    
    static var addEmailSql: String {
        return """
        alter table person
        add column email text,
        add column address text
        """
    }
}

extension Person: DBProtocol {
    
    static var tableName: String {
        return "person"
    }
    
    static var createSql: String {
        return "create table if not exists \(tableName) (id integer primary key autoincrement, name text, age integer)"
    }
    
    var insertSql: String {
        return "insert into \(Person.tableName) (name, age) values ('\(name)','\(age)')"
//        return "insert into \(Person.tableName) (name, age, email) values ('\(name)','\(age)', '\(email)')"
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
        return person
    }
}
