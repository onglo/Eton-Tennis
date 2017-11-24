//
//  quickSort.swift
//  Eton Tennis
//
//  Created by Edouard Long on 24/11/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import Foundation

class QuickSort {
    
    // init array to sort
    var arrayToSort:[Int]!
    
    // initialisation func
    init(sort: [Int]) {
        
        // set array to be sorted and call quick sort
        arrayToSort = sort
        quickSort(leftmark: 0, rightmark: arrayToSort.count - 1)
    }
    
    // function to perform a quick sort
    func quickSort(leftmark:Int, rightmark:Int) {
        
        // first choose pivot value to be right most value
        var pivot = rightmark;
        
        // array that stores the positions to be deleted
        var positionsToDelete:[Int] = []
        
        // check if the rightmark is greater than left mark
        if (rightmark > leftmark) {
            
            // go through each number in the array
            for number in leftmark...rightmark {
                
                // check if it is greater than the pivot
                if arrayToSort[number] > arrayToSort[pivot] {
                    
                    // move the number to the right of the pivot
                    arrayToSort.insert(arrayToSort[number], at: pivot + 1)
                    
                    // mark the old number position to be deleted
                    positionsToDelete.append(number)
                    
                }
                
            }
            
            // var that keeps track of how many numbers we have deleted
            var numberDeleted:Int = 0;
            
            // delete the old values
            for value in positionsToDelete {
                
                // remove this value from the array (minus number deleted as array shifts for each value delete)
                arrayToSort.remove(at: value - numberDeleted)
                
                // add one to then number deleted
                numberDeleted += 1
                
                // minus one from the pivot (array is getting smaller)
                pivot -= 1
            }
            
            // call the function again for the upper half of the array
            quickSort(leftmark: leftmark, rightmark: pivot - 1)
            
            // call the function for the lower half of the array
            quickSort(leftmark: pivot + 1, rightmark: rightmark)
        }
    }
}
