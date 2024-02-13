//
//  main.swift
//  structs
//
//  Created by StudentAM on 2/9/24.
//

import Foundation
import CSV

//This is a safety parameter that prevents errors from crashing the code
do{
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv" )
    let csv = try CSVReader(stream: stream!)
    
    while let row = csv.next(){
        manageData (row)
    }
}
catch{
    print("There was an error trying to read the file")
}
var studentInfo: [String] = []

struct classInfo {
    var fullName: String
    var grades: [String]
    var finalGrade: Double
}

func manageData( _ studentInfo: [String]){
    var tempGrades: [grades]
    
    for i in grades.indices{
        if i == 0{
            fullNames.append(studentInfo[0])
        }
    }
}
