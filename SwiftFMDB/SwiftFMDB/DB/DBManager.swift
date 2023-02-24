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
    
    static let lastestVersion = 2
    
    static let shared = DBManager()

    private init() {
        print("init")
        createTable(sql: Person.createSql)
    }
    
    static let dbPath = NSTemporaryDirectory().appending("tmp.db")
    
    let dbQueue: FMDatabaseQueue? = FMDatabaseQueue(path: dbPath)
    
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
        if DBManager.shared.dbVersion >= lastestVersion {
            print("已是最新版本, 不需要升级")
            return
        }
        
        print("从\(DBManager.shared.dbVersion)升级到版本\(lastestVersion)")
        let manager = FMDBMigrationManager(databaseAtPath: dbPath, migrationsBundle: Bundle.main)
        
        if manager?.hasMigrationsTable == false {
            do {
                try manager?.createMigrationsTable()
            } catch {
                print(error)
            }
        }
        
        let migration1 = Migration(name: "升级第1个版本", version: 1, updateSqlArray: Person.upgradeVersion1Sql)
        let migration2 = Migration(name: "升级第2个版本", version: 2, updateSqlArray: Person.upgradeVersion2Sql)
        manager?.addMigration(migration1)
        manager?.addMigration(migration2)
        do {
            try manager?.migrateDatabase(toVersion: UInt64.max, progress: { progress in
                if let value = progress?.completedUnitCount, let total = progress?.totalUnitCount {
                    let curProgress = Double(value) / Double(total)
                    print("progress \(curProgress)")
                }
            })
        } catch {
            print(error)
        }
        
        // 更新版本号
        DBManager.shared.dbVersion = DBManager.lastestVersion
    }
}

extension DBManager {
    var dbVersion: Int {
        get {
            return UserDefaults.standard.object(forKey: "version") as? Int ?? 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "version")
        }
    }
}
