////
////  DBManager1.swift
////  SwiftFMDB
////
////  Created by yfm on 2023/3/2.
////
//
//import Foundation
//import FMDB
//
//class DBManager1 {
//    static let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    static let dbPath = documentPath.appending("/test.db")
//    
//    static let shared = DBManager1()
//    private init() {}
//    let dbQueue: FMDatabaseQueue? = FMDatabaseQueue(path: DBManager1.dbPath)
//    
//    static func asyncExcute(block: @escaping (FMDatabase)->()) {
//        DispatchQueue.global().async {
//            shared.dbQueue?.inDatabase({ db in
//                block(db)
//            })
//        }
//    }
//    
//    static func syncExcute(block: @escaping (FMDatabase)->()) {
//        shared.dbQueue?.inDatabase({ db in
//            block(db)
//        })
//    }
//    
//    static func createTables() {
//        DispatchQueue.global().async {
//            shared.dbQueue?.inTransaction({ db, rollback  in
//                let success = db.executeStatements(Book.createSql)
//                if !success {
//                    rollback.pointee = true
//                    print("create book table error")
//                }
//            })
//        }
//    }
//}
