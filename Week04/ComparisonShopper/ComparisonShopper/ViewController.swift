//
//  ViewController.swift
//  ComparisonShopper
//
//  Created by Jay Strawn on 6/15/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Left
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var priceLabelLeft: UILabel!
    @IBOutlet weak var roomLabelLeft: UILabel!

    // Right
    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var priceLabelRight: UILabel!
    @IBOutlet weak var roomLabelRight: UILabel!

    var house1: House?
    var house2: House?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        house1 = House()
        house1?.price = "$12,000"
        house1?.bedrooms = "3 bedrooms"
        
        setUpLeftSideUI()
        setUpRightSideUI()
    }

    func setUpLeftSideUI() {
        [titleLabelLeft, imageViewLeft, priceLabelLeft, roomLabelLeft].forEach{
            $0.alpha = (house1 == nil ? 0 : 1)
        }
        [titleLabelLeft, priceLabelLeft, roomLabelLeft].forEach{
            $0.text = ""
        }
        if let address = house1?.address {
            titleLabelLeft.text = address
        } else {
            titleLabelLeft.text = "no title info"
        }
        if let price = house1?.price {
            priceLabelLeft.text = price
        } else {
            priceLabelLeft.text = "no price info"
        }
        if let bedrooms = house1?.bedrooms {
            roomLabelLeft.text = bedrooms
        } else {
            roomLabelLeft.text = "no bedroom info"
        }
    }

    func setUpRightSideUI() {
        [titleLabelRight, imageViewRight, priceLabelRight, roomLabelRight].forEach{
            $0.alpha = (house2 == nil ? 0 : 1)
        }
        [titleLabelRight, priceLabelRight, roomLabelRight].forEach{
            $0.text = ""
        }
        if let address = house2?.address {
            titleLabelRight.text = address
        } else {
            titleLabelRight.text = "no title info"
        }
        if let price = house2?.price {
            priceLabelRight.text = price
        } else {
            priceLabelRight.text = "no price info"
        }
        if let bedrooms = house2?.bedrooms {
            roomLabelRight.text = bedrooms
        } else {
            roomLabelRight.text = "no bedroom info"
        }
    }

    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "address"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "price"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "bedrooms"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            var house = House()
            house.address = alert.textFields?[0].text
            house.price = alert.textFields?[1].text
            house.bedrooms = alert.textFields?[2].text
            self.house2 = house
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

struct House {
    var address: String?
    var price: String?
    var bedrooms: String?
}

