//
//  ViewController.swift
//  CalculateGame
//
//  Created by dd on 28/04/15.
//  Copyright (c) 2015 dd. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    
    @IBOutlet weak var refView: UIView!

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var displayResult: UILabel!
 
    @IBOutlet weak var correctnessDisplay: UILabel!
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    
    var expectedResult: Int32 = 0
    var numOfFailedTry = 0
    let operation = "+"
    
    override func viewDidLoad() {
        let frame = CGRect(x: refView.bounds.width/2, y: refView.bounds.height/2, width: refView.bounds.width*0.8, height: refView.bounds.height/2)
        let displayView = UIView(frame: frame)
        displayView.backgroundColor = UIColor.blueColor()
        displayView.alpha = 0.5
    }
    
    @IBAction func generateAddTask(sender: UITapGestureRecognizer) {
        generateCalcTaskCore()
    }
    
    func generateCalcTaskCore() {
        let operand0 = getRandom0To100Operand()
        let operand1 = getRandom0To100Operand()
        print(operand0)
        print(operand1)
        let strOperand0 = String(operand0)
        let strOperand1 = String(operand1)
        let displayStr = strOperand0 + operation + strOperand1 + " = "
        display.text! = displayStr + "?"
        
        switch operation {
        case "+":
            expectedResult = operand0 + operand1
        case "−":
            expectedResult = operand0 - operand1
        case "×":
            expectedResult = operand0 * operand1
        case "÷":
            expectedResult = -555
            display.text = "÷ geht noch nicht "
        default:
            break
        }

        displayResult.text = ""
        correctnessDisplay.text = ""
        
        // stop watch start
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
//    @IBAction func generateCalcTask(sender: UIButton) {
//        let operand0 = getRandom0To100Operand()
//        let operand1 = getRandom0To100Operand()
//        print(operand0)
//        print(operand1)
//        let strOperand0 = String(operand0)
//        let strOperand1 = String(operand1)
//        let displayStr = strOperand0 + sender.currentTitle! + strOperand1 + " = "
//        display.text! = displayStr + "?"
//        
//        switch sender.currentTitle! {
//        case "+":
//            expectedResult = operand0 + operand1
//        case "−":
//            expectedResult = operand0 - operand1
//        case "×":
//            expectedResult = operand0 * operand1
//        case "÷":
//            expectedResult = -555
//            display.text = "÷ geht noch nicht "
//        default:
//            break
//        }
//        
//    }
    var digitStack = [Int32]()
    
    var displayToBeCleanedUpNextTime = true
    
    var isNegative = false
    
    @IBAction func negative() {
        isNegative = true
        displayResult.text = "-"
        displayToBeCleanedUpNextTime = false
    }

    @IBAction func appendDigit(sender: UIButton) {
        
        let intDigit = NSNumberFormatter().numberFromString(sender.currentTitle!)!.intValue
        digitStack.append(intDigit)
//        var dispStr = ""
        if displayToBeCleanedUpNextTime {
            displayResult.text = "\(intDigit)"
            displayToBeCleanedUpNextTime = false
        }
        else{
            displayResult.text = displayResult.text! + "\(intDigit)"
        }
        print("displayResult.text  = " + displayResult.text!)
        
//        if (isNegative && isFirstCharNotMinus(displayResult.text!)) {
//            displayResult.text = "-" + displayResult.text!
//        }else{
//            displayResult.text = displayResult.text!
//        }

    }
    
    private func isFirstCharNotMinus( s: String) -> Bool{
        let c = s[s.startIndex]
        if c != "-"{
            return true
        }else{
            return false
        }
        
    }
    
    
    @IBAction func removeLastEntry(sender: AnyObject) {
        if digitStack.count>0{
            digitStack.removeLast()
            (_, displayResult.text!) = stackToNumber(digitStack)
        }
    }
    
    private func getRandom0To100Operand()->Int32{
        let seed = UInt32(NSDate().timeIntervalSince1970)
//        srand(seed)
        let r = arc4random_uniform(seed)
        return Int32( Double(r)*100.0 / Double(Int32.max))
    }
    
    @IBAction func enterResult() {
        var result: Int32
        (result, _) = stackToNumber(digitStack)
        
        if isNegative {
            result = -result
            isNegative = false
        }
        
        print("result = \(result)")
        displayToBeCleanedUpNextTime = true
        
        if result == expectedResult {
            correctnessDisplay.font.fontWithSize(30)
            correctnessDisplay.text = "Richtig 😊 Du bist Super !! "
            
            // stop timer
            timer.invalidate()
//            //timer = nil
            
        }else{
            correctnessDisplay.font.fontWithSize(25)
            if numOfFailedTry<=1{
                correctnessDisplay.text = "Nicht ganz (\(numOfFailedTry)) 😐, Versuch nochmal ? "
            }else if numOfFailedTry==2{
                correctnessDisplay.text = "Noch nicht richtig (\(numOfFailedTry)) 😮, noch mal ! "
            }
            else if numOfFailedTry==3{
                correctnessDisplay.text = "Letzte Versuch (\(numOfFailedTry)) 😓 ! "
            }else{
                correctnessDisplay.text = "😞"
                display.text = "Richtige Ergebnis: " + display.text! + "\(expectedResult)"
            }
            
            numOfFailedTry++
        }
        digitStack.removeAll(keepCapacity: false)
    }
    
    private func stackToNumber(stack:[Int32])-> (Int32, String){
        var stackReverse = Array(stack.reverse())
        var stringTemp:String=""
        let stackLengh = stackReverse.count
        var result: Int32
        if stackLengh > 0{
            for var i = 0; i < stackLengh; ++i {
                let sTemp = "\(stackReverse.removeLast())"
                stringTemp = stringTemp + sTemp
            }
            result = NSNumberFormatter().numberFromString(stringTemp)!.intValue
        }else{
            result = -555
        }
        return (result, "\(result)")
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        let fraction = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timerDisplay.text = "\(strMinutes):\(strSeconds):\(strFraction)"
//        timerDisplay.text = "\(strMinutes):\(strSeconds)"
        
    }
}

