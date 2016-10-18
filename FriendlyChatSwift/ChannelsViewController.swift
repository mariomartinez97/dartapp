//
//  ChannelsViewController.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/12/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {

    @IBOutlet weak var textBox: UITextField!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    var list = ["1","2","3"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func numberOfComponents(in pickerView: UIPickerView) -> Int{ return 1 }
    
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{ return list.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { self.view.endEditing(true); return list[row] }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { self.textBox.text = self.list[row]; self.dropDown.isHidden = true }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { if textField == self.textBox { self.dropDown.isHidden = false
        //if you dont want the users to se the keyboard type: 
        textField.endEditing(true) }
    }

}
