//
//  ViewController.swift
//  Calculator Bootcamp
//
//  Created by Sadettin Karadavut on 22.04.2026.
//

import UIKit

class HomeViewController: UIViewController {

        // MARK: - Enums

        enum CalcOperator {
            case add, subtract, multiply, divide, modulo
        }

        // MARK: - Outlets

        @IBOutlet weak var resultLabel: UILabel!

        // MARK: - Properties

        var isTyping: Bool = false
        var firstValue: Double = 0
        var currentOperator: CalcOperator?

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            resultLabel.text = "0"
        }

        // MARK: - Helpers

        /// Displays a Double, trimming unnecessary decimal places.
        private func display(_ value: Double) {
            resultLabel.text = value.truncatingRemainder(dividingBy: 1) == 0
                ? String(format: "%.0f", value)
                : String(value)
        }

        /// Performs the calculation and returns the result, or nil on error.
        private func calculate(first: Double, second: Double, op: CalcOperator) -> Double? {
            switch op {
            case .add:      return first + second
            case .subtract: return first - second
            case .multiply: return first * second
            case .divide:
                guard second != 0 else { return nil }
                return first / second
            case .modulo:
                guard second != 0 else { return nil }
                return first.truncatingRemainder(dividingBy: second)
            }
        }

        // MARK: - Number Input

        /// Appends the tapped digit to the display, or starts a new number.
        @IBAction func numberPressed(_ sender: UIButton) {
            let number = String(sender.tag)

            if isTyping {
                resultLabel.text = (resultLabel.text ?? "") + number
            } else {
                resultLabel.text = number
                isTyping = true
            }
        }

        /// Adds a decimal point, preventing duplicates and leading with "0." when needed.
        @IBAction func commaPressed(_ sender: UIButton) {
            guard let text = resultLabel.text, !text.contains(".") else { return }

            if !isTyping {
                resultLabel.text = "0."
                isTyping = true
            } else {
                resultLabel.text = text + "."
            }
        }

        // MARK: - Operations

        /// Saves the first operand and records the chosen operator.
        @IBAction func operationPressed(_ sender: UIButton) {
            guard let text = resultLabel.text,
                  let value = Double(text) else { return }

            firstValue = value
            isTyping = false

            switch sender.tag {
            case 10: currentOperator = .add
            case 11: currentOperator = .subtract
            case 12: currentOperator = .multiply
            case 13: currentOperator = .divide
            case 17: currentOperator = .modulo
            default: break
            }
        }

        /// Computes the result and displays it; shows "Error" on division/modulo by zero.
        @IBAction func equalsPressed(_ sender: UIButton) {
            guard let text = resultLabel.text,
                  let secondValue = Double(text),
                  let op = currentOperator else { return }

            if let result = calculate(first: firstValue, second: secondValue, op: op) {
                display(result)
            } else {
                resultLabel.text = "Error"
            }

            currentOperator = nil
            isTyping = false
        }

        // MARK: - Utility Actions

        /// Resets the calculator to its initial state.
        @IBAction func acPressed(_ sender: UIButton) {
            resultLabel.text = "0"
            firstValue = 0
            currentOperator = nil
            isTyping = false
        }

        /// Toggles the sign of the current display value.
        @IBAction func plusMinusPressed(_ sender: UIButton) {
            guard let text = resultLabel.text,
                  let value = Double(text) else { return }
            display(value * -1)
        }

}
