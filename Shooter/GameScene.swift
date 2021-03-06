//
//  GameScene.swift
//  Shooter
//
//bean edits
//add shoot down egg, shoot power up drops






//  Created by Dean Sponholz on 6/11/16.
//  Copyright (c) 2016 Dean Sponholz. All rights reserved.
//http://www.theappguruz.com/blog/how-to-make-a-2d-game-background-in-photoshop
//https://www.quora.com/How-would-I-use-SpriteKit-to-make-a-health-and-stamina-bar-in-swift

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //SpriteNodes
    
        //scene
    var backgroundImageNode = SKSpriteNode()
    var groundDirt = SKSpriteNode()
    var groundGrass = SKSpriteNode()
    
        //label
    var mainMenuLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var eggLabelNode = SKSpriteNode()
    var eggLabelScoreNode = SKLabelNode()
    
    var userDefaults = NSUserDefaults()
    var hitCount:Int = 0
    var highScoreShow = Int()
    var score: Int = 0
    var eggScore: Int = 0
    var myTimer = NSTimer()
    var test: Bool = true
    var destinationPoint = CGPoint()
    var eggSpawnInt: Int = 0
    var enemyRespawnSpeed: Double = 2.0
    var dragonFlightSpeed: Double = 4.0
    var projectileFlightSpeed: Double = 3.5
        //interactive
    var bulletNode = SKSpriteNode()
    var scopeNode = SKSpriteNode()
    var turretNode = SKSpriteNode()
    var rightBarNode = SKSpriteNode()
    
    var enemy = SKSpriteNode()
    var enemyPosition = CGPoint()
    var projectileNode = SKSpriteNode()
    var dragonNode = SKSpriteNode()
    var atlas = SKTextureAtlas()
    var dragonFlyFrames : [SKTexture]!
    var eggFlyFrames : [SKTexture]!
    var dragonProjectileNode = SKSpriteNode()
    var healthbar = SKSpriteNode()
    var healthbarFrame = SKSpriteNode()
    var healthRatio: Int = 1
    
    //var shootTimer = NSTimer()
    var dragonDied = Bool()
    var collisionHappenedDragon_Bullet = Bool()
    var collisionHappenedProjectile_Turret = Bool()
    var collisionHappenedProjectile_Bullet = Bool()
    var collisionHappenedDragon_Frame = Bool()
    var vx = CGFloat()
    var vy = CGFloat()
    
    var touching = Bool()
    var positionInScene = CGPoint()
    var scopeColor = UIColor()
    var clearColor = UIColor()
    var shootLocationX = CGFloat()
    var shootDelayTime = Double()
    //var scopeCurrentColor = UIColor()
    
    let None: UInt32 = 0
    let bulletCategory: UInt32 = 0x1 << 0
    let dragonCategory: UInt32 = 0x1 << 1
    let dragonProjectileCategory: UInt32 = 0x1 << 2
    let turretCategory: UInt32 = 0x1 << 3
    let frameCategory: UInt32 = 0x1 << 4
    //let eggCategory: UInt32 = 0x1 << 4

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        createScene()
        startGame()
        
    }
    
    func createScene(){
        
        //backgroundColor = UIColor.blackColor()
        
        loadAppearance_Background()
        loadAppearance_MainMenuLabel()
        loadAppearance_EggScoreLabel()
        loadAppearance_ScoreLabel()
        loadAppearance_Bullet()
        loadAppearance_Turret()
        castleLoadAppearance_healthbar()
        rightBar()
        addPhysicsWorld()
        
    }
    
    func startGame(){

        //loadAppearance_Dragon()
        //loadAppearance_DragonProjectile()
        
        //dragonFlyAnimation()
        //spawnEnemies()
        //eggMoveRight()
        //shootProjectile()
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(enemyRespawnSpeed, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
        //levelManager()
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    func loadAppearance_Background(){
        backgroundImageNode = SKSpriteNode(imageNamed: "graph_paper_background")
        backgroundImageNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        backgroundImageNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        backgroundImageNode.name = "background"
        backgroundImageNode.zPosition = 0
        self.addChild(backgroundImageNode)
        

    }

    func loadAppearance_MainMenuLabel(){
        //ReloadLabel
        mainMenuLabel = SKLabelNode(fontNamed:"Chalkduster")
        mainMenuLabel.text = "Menu"
        //mainMenuLabel.fontColor = UIColor.blackColor()
        mainMenuLabel.fontSize = 80
        mainMenuLabel.position = CGPointMake(self.frame.size.width * 0.15, self.frame.size.height * 0.95)
        mainMenuLabel.name = "MainMenu"
        mainMenuLabel.fontColor = UIColor.blackColor()
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)
    }
    
    func loadAppearance_ScoreLabel(){
        //ReloadLabel
        scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel.text = "0"
        //mainMenuLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = 80
        scoreLabel.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.95)
        //scoreLabel.name = "MainMenu"
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
    }
    
    func loadAppearance_EggScoreLabel(){
        //eggLabel
        eggLabelNode = SKSpriteNode(imageNamed: "EggLabel")
        eggLabelNode.setScale(0.50)
        eggLabelNode.position = CGPointMake(self.frame.size.width * 0.085, self.frame.size.height * 0.1)
        eggLabelNode.zPosition = 1
        self.addChild(eggLabelNode)
        //eggScoreLabel
        eggLabelScoreNode = SKLabelNode(fontNamed: "Chalkduster")
        let x = (String(userDefaults.valueForKey("highscore")!))
        eggLabelScoreNode.text = x
        eggLabelScoreNode.fontSize = 80
        eggLabelScoreNode.position = CGPointMake(self.frame.size.width * 0.085, self.frame.size.height * 0.025)
        eggLabelScoreNode.fontColor = UIColor.blackColor()
        eggLabelScoreNode.zPosition = 1
        self.addChild(eggLabelScoreNode)
        
    }
    
    func rightBar(){
        rightBarNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width * 0.045, self.frame.size.height))
        rightBarNode.position = CGPointMake(self.frame.size.width * 1.1 , self.frame.size.height / 2)
        rightBarNode.physicsBody = SKPhysicsBody(rectangleOfSize: rightBarNode.size)
        rightBarNode.zPosition = 2
        rightBarNode.physicsBody?.affectedByGravity = false
        rightBarNode.physicsBody?.dynamic = true
        rightBarNode.physicsBody!.categoryBitMask = frameCategory
        rightBarNode.physicsBody!.usesPreciseCollisionDetection = true
        
        rightBarNode.physicsBody!.collisionBitMask = 0
        rightBarNode.physicsBody!.contactTestBitMask = dragonCategory
        self.addChild(rightBarNode)
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    /*
     
     //Turrent, Bullet, Scope
 
     */
    func loadAppearance_Turret(){
        //turretNode
        turretNode = SKSpriteNode(imageNamed: "turret")
        turretNode.anchorPoint = CGPointMake(0.5, 0.5)
        turretNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09)
        turretNode.zPosition = 3
        turretNode.physicsBody = SKPhysicsBody(texture: turretNode.texture!, size: CGSizeMake(turretNode.size.width, turretNode.size.height))
        turretNode.physicsBody?.affectedByGravity = false
        turretNode.physicsBody?.dynamic = false
        turretNode.physicsBody?.categoryBitMask = turretCategory
        turretNode.physicsBody?.restitution = 0
        //turretNode.physicsBody?.collisionBitMask = dragonProjectileCategory
        turretNode.physicsBody?.contactTestBitMask = dragonProjectileCategory
        self.addChild(turretNode)
    }
    
    func loadAppearance_Bullet(){
        
        //objectShotNode
        bulletNode = SKSpriteNode(imageNamed: "bullet")
        let texture = SKTexture(imageNamed: "bullet")
        bulletNode.setScale(3.0)
        
        bulletNode.anchorPoint = CGPointMake(0.5, 0.5)
        bulletNode.position = CGPointMake(self.frame.size.width * 0.5085, self.frame.size.height * 0.20)
        bulletNode.zPosition = 2
        bulletNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        bulletNode.physicsBody?.affectedByGravity = false
        bulletNode.physicsBody?.dynamic = true
        bulletNode.physicsBody?.categoryBitMask = bulletCategory
        bulletNode.physicsBody?.collisionBitMask = dragonCategory
        bulletNode.physicsBody?.contactTestBitMask = dragonCategory
        bulletNode.physicsBody?.contactTestBitMask = dragonProjectileCategory


        self.addChild(bulletNode)
        
    }
    
    func resetBullet(){

        bulletNode.removeFromParent()
        loadAppearance_Bullet()
    
        bulletNode.zRotation = 0
        view?.userInteractionEnabled = true
    }
    
    func loadAppearance_Scope(){
        //scopeNode
        scopeNode = SKSpriteNode(imageNamed: "scope")
        scopeNode.setScale(1.5)
        scopeNode.anchorPoint = CGPointMake(0.5, 0.5)
        scopeNode.zPosition = 4
        //scopeNode.hidden = true
        //colorizeScope(scopeNode)
        self.addChild(scopeNode)
    }
    
    func colorizeScope(scopeNode: SKSpriteNode){
        
        let fadeOutAction = SKAction.fadeOutWithDuration(0.425)
        let hideAction = SKAction.hide()
        let actionSequence = SKAction.sequence([fadeOutAction, hideAction])
        scopeNode.runAction(actionSequence)
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    func loadAppearance_Dragon() -> SKSpriteNode{

        let dragonAnimatedAtlas = SKTextureAtlas(named: "redDragonSprites")
        var flyFrames = [SKTexture]()
        let numImages = dragonAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let dragonTextureName = "redDragon\(i)"
            flyFrames.append(dragonAnimatedAtlas.textureNamed(dragonTextureName))
        }
        dragonFlyFrames = flyFrames
        let firstFrame = dragonFlyFrames[0]
        
        let dragonNode = SKSpriteNode(texture: firstFrame)
        dragonNode.anchorPoint = CGPointMake(0.5, 0.5)
        //dragonNode.setScale(0.225)
        dragonNode.zPosition = 2
        dragonNode.position = loadRandSpawnLeft()
        //dragonNode.name = "redDragon"
        dragonNode.physicsBody = SKPhysicsBody(texture: dragonNode.texture!, size: CGSizeMake(dragonNode.size.width, dragonNode.size.height))
        dragonNode.physicsBody?.affectedByGravity = false
        dragonNode.physicsBody?.dynamic = false
        dragonNode.physicsBody?.categoryBitMask = dragonCategory
        dragonNode.physicsBody?.usesPreciseCollisionDetection = true
        dragonNode.physicsBody?.collisionBitMask = bulletCategory | frameCategory
        //dragonNode.physicsBody?.collisionBitMask = frameCategory
        dragonNode.physicsBody?.contactTestBitMask = bulletCategory | frameCategory
        //dragonNode.physicsBody?.contactTestBitMask = frameCategory
        return dragonNode
        
    }
    
    func resetDragon(){

        dragonNode.removeFromParent()
        
        self.addChild(dragonNode)
        self.addChild(dragonProjectileNode)
        let point = loadRandSpawnLeft()
        dragonNode.runAction(SKAction.moveTo(point, duration: 0.0))
        dragonProjectileNode.runAction(SKAction.moveTo(point, duration: 0.0))
        
    }
    
    
    func dragonMoveRight(enemy: SKSpriteNode){
        
        destinationPoint = loadRandDestinationRight()
        
        //print(destinationPoint, "dragon")
        
        
        if score == 5{
            dragonFlightSpeed = 3.8
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1.7, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 4.25
        }
        
        if score == 10{
            dragonFlightSpeed = 3.6
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 3.75
        }
        
        if score == 15{
            dragonFlightSpeed = 3.4
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 3.25
        }
        if score == 20{
            dragonFlightSpeed = 3.2
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 2.75
        }
        if score == 25{
            dragonFlightSpeed = 3.0
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 2.25
        }
        if score == 30{
            dragonFlightSpeed = 2.8
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 1.75
        }
        if score == 35{
            dragonFlightSpeed = 2.6
            myTimer.invalidate()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: ("spawnEnemies"), userInfo: nil, repeats: true)
            //projectileFlightSpeed = 1.75
        }
        /*
        if score == 40{
            dragonFlightSpeed = 4.33
            //projectileFlightSpeed = 1.75
        }
        if score == 45{
            dragonFlightSpeed = 4.0
            //projectileFlightSpeed = 1.75
        }
        if score == 50{
            dragonFlightSpeed = 3.66
            //projectileFlightSpeed = 1.75
        }
 */
        
        let moveDragon = SKAction.moveTo(destinationPoint, duration: dragonFlightSpeed)
        enemy.runAction(moveDragon)
    }
    
    func dragonFlyAnimation(enemy: SKSpriteNode){
        enemy.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(dragonFlyFrames, timePerFrame: 0.125)))
    }
    
    func spawnEnemies(){
        //dragonDied = true
        enemy = loadAppearance_Dragon()
        projectileNode = loadAppearance_DragonProjectile()
        
        enemy.name = "enemyDragon"
        projectileNode.name = "enemyProjectile"
        self.addChild(enemy)
        self.addChild(projectileNode)
        
        //dragonProjectileNode.position = enemy.position
        dragonMoveRight(enemy)
        dragonFlyAnimation(enemy)
        
        /*
        let delay = SKAction.waitForDuration(loadRandDropTime())
        let loadAction = SKAction.runBlock {
            if self.dragonDied != true{
                self.projectileNode.position = self.enemy.position
                self.projectileNode.hidden = false
            }
        }
        let shoot = SKAction.runBlock {
            if self.dragonDied != true{
                self.shootProjectile(self.projectileNode, enemyParam: self.enemy)
            }
            self.dragonDied = false
        }
 
        
        let sequence = SKAction.sequence([delay, loadAction, shoot])
        projectileNode.runAction(sequence)
 */
        shootProjectileTest(projectileNode, enemyParam: enemy)

        
        
    }

    func loadAppearance_DragonProjectile() -> SKSpriteNode{
        let projectileAnimatedAtlas = SKTextureAtlas(named: "Eggs")
        var flyFrames2 = [SKTexture]()
        let numImages = projectileAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let eggTextureName = "Egg\(i)"
            flyFrames2.append(projectileAnimatedAtlas.textureNamed(eggTextureName))
        }
        eggFlyFrames = flyFrames2
        let firstFrame = eggFlyFrames[0]

        let dragonProjectileNode = SKSpriteNode(texture: firstFrame)
        //dragonProjectileNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width * 0.065, self.frame.size.width * 0.065))
        dragonProjectileNode.setScale(0.775)
        
        //dragonProjectileNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09)
        dragonProjectileNode.zPosition = 3
        //dragonProjectileNode.name = "projectile"
        dragonProjectileNode.physicsBody = SKPhysicsBody(texture: dragonProjectileNode.texture!, size: (dragonProjectileNode.texture?.size())!)
        //dragonProjectileNode.physicsBody = SKPhysicsBody(texture: dragonProjectileNode.texture!, size: CGSizeMake(dragonProjectileNode.size.width, dragonProjectileNode.size.height))
        dragonProjectileNode.physicsBody?.collisionBitMask = turretCategory
        dragonProjectileNode.physicsBody?.affectedByGravity = false
        dragonProjectileNode.physicsBody?.dynamic = true
        dragonProjectileNode.physicsBody?.categoryBitMask = dragonProjectileCategory
        dragonProjectileNode.physicsBody?.collisionBitMask = 0
        dragonProjectileNode.physicsBody?.contactTestBitMask = turretCategory
        dragonProjectileNode.hidden = true
        //eggFlyAnimation()
        
        return dragonProjectileNode
        //eggMoveRight()
        //dragonNode.addChild(dragonProjectileNode)
    }
    
    func eggFlyAnimation(projectile: SKSpriteNode){
        projectile.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(eggFlyFrames, timePerFrame: 0.225)))
    }
    
    func shootProjectileTest(projectileNode: SKSpriteNode, enemyParam: SKSpriteNode){
        
        
        //aim
        let dx = turretNode.position.x - dragonNode.position.x
        let dy = turretNode.position.y - dragonNode.position.y
        let angle = atan2(dy, dx)
        
        //Seek
        var vx = turretNode.position.x
        var vy = turretNode.position.y
        
        
        let shootAction = SKAction.moveTo(CGPointMake(vx, vy),duration: projectileFlightSpeed)
        
        
        
        let delay = SKAction.waitForDuration(loadRandDropTime())
        
        let loadAction = SKAction.runBlock {
            if self.dragonDied != true{
                projectileNode.position = enemyParam.position
                projectileNode.hidden = false
            }
        }
        
        let shoot = SKAction.runBlock {
            if self.dragonDied != true{
                projectileNode.runAction(shootAction)
                self.eggFlyAnimation(projectileNode)
            }
            self.dragonDied = false
        }
        
        let sequence = SKAction.sequence([delay, loadAction, shoot])
        projectileNode.runAction(sequence)

    }
    
    func shootProjectile(projectileNode: SKSpriteNode, enemyParam: SKSpriteNode) {
        
        //aim
        let dx = turretNode.position.x - dragonNode.position.x
        let dy = turretNode.position.y - dragonNode.position.y
        let angle = atan2(dy, dx)
        
        //Seek
        var vx = turretNode.position.x
        var vy = turretNode.position.y

        
        let shootAction = SKAction.moveTo(CGPointMake(vx, vy),duration: projectileFlightSpeed)

        
        projectileNode.runAction(shootAction)
    }
    

    func castleLoadAppearance_healthbar(){
        
        healthbarFrame = SKSpriteNode(imageNamed: "healthBarFrame")
        healthbarFrame.position = CGPointMake(self.frame.size.width * 0.670, self.frame.size.height * 0.8)
        healthbarFrame.setScale(2.0)
        healthbarFrame.xScale = (2.5)
        healthbarFrame.zPosition = 1
        healthbarFrame.anchorPoint = CGPointZero
        self.addChild(healthbarFrame)
        
        
        healthbar = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(self.frame.size.width * 0.26, self.frame.size.height * 0.0223))
        healthbar.zPosition = 1
        healthbar.anchorPoint = CGPointMake(0, 0.5)
        healthbar.position = CGPointMake(self.frame.size.width * 0.7, self.frame.size.height * 0.9615)
        self.addChild(healthbar)
    }

    
    func loadRandDropTime() -> NSTimeInterval{
    
    
    //or minNodeTimeValue?
    var MinNodeSpawnValue = 1.0
    
    //or maxNodeTimeValue?
    var MaxNodeSpawnValue = dragonFlightSpeed - 0.5
    
    //or randomTime?
    var randomPoint = UInt32(MaxNodeSpawnValue - MinNodeSpawnValue)
        
    return (NSTimeInterval(arc4random_uniform(randomPoint)) + MinNodeSpawnValue)
    
        
    }
    
    func getEnemyPosition(enemy: SKSpriteNode) -> CGPoint{
        return enemy.position
    }
    
    func loadRandDropXPoint(enemy: SKSpriteNode) -> CGFloat{
        var MinSpawnValue = self.frame.size.width * 0.1
        var MaxSpawnValue = self.frame.size.width * 0.9
        var dropPoint = UInt32(MaxSpawnValue - MinSpawnValue)
        
        return CGFloat(CGFloat(arc4random_uniform(dropPoint)) + MinSpawnValue)
    }

    func loadRandSpawnLeft() -> CGPoint{
        var MinSpawnValue = self.frame.size.height * 0.45
        var MaxSpawnValue = self.frame.size.height * 0.8
        var SpawnPosition = UInt32(MaxSpawnValue - MinSpawnValue)
        return CGPointMake(self.frame.size.width * 0.0075, CGFloat(arc4random_uniform(SpawnPosition)) + MinSpawnValue)
    }
    func loadRandDestinationRight() -> CGPoint{
        var MinSpawnValue = self.frame.size.height * 0.45
        var MaxSpawnValue = self.frame.size.height * 0.85
        var SpawnPosition = UInt32(MaxSpawnValue - MinSpawnValue)
        return CGPointMake(self.frame.size.width, CGFloat(arc4random_uniform(SpawnPosition)) + MinSpawnValue)
    }
    
    func saveHighscore(){
        userDefaults = NSUserDefaults.standardUserDefaults()
        let highscore = userDefaults.integerForKey("highscore")
        
        if (score > highscore){
            userDefaults.setInteger(score, forKey: "highscore")
            eggLabelScoreNode.text = String(score)
        }
        highScoreShow = userDefaults.integerForKey("highscore")
        
    }
    
    func addPhysicsWorld() {
        
        //amount of effect the gravity has
        //x is 0 for no side to side
        //-9.8 is gravity on Earth
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        //close off the frame with a physicsbody
        //sceneBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //friction - ball will bounce back at same speed
        self.name = "self"
        self.physicsBody?.friction = 0
        //apply physics body to scene

    }

    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == dragonCategory && secondBody.categoryBitMask == frameCategory && collisionHappenedDragon_Frame != true || firstBody.categoryBitMask == frameCategory && secondBody.categoryBitMask == dragonCategory && collisionHappenedDragon_Frame != true {
            
            collisionHappenedDragon_Frame = true
            
            
            if firstBody.node?.name == "enemyDragon"{
                firstBody.node?.removeFromParent()
            }
            else if secondBody.node?.name == "enemyDragon"{
                secondBody.node?.removeFromParent()
            }
            
        }
        
        if firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == dragonCategory && collisionHappenedDragon_Bullet != true || firstBody.categoryBitMask == dragonCategory && secondBody.categoryBitMask == bulletCategory && collisionHappenedDragon_Bullet != true {

            
            dragonDied = true
            
            if scopeNode.hidden == true {

                
                collisionHappenedDragon_Bullet = true
                scopeNode.removeFromParent()
                bulletNode.removeFromParent()
                
                loadAppearance_Bullet()
                
                score = score + 1
                scoreLabel.text = String(score)
                
                
                //projectileNode.removeFromParent()
                
                //resetDragon()
                if firstBody.node?.name == "enemyDragon"{
                    firstBody.node?.removeFromParent()
                }
                else if secondBody.node?.name == "enemyDragon"{
                    secondBody.node?.removeFromParent()
                }
                
            }
            
            if scopeNode.hidden != true{
                
                collisionHappenedDragon_Bullet = true
                //dragonProjectileNode.removeFromParent()
                scopeNode.removeFromParent()
                bulletNode.removeFromParent()
                loadAppearance_Bullet()
            }
            view?.userInteractionEnabled = true
            //collisionHappened = false
        }
        if firstBody.categoryBitMask == dragonProjectileCategory && secondBody.categoryBitMask == turretCategory && collisionHappenedProjectile_Turret != true || firstBody.categoryBitMask == turretCategory && secondBody.categoryBitMask == dragonProjectileCategory && collisionHappenedProjectile_Turret != true{
            
            collisionHappenedProjectile_Turret = true
            //dragonProjectileNode.removeFromParent()
            
            hitCount++
            
            if (hitCount == 1){
                healthbar.runAction(SKAction.resizeToWidth(self.frame.size.width * 0.1775, height: healthbar.size.height, duration: 0.25))
            }
            if (hitCount == 2){
                healthbar.runAction(SKAction.resizeToWidth(self.frame.size.width * 0.09, height: healthbar.size.height, duration: 0.25))
                healthbar.color = UIColor.yellowColor()
            }
            if (hitCount == 3){
                healthbar.runAction(SKAction.resizeToWidth(self.frame.size.width * 0.02, height: healthbar.size.height, duration: 0.25))
                healthbar.color = UIColor.redColor()
            }
            if (hitCount == 4){
                healthbar.runAction(SKAction.resizeToWidth(0, height: healthbar.size.height, duration: 0.25))
                myTimer.invalidate()
                projectileNode.removeFromParent()
                saveHighscore()

            }

            
            if firstBody.node?.name == "enemyProjectile"{
                firstBody.node?.removeFromParent()
            }
            else if secondBody.node?.name == "enemyProjectile"{
                secondBody.node?.removeFromParent()
            }
            
            
            //print("you died")
            //loadAppearance_DragonProjectile()
            //eggMoveRight()
            //turretNode.runAction(SKAction.moveTo(CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09), duration: 0))
            //turretNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.09)
        }
        if firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == dragonProjectileCategory && collisionHappenedProjectile_Bullet != true || firstBody.categoryBitMask == dragonProjectileCategory && secondBody.categoryBitMask == bulletCategory && collisionHappenedProjectile_Bullet != true {
            
            collisionHappenedProjectile_Bullet = true
            //dragonProjectileNode.removeFromParent()
            
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        touching = false
        
        for touch: AnyObject! in touches {
            print(dragonDied)
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            
            if let name = touchedNode.name{
                
                touching = true
                if name == "self" || name == "redDragon" || name == "background"{
                    var dx = bulletNode.position.x - positionInScene.x
                    var dy = bulletNode.position.y - positionInScene.y
                    var angle = atan2(dy, dx) + CGFloat(M_PI_2)
                    
                    if(angle < 0){
                        angle = angle + 2 * CGFloat(M_PI)
                    }
                    bulletNode.hidden = false
                    bulletNode.zRotation = angle
                    loadAppearance_Scope()
                    scopeNode.position = positionInScene
                    colorizeScope(scopeNode)

                }

                /*if name == "projectile" && name != "self"{
                    dragonProjectileNode.removeFromParent()
                    touching = false
                    eggScore += 1
                    eggLabelScoreNode.text = String(eggScore)
                }*/
                if name == "MainMenu"{
                    let myScene = StartScene(size: CGSize(width: 1536, height: 2048))
                    myScene.scaleMode = .AspectFill
                    let reveal = SKTransition.fadeWithDuration(0.65)
                    self.view?.presentScene(myScene, transition: reveal)
                }
                if name == "enemyProjectile"{
                    touchedNode.removeFromParent()
                    touching = false
                }
            }
        }
    
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)

            positionInScene = location
            scopeNode.runAction(SKAction.moveTo(positionInScene, duration: 0))
            var dx = bulletNode.position.x - positionInScene.x
            var dy = bulletNode.position.y - positionInScene.y
            var angle = atan2(dy, dx) + CGFloat(M_PI_2)
            
            if(angle < 0){
                angle = angle + 2 * CGFloat(M_PI)
            }

            bulletNode.zRotation = angle
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if touching == true{
            let shootAction = SKAction.moveTo(CGPointMake(1900 * -cos(bulletNode.zRotation - 1.57079633) + bulletNode.position.x,1900 * -sin(bulletNode.zRotation - 1.57079633) + bulletNode.position.y),duration: 1)
            view?.userInteractionEnabled = false
            scopeNode.removeAllActions()
            bulletNode.runAction(shootAction)
        }
        //view?.userInteractionEnabled = true
    }


   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //dragonDied = false
        collisionHappenedDragon_Bullet = false
        collisionHappenedProjectile_Turret = false
        collisionHappenedProjectile_Bullet = false
        collisionHappenedDragon_Frame = false
        
        /*
        if dragonNode.position.x > self.frame.size.width * 0.9999999{
            self.removeAllChildren()
        }
 */
        
        if bulletNode.position.y > self.frame.size.height || bulletNode.position.y < self.frame.size.height * 0.00001 || bulletNode.position.x < self.frame.size.width * 0.0000001 || bulletNode.position.x > self.frame.size.width{
            scopeNode.removeFromParent()
            resetBullet()
            }
        
        }
    

}
