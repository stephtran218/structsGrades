//
//  main.swift
//  structs
//
//  Created by StudentAM on 2/9/24.
//

import Foundation
import CSV

struct Student {
    var fullName: String
    var grades: [String]
    var finalGrade: Double
}

var studentInfo: [Student] = []

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

func manageData( _ row: [String]){
    //this takes the 0-index in all the rows in csv file and takes it as the students name
    var tempName: String = row[0]
    //this completes the student's info w/ name, grades, and finalGrade in class
    var tempStudent: Student = Student(fullName: tempName, grades: [], finalGrade: 0.0)
    
    var grades = row
    grades.removeFirst()
    
    tempStudent.grades = row
    
    var sum: Double = 0.0
    
    for i in 0...row.count - 1{
        if let gradeValue = Double(row[i]) {
            sum += gradeValue
        }

    }
    
    var tempGPA: Double = round(sum * 10) / 100
    tempStudent.finalGrade = tempGPA
    
    studentInfo.append(tempStudent)
    
}
mainMenu()


func mainMenu() {
    var menuChoice: String = "0"
    
    while menuChoice != "9" {
        print("Welcome to the Grade Manager!\n",
              "What would you like to do? (Enter the number):\n",
              "1. Display grade of a single student\n",
              "2. Display all grades for a student\n",
              "3. Display all grades of ALL students\n",
              "4. Find the average grade of the class\n",
              "5. Find the average grade of an assignment\n",
              "6. Find the lowest grade in the class\n",
              "7. Find the highest grade of the class\n",
              "8. Filter students by grade range\n",
              "9. Quit\n")
        
        if let userPick = readLine() {
            if userPick == "1" {
                displaySingleStudentGrade()
            } else if userPick == "2" {
                displayAllStudentsGrades()
            } else if userPick == "3" {
                displayAllGradesForAllStudents()
            } else if userPick == "4" {
                classAverage()
            } else if userPick == "5" {
//                assignmentGradeAverage()
            } else if userPick == "6" {
//                classLowestGrade()
            } else if userPick == "7" {
//                classHighestGrade()
            } else if userPick == "8" {
//                studentsByGradeRange()
            } else if userPick == "9" {
//                quitMenu()
            } else {
                print("Please enter a valid selection 1-9")
            }
            menuChoice = userPick
        }
    }
}

func displaySingleStudentGrade(){
    print("Which student would you like to choose?")
    
    if let chosenStudent = readLine(){
        let index = findStudent(chosenStudent)
        if index != -1 {
            let finalGrade = studentInfo[index].finalGrade
            print("\(chosenStudent)'s grade in the class is \(finalGrade)")
        }else{
            print ("Student not found")
        }
    }
    print()
}

func findStudent(_ userPick: String) -> Int {
    for index in studentInfo.indices {
        if studentInfo[index].fullName.lowercased() == userPick.lowercased() {
            return index
        }
    }
    return -1
}

func displayAllStudentsGrades() {
    print("Which student would you like to choose?")
    
    if let pickedStudentName = readLine(){
        var studentIndex = findStudent(pickedStudentName)
        if studentIndex < studentInfo.count && studentIndex != -1 {
            let pickedStudent = studentInfo[studentIndex]
            
            print("\(pickedStudent.fullName)'s grades for this class are:")

            for i in 1..<pickedStudent.grades.count {
                print(pickedStudent.grades[i], terminator: ", ")
            }
            print()
        }
    }
}

func displayAllGradesForAllStudents() {
    for student in studentInfo {
        let name = student.fullName
        let grades = Array(student.grades.dropFirst())
        
        let cleanedGrades = grades.joined(separator: ", ")

        print("\(name)'s grades are: \(cleanedGrades)")
    }
    print()
}

func classAverage() -> Double? {
    var totalSum: Double = 0.0
    var headCount: Int = 0
    
    for student in studentInfo {
        for gradeString in student.grades {
            if let grade = Double(gradeString) {
                totalSum += grade
                headCount += 1
            }
        }
    }
    //this performs the calculates to the grade
        let average = totalSum / Double(headCount)
        //This rounds the total average t just two decimal places
        let roundedAverage = (average * 100).rounded() / 100
        print("The class average is: \(roundedAverage)")
        print()

        return roundedAverage
}
