//
//  ViewController.swift
//  CalculateGame
//
//  Created by dd on 28/04/15.
//  Copyright (c) 2015 dd. All rights reserved.
//

import UIKit
import Foundation

class MainVC: UIViewController {

    
    var refView: UIView!
    let gravity = UIGravityBehavior()
    lazy var animator: UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.refView)
        return lazyAnimator
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCollider
    }()

    @IBOutlet weak var display: UILabel!
    
//    @IBOutlet weak var displayResult: UILabel!
// 
//    @IBOutlet weak var correctnessDisplay: UILabel!
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    var numChoices:Int = 4
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    
    var expectedResult: Int32 = 0
    var numOfFailedTry = 0
    let operation = "+"
    let locationResolution = 10
    
    var bottonSize:CGSize!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: CGPointZero.x, y: CGPointZero.y, width: self.view.bounds.width, height: self.view.bounds.height*0.8)
        let displayView = UIView(frame: frame)
//        displayView.backgroundColor = UIColor.blueColor()
//        displayView.alpha = 0.5
        
        self.view.addSubview(displayView)
        refView = displayView
        
        let size = refView.bounds.size.width/CGFloat(locationResolution)
        bottonSize = CGSize(width: size, height: size)
        animator.addBehavior(gravity)
        animator.addBehavior(collider)
    }
    
    @IBAction func generateAddTask(sender: UITapGestureRecognizer) {
        generateCalcTaskCore()
        dropMultiChoice(numChoices, correctResult: expectedResult)
        
    }
    
    func dropMultiChoice(numChoices:Int, correctResult: Int32){
        var multiChoices = [Int32](count:numChoices, repeatedValue: 0)
        var buttons = [UIButton]()
        let idxCorrectAnswer = Int(getRandom0ToN(3))
        for i in 0...(numChoices-1){
            
            if i==idxCorrectAnswer{
                
                multiChoices[idxCorrectAnswer] = correctResult
            }else{
                let randUp = max(2*correctResult,20)
                multiChoices[i] = getRandom0ToN(randUp)
            }
            
            buttons.append(getUIButton("\(multiChoices[i])", buttonSize: bottonSize))
            refView.addSubview(buttons[i])
            
            gravity.addItem(buttons[i])
            collider.addItem(buttons[i])
//            sleep(1)
        }
        
    }
    

    
    func answerIsCorrect(){
        print("the answer is correct")
            }
    
    func answerIsWrong(){
        print("the answer is WRONG")
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

//        displayResult.text = ""
//        correctnessDisplay.text = ""
        
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
    
//    @IBAction func negative() {
//        isNegative = true
//        displayResult.text = "-"
//        displayToBeCleanedUpNextTime = false
//    }
//
//    @IBAction func appendDigit(sender: UIButton) {
//        
//        let intDigit = NSNumberFormatter().numberFromString(sender.currentTitle!)!.intValue
//        digitStack.append(intDigit)
////        var dispStr = ""
//        if displayToBeCleanedUpNextTime {
//            displayResult.text = "\(intDigit)"
//            displayToBeCleanedUpNextTime = false
//        }
//        else{
//            displayResult.text = displayResult.text! + "\(intDigit)"
//        }
//        print("displayResult.text  = " + displayResult.text!)
//        
////        if (isNegative && isFirstCharNotMinus(displayResult.text!)) {
////            displayResult.text = "-" + displayResult.text!
////        }else{
////            displayResult.text = displayResult.text!
////        }
//
//    }
    
    private func isFirstCharNotMinus( s: String) -> Bool{
        let c = s[s.startIndex]
        if c != "-"{
            return true
        }else{
            return false
        }
        
    }
    
    
//    @IBAction func removeLastEntry(sender: AnyObject) {
//        if digitStack.count>0{
//            digitStack.removeLast()
//            (_, displayResult.text!) = stackToNumber(digitStack)
//        }
//    }
    
    private func getRandom0To100Operand()->Int32{
        return getRandom0ToN(100)
    }
    
    private func getRandom0ToN(n:Int32)->Int32{
        let seed = UInt32(NSDate().timeIntervalSince1970)
        let r = arc4random_uniform(seed)
        return Int32( Double(r) * Double(n) / Double(Int32.max))
    }
    
//    @IBAction func enterResult() {
//        var result: Int32
//        (result, _) = stackToNumber(digitStack)
//        
//        if isNegative {
//            result = -result
//            isNegative = false
//        }
//        
//        print("result = \(result)")
//        displayToBeCleanedUpNextTime = true
//        
//        if result == expectedResult {
//            correctnessDisplay.font.fontWithSize(30)
//            correctnessDisplay.text = "Richtig 😊 Du bist Super !! "
//            
//            // stop timer
//            timer.invalidate()
////            //timer = nil
//            
//        }else{
//            correctnessDisplay.font.fontWithSize(25)
//            if numOfFailedTry<=1{
//                correctnessDisplay.text = "Nicht ganz (\(numOfFailedTry)) 😐, Versuch nochmal ? "
//            }else if numOfFailedTry==2{
//                correctnessDisplay.text = "Noch nicht richtig (\(numOfFailedTry)) 😮, noch mal ! "
//            }
//            else if numOfFailedTry==3{
//                correctnessDisplay.text = "Letzte Versuch (\(numOfFailedTry)) 😓 ! "
//            }else{
//                correctnessDisplay.text = "😞"
//                display.text = "Richtige Ergebnis: " + display.text! + "\(expectedResult)"
//            }
//            
//            numOfFailedTry++
//        }
//        digitStack.removeAll(keepCapacity: false)
//    }
    
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
    
    func getUIButton(text:String, buttonSize:CGSize) -> UIButton{
        let button = UIButton()
        button.frame = CGRect(origin: CGPointZero, size: buttonSize)
        //        button.frame.origin.x = CGFloat.random(widthRatio) * buttonSize.width
        button.frame.origin.x = CGFloat.random(10) * buttonSize.width
        button.layer.cornerRadius = 18
        button.backgroundColor = UIColor.random
        button.setTitle(text, forState: .Normal)
        button.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func getUIButton(text:String, buttonSize:CGSize, xLocation:CGFloat) -> UIButton{
        let button = UIButton()
        button.frame = CGRect(origin: CGPointZero, size: buttonSize)
        //        button.frame.origin.x = CGFloat.random(widthRatio) * buttonSize.width
        button.frame.origin.x = xLocation
        button.layer.cornerRadius = 18
        button.backgroundColor = UIColor.random
        button.setTitle(text, forState: .Normal)
        button.addTarget(self, action: Selector("pressed:"), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func pressed(sender:UIButton!){
        print("button pressed")
        timer.invalidate()
    }
    
    func chooseResult(sender: UIButton!){
        let chosenAnswer = Int32(sender.currentTitle!)
        
        if chosenAnswer == expectedResult {
            answerIsCorrect()
        }else{
            answerIsWrong()
        }
        // stop timer
        timer.invalidate()
        //            //timer = nil
        
        
    }
    
    
}

private extension CGFloat{
    static func random(max:Int)->CGFloat{
        let x = arc4random() % UInt32(max)
        return CGFloat(x)
    }
}

private extension UIColor {
    class var random:UIColor{
        switch arc4random()%5{
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
            
        }
    }
}

