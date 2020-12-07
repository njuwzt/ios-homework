//
//  YOLO.swift
//  NewMultiSnacks
//
//  Created by Astinna on 2020/12/7.
//  Copyright © 2020 NJU. All rights reserved.
//

import Foundation
import UIKit
import CoreML



class YOLO {
  public static let inputWidth = 224
  public static let inputHeight = 224
  public static let maxBoundingBoxes = 10

  // Tweak these values to get more or fewer predictions.
  let confidenceThreshold: Float = 0.3
  let iouThreshold: Float = 0.5

  struct Prediction {
    let classIndex: Int
    let rect: CGRect
  }

  let model = MultiSnacks()

  public init() { }

  public func predict(image: CVPixelBuffer) -> Prediction? {
    if let output = try? model.prediction(image: image) {
        return computeBoundingBoxes(output: output)
    } else {
      return nil
    }
  }

  public func computeBoundingBoxes(output: MultiSnacksOutput) -> Prediction {
    var index = -1
    var prob = -1.0
    for i in 0..<20{
        if output.output1[i].doubleValue > prob {
            prob = output.output1[i].doubleValue
            index = i
        }
    }
    let rect = output.output2
    return Prediction(classIndex: index , rect: CGRect(
                        x: rect[0].doubleValue * Double(YOLO.inputWidth),
                        y: rect[2].doubleValue * Double(YOLO.inputHeight),
                        width: (rect[1].doubleValue - rect[0].doubleValue) * Double(YOLO.inputWidth),
                        height: (rect[3].doubleValue - rect[2].doubleValue) * Double(YOLO.inputHeight)))
    
    }
    
}
