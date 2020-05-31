//
//  InfoViewController.swift
//  hwweek1
//
//  Created by Руслан Рахимов on 31.05.2020.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://en.wikipedia.org/wiki/RGB_color_model")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
