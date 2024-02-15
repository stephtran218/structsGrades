//
//  main.swift
//  structs
//
//  Created by StudentAM on 2/9/24.
//

import Foundation
import CSV

//This struct will hold all the info on the student
struct Student {
    var fullName: String
    var grades: [String]
    var finalGrade: Double
}

//The gradeBook array will be used throughout the code to get info on grades and perform calculations
var gradeBook: [Student] = []

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

//This function will sort out the data
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
    
    gradeBook.append(tempStudent)
    
}
mainMenu()

//This is the main menu function that will display all the options for the user
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
                assignmentGradeAverage()
            } else if userPick == "6" {
                classLowestGrade()
            } else if userPick == "7" {
                classHighestGrade()
            } else if userPick == "8" {
                studentsByGradeRange()
            } else if userPick == "9" {
                quitMenu()
            } else {
                print("Please enter a valid selection 1-9")
            }
            menuChoice = userPick
        }
    }
}

//This option is responsible for displaying a specific student's grade that the user asked for
func displaySingleStudentGrade(){
    print("Which student would you like to choose?")
    
    if let chosenStudent = readLine(){
        let index = findStudent(chosenStudent)
        if index != -1 {
            let finalGrade = gradeBook[index].finalGrade
            print("\(chosenStudent)'s grade in the class is \(finalGrade)")
        }else{
            print ("Student not found")
        }
    }
    print()
}

//this function will find the student that the user requested and take the index their name was in to match with the index in the grades array
func findStudent(_ userPick: String) -> Int {
    for index in gradeBook.indices {
        if gradeBook[index].fullName.lowercased() == userPick.lowercased() {
            return index
        }
    }
    return -1
}

//This function will print out the specific student's name and all of the scores for every assignment (all 10)
func displayAllStudentsGrades() {
    print("Which student would you like to choose?")
    
    if let pickedStudentName = readLine(){
        var studentIndex = findStudent(pickedStudentName)
        if studentIndex < gradeBook.count && studentIndex != -1 {
            let pickedStudent = gradeBook[studentIndex]
            
            print("\(pickedStudent.fullName)'s grades for this class are:")

            for i in 1..<pickedStudent.grades.count {
                print(pickedStudent.grades[i], terminator: ", ")
            }
            print()
        }
    }
}

//this function will print out every student's name and their grade in the class (full roster)
func displayAllGradesForAllStudents() {
    for student in gradeBook {
        let name = student.fullName
        let grades = Array(student.grades.dropFirst())
        
        let cleanedGrades = grades.joined(separator: ", ")

        print("\(name)'s grades are: \(cleanedGrades)")
    }
    print()
}

//This finds the average grade out of the entire class
func classAverage() -> Double? {
    var totalSum: Double = 0.0
    var headCount: Int = 0
    
    for student in gradeBook {
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

//this finds the average grade per specfic assignment the user inputted
func assignmentGradeAverage() {
    print("Which assignment would you like to get the average of (1-10):")
    
    if let chosenAssignment = readLine(), let assignmentNumber = Int(chosenAssignment) {
        var totalSum: Double = 0
        var count: Int = 0
        
        for student in gradeBook {
            let assignmentIndex = assignmentNumber - 1
            if assignmentIndex < student.grades.count, let grade = Double(student.grades[assignmentIndex]){
                totalSum += grade
                count += 1
            }
        }
        
        if count > 0 {
            let average = totalSum / Double(count)
            print("The average grade for assignment \(assignmentNumber) is \(average)")
        } else {
            print("No grades found for assignment \(assignmentNumber)")
        }
    }
    print()
}

//This will find the student who has the lowest grade in the class
func classLowestGrade() {
    var lowestGrade = gradeBook[0].finalGrade
    var lowestGradeStudentName = gradeBook[0].fullName

    for index in 1..<gradeBook.count {
        let student = gradeBook[index]
        if student.finalGrade < lowestGrade {
            lowestGrade = student.finalGrade
            lowestGradeStudentName = student.fullName
        }
    }

    print("\(lowestGradeStudentName) is the student with the lowest grade: \(lowestGrade)")
    print()
}

//This will find the student who has the highest grade in the class
func classHighestGrade() {
    var highestGrade = gradeBook[0].finalGrade
    var highestGradeStudentName = gradeBook[0].fullName

    for index in 1..<gradeBook.count {
        let student = gradeBook[index]
        if student.finalGrade > highestGrade {
            highestGrade = student.finalGrade
            highestGradeStudentName = student.fullName
        }
    }

    print("\(highestGradeStudentName) is the student with the highest grade: \(highestGrade)")
    print()
}

//This function allows users to find the students that fit in between the grade ranges they put in
func studentsByGradeRange() {
    print("Enter the low range you would like to use:")
    
    // Read the low range input
    if let lowRangeString = readLine() {
        if let lowRange = Double(lowRangeString) {
            print("Enter the high range you would like to use:")
            
            // Read the high range input
            if let highRangeString = readLine() {
                if let highRange = Double(highRangeString) {
                    // Iterate over each student in the grade book
                    for student in gradeBook {
                        // Check if the student's final grade falls within the specified range
                        if student.finalGrade >= lowRange && student.finalGrade <= highRange {
                            // Print the student's full name
                            print(student.fullName)
                        }
                    }
                    print()
                    return
                }
            }
        }
    }
    
    print("Invalid input for range.")
}

//This quits the entire program and ends it with a goodbye message
func quitMenu(){
    print("Have a great rest of your day!")
}

