//
//  encryption.swift
//  Eton Tennis
//
//  Created by Edouard Long on 21/11/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import Foundation

class Encryption {
    
    var encryptionString:String!
    
    // function to encrypt a string
    func encryptString(stringToEncrypt:String) -> String {
        
        // init encrypted string
        var encryptedString = ""
        
        // loop through each value in the string
        for character in stringToEncrypt {
            
            // get the unicode scalars representation of the string
            let unicodeRepresentation = String(character).unicodeScalars
            
            // get ascii value
            var asciiValue = unicodeRepresentation[unicodeRepresentation.startIndex].value;
            
            // add 1 to the ascii value
            asciiValue += 1
            
            // get new character value
            let newCharacterValue = Character(UnicodeScalar(asciiValue)!)
            
            // add this to encrypted string
            encryptedString.append(newCharacterValue);
        }
        
        return encryptedString
    }
    
    // function to decrypt a string
    func decryptString(stringToDecrypt:String) -> String {
        
        // init decrypted string
        var decryptedString = ""
        
        // loop through each character
        for character in stringToDecrypt {
            
            // get the unicode scalars representation of the string
            let unicodeRepresentation = String(character).unicodeScalars
            
            // get ascii value
            var asciiValue = unicodeRepresentation[unicodeRepresentation.startIndex].value;
            
            // subtract one from the ascii value
            asciiValue -= 1
            
            // get new character value
            let newCharacterValue = Character(UnicodeScalar(asciiValue)!)
            
            // add this to decrypted string
            decryptedString.append(newCharacterValue);
            
        }
        
        return decryptedString
    }
    
}
