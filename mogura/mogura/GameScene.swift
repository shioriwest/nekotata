//
//  GameScene.swift
//  mogura
//
//  Created by 西島志織 on 2016/08/27.
//  Copyright (c) 2016年 西島志織. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    // ねこくんの位置（x,y）
    let nekoPoint = [[200, 300], [600, 400], [300, 600], [650, 700], [250, 900]]
    
    // ねこくんを入れる配列を用意する
    var nekoArray:[SKSpriteNode] = []
    
    // スコアとスコア表示用ラベルを用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    // 残り時間と残り時間表示用ラベルとタイマーを用意する
    var timeCount = 15
    let timeLabel = SKLabelNode(fontNamed: "Verdana-bold")
    var myTimer = NSTimer()
    
    // オーディオ
    var player = AVAudioPlayer()
    
    
    override func didMoveToView(view: SKView) {
        // BGMの設定
        let bgm_url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bgm", ofType:"mp3")!) 
        player = try! AVAudioPlayer(contentsOfURL: bgm_url, fileTypeHint: "mp3")
        player.play()
        
        // 背景の作成
        let background = SKSpriteNode(imageNamed: "play.jpg")
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.size = CGSize(width: size.width, height: size.height)
        
        // ゲームシーンに追加する
        self.addChild(background)
        
        scoreLabel.text = "SCORE:\(score)"
        scoreLabel.fontSize = 50
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: 40, y: 1250)
        self.addChild(scoreLabel)
        
        
        // ねこくんの準備
        for i in 0...4 {
            
            // ねこくんのあな
            let hole = SKSpriteNode(imageNamed: "glass.png")
            hole.position = CGPoint(x:nekoPoint[i][0], y:nekoPoint[i][1])
            self.addChild(hole)
            
            var neko: SKSpriteNode
            if (i == 0 || i == 1 || i == 4) {
                // ねこくん
                neko = SKSpriteNode(imageNamed: "neko.png")
                neko.name = "neko"
                neko.position = CGPoint(x:nekoPoint[i][0], y:nekoPoint[i][1])
            } else if (i == 2) {
                // ねこくん
                neko = SKSpriteNode(imageNamed: "nekutai.png")
                neko.name = "neku"
                neko.position = CGPoint(x:nekoPoint[i][0], y:nekoPoint[i][1])
            } else {
                // ねこくん
                neko = SKSpriteNode(imageNamed: "ribon.png")
                neko.name = "ribo"
                neko.position = CGPoint(x:nekoPoint[i][0], y:nekoPoint[i][1])
            }
            self.addChild(neko)
            
            nekoArray.append(neko)
            
            // ねこくんを地下に移動する
            let action1 = SKAction.moveToY(-1000, duration: 0.0)
            
            // 0〜4秒ランダムに時間待ち(2秒を中心に前後4秒範囲)
            let action2 = SKAction.waitForDuration(2.0, withRange: 4.0)
            
            // ねこくんを穴の位置に移動するアクション
            let action3 = SKAction.moveToY(hole.position.y, duration: 0.0)
            
            // 0~2秒でランダムに時間待ち
            let action4 = SKAction.waitForDuration(1.0, withRange: 2.0)
            
            let actionS = SKAction.sequence([action1, action2, action3, action4])
            
            // ActionSをずっとくりかえす
            let actionR = SKAction.repeatActionForever(actionS)
            
            neko.runAction(actionR)
        }
        
        timeLabel.text = "Time:\(timeCount)"
        timeLabel.horizontalAlignmentMode = .Left
        timeLabel.fontSize = 50
        timeLabel.fontColor = SKColor.blackColor()
        timeLabel.position = CGPoint(x: 480, y: 1250)
        self.addChild(timeLabel)
        
        // タイマーをスタートさせる
        myTimer = NSTimer.scheduledTimerWithTimeInterval(
            1.0, target: self, selector: "timeUpdate", userInfo: nil, repeats: true)
        
    }
    
    func timeUpdate() {
        timeCount--
        timeLabel.text = "Time:\(timeCount)"
        
        // タイムオーバー時の挙動
        if timeCount < 1 {
            myTimer.invalidate()
            
            var next:SKScene
            // 200点以上の場合はハイスコア画面に遷移
            if (score >= 200) {
                next = HighScoreScene(size: self.size)
            } else {
                next = GameOverScene(size: self.size)
            }
            
            let scene = next
            let skView = self.view as! GameSKView
            skView.score = score
            scene.scaleMode = SKSceneScaleMode.AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            // タッチした位置にあるものを調べる
            let touchNode = self.nodeAtPoint(location)
            
            for i in 0...4 {
                if touchNode == nekoArray[i] {
                    var name = ""
                    // 何をタッチしたかによって点数の配分を変更するのと、やられたねこくんの画像ファイル名を修正
                    if (touchNode.name == "neku") {
                        name = "tobaneku.png"
                        score += 30
                    } else if (touchNode.name == "ribo") {
                        name = "tobaribo.png"
                        score += 20
                    } else {
                        name = "tobaneko.png"
                        score += 10
                    }
                    scoreLabel.text = "SCORE:\(score)"
                    
                    var effect : SKAction = SKAction.playSoundFileNamed("touch.mp3", waitForCompletion: true)
                    
                    // やられたねこくんを表示
                    let neko = SKSpriteNode(imageNamed: name)
                    neko.position = touchNode.position
                    self.addChild(neko)
                    
                    let action1 = SKAction.rotateByAngle(6.28, duration: 0.3)
                    let action2 = SKAction.moveToY(touchNode.position.y + 200, duration: 0.3)
                    let actionG = SKAction.group([action1, action2])
                    
                    let action3 = SKAction.removeFromParent()
                    let actionS = SKAction.sequence([actionG, action3])
                    
                    self.runAction(effect)
                    neko.runAction(actionS)
                    
                    // ねこくんを地下に移動して消す
                    touchNode.position.y = -1000
                }
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
