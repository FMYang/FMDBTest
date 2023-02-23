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
    static var tableName: String { get }
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
    public func createTable(sql: String) {
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
    
    // 数据库升级（FMDB支持动态创建新表和删除表，这种情况不需要升级）
    static func upgrade() {
        let manager = FMDBMigrationManager(databaseAtPath: dbPath, migrationsBundle: Bundle.main)
        
        if manager?.hasMigrationsTable == false {
            do {
                try manager?.createMigrationsTable()
            } catch {
                print(error)
            }
        }
        
//        if manager?.needsMigration == false {
//            print("不需要升级")
//            return
//        }
        
        let migration = Migration(name: "在person表中插入email列", version: 5, updateSqlArray: [Person.addEmailSql])
        manager?.addMigration(migration)
        do {
//            print("上一个版本: \(manager?.originVersion ?? 0)")
//            print("当前的版本: \(manager?.currentVersion ?? 0)")
//            print("1: \(manager?.pendingVersions)")
//            print("2: \(manager?.appliedVersions)")

            try manager?.migrateDatabase(toVersion: UInt64.max, progress: { progress in
                if let value = progress?.completedUnitCount, let total = progress?.totalUnitCount {
                    let curProgress = Double(value) / Double(total)
                    print("progress \(curProgress)")
                }
            })
        } catch {
            print(error)
        }
        
    }
}
