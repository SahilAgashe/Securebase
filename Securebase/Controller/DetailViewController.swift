//
//  DetailViewController.swift
//  Securebase
//
//  Created by SAHIL AMRUT AGASHE on 22/06/24.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfNote: UITextField!
    var noteText: String? {
        didSet {
            configureUI()
        }
    }
    
    func configureUI() {
        if let tf = tfNote {
            tf.text = self.noteText ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.noteText = tfNote.text
    }
    
}


