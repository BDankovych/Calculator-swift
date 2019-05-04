import UIKit


enum Operations: Int, CaseIterable {
    
    case division
    case multiplication
    case subtraction
    case addition
    
    var sumbol: String {
        switch self {
        case .division: return "÷"
        case .multiplication: return "×"
        case .subtraction: return "-"
        case .addition: return "+"
        }
    }
}

protocol ButtonsViewDelegate: class {
    func numberPressed(_ number: Int)
    func dotPressed()
    func operationPressed(_ operation: Operations)
    func clearPressed()
    func changeSymbolPressed()
    func bacspacePressed()
    func equalPressed()
}

class ButtonsView: BaseView {

    @IBOutlet private var operationButtuns: [UIButton]!
    
    
    weak var delegate: ButtonsViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        for i in 0..<operationButtuns.count {
            operationButtuns[i].setTitle(Operations.allCases[i].sumbol, for: .normal)
            operationButtuns[i].tag = i
        }
    }
    
    @IBAction private func operationButtonPressed( _ sender: UIButton) {
        guard let operation = Operations(rawValue: sender.tag) else {
            return
        }
        delegate?.operationPressed(operation)
    }
    
    @IBAction private func numberPressed( _ sender: UIButton) {
        guard let stringValue = sender.title(for: .normal),
            let number = Int(stringValue) else {
            return
        }
        delegate?.numberPressed(number)
    }
    
    @IBAction private func dotPressed() {
        delegate?.dotPressed()
    }
    
    @IBAction private func clearPressed() {
        delegate?.clearPressed()
    }
    
    @IBAction private func changeSymbolPressed() {
        delegate?.changeSymbolPressed()
    }
    
    @IBAction private func backspacePressed() {
        delegate?.bacspacePressed()
    }
    
    @IBAction private func equalPressed() {
        delegate?.equalPressed()
    }
}
