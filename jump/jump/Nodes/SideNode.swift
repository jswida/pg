//
//  SideNode.swift
//  jump
//
//  Created by joanthesiren on 23/01/2022.
//

import  SpriteKit

class SideNode: SKNode {
    
    //MARK: - Properties
    private var node: SKSpriteNode!
    
    //MARK: - Initializes
    override init() {
        super.init()
        self.name = "Side"
        self.zPosition = 5.0
        
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


//MARK: - Setupds
extension SideNode {
    
    private func setupPhysics(){
        let size = CGSize(width: 40.0, height: screenHeight)
        node  = SKSpriteNode(color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 1.0
        node.physicsBody?.restitution = 1.0
        node.physicsBody?.categoryBitMask = PhysicsCategories.Side
        addChild(node)
    }

}
