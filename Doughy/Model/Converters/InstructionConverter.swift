//
//  InstructionConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class InstructionConverter: NSObject {
    
    let objectFactory = ObjectFactory.shared
    
    static let shared = InstructionConverter()
    
    private override init() { }
    
    func convertToCoreData(instruction: Instruction) -> XCInstruction {
        let coreData = objectFactory.createInstruction()
        
        coreData.step = instruction.step
        
        return coreData
    }
    
    func convertToExternal(instruction: XCInstruction) -> Instruction {
        let step = instruction.step!
        
        return Instruction(step: step)
    }

}
