//
//  Sprites.swift
//  FinalProject
//
//  Created by Astinna on 2020/12/16.
//  Copyright © 2020 NJU. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// PADDLE:
var PADDLE_WIDTH: CGFloat = 0
var PADDLE_HEIGHT: CGFloat = 0
var SCALAR_TO_FIT: CGFloat = 4.446667
var MARGIN: CGFloat = 0
let PADDING: CGFloat = 100
let PADDLE_MASK: UInt32 = 0x1 << 1
let PADDLE_AI_MASK: UInt32 = 0x1 << 2
let PADDLE_AI_DIFFICULTY: TimeInterval = 0.095

enum PaddlePosition {
    case Top
    case Bottom
}

func SetPaddleValues(_ frame: CGRect) {
    PADDLE_WIDTH = frame.size.width / 5
    PADDLE_HEIGHT = PADDLE_WIDTH / 5
    MARGIN = (PADDLE_WIDTH * SCALAR_TO_FIT)
    BALL_BASE_SPEED = MARGIN
}

class Paddle {
    // Paddle value
    public var PSprite: SKSpriteNode!
    public var OpenAi: Bool = false
    public var previous = CGPoint(x: 0, y: 0)
    public var velocity = CGVector(dx: 0, dy: 0)
    public var PaddlePath: SKShapeNode!
    public var PaddleLeftEnd: SKShapeNode!
    public var PaddleRightEnd: SKShapeNode!
    public var score: Int = 0
    public var ScoreLabel: SKLabelNode!
    
    public init(frame: CGRect, position: PaddlePosition, ai: Bool) {
        // Create sprite
        PSprite = SKSpriteNode(color: .white, size: CGSize(width: PADDLE_WIDTH, height: PADDLE_HEIGHT))
        
        // Create physics body
        PSprite.physicsBody = SKPhysicsBody(rectangleOf: PSprite.size)
        PSprite.physicsBody?.isDynamic = false
        PSprite.physicsBody?.affectedByGravity = false
        PSprite.physicsBody?.friction = 0
        PSprite.physicsBody?.restitution = 0
        
        // Set masks
        if ai == false {
            PSprite.physicsBody?.categoryBitMask = PADDLE_MASK
        } else {
            PSprite.physicsBody?.categoryBitMask = PADDLE_AI_MASK
        }
        
        // Create score label
        // Label font
        ScoreLabel = SKLabelNode(fontNamed: "Montserrat-Bold")
        ScoreLabel.text = "\(score)"
        ScoreLabel.position = CGPoint(x: 0, y: (PADDING - MARGIN) / 2)
        ScoreLabel.fontSize = 2 * (PADDLE_WIDTH / 3)
        ScoreLabel.fontColor = UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1)
        ScoreLabel.horizontalAlignmentMode = .center
        ScoreLabel.verticalAlignmentMode = .center
        
        // Set paddle and label positions
        if position == .Top {
            // Paddle
            PSprite.position = CGPoint(x: 0, y: MARGIN - PADDING)
            // Label
            ScoreLabel.position = CGPoint(x: 0, y: ((MARGIN - PADDING) / 2))
        }
        else if position == .Bottom {
            // Paddle
            PSprite.position = CGPoint(x: 0, y: PADDING - MARGIN)
            // Label
            ScoreLabel.position = CGPoint(x: 0, y: (PADDING - MARGIN) / 2)
        }
        
        // Create paddle path
        PaddlePath = SKShapeNode(rectOf: CGSize(width: frame.size.width - PADDLE_WIDTH, height: PADDLE_HEIGHT / 8))
        PaddlePath.position = PSprite.position
        PaddlePath.strokeColor = .clear
        
        PaddleLeftEnd = SKShapeNode(circleOfRadius: PADDLE_HEIGHT / 4)
        PaddleLeftEnd.position = CGPoint(x: -(frame.size.width / 2) + (PADDLE_WIDTH / 2), y: PSprite.position.y)
        PaddleLeftEnd.strokeColor = .clear
        
        PaddleRightEnd = SKShapeNode(circleOfRadius: PADDLE_HEIGHT / 4)
        PaddleRightEnd.position = CGPoint(x: (frame.size.width / 2) - (PADDLE_WIDTH / 2), y: PSprite.position.y)
        PaddleRightEnd.strokeColor = .clear
        
        // Set color
        if ai == false {
            PaddlePath.fillColor = UIColor(red: 1, green: 0/255, blue: 68/255, alpha: 1)
            PaddleLeftEnd.fillColor = UIColor(red: 1, green: 0/255, blue: 68/255, alpha: 1)
            PaddleRightEnd.fillColor = UIColor(red: 1, green: 0/255, blue: 68/255, alpha: 1)
        } else {
            PaddlePath.fillColor = UIColor(red: 0, green: 153/255, blue: 219/255, alpha: 1)
            PaddleLeftEnd.fillColor = UIColor(red: 0/255, green: 153/255, blue: 219/255, alpha: 1)
            PaddleRightEnd.fillColor = UIColor(red: 0/255, green: 153/255, blue: 219/255, alpha: 1)
        }
    }
    
    public func update(_ delta: CGFloat) {
        ScoreLabel.text = "\(score)"
        velocity = CGVector(dx: PSprite.position.x - previous.x, dy: PSprite.position.y - previous.y)
        previous = PSprite.position
    }
    
    public func input(_ location: CGPoint) {
        if OpenAi == false {
            PSprite.position.x = location.x
        }
    }
}

// WALL:
let WALL_MASK: UInt32 = 0x1 << 4

// BALL:
var BALL_BASE_SPEED: CGFloat = 0
var BALL_SPEED: CGFloat = BALL_BASE_SPEED
let BALL_MIN_Y_INCREMENT: CGFloat = 150
let BALL_SPEED_INCREMENT: CGFloat = 15
let BALL_SERVE_SPEED: CGFloat = 200
let BALL_EMISSION_RATE: CGFloat = 150
let BALL_MASK: UInt32 = 0x1 << 3
let BALL_MAX_ANGLE: CGFloat = CGFloat.pi / 3

class Ball {
    // Set ball value
    public var BSprite: SKSpriteNode!
    public let radius: CGFloat = PADDLE_HEIGHT / 2
    
    public init() {
        // Create ball shape
        BSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Ball"), size: CGSize(width: radius * 2, height: radius * 2))
        BSprite.position = CGPoint(x: 0, y: 0)
        
        // Add ball body
        BSprite.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        BSprite.physicsBody?.isDynamic = true
        BSprite.physicsBody?.affectedByGravity = false
        BSprite.physicsBody?.friction = 0
        BSprite.physicsBody?.restitution = 1
        BSprite.physicsBody?.linearDamping = 0
        BSprite.physicsBody?.angularDamping = 0
        BSprite.physicsBody?.categoryBitMask = BALL_MASK
        BSprite.physicsBody?.contactTestBitMask = PADDLE_MASK | PADDLE_AI_MASK | WALL_MASK
    }
}


