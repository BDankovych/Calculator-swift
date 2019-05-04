import UIKit


enum CalculatorErrors: String {
    case devideByZero = "Devide by zero"
    case toBigInput = "Maximum character count is reached"
    case resultToBig = "Result is too big"
}

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var buttonsView: ButtonsView!
    
    private var isFirstSymbol = true
    fileprivate var firstOperand: Float?
    fileprivate var operation: Operations?
    
    
    fileprivate var resultText: String = "0" {
        didSet {
            if Float(resultText) == nil {
                showAlert(withText: CalculatorErrors.toBigInput.rawValue)
                resultText.removeLast()
            } else {
                resultLabel.text = resultText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsView.delegate = self
    }
    
    private func shouldInsertDot() -> Bool {
        return !resultText.contains(".")
    }
    
    private func clearView() {
        isFirstSymbol = true
        resultText = "0"
    }
    
    private func showAlert(withText: String) {
        let alertView = UIAlertController(title: "Error", message: withText, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertView, animated: true)
    }
    
    private func display(result: Float) {
        if floor(result) == result {
            resultText = String(format: "%.0f", result)
        } else {
            var resultString = String(format: "%.8f", result)
            while resultString.last == "0" {
                resultString.removeLast()
            }
            resultText = resultString
        }
    }
}


extension ViewController: ButtonsViewDelegate {
    func numberPressed(_ number: Int) {
        if isFirstSymbol && number == 0 {
            return
        }
        
        if isFirstSymbol {
            isFirstSymbol = false
            resultText = String(number)
        } else {
            resultText += String(number)
        }
        
    }
    
    func dotPressed() {
        if shouldInsertDot() {
            resultText += "."
            isFirstSymbol = false
        }
    }
    
    func operationPressed(_ operation: Operations) {
        guard let floatValue = Float(resultText) else {
            return
        }
        self.operation = operation
        if firstOperand == nil {
            firstOperand = floatValue
            clearView()
        } else {
            equalPressed()
        }
        
    }
    
    func clearPressed() {
        operation = nil
        firstOperand = nil
        clearView()
    }
    
    func changeSymbolPressed() {
        if resultText.first == "-" {
            resultText.removeFirst()
        } else if resultText != "0" {
            resultText.insert("-", at: resultText.startIndex)
        }
    }
    
    func bacspacePressed() {
        if resultText.count == 1 || (resultText.count == 2 && resultText.first == "-") {
            resultText = "0"
            isFirstSymbol = true
        } else {
            resultText.removeLast()
        }
        if resultText == "0" {
            isFirstSymbol = true
        }
    }
    
    func equalPressed() {
        guard let first = firstOperand,
            let second = Float(resultText),
            let operation = operation
            else {
                return
        }
        
        switch operation {
        case .addition:
            firstOperand = first + second
        case .subtraction:
            firstOperand = first - second
        case .division:
            if second == 0 {
                showAlert(withText: CalculatorErrors.devideByZero.rawValue)
                return
            } else {
                firstOperand = first / second
            }
        case .multiplication:
            firstOperand = first * second
        }
        isFirstSymbol = true
        display(result: firstOperand!)
        firstOperand = nil
    }
    
    
}
