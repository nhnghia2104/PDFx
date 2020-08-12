//
//  FirstViewController.swift
//  FirstApp
//
//  Created by Nghia NH on 8/10/20.
//  Copyright © 2020 Tab21. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.title = "cc"
    }
    @IBAction func push() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

}

