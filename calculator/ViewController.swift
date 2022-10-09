//
//  ViewController.swift
//  calculator
//
//  Created by Arina Postnikova on 4.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private properties
    private var firstNumber: Double = 0
    private var isFirstNumExists = false
    private var isFirstDouble = false
    private var firstAction = ActionType.none
    
    private var secondNumber: Double = 0
    private var isSecondNumExists = false
    private var isSecondDouble = false
    private var secondAction = ActionType.none
    
    private var thirdNumber: Double = 0
    private var isThirdNumExists = false
    private var isThirdDouble = false
    private var thirdAction = ActionType.none
    
    private var currentNumber:Double = 0
    private var currentNumberString = "0"
    private var toLabel = "0"
    private var isDouble = false
    private var isLastComputed = false

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelText.numberOfLines = 1
        labelText.adjustsFontForContentSizeCategory = true
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
    
    @IBOutlet weak var labelField: UIView!
    
    // MARK: - Private methods
    private func softClear() {
        firstNumber = 0
        isFirstNumExists = false
        isFirstDouble = false
        firstAction = ActionType.none
        secondNumber = 0
        isSecondNumExists = false
        isSecondDouble = false
        secondAction = ActionType.none
        thirdNumber = 0
        isThirdNumExists = false
        isThirdDouble = false
        thirdAction = ActionType.none
    }
    
    private func clear() {
        softClear()
        currentNumber = 0
        currentNumberString = "0"
        toLabel = "0"
        isDouble = false
        isLastComputed = false
    }
    
    private func tapNumber(num: Int) {
        if (labelText.text == "Ошибка" || isLastComputed) {
            clear()
        }
        if (isDouble) {
            if (currentNumberString.count >= 10) {
                return
            }
            toLabel += String(num)
            currentNumberString += String(num)
            currentNumber = Double(currentNumberString) ?? currentNumber
            labelText.text = toLabel
            return
        }
        if (currentNumberString == "0") {
            currentNumberString = ""
        }
        if (currentNumberString.count >= 9) {
            return
        }
        currentNumberString += String(num)
        currentNumber = Double(currentNumberString) ?? 0
        toLabel = currentNumberString
        setSpacesToLabel()
        labelText.text = toLabel
    }
    
    private func setSpacesToLabel() {
        if (toLabel.count > 6) {
            toLabel.insert(" ", at: toLabel.index(toLabel.endIndex, offsetBy: -6))
        }
        if (toLabel.count > 3) {
            toLabel.insert(" ", at: toLabel.index(toLabel.endIndex, offsetBy: -3))
        }
    }
    
    private func newNumber (actionType: ActionType = .none) {
        if (labelText.text == "Ошибка") {
            return
        }
        if (!isFirstNumExists) {
            isFirstNumExists = true
            firstNumber = currentNumber
            if (actionType != .none) {
                firstAction = actionType
            }
            toNextNumber()
        } else {
            if(!isSecondNumExists) {
                isSecondNumExists = true
                secondNumber = currentNumber
                if (actionType != .none) {
                    secondAction = actionType
                }
                toNextNumber()
            } else {
                if(!isThirdNumExists) {
                    isThirdNumExists = true
                    thirdNumber = currentNumber
                    if (actionType != .none) {
                        thirdAction = actionType
                    }
                    toNextNumber()
                } else {
                    precompute()
                    isThirdNumExists = true
                    thirdNumber = currentNumber
                    if (actionType != .none) {
                        thirdAction = actionType
                    }
                    toNextNumber()
                }
            }
        }
    }
    
    private func precompute() {
        let fs: Bool = (firstAction == .plus || firstAction == .minus)
        let ff: Bool = (firstAction == .multiply || firstAction == .divide)
        let ss: Bool = (secondAction == .plus || secondAction == .minus)
        let sf: Bool = (secondAction == .multiply || secondAction == .divide)
        
        if ((fs && ss) || (ff && sf) || (ff && ss)) {
            _ = computeFirstAction()
            secondNumber = thirdNumber
            firstAction = secondAction
            isSecondDouble = isThirdDouble
            thirdNumber = 0
            thirdAction = .none
            isThirdNumExists = false
            isThirdDouble = false
        } else {
            computeSecondAction()
            secondAction = thirdAction
            thirdNumber = 0
            thirdAction = .none
            isThirdNumExists = false
            isThirdDouble = false
        }
    }
    
    private func toNextNumber() {
        currentNumber = 0
        currentNumberString = "0"
        toLabel = "0"
        isDouble = false
        isLastComputed = false
    }
    
    private func computeFirstAction() -> String {
        if (isFirstNumExists && isSecondNumExists) {
            switch firstAction {
            case .plus: do {
                self.firstNumber += secondNumber
                }
            case .minus: do {
                self.firstNumber -= secondNumber
            }
            case .multiply: do {
                self.firstNumber *= secondNumber
            }
            case .divide: do {
                if (self.secondNumber == 0) {
                    labelText.text = "Ошибка"
                    return ""
                }
                self.firstNumber /= secondNumber
            }
            case .none: do {}
            }
        }
        
        isFirstDouble = true
        var copyOfFirstNumber = String(firstNumber)
        if (copyOfFirstNumber.removeLast() == "0") {
            if (copyOfFirstNumber.removeLast() == ".") {
                isFirstDouble = false
            }
        }
        return copyOfFirstNumber
    }
    
    private func computeSecondAction() {
        if (isSecondNumExists && isThirdNumExists) {
            switch secondAction {
            case .plus: do {
                self.secondNumber += thirdNumber
                }
            case .minus: do {
                self.secondNumber -= thirdNumber
            }
            case .multiply: do {
                self.secondNumber *= thirdNumber
            }
            case .divide: do {
                if (self.thirdNumber == 0) {
                    labelText.text = "Ошибка"
                    return
                }
                self.secondNumber /= thirdNumber
            }
            case .none: do {}
            }
        }
        
        isSecondDouble = true
        var copyOfSecondNumber = String(secondNumber)
        if (copyOfSecondNumber.removeLast() == "0") {
            if (copyOfSecondNumber.removeLast() == ".") {
                isSecondDouble = false
            }
        }
    }
    
    private func toExpForm() {
        var count = 0
        while (currentNumberString.count > 6) {
            _ = currentNumberString.removeLast()
            count += 1
        }
        if (count > 0) {
            currentNumberString.insert(",", at: currentNumberString.index(currentNumberString.startIndex, offsetBy: 1))
            while (currentNumberString.last == "0") {
                _ = currentNumberString.removeLast()
            }
            if (currentNumberString.last == ",") {
                _ = currentNumberString.removeLast()
            }
            currentNumberString += "e"
            currentNumberString += String(count + 5)
        }
        labelText.text = currentNumberString
        isLastComputed = true
        softClear()
    }
    
    private func tapSign() {
        if (labelText.text == "Ошибка") {
            return
        }
        currentNumber *= -1
        if (currentNumberString.first != "-") {
            currentNumberString.insert("-", at: currentNumberString.startIndex)
            toLabel.insert("-", at: toLabel.startIndex)
            labelText.text = toLabel
        } else {
            currentNumberString.remove(at: currentNumberString.startIndex)
            toLabel.remove(at: toLabel.startIndex)
            labelText.text = toLabel
        }
    }
    
    private func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction) {
        let swipeGesture = (UISwipeGestureRecognizer(target: self, action: #selector(backSpace)))
        swipeGesture.direction = direction
        labelField.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func backSpace(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        var label = labelText.text
        switch gestureRecognizer.direction {
        case .left:
            if label!.count > 1 {
                label?.removeLast()
                labelText.text = label
            } else {
                labelText.text = "0"
            }
        case .right:
            if label!.count > 1 {
                label?.removeLast()
                labelText.text = label
            } else {
                labelText.text = "0"
            }
        default:
            return
        }
    }
    
    // MARK: - IBActions
    @IBAction func tapFuncButtons(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 18:
            clear()
            labelText.text = toLabel
        case 17:
            tapSign()
        case 16:
            return
        default:
            return
        }
    }
    
    @IBAction func tapActionButtons(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 15:
            newNumber(actionType: .divide)
        case 14:
            newNumber(actionType: .multiply)
        case 13:
            newNumber(actionType: .minus)
        case 12:
            newNumber(actionType: .plus)
        default:
            return
        }
    }
    
    @IBAction func tapNumberButtons(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 0:
            tapNumber(num: 0)
        case 1:
            tapNumber(num: 1)
        case 2:
            tapNumber(num: 2)
        case 3:
            tapNumber(num: 3)
        case 4:
            tapNumber(num: 4)
        case 5:
            tapNumber(num: 5)
        case 6:
            tapNumber(num: 6)
        case 7:
            tapNumber(num: 7)
        case 8:
            tapNumber(num: 8)
        case 9:
            tapNumber(num: 9)
        default:
            return
        }
    }
    
    @IBAction func tapComma(_ sender: Any) {
        if (labelText.text == "Ошибка" ||
            isDouble == true ||
            currentNumberString.count >= 9) {
            return
        }
        
        isDouble = true
        currentNumberString += "."
        toLabel += ","
        labelText.text = toLabel
    }
    
    @IBAction func tapCompute(_ sender: Any) {
        if (labelText.text == "Ошибка") {
            return
        }
        newNumber()
        
        if (isThirdNumExists) {
            precompute()
        }
        
        let copyOfFirstNumber = computeFirstAction()
        currentNumber = firstNumber
        isDouble = isFirstDouble
        
        thirdNumber = 0
        isThirdNumExists = false
        isThirdDouble = false
        thirdAction = ActionType.none
        
        if (isDouble) {
            currentNumberString = String(currentNumber)
        } else {
            currentNumberString = copyOfFirstNumber
            if (currentNumberString.count < 9) {
                toLabel = currentNumberString
                setSpacesToLabel()
                labelText.text = toLabel
                isLastComputed = true
                softClear()
                return
            } else {
                toExpForm()
                return
            }
        }
        var i = 0
        var copyOfCurrentNumberString = currentNumberString
        var isTooLong = true
        
        while (i < 9 && currentNumberString.count > 9) {
            if (copyOfCurrentNumberString.removeFirst() == ".") {
                isTooLong = false
            }
            i += 1
        }
        if (isTooLong) {
            currentNumberString = String(Int(currentNumber))
            toExpForm()
            return
        } else {
            isLastComputed = true
            softClear()
            return
        }
    }
    
}

