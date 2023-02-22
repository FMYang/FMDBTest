//
//  ViewController.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Button", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc func btnClick() {
        let vc = DBVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}

