//
//  Migration.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/22.
//

import Foundation
import FMDBMigrationManager

class Migration:NSObject, FMDBMigrating {
    
    public private(set) var name: String = ""
    
    public private(set) var version: UInt64 = 0
    
    public private(set) var updateSqlArray: [String] = []
    
    func migrateDatabase(_ database: FMDatabase!) throws {
        for sql in updateSqlArray {
            database.executeUpdate(sql, withArgumentsIn: [])
        }
    }
    
    override init() {
        super.init()
    }
    
    required init(name: String, version: UInt64, updateSqlArray: [String]) {
        self.name = name
        self.version = version
        self.updateSqlArray = updateSqlArray
    }
}


