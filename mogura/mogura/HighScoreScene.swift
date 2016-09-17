//
//  GameOverScene.swift
//  mogura
//
//  Created by 西島志織 on 2016/08/28.
//  Copyright © 2016年 西島志織. All rights reserved.
//

import SpriteKit
import AVFoundation

class HighScoreScene: SKScene {
    let endLabel = SKLabelNode(fontNamed:"ArialRoundedMTBold")
    let replayLabel = SKLabelNode(fontNamed:"ArialRoundedMTBold")
    let scoreLabel = SKLabelNode(fontNamed:"Verdana-bold")

    // オーディオ
    var player = AVAudioPlayer()

    override func didMoveToView(view: SKView) {
        // BGMの設定
        let bgm_url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("high", ofType:"mp3")!)
        player = try! AVAudioPlayer(contentsOfURL: bgm_url, fileTypeHint: "mp3")
        player.play()
        
        // 背景の作成
        let background = SKSpriteNode(imageNamed: "high2.jpg")
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.size = CGSize(width: size.width, height: size.height)
        
        // ゲームシーンに追加する
        self.addChild(background)
        
        endLabel.text = "HIGH SCORE"
        endLabel.fontSize = 80
        endLabel.fontColor = SKColor.blackColor()
        endLabel.position = CGPoint(x: 375, y: 1000)
        // self.addChild(endLabel)
        
        replayLabel.text = "REPLAY"
        replayLabel.fontSize = 70
        replayLabel.fontColor = SKColor.cyanColor()
        replayLabel.position = CGPoint(x: 375, y: 200)
        self.addChild(replayLabel)
        
        let gameSKView = self.view as! GameSKView
        scoreLabel.text = "SCORE:\(gameSKView.score)"
        scoreLabel.fontSize = 75
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: 375, y: 1150)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            
            if touchNode == replayLabel {
                let skView = self.view! as SKView
                let scene = TitleScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                skView.presentScene(scene)
            }
        }
    }
    
}
