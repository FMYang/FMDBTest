//
//  DBManager.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import FMDB

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
    
    static let shared = DBManager()
    
    private init() {}
    
    let dbQueue: FMDatabaseQueue? = FMDatabaseQueue(path: DBManager.dbPath)
    
    // MARK: - public method
    
    // 创建表
    public static func create<T: DBProtocol>(tables: [T.Type]) {
        tables.forEach { createTable(object: $0) }
    }
    
    // 升级表
    public static func upgrade<T: DBProtocol>(tables: [T.Type]) {
        tables.forEach { upgrade(object: $0) }
    }
    
    /// 插入数据
    public static func insert(object: DBProtocol) {
        shared.dbQueue?.inDatabase({ db in
            let success = db.executeUpdate(object.insertSql, withArgumentsIn: [])
            if !success {
                print("insert error \(object.insertSql)")
            }
        })
    }
    
    /// 查询数据
    /// - Parameters:
    ///   - object: 符合<DBProtocol>协议的对象
    ///   - condition: 查询条件
    ///   - groupBy: 分组条件
    ///   - orderBy: 排序条件
    ///   - isDesc: 是否降序，默认升序
    ///   - callBack: 结果回调
    public static func query<T: DBProtocol>(object: T.Type,
                                            condition: String? = nil,
                                            groupBy: String? = nil,
                                            orderBy: String? = nil,
                                            isDesc: Bool = false,
                                            limit: Int? = nil,
                                            offset: Int? = nil,
                                            callBack: @escaping ([DBProtocol])->()) {
        var sql = "select * from \(object.tableName)"
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
                    let model = object.toModel(resultSet: resultSet)
                    result.append(model)
                }
                callBack(result)
                resultSet.close()
                db.close()
            } catch {
                print(error)
            }
        })
    }
    
    // MARK: - private method
    private static func createTable<T: DBProtocol>(object: T.Type) {
        shared.dbQueue?.inDatabase({ db in
            if !db.tableExists(object.tableName) {
                let success = db.executeStatements(object.createSql)
                if !success {
                    print("create table error \(object.createSql)")
                }
            }
        })
    }
    
    /// 升级表
    ///
    /// - 对比当前表的列名及DBProtocol协议中的columns（当前表的所有列表和类型集合），
    /// 不在当前表中的字段，使用alter添加到表中，只有添加列，暂不支持删除列
    private static func upgrade<T: DBProtocol>(object: T.Type) {
        var tableColumns = [String]()
        shared.dbQueue?.inDatabase({ db in
            if let resultSet = db.getTableSchema(object.tableName) {
                while resultSet.next() {
                    if let columnName = resultSet.string(forColumn: "name") {
                        tableColumns.append(columnName)
                    }
                }
            }
        })
        var sqls = [String]()
        for info in object.columns {
            if let name = info.keys.first, let type = info.values.first {
                if !tableColumns.contains(name) {
                    sqls.append("alter table \(object.tableName) add column \(name) \(type)")
                }
            }
        }
        if sqls.count <= 0 { return }
        print("\(object.tableName)表升级: \(sqls)")
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
}
