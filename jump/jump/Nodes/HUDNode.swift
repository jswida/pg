//
//  HUDNode.swift
//  jump
//
//  Created by joanthesiren on 23/01/2022.
//

import SpriteKit

class HUDNode: SKNode {
    
    //MARK: - Properties
    private var topScoreShape: SKShapeNode!
    private var topScoreLbl: SKLabelNode!
    
    private var gameOverShape: SKShapeNode!
    private var gameOverNode: SKSpriteNode!
    
    private var homeNode: SKSpriteNode!
    private var againNode: SKSpriteNode!
    
    private var scoreTitleLbl: SKLabelNode!
    private var scoreLbl: SKLabelNode!
    private var highscoreTitleLbl: SKLabelNode!
    private var highscoreLbl: SKLabelNode!
    
    private var panelNode: SKSpriteNode!
    
    var easeScene: GameScene?
    var skView: SKView!
    
    private var isHome = false {
        didSet {
            updateBtn(node: homeNode, event: isHome)
        }
    }
    private var isAgain = false {
        didSet {
            updateBtn(node: againNode, event: isAgain)
        }
    }
    private var isPanel = false {
        didSet {
            updateBtn(node: panelNode, event: isPanel)
        }
    }
    //MARK: - Initializes
    override init() {
        super.init()
        setupTopScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        
        if node.name == "Home" && !isHome{
            isHome = true
        }
        
        if node.name == "PlayAgain" && !isAgain {
            isAgain = true
        }
        if node.name == "Panel" && !isPanel {
            isPanel = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isHome {
            isHome = false
            print("home")
        }
        if isAgain {
            isAgain = false
            
            if let _ = easeScene {
                let scene = GameScene(size: CGSize(width: screenWidth, height: screenHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
        }
        if isPanel {
            isPanel = false
            removeNode()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = homeNode?.parent {
            isHome = homeNode.contains(touch.location(in: parent))
        }
        
        if let parent = againNode?.parent {
            isAgain = againNode.contains(touch.location(in: parent))
        }
        
        if let parent = panelNode?.parent {
            isPanel = panelNode.contains(touch.location(in: parent))
        }
    }
}


//MARK: - Setupds
extension HUDNode {
    
    private func setupTopScore(){
        let statusH: CGFloat = appDL.isIPhoneX ? 88 : 40
        let scoreY: CGFloat = screenHeight - (statusH + 90/2 + 20)
        
        topScoreShape = SKShapeNode(rectOf: CGSize(width: 220, height: 90), cornerRadius: 8.0)
        topScoreShape.fillColor = UIColor(hex: 0x000000, alpha: 0.5)
        topScoreShape.zPosition = 20.0
        topScoreShape.position = CGPoint(x: screenWidth/2, y: scoreY)
        addChild(topScoreShape)
        
        topScoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        topScoreLbl.fontSize = 60.0
        topScoreLbl.text = "0"
        topScoreLbl.fontColor = .white
        topScoreLbl.zPosition = 25.0
        topScoreLbl.position = CGPoint(x: topScoreShape.frame.midX, y: topScoreShape.frame.midY - topScoreLbl.frame.height/2)
        addChild(topScoreLbl)
        
    }
    
    func updateScore(_ score: Int) {
        topScoreLbl.text = "\(score)"
        topScoreLbl.run(.sequence([
            .scale(to: 1.3, duration: 0.1),
            .scale(to: 1.0, duration: 0.1),
        ]))
    }
    
    private func removeNode() {
        gameOverShape?.removeFromParent()
        gameOverNode?.removeFromParent()
        panelNode?.removeFromParent()
    }

}


//MARK: - GameOver
extension HUDNode {
    
    private func updateBtn(node: SKNode, event: Bool) {
        var alpha: CGFloat = 1.0
        if event {
            alpha = 0.5
        }
        node.run(.fadeAlpha(to: alpha, duration: 0.1))
    }
    
    private func crerateGameOverShape() {
        gameOverShape = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight))
        gameOverShape.zPosition = 49.0
        gameOverShape.fillColor = UIColor(hex: 0x000000, alpha: 0.7)
        addChild(gameOverShape)
    }
    
    private func createGamePanel(_ name: String, scale: CGFloat){
        gameOverNode = SKSpriteNode(imageNamed: name)
        gameOverNode.setScale(scale)
        gameOverNode.zPosition = 50.0
        gameOverNode.position = CGPoint(x:screenWidth/2, y:screenHeight/2)
        addChild(gameOverNode)
    }
    
    func setupGameOver(_ score: Int, highscore: Int) {
        crerateGameOverShape()
        
        isUserInteractionEnabled = true
        let scale: CGFloat = appDL.isIPhoneX ? 0.6 : 0.7
        
        createGamePanel("panel-gameOver", scale: scale)
        
        againNode = SKSpriteNode(imageNamed: "icon-playAgain")
        againNode.setScale(scale)
        againNode.zPosition = 55.0
        againNode.position = CGPoint(
            x: gameOverNode.frame.midX,
            y: gameOverNode.frame.minY + againNode.frame.height - 20)
        againNode.name = "PlayAgain"
        addChild(againNode)
        
        scoreTitleLbl = SKLabelNode(fontNamed: FontName.wheaton)
        scoreTitleLbl.fontSize = 60.0
        scoreTitleLbl.text = "Score:"
        scoreTitleLbl.fontColor = .white
        scoreTitleLbl.zPosition = 55.0
        scoreTitleLbl.position = CGPoint(
            x: gameOverNode.frame.minX + scoreTitleLbl.frame.width/2 + 30,
            y: screenHeight/2)
        addChild(scoreTitleLbl)
        
        scoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        scoreLbl.fontSize = 60.0
        scoreLbl.text = "\(score)"
        scoreLbl.fontColor = .white
        scoreLbl.zPosition = 55.0
        scoreLbl.position = CGPoint(
            x: gameOverNode.frame.maxX - scoreTitleLbl.frame.width/2 - 30,
            y: scoreTitleLbl.position.y)
        addChild(scoreLbl)
        
        highscoreTitleLbl = SKLabelNode(fontNamed: FontName.wheaton)
        highscoreTitleLbl.fontSize = 60.0
        highscoreTitleLbl.text = "Highscore"
        highscoreTitleLbl.fontColor = .white
        highscoreTitleLbl.zPosition = 55.0
        highscoreTitleLbl.position = CGPoint(
            x: gameOverNode.frame.minX + highscoreTitleLbl.frame.width/2 + 30,
            y: screenHeight/2 - highscoreTitleLbl.frame.height*2)
        addChild(highscoreTitleLbl)
        
        highscoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        highscoreLbl.fontSize = 60.0
        highscoreLbl.text = "\(highscore)"
        highscoreLbl.fontColor = .white
        highscoreLbl.zPosition = 55.0
        highscoreLbl.position = CGPoint(
            x: gameOverNode.frame.maxX - scoreTitleLbl.frame.width/2 - 30,
            y: highscoreTitleLbl.position.y)
        addChild(highscoreLbl)
        
    }
}


//MARK: - Notif
extension HUDNode {
    func setupPanel(btnName: String)
    {
        crerateGameOverShape()
        isUserInteractionEnabled = true
        let scale: CGFloat = appDL.isIPhoneX ? 0.6 : 0.7
        createGamePanel(btnName, scale: scale)
        
        panelNode = SKSpriteNode(imageNamed: "icon-letsGo")
        panelNode.setScale(scale)
        panelNode.zPosition = 55.0
        panelNode.position = CGPoint(
            x: gameOverNode.frame.midX,
            y: gameOverNode.frame.midY)
        panelNode.name = "Panel"
        addChild(panelNode)
    }
}
