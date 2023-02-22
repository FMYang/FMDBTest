//
//  DBManager.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import FMDB
import FMDBMigrationManager

protocol DBProtocol {
    var insertSql: String { get }
    static var createSql: String { get }
    static var querySql: String { get }
    static func toModel(resultSet: FMResultSet) -> DBProtocol
}

class DBManager {
    
    static let shared = DBManager()

    private init() {
        createTable(sql: Person.createSql)
    }
    
    static let dbPath = NSTemporaryDirectory().appending("tmp.db")
    
    let dbQueue: FMDatabaseQueue? = FMDatabaseQueue(path: dbPath)
    
    // 2.create table
    private func createTable(sql: String) {
        dbQueue?.inDatabase({ db in
            print("1 \(Thread.current)")
            let success = db.executeStatements(sql)
            if !success {
                print("create table error \(sql)")
            }
        })
    }
    
    static func insert(object: DBProtocol) {
        DBManager.shared.dbQueue?.inDatabase({ db in
            print("22 \(Thread.current)")
            let success = db.executeUpdate(object.insertSql, withArgumentsIn: [])
            if !success {
                print("insert error \(object.insertSql)")
            }
        })
    }
    
    static func query<T: DBProtocol>(object: T.Type, callBack: @escaping ([DBProtocol])->()) {
        DBManager.shared.dbQueue?.inDatabase({ db in
            do {
                var result: [DBProtocol] = []
                let resultSet = try db.executeQuery(T.querySql, values: nil)
                while resultSet.next() {
                    let person = T.toModel(resultSet: resultSet)
                    result.append(person)
                }
                callBack(result)
                resultSet.close()
                db.close()
            } catch {
                print(error)
            }
        })
    }
    
    static func upgrade() {
        let manager = FMDBMigrationManager(databaseAtPath: dbPath, migrationsBundle: Bundle.main)
    }
}
