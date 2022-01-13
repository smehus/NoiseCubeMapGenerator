//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import GameplayKit
import UIKit

enum Face {
    case xPositive
    case xNegtive
    case yPositive
    case yNegative
    case zPositive
    case zNegative
    
    static var width: CGFloat = 200
    
    var x: CGFloat {
        switch self {
        case .zPositive:
            return 0
        case .zNegative:
            return Face.width * 2
        case .xNegtive:
            return -Face.width
        case .xPositive:
            return Face.width
        case .yPositive, .yNegative:
            return 0
        }
    }
    
    var y: CGFloat {
        switch self {
        case .yPositive:
            return Face.width
        case .yNegative:
            return -Face.width
        default:
            return 0
        }
    }
}


class GameScene: SKScene {
    func url(for id: String) -> URL {
        return playgroundSharedDataDirectory.appendingPathComponent("world_map_\(id).png")
    }
    
    override func didMove(to view: SKView) {
        for child in children {
            child.removeFromParent()
        }
        
        print(playgroundSharedDataDirectory)
        
        
        let fakeSource = GKPerlinNoiseSource()
        print("freq \(fakeSource.frequency)  octave \(fakeSource.octaveCount) persistence \(fakeSource.persistence) lacunarity \(fakeSource.lacunarity) seed \(fakeSource.seed) ")

        
        ///
        /// ENEMY SHIP SOURCES
        ///
        
        // Do we want spawn enemies using noise?
        
        let source = GKPerlinNoiseSource()
        source.persistence = 0.6
        source.frequency = 0.08
        
//        let source = GKBillowNoiseSource(frequency: 2.0,
//                                         octaveCount: 6,
//                                         persistence: 0.5,
//                                         lacunarity: 0.2,
//                                         seed: Int32(2))
        
        ///
        /// WATER LAND SOURCES
        ///
        
//        let source = GKPerlinNoiseSource(frequency: 0.2,
//                                     octaveCount: 6,
//                                     persistence: 0.5,
//                                     lacunarity: 2.0,
//                                     seed: Int32(50))
//

//        let source = GKRidgedNoiseSource(frequency: 0.2,
//                                         octaveCount: 5,
//                                         lacunarity: 0.8,
//                                         seed: Int32(50))
//
//        let source = GKRidgedNoiseSource(frequency: 0.5,
//                                         octaveCount: 10,
//                                         lacunarity: 2.0,
//                                         seed: Int32(50))
        
//        let source = GKBillowNoiseSource(frequency: 6.0,
//                                         octaveCount: 6,
//                                         persistence: 10.0,
//                                         lacunarity: 0.6,
//                                         seed: Int32(2))
        
        // Frequency basically zooms out
//        number and size of visible features in any given unit area of generated noise
        
        // Persistence: How quickly the hills drop
        // aka - How quickly the red bits turn into green bits
        // Smooths it out kinda
//        Smaller values result in smoother noise; larger values increase roughness. The default value is 0.5.
        
        
        // Lacunarity: less green splots - but larger - more uniformity
        // or more green spots and smaller
//        Smaller values result in coarser noise with more visible structure; finer values result in finer, more uniform noise. The default value is 2.0.
        
        
        // Octave Count:
//        Coherent noise is composed from several applications of a pseudorandom function. Each                 successive application, or octave, increases in frequency and decreases in amplitude relative to the previous octave. This combination of many octaves produces the fractal appearance that makes coherent noise resemble natural phenomena like clouds, stone, and water.
        
//        This property determines the number of octaves of the noise function that the noise source combines to produce noise. A smaller number results in smoother, simpler output; larger numbers result in rougher, more complex output.
        
        
//        let source = GKVoronoiNoiseSource()
//        let source = GKSpheresNoiseSource()
//        let source = GKCoherentNoiseSource()
//        let source = GKCylindersNoiseSource()
        
//        let noise = GKNoise(source,
//                            gradientColors: [0.8: .blue, 1: .red])

        
        // Land water noise
//        let noise = GKNoise(source,
//                            gradientColors: [0: .white, 1: .black])
//        noise.remapValues(toTerracesWithPeaks: [-1, 0.0, 1.0], terracesInverted: false)
        
        let noise = GKNoise(source)
//        noise.invert()

//        noise.move(by: vector_double3(0, 0, 0))
        let map = GKNoiseMap(noise)
        print("sample count \(map.sampleCount)")
        print("size \(map.size)")
        print("origin \(map.origin)")
        
        let size = vector_double2(128, 128)
        let sampleCount = vector_int2(Int32(Int(512)), Int32(512))
        var origin = SIMD2<Double>(0, 0)
        let spriteSize = CGSize(width: Face.width, height: Face.width)
        
        let customMap = GKNoiseMap(noise,
                                   size: size,
                                   origin: origin,
                                   sampleCount: sampleCount,
                                   seamless: true)
        

        let texture = SKTexture(noiseMap: customMap)
        try! UIImage(cgImage: texture.cgImage())
            .pngData()!
            .write(to: url(for: "+z"))
        
        
        let sprite = SKSpriteNode(texture: texture, color: .white, size: spriteSize)
        sprite.drawBorder(color: .green, width: 1.0)
        sprite.position = CGPoint(x: Face.zPositive.x, y: 0)
        
        addChild(sprite)
        
        
        /// Will need to keep track of the translation - and maybe
        /// reset back to 0 each time a new map is about to be created
        noise.move(by: vector_double3(size.x, 0, 0))
        let customMap2 = GKNoiseMap(noise,
                                    size: size,
                                    origin: origin,
                                    sampleCount: sampleCount,
                                    seamless: true)

        let texture2 = SKTexture(noiseMap: customMap2)
        try! UIImage(cgImage: texture2.cgImage())
            .pngData()!
            .write(to: url(for: "+x"))
        let sprite2 = SKSpriteNode(texture: texture2, color: .white, size: spriteSize)
        sprite2.drawBorder(color: .blue, width: 1.0)
        sprite2.position = CGPoint(x: Face.xPositive.x, y: 0)
        
        addChild(sprite2)


        // MOVE BY NOT MOVE TO DUMBASS
        noise.move(by: vector_double3(size.x, 0, 0))
        let customMap3 = GKNoiseMap(noise,
                                    size: size,
                                    origin: origin,
                                    sampleCount: sampleCount,
                                    seamless: true)

        let texture3 = SKTexture(noiseMap: customMap3)
        try! UIImage(cgImage: texture3.cgImage())
            .pngData()!
            .write(to: url(for: "-z"))
        let sprite3 = SKSpriteNode(texture: texture3, color: .white, size: spriteSize)
        sprite3.drawBorder(color: .red, width: 1.0)
        sprite3.position = CGPoint(x: Face.zNegative.x, y: 0)
        addChild(sprite3)



        noise.move(by: vector_double3(-(size.x * 3), 0, 0))
        let customMap4 = GKNoiseMap(noise,
                                    size: size,
                                    origin: origin,
                                    sampleCount: sampleCount,
                                    seamless: false)

        let texture4 = SKTexture(noiseMap: customMap4)
        
        try! UIImage(cgImage: texture4.cgImage())
            .pngData()!
            .write(to: url(for: "-x"))
        
        let sprite4 = SKSpriteNode(texture: texture4, color: .white, size: spriteSize)
        sprite4.drawBorder(color: .yellow, width: 1.0)
//        sprite4.position = CGPoint(x: Face.zNegative.x + 100, y: 0)
        sprite4.position = CGPoint(x: Face.xNegtive.x, y: 0)
        addChild(sprite4)

        
        
        
        noise.move(by: vector_double3(size.x, size.y, 0))
        let customMap5 = GKNoiseMap(noise,
                                    size: size,
                                    origin: origin,
                                    sampleCount: sampleCount,
                                    seamless: true)


        let texture5 = SKTexture(noiseMap: customMap5)
        try! UIImage(cgImage: texture5.cgImage())
            .pngData()!
            .write(to: url(for: "+y"))
        
        let sprite5 = SKSpriteNode(texture: texture5, color: .white, size: spriteSize)
        sprite5.drawBorder(color: .systemPink, width: 1.0)
        sprite5.position = CGPoint(x: Face.yPositive.x, y: Face.yPositive.y)
        addChild(sprite5)
        
        
        
        noise.move(by: vector_double3(0, -(size.y * 2), 0))
        let customMap6 = GKNoiseMap(noise,
                                    size: size,
                                    origin: origin,
                                    sampleCount: sampleCount,
                                    seamless: true)


        let texture6 = SKTexture(noiseMap: customMap6)
        try! UIImage(cgImage: texture6.cgImage())
            .pngData()!
            .write(to: url(for: "-y"))
        let sprite6 = SKSpriteNode(texture: texture6, color: .white, size: spriteSize)
        sprite6.drawBorder(color: .purple, width: 1.0)
        sprite6.position = CGPoint(x: Face.yNegative.x, y: Face.yNegative.y)
        addChild(sprite6)
    }
    
    func printValues(with map: GKNoiseMap, name: String) {
//        for i in 0..<map.sampleCount.x {
////            print("\(name): idx: \(i) -> \(map.value(at: vector_int2(i, 0)))")
//        }
    }
    
    /// This will use a map to decide which noise object to use. So that within each section of the selection map, varying values of the sub noise can be used. Water noise can have its own map, and land can have its own map.
    func componentNoise() {
        let waterSource = GKRidgedNoiseSource()
        let waterNoise = GKNoise(waterSource, gradientColors: [-1: .blue, 1: .blue])
        
        let landSource = GKPerlinNoiseSource()
        let landNoise = GKNoise(landSource, gradientColors: [-1: .green, 1: .green])
        
        
        let selectionSource = GKPerlinNoiseSource()
        let selectionNoise = GKNoise(selectionSource)
        
        let mapNoise = GKNoise(componentNoises: [waterNoise, landNoise], selectionNoise: selectionNoise)
        
        let map = GKNoiseMap(mapNoise)
        let texture = SKTexture(noiseMap: map)
        let sprite = SKSpriteNode(texture: texture)
        sprite.position = CGPoint(x: 0, y: 0)
        
        addChild(sprite)
    }
    
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFit
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}
