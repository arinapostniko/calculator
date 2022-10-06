//
//  ViewController.swift
//  calculator
//
//  Created by Arina Postnikova on 4.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private properties
    var firstNumber: Double = 0
    var isFirstNumExists = false
    var isFirstDouble = false
    var firstAction = ActionType.nothing
    
    var secondNumber: Double = 0
    var isSecondNumExists = false
    var isSecondDouble = false
    var secondAction = ActionType.nothing
    
    var thirdNumber: Double = 0
    var isThirdNumExists = false
    var isThirdDouble = false
    var thirdAction = ActionType.nothing
    
    var currentNumber:Double = 0
    var curentNumberString = "0"
    var toLabel = "0"
    var isDouble = false
    var isLastComputed = false

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        view.layoutIfNeeded()
        buttons.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var labelText: UILabel!
    
    // MARK: - Private methods
    private func softClear() {
        firstNumber = 0
        isFirstNumExists = false
        isFirstDouble = false
        firstAction = ActionType.nothing
        secondNumber = 0
        isSecondNumExists = false
        isSecondDouble = false
        secondAction = ActionType.nothing
        thirdNumber = 0
        isThirdNumExists = false
        isThirdDouble = false
        thirdAction = ActionType.nothing
    }
    
    private func clear() {
        softClear()
        currentNumber = 0
        curentNumberString = "0"
        toLabel = "0"
        isDouble = false
        isLastComputed = false
    }
    
    // MARK: - IBActions
    @IBAction func tapFuncButtons(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 18:
            clear()
            labelText.text = toLabel
        case 17:
            return
        case 16:
            return
        default:
            return
        }
    }
    
    @IBAction func tapActionButtons(_ sender: UIButton) {
    }
    
    @IBAction func tapNumberButtons(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 15:
            return
        case 14:
            return
        case 13:
            return
        case 12:
            return
        case 11:
            return
        default:
            return
        }
    }
    
}

