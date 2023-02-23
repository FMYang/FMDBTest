//
//  DBVC.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import DatabaseVisual

class DBVC: UIViewController {
            
    var datasource: [Person] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var queryButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Query", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(queryAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var upgradeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("upgrade", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(upgradeAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var showButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("show", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeUI()
        queryAction()
    }
    
    @objc func addAction() {
        let age = Int(10 + arc4random() % (50 - 10 + 1))
        let person = Person(name: "test", age: age, email: "11@qq.com")
        DBManager.insert(object: person)
        queryAction()
    }
    
    @objc func queryAction() {
        DBManager.query(object: Person.self) { [weak self] data in
            if let data = data as? [Person] {
                DispatchQueue.main.async {
                    self?.datasource = data
                }
            }
        }
    }
    
    @objc func upgradeAction() {
        DBManager.upgrade()
    }
    
    @objc func showAction() {
        DatabaseManager.sharedInstance().showTables()
    }
    
    func makeUI() {
        view.addSubview(addButton)
        view.addSubview(queryButton)
        view.addSubview(upgradeButton)
        view.addSubview(showButton)
        view.addSubview(tableView)
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.height.equalTo(44)
        }
        
        queryButton.snp.makeConstraints { make in
            make.left.equalTo(addButton.snp.right)
            make.centerY.equalTo(addButton)
            make.width.equalTo(addButton)
        }
        
        upgradeButton.snp.makeConstraints { make in
            make.left.equalTo(queryButton.snp.right)
            make.centerY.equalTo(queryButton)
            make.width.equalTo(queryButton)
        }
        
        showButton.snp.makeConstraints { make in
            make.left.equalTo(upgradeButton.snp.right)
            make.centerY.equalTo(upgradeButton)
            make.width.equalTo(upgradeButton)
            make.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension DBVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let person = datasource[indexPath.row]
        cell.textLabel?.text = "name = \(person.name)_\(person.id), age = \(person.age)"
        return cell
    }
}
