//
//  ViewController.swift
//  GestureClassifier
//
//  Created by Astinna on 2020/12/18.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit
import CoreML
import CoreMotion



class ViewController: UIViewController {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let motions = ["chop", "shake", "drive"]
    let MLmodel: GestureClassifier = {
        do {
            return try GestureClassifier(configuration: MLModelConfiguration())
        } catch {
            fatalError("Fail to create model")
        }
    }()
    
    
    static let samplesPerSecond = 25.0
    static let numberOfFeatures = 6
    static let windowSize = 20
    static let windowOffset = 5
    static let numberOfWindows = windowSize / windowOffset
    static let bufferSize = windowSize + windowOffset * (numberOfWindows - 1)
    static let sampleSizeAsBytes = ViewController.numberOfFeatures * MemoryLayout<Double>.stride
    static let windowOffsetAsBytes = ViewController.windowOffset * sampleSizeAsBytes
    static let windowSizeAsBytes = ViewController.windowSize * sampleSizeAsBytes
    
    var startOrNot = false
    var yscore = 0
    var time = 3
    var over = false
    var Output: GestureClassifierOutput!
    var target = "NULL"
    var count = 0
    
    func enableMotionUpdates(){
        motionManager.deviceMotionUpdateInterval = 1 / ViewController.samplesPerSecond
        motionManager.startDeviceMotionUpdates(
            using: .xArbitraryZVertical,
            to: queue,
            withHandler: { [weak self] motionData, error in
                guard let self = self, let motionData = motionData else {
                    let errorText = error?.localizedDescription ?? "Unknown"
                    print("Device motion update error: \(errorText)")
                    return
                }
                self.buffer(motionData)
                self.bufferIndex = (self.bufferIndex + 1) % ViewController.windowSize
                if self.bufferIndex == 0 {
                    self.isDataAvailable = true
                }
                self.predict()
                DispatchQueue.main.async {
                    self.run()
                }
            }
        )
    }
    @IBOutlet weak var ymotion: UILabel!
    
    func predict(){
        if isDataAvailable && bufferIndex % ViewController.windowOffset == 0 && bufferIndex + ViewController.windowOffset <= ViewController.windowSize {
            let window = bufferIndex / ViewController.windowOffset
            memcpy(modelInput.dataPointer, dataBuffer.dataPointer.advanced(by: window * ViewController.windowOffsetAsBytes), ViewController.windowSizeAsBytes)
            //TODO:predict the gesture
            var classifierInput: GestureClassifierInput? = nil
            if Output == nil{
                classifierInput = GestureClassifierInput(features: modelInput)
            }
            else{
                classifierInput = GestureClassifierInput(features: modelInput, hiddenIn: Output.hiddenOut, cellIn: Output.cellOut)
            }
            Output = try? MLmodel.prediction(input: classifierInput!)
            DispatchQueue.main.async {
                self.ymotion.text = self.Output.activity
            }
        }
    }
    
    func createMotion(){
        let index = Int.random(in: 0..<3)
        target = motions[index]
        motion.text = motions[index]
        time = 3
        over = false
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if startOrNot == false{
            yscore = 0
            sender.setTitle("end", for: .normal)
            count = 0
            score.text = "0"
            createMotion()
            startOrNot = true
        }
        else{
            sender.setTitle("start", for: .normal)
            motion.text = "NULL"
            target = "NULL"
            startOrNot = false
        }
    }
    @IBOutlet weak var motion: UILabel!
    @IBOutlet weak var score: UILabel!
    func run(){
        if startOrNot == true{
            count = (count+1)%25
            if over == false && Output.activity == target{
                //add score
                count = 0
                yscore = yscore + 1
                score.text = String(yscore)
                createMotion()
            }
            else if count==0{
                if over == true{
                    createMotion()
                }
                else{
                    if time == 0{
                        over = true
                        yscore = yscore-1
                        score.text = String(yscore)
                    }
                    else{
                        time = time-1
                    }
                }
            }
        }
        
    }
    
    static private func makeMLMultiArray(numberOfSamples: Int) -> MLMultiArray? {
        try? MLMultiArray(
            shape: [1, numberOfSamples, numberOfFeatures] as [NSNumber],
            dataType: .double
        )
    }
    
    let modelInput: MLMultiArray! = makeMLMultiArray(numberOfSamples: windowSize)
    let dataBuffer: MLMultiArray! = makeMLMultiArray(numberOfSamples: bufferSize)
    var bufferIndex = 0
    var isDataAvailable = false
    
    
    func addToBuffer(_ index: Int, _ res: Int, _ data: Double) {
        dataBuffer[[0, index, res] as [NSNumber]] = NSNumber(value: data)
    }
    
    func buffer(_ motionData: CMDeviceMotion) {
        for offset in [0, ViewController.windowSize] {
            let index = bufferIndex + offset
            if index >= ViewController.bufferSize {
                continue
            }
            addToBuffer(index, 0, motionData.rotationRate.x)
            addToBuffer(index, 1, motionData.rotationRate.y)
            addToBuffer(index, 2, motionData.rotationRate.z)
            addToBuffer(index, 3, motionData.userAcceleration.x)
            addToBuffer(index, 4, motionData.userAcceleration.y)
            addToBuffer(index, 5, motionData.userAcceleration.z)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableMotionUpdates()
    }


}

