//
//  GameScene.swift
//  FinalProject
//
//  Created by Astinna on 2020/12/21.
//  Copyright © 2020 NJU. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Prompt background sprites
    var PromptBackground: SKSpriteNode!
    var PromptBox: SKSpriteNode!
    var PromptInstruction: SKLabelNode!
    var PromptText: SKLabelNode!
    var GameBegin = false
    var GameEnd = true
    
    // CenterLine value
    var CenterLineLeft: SKSpriteNode!
    var CenterLineRight: SKSpriteNode!
    var CenterCircle: SKShapeNode!
    
    // Player machine and ball
    var player: Paddle!
    var machine: Paddle!
    var ball: Ball!
    
    var PlayerScored = false
    var MachineScored = false
    var ScorePrompt: SKLabelNode!
    
    // Timer
    private var lastTime: TimeInterval = 0
    
    // Present GameScene
    override func sceneDidLoad() {
        // Set background color
        backgroundColor = UIColor(red: 24/255, green: 20/255, blue: 37/255, alpha: 1)
        
        // Set paddle values
        let screen = frame; SetPaddleValues(screen)
        
        // Set contact delegate
        physicsWorld.contactDelegate = self
        
        // Create border physics bodies
        let leftWall = SKNode()
        leftWall.position.x = -(frame.size.width / 2)
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -(frame.size.height / 2)), to: CGPoint(x: 0, y: (frame.size.height / 2)))
        leftWall.physicsBody?.categoryBitMask = WALL_MASK
        addChild(leftWall)
        
        let rightWall = SKNode()
        rightWall.position.x = (frame.size.width / 2)
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -(frame.size.height / 2)), to: CGPoint(x: 0, y: (frame.size.height / 2)))
        rightWall.physicsBody?.categoryBitMask = WALL_MASK
        addChild(rightWall)
        
        // Prompt to begin game
        PromptBackground = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), size: frame.size)
        PromptBackground.position = CGPoint(x: 0, y: 0)
        PromptBackground.zPosition = 2
        addChild(PromptBackground!)
        
        PromptBox = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize(width: frame.size.width, height: PADDLE_WIDTH * 2))
        PromptBox.position = CGPoint(x: 0, y: 0)
        PromptBox.zPosition = 2
        addChild(PromptBox!)
        
        PromptInstruction = SKLabelNode(fontNamed: "Montserrat-BLACK")
        PromptInstruction.position = CGPoint(x: 0, y: PADDLE_WIDTH / 3)
        PromptInstruction.zPosition = 2
        PromptInstruction.text = "SCORE 4 TO WIN"
        PromptInstruction.verticalAlignmentMode = .center
        PromptInstruction.horizontalAlignmentMode = .center
        PromptInstruction.fontColor = .white
        PromptInstruction.fontSize = PADDLE_WIDTH / 2
        addChild(PromptInstruction!)
        
        PromptText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
        PromptText.position = CGPoint(x: 0, y: -(PADDLE_WIDTH / 3))
        PromptText.zPosition = 2
        PromptText.text = "Touch to begin the game."
        PromptText.verticalAlignmentMode = .center
        PromptText.horizontalAlignmentMode = .center
        PromptText.fontColor = .white
        PromptText.fontSize = PADDLE_WIDTH / 3
        addChild(PromptText!)
        
        // Center line
        CenterLineLeft = SKSpriteNode(color: UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1), size: CGSize(width: (frame.size.width / 2) - (PADDLE_WIDTH / 2), height: PADDLE_HEIGHT / 4))
        CenterLineLeft.position = CGPoint(x: -(frame.size.width / 2) + (CenterLineLeft.size.width / 2), y: 0)
        addChild(CenterLineLeft!)
        
        CenterLineRight = SKSpriteNode(color: UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1), size: CGSize(width: (frame.size.width / 2) - (PADDLE_WIDTH / 2), height: PADDLE_HEIGHT / 4))
        CenterLineRight.position = CGPoint(x: (frame.size.width / 2) - (CenterLineRight.size.width / 2), y: 0)
        addChild(CenterLineRight!)
        
        CenterCircle = SKShapeNode(circleOfRadius: PADDLE_WIDTH / 2)
        CenterCircle.position = CGPoint(x: 0, y: 0)
        CenterCircle.fillColor = .clear
        CenterCircle.lineWidth = PADDLE_HEIGHT / 3.25
        CenterCircle.strokeColor = UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1)
        addChild(CenterCircle!)
        
        // Player
        player = Paddle(frame: frame, position: .Bottom, ai: false)
        addChild(player.PaddlePath!)
        addChild(player.PaddleLeftEnd!)
        addChild(player.PaddleRightEnd!)
        addChild(player.PSprite!)
        addChild(player.ScoreLabel!)
        
        // Machine
        machine = Paddle(frame: frame, position: .Top, ai: true)
        addChild(machine.PaddlePath!)
        addChild(machine.PaddleLeftEnd!)
        addChild(machine.PaddleRightEnd!)
        addChild(machine.PSprite!)
        addChild(machine.ScoreLabel!)
        
        // Ball
        ball = Ball()
        addChild(ball.BSprite!)
        
        // Score
        ScorePrompt = SKLabelNode(fontNamed: "FredokaOne-Regular")
        ScorePrompt.text = "SCORE!"
        ScorePrompt.zPosition = 2
        ScorePrompt.fontSize = PADDLE_WIDTH
        ScorePrompt.fontColor = UIColor(red: 254/255, green: 174/255, blue: 52/255, alpha: 1)
        ScorePrompt.verticalAlignmentMode = .center
        ScorePrompt.horizontalAlignmentMode = .center
        ScorePrompt.run(.fadeOut(withDuration: 0))
        addChild(ScorePrompt!)
    }
    
    // Update
    override func update(_ currentTime: TimeInterval) {
        let delta = CGFloat(currentTime - lastTime)
        lastTime = currentTime
        
        player.update(delta)
        machine.update(delta)
        
        // Machine catch the ball
        if (ball.BSprite.physicsBody?.velocity.dy)! > 0 {
            var destination = ball.BSprite.position.x
            
             // Judge the ball go to the left or right of machine
            if destination < machine.PSprite.position.x {
                if destination - (PADDLE_WIDTH / 2) < -(frame.size.width / 2) {
                    destination = -(frame.size.width / 2) + (PADDLE_WIDTH / 2)
                }
            } else if destination > machine.PSprite.position.x {
                if destination + (PADDLE_WIDTH / 2) > (frame.size.width / 2) {
                    destination = (frame.size.width / 2) - (PADDLE_WIDTH / 2)
                }
            }
            
            // Judge the ball is out the paddle or not
            if ball.BSprite.position.y + ball.radius >= machine.PSprite.position.y - (PADDLE_HEIGHT / 2) {
                destination = machine.PSprite.position.x
            }
            
            // Move to destination
            machine.PSprite.run(.moveTo(x: destination, duration: PADDLE_AI_DIFFICULTY))
        }
        
        // Player scores
        if ball.BSprite.position.y - (PADDLE_HEIGHT / 2) > frame.size.height / 2 && !PlayerScored {
            player.score += 1
            
            if player.score >= 4 {
                ToEndGame(true)
            } else {
                ToScore(false)
            }
        }
        
        // Machine scores
        if ball.BSprite.position.y + (PADDLE_HEIGHT / 2) < -(frame.size.height / 2) && !MachineScored {
            machine.score += 1
            
            if machine.score >= 4 {
                ToEndGame(false)
            } else {
                ToScore(true)
            }
        }
    }
    
    // Score
    private func ToScore(_ isAi: Bool) {
        if !isAi {
            PlayerScored = true
        } else {
            MachineScored = true
        }
        
        // Reset ball speed
        BALL_SPEED = BALL_BASE_SPEED
        
        // Reset ball velocity
        ball.BSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        // Show "Score"
        do {
            let impact = SKAction.run({
                let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
                hapticHeavy.impactOccurred()
            })
            let fadeIn = SKAction.fadeIn(withDuration: 0)
            let scaleUp = SKAction.scale(by: 2, duration: 0.5)
            let fadeOut = SKAction.run({ self.ScorePrompt.run(.fadeOut(withDuration: 0.5)) })
            let wait = SKAction.wait(forDuration: 0.5)
            let scaleDown = SKAction.scale(by: 0.5, duration: 0)
            
            ScorePrompt.run(.sequence([ impact, fadeIn, fadeOut, scaleUp, wait, scaleDown ]))
        }
        
        // Sequence 1
        do {
            let initWait = SKAction.wait(forDuration: 0.5)
            let colorBlue = SKAction.run({ self.player.ScoreLabel.fontColor = UIColor(red: 0, green: 153/255, blue: 219/255, alpha: 1) })
            let colorRed = SKAction.run({ self.machine.ScoreLabel.fontColor = UIColor(red: 1, green: 0/255, blue: 68/255, alpha: 1) })
            let hit = SKAction.run({
                let hapticLight = UIImpactFeedbackGenerator(style: .light)
                let impact = SKAction.run({
                    hapticLight.impactOccurred()
                })
                self.ball.BSprite.run(.sequence([ impact ]))
            })
            let scaleUp = SKAction.scale(by: 2, duration: 0.25)
            let scaleDown = SKAction.scale(by: 0.5, duration: 0.25)
            let shake = SKAction.run({
                let duration: Float = 0.25
                let amplitudeX: Float = 10
                let amplitudeY: Float = 6
                let numShakes = duration / 0.04
                var actions: [SKAction] = []
                
                for _ in 1...Int(numShakes) {
                    let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
                    let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
                    let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
                    shakeAction.timingMode = SKActionTimingMode.easeOut
                    actions.append(shakeAction)
                    actions.append(shakeAction.reversed())
                }
                
                if !isAi {
                    self.player.ScoreLabel.run(.sequence(actions))
                } else {
                    self.machine.ScoreLabel.run(.sequence(actions))
                }
            })
            let rumble = SKAction.run({
                let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
                let impact = SKAction.run({
                    hapticHeavy.impactOccurred()
                })
                let wait = SKAction.wait(forDuration: 0.15)
                
                self.ball.BSprite.run(.sequence([ impact, wait, impact, wait, impact ]))
            })
            let wait = SKAction.wait(forDuration: 0.5)
            let colorReset = SKAction.run({ self.player.ScoreLabel.fontColor = UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1); self.machine.ScoreLabel.fontColor = UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1) })
            
            
            if !isAi {
                player.ScoreLabel.run(.sequence([ initWait, colorRed, hit, scaleUp, scaleDown, shake, rumble, wait, colorReset ]))
            } else {
                machine.ScoreLabel.run(.sequence([ initWait, colorBlue, hit, scaleUp, scaleDown, shake, rumble, wait, colorReset ]))
            }
        }
        
        // Sequence 2
        do {
            let fadeOut = SKAction.fadeOut(withDuration: 0)
            let wait = SKAction.wait(forDuration: 2)
            let move = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0)
            let fadeIn = SKAction.fadeIn(withDuration: 1)
            let serve = SKAction.run({
                // Determine serve direction
                let serveDirection = !isAi ? BALL_SERVE_SPEED : -BALL_SERVE_SPEED
                self.ball.BSprite.physicsBody?.velocity = CGVector(dx: 0, dy: serveDirection)
                
                // Reset
                if !isAi { self.PlayerScored = false } else { self.MachineScored = false }
            })
            
            ball.BSprite.run(.sequence([ fadeOut, wait, move, fadeIn, serve ]))
        }
    }
    
    // Either player or machine win
    private func ToEndGame(_ playerWon: Bool) {
        if playerWon {
            PromptInstruction.text = "YOU WON !"
            PromptInstruction.fontColor = UIColor(red: 0, green: 153/255, blue: 219/255, alpha: 1)
            PromptText.text = "Touch to play again."
        } else {
            PromptInstruction.text = "YOU LOSE !"
            PromptInstruction.fontColor = UIColor(red: 1, green: 0/255, blue: 68/255, alpha: 1)
            PromptText.text = "Touch to try again."
        }
        
        // Reset ball speed
        BALL_SPEED = BALL_BASE_SPEED
        
        // Reset ball velocity
        ball.BSprite.run(.fadeOut(withDuration: 0))
        ball.BSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.BSprite.position = CGPoint(x: 0, y: 0)
        
        // Reset prompt
        GameBegin = false
        GameEnd = false
        
        let fadeInSequence = SKAction.sequence([ .wait(forDuration: 1), .fadeIn(withDuration: 1), .run({ self.GameEnd = true; self.ball.BSprite.run(.fadeIn(withDuration: 0)) }) ])
        
        PromptBackground.run(.fadeIn(withDuration: 1))
        PromptBox.run(fadeInSequence)
        PromptText.run(fadeInSequence)
        PromptInstruction.run(fadeInSequence)
    }
    
    // Touch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !GameBegin && GameEnd {
            GameBegin = true
            
            // Reset scores
            player.score = 0
            machine.score = 0
            
            let haptic = UIImpactFeedbackGenerator(style: .heavy)
            haptic.impactOccurred()
            
            // Remove prompt
            PromptBackground.run(.fadeOut(withDuration: 0.5))
            PromptBox.run(.fadeOut(withDuration: 0.5))
            PromptInstruction.run(.fadeOut(withDuration: 0.5))
            PromptText.run(.fadeOut(withDuration: 0.5))
            
            // Serve ball
            ball.BSprite.physicsBody?.velocity = CGVector(dx: 0, dy: -BALL_SERVE_SPEED)
        }
    }
    
    // Run game and handle input
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if GameBegin {
                if location.x + (PADDLE_WIDTH / 2) > (frame.size.width / 2) {
                    player.PSprite.position.x = (frame.size.width / 2) - (PADDLE_WIDTH / 2)
                } else if location.x - (PADDLE_WIDTH / 2) < -(frame.size.width / 2) {
                    player.PSprite.position.x = -(frame.size.width / 2) + (PADDLE_WIDTH / 2)
                } else {
                    player.input(location)
                }
            }
        }
    }
    
    // Run game
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Haptic generators
        let hapticLight = UIImpactFeedbackGenerator(style: .light)
        let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
        
        // Detect contacts here
        switch contactMask {
        case BALL_MASK | WALL_MASK: hapticLight.impactOccurred()
        // Ball collides with Player
        case BALL_MASK | PADDLE_MASK:
            hapticHeavy.impactOccurred()
            
            // Reflect ball towards machine
            reflectBall(false)
            
            // Increase ball speed
            BALL_SPEED += BALL_SPEED_INCREMENT
            
            break
        // Ball collides with AI
        case BALL_MASK | PADDLE_AI_MASK:
            hapticHeavy.impactOccurred()
            
            // Reflect ball towards player
            reflectBall(true)
            
            // Increase ball speed
            BALL_SPEED += BALL_SPEED_INCREMENT
            
            break
        default: break
        }
    }
    
    // Calculate ball's direction
    private func reflectBall(_ isAi: Bool) {
        // Calculate the intersection of the ball
        var relativeIntersect: CGFloat = 0
        if !isAi { relativeIntersect = player.PSprite.position.x - ball.BSprite.position.x }
        else { relativeIntersect = machine.PSprite.position.x - ball.BSprite.position.x }
        
        // Normalize the intersection
        var normalizedIntersect = relativeIntersect / (PADDLE_WIDTH / 2)
        
        // Check if == 0.0
        if normalizedIntersect == 0 {
            let rand = Int.random(in: 1...2)
            if rand == 1 { normalizedIntersect = 0.2 }
            else if rand == 2 { normalizedIntersect = -0.2 }
        }
        
        // Calculate ball's angle
        let bounceAngle = normalizedIntersect * BALL_MAX_ANGLE
        
        // Set the ball's velocity
        if !isAi && normalizedIntersect <= 1 && normalizedIntersect >= -1 && ball.BSprite.position.y >= player.PSprite.position.y {
            let ballDx = BALL_SPEED * -sin(bounceAngle)
            var ballDy = BALL_SPEED *  cos(bounceAngle)
            
            if ballDy < BALL_MIN_Y_INCREMENT { ballDy = BALL_MIN_Y_INCREMENT }
            ball.BSprite.physicsBody?.velocity = CGVector(dx: ballDx, dy: ballDy)
        } else if isAi && normalizedIntersect <= 1 && normalizedIntersect >= -1 && ball.BSprite.position.y <= ball.BSprite.position.y {
            let ballDx = BALL_SPEED * -sin(bounceAngle)
            var ballDy = BALL_SPEED *  cos(bounceAngle)
            
            if ballDy < BALL_MIN_Y_INCREMENT { ballDy = BALL_MIN_Y_INCREMENT }
            ball.BSprite.physicsBody?.velocity = CGVector(dx: ballDx, dy: -ballDy)
        }
    }
}
