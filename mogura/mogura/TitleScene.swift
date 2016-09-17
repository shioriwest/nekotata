//
//  TitleScene.swift
//  mogura
//
//  Created by 西島志織 on 2016/08/27.
//  Copyright © 2016年 西島志織. All rights reserved.
//

import SpriteKit
import AVFoundation

class TitleScene: SKScene {
    let titleLabel = SKLabelNode(fontNamed:"Arial Iatlic")
    let startLabel = SKLabelNode(fontNamed:"ArialRoundedMTBold")
    let help = SKSpriteNode(imageNamed: "help.png")
    
    // オーディオ
    var player = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        // BGMの設定
        let bgm_url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bgm", ofType:"mp3")!)
        player = try! AVAudioPlayer(contentsOfURL: bgm_url, fileTypeHint: "mp3")
        player.numberOfLoops = -1 // くりかえし
        player.play()
        
        // 背景の作成
        let background = SKSpriteNode(imageNamed: "title2.jpg")
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.size = CGSize(width: size.width, height: size.height)
        
        // ゲームシーンに追加する
        self.addChild(background)
        
        titleLabel.text = "ねこくんたたきゲーム"
        titleLabel.fontSize = 70
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x: 375, y: 1200)
        // self.addChild(titleLabel)
        
        startLabel.text = "START"
        startLabel.fontSize = 80
        startLabel.position = CGPoint(x: 375, y: 200)
        self.addChild(startLabel)
        
        // ヘルプ画面りんく
        help.position = CGPoint(x:690, y:1290)
        self.addChild(help)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            
            // ゲーム画面へ遷移
            if touchNode == startLabel {
                let skView = self.view! as SKView
                let scene = GameScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                skView.presentScene(scene)
            }
            // 説明画面に遷移
            if touchNode == help {
                let skView = self.view! as SKView
                let scene = LectureScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                skView.presentScene(scene)
            }
        }
    }
    
}
