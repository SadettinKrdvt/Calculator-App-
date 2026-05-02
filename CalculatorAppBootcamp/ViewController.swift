//
//  ViewController.swift
//  Calculator Bootcamp
//
//  Created by Sadettin Karadavut on 22.04.2026.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var resultLabel: UILabel!

    // MARK: - Properties

    var isTyping: Bool = false      // Tracks whether the user is mid-input
    var firstValue: Double = 0      // Stores the first value
    var currentOperator: String = ""// Stores the selected operator

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
    }

    // MARK: - Number Input

    /// Appends the tapped digit to the display, or starts a new number.
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = String(sender.tag)

        if isTyping {
            resultLabel.text! += number
        } else {
            resultLabel.text = number
            isTyping = true
        }
    }

    /// Adds a decimal point, preventing duplicates and leading with "0." when needed.
    @IBAction func commaPressed(_ sender: UIButton) {
        guard !(resultLabel.text!.contains(".")) else { return }

        if !isTyping {
            resultLabel.text = "0."
            isTyping = true
        } else {
            resultLabel.text! += "."
        }
    }

    // MARK: - Operations

    /// Saves the first operand and records the chosen operator (+, -, x, ÷).
    @IBAction func operationPressed(_ sender: UIButton) {
        firstValue = Double(resultLabel.text!) ?? 0
        isTyping = false

        switch sender.tag {
        case 10: currentOperator = "+"
        case 11: currentOperator = "-"
        case 12: currentOperator = "x"
        case 13: currentOperator = "÷"
        default: break
        }
    }

    /// Computes the result and displays it; shows "Error" on division by zero.
    @IBAction func equalsPressed(_ sender: UIButton) {
        guard let text = resultLabel.text,
              let secondValue = Double(text) else { return }

        var result: Double = 0

        switch currentOperator {
        case "+": result = firstValue + secondValue
        case "-": result = firstValue - secondValue
        case "x": result = firstValue * secondValue
        case "÷":
            guard secondValue != 0 else {
                resultLabel.text = "Error"
                return
            }
            result = firstValue / secondValue
        default: return
        }

        // Show as integer if there is no fractional part
        resultLabel.text = result.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", result)
            : String(result)

        currentOperator = ""
        isTyping = false
    }

    // MARK: - Utility Actions

    /// Resets the calculator to its initial state.
    @IBAction func acPressed(_ sender: UIButton) {
        resultLabel.text = "0"
        firstValue = 0
        currentOperator = ""
        isTyping = false
    }

    /// Toggles the sign of the current display value.
    @IBAction func plusMinusPressed(_ sender: UIButton) {
        guard let text = resultLabel.text,
              let value = Double(text) else { return }
        resultLabel.text = String(format: "%g", value * -1)
    }

    /// Converts the current display value to its percentage (÷ 100).
    @IBAction func percentagePressed(_ sender: UIButton) {
        guard let text = resultLabel.text,
              let value = Double(text) else { return }
        resultLabel.text = String(format: "%g", value / 100)
        isTyping = false
    }
}
