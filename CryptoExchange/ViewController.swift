//
//  ViewController.swift
//  CryptoExchange
//
//  Created by Andrey Gumen on 09.10.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.shared.getAssets { models in
            print(models)
        }
    }

}

