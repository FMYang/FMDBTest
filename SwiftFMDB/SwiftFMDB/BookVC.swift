////
////  BookVC.swift
////  SwiftFMDB
////
////  Created by yfm on 2023/3/2.
////
//
//import UIKit
//import DatabaseVisual
//
//class BookVC: UIViewController {
//    var datasource: [Book] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    
//    lazy var addButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Add", for: .normal)
//        btn.setTitleColor(.red, for: .normal)
//        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
//        return btn
//    }()
//    
//    lazy var queryButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Query", for: .normal)
//        btn.setTitleColor(.red, for: .normal)
//        btn.addTarget(self, action: #selector(queryAction), for: .touchUpInside)
//        return btn
//    }()
//        
//    lazy var showButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("show", for: .normal)
//        btn.setTitleColor(.red, for: .normal)
//        btn.addTarget(self, action: #selector(showAction), for: .touchUpInside)
//        return btn
//    }()
//    
//    lazy var tableView: UITableView = {
//        let view = UITableView()
//        view.delegate = self
//        view.dataSource = self
//        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        makeUI()
//        queryAction()
//    }
//    
//    @objc func addAction() {
//        let index = arc4random() % 100 + 1
//        let person = Book(name: "book_\(index)", author: "yfm")
//        Book.insert(object: person)
//        queryAction()
//    }
//    
//    @objc func queryAction() {
//        Book.query { [weak self] data in
//            self?.datasource = data
//        }
////        Book.query(where: 5, block: { [weak self] data in
////            self?.datasource = data
////        })
//    }
//        
//    @objc func showAction() {
//        DatabaseManager.sharedInstance().showTables()
//    }
//    
//    func makeUI() {
//        view.addSubview(addButton)
//        view.addSubview(queryButton)
//        view.addSubview(showButton)
//        view.addSubview(tableView)
//        addButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(20)
//            make.left.equalToSuperview()
//            make.height.equalTo(44)
//        }
//        
//        queryButton.snp.makeConstraints { make in
//            make.left.equalTo(addButton.snp.right)
//            make.centerY.equalTo(addButton)
//            make.width.equalTo(addButton)
//        }
//        
//        showButton.snp.makeConstraints { make in
//            make.left.equalTo(queryButton.snp.right)
//            make.centerY.equalTo(queryButton)
//            make.width.equalTo(queryButton)
//            make.right.equalToSuperview()
//        }
//        
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(addButton.snp.bottom).offset(10)
//            make.left.right.bottom.equalToSuperview()
//        }
//    }
//
//}
//
//extension BookVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datasource.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//        let book = datasource[indexPath.row]
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        let str = (book.publishDate != nil) ? formatter.string(from: book.publishDate!) : ""
//        cell.textLabel?.text = "\(book.name), \(book.author), \(str)"
//        return cell
//    }
//}
