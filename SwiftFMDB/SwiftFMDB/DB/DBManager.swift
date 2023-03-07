//
//  DBManager.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import FMDB
//import FMDBMigrationManager

protocol DBProtocol {
    var insertSql: String { get }
    static var tableName: String { get }
    static var createSql: String { get }
    static func toModel(resultSet: FMResultSet) -> DBProtocol
    static var columns: [[String: String]] { get }
}

class DBManager {
    
    static let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static let dbPath = documentDir.appending("/tmp.db")

    static let lastestVersion = 0
    
    static let shared = DBManager()

    private init() {}
        
    let dbQueue: FMDatabaseQueue? = FMDatabaseQueue(path: DBManager.dbPath)
    
    public static func createTables() {
        createTable(object: Person.self)
    }
    
    public static func createTable<T: DBProtocol>(object: T.Type) {
        shared.dbQueue?.inDatabase({ db in
            if !db.tableExists(Person.tableName) {
                let success = db.executeStatements(T.createSql)
                if !success {
                    print("create table error \(T.createSql)")
                }
            }
        })
    }
    
    /// 插入
    static func insert(object: DBProtocol) {
        shared.dbQueue?.inDatabase({ db in
            let success = db.executeUpdate(object.insertSql, withArgumentsIn: [])
            if !success {
                print("insert error \(object.insertSql)")
            }
        })
    }
    
    /// 查询
    /// - Parameters:
    ///   - object: 符合<DBProtocol>协议的对象
    ///   - condition: 查询条件
    ///   - groupBy: 分组条件
    ///   - orderBy: 排序条件
    ///   - isDesc: 是否降序，默认升序
    ///   - callBack: 结果回调
    static func query<T: DBProtocol>(object: T.Type,
                                     condition: String? = nil,
                                     groupBy: String? = nil,
                                     orderBy: String? = nil,
                                     isDesc: Bool = false,
                                     limit: Int? = nil,
                                     offset: Int? = nil,
                                     callBack: @escaping ([DBProtocol])->()) {
        var sql = "select * from \(T.tableName)"
        if let condition = condition {
            sql += " where \(condition)"
        }
        if let groupBy = groupBy {
            sql += " group by \(groupBy)"
        }
        if let orderBy = orderBy {
            sql += " order by \(orderBy)"
        }
        sql += isDesc ? " desc" : ""
        if let limit = limit {
            sql += " limit \(limit)"
        }
        print(sql)
        shared.dbQueue?.inDatabase({ db in
            do {
                var result: [DBProtocol] = []
                let resultSet = try db.executeQuery(sql, values: nil)
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
        var tableColumns = [String]()
        shared.dbQueue?.inDatabase({ db in
            if let resultSet = db.getTableSchema(Person.tableName) {
                while resultSet.next() {
                    if let columnName = resultSet.string(forColumn: "name") {
                        tableColumns.append(columnName)
                    }
                }
            }
        })
        var sqls = [String]()
//        for column in Person.columnSet {
//            if !tableColumns.contains(column) {
//                sqls.append("alter table \(Person.tableName) add column \(column) text")
//            }
//        }
        for info in Person.columns {
            if let name = info.keys.first, let type = info.values.first {
                if !tableColumns.contains(name) {
                    sqls.append("alter table \(Person.tableName) add column \(name) \(type)")
                }
            }
        }
        if sqls.count <= 0 { return }
        print("数据库升级: " + sqls.joined(separator: ";"))
        shared.dbQueue?.inDatabase({ db in
            sqls.forEach {
                do {
                    try db.executeUpdate($0, values: nil)
                } catch {
                    print(error)
                }
            }
        })
    }
    
//    // 数据库升级（FMDB支持动态创建新表和删除表，这种情况不需要升级）
//    static func upgrade() {
//        if DBManager.shared.dbVersion >= lastestVersion {
//            print("已是最新版本, 不需要升级")
//            return
//        }
//
//        print("从\(DBManager.shared.dbVersion)升级到版本\(lastestVersion)")
//        let manager = FMDBMigrationManager(databaseAtPath: dbPath, migrationsBundle: Bundle.main)
//
//        if manager?.hasMigrationsTable == false {
//            do {
//                try manager?.createMigrationsTable()
//            } catch {
//                print(error)
//            }
//        }
//
//        let migration1 = Migration(name: "升级第1个版本", version: 1, updateSqlArray: Person.upgradeVersion1Sql)
//        let migration2 = Migration(name: "升级第2个版本", version: 2, updateSqlArray: Person.upgradeVersion2Sql)
//        manager?.addMigration(migration1)
//        manager?.addMigration(migration2)
//        do {
//            try manager?.migrateDatabase(toVersion: UInt64.max, progress: { progress in
//                if let value = progress?.completedUnitCount, let total = progress?.totalUnitCount {
//                    let curProgress = Double(value) / Double(total)
//                    print("progress \(curProgress)")
//                }
//            })
//        } catch {
//            print(error)
//        }
//
//        // 更新版本号
//        DBManager.shared.dbVersion = DBManager.lastestVersion
//    }
}

//extension DBManager {
//    var dbVersion: Int {
//        get {
//            return UserDefaults.standard.object(forKey: "version") as? Int ?? 0
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "version")
//        }
//    }
//}
