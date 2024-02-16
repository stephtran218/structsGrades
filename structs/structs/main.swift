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
        //This calls the function findStudent to find the student's index in the roster
        let index = findStudent(chosenStudent)
        //If index isn't -1, meaning there wasn't an error, finalGrade is the matched index of student's placement in array and their grade's
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
        //this allows it to not be case sensitive
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
        //this takes the name the user puts in and finds them using the function
        var studentIndex = findStudent(pickedStudentName)
        //if the index isn't -1, that means there wasn't an error and it found the correct student through matching index
        if studentIndex < gradeBook.count && studentIndex != -1 {
            let pickedStudent = gradeBook[studentIndex]
            
            print("\(pickedStudent.fullName)'s grades for this class are:")
            //this uses a for loop so that it can print out every score as the loop runs
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
        
        //This cleans up the names so it looks nicer as it prints
        let cleanedGrades = grades.joined(separator: ", ")

        print("\(name)'s grades are: \(cleanedGrades)")
    }
    print()
}

//This finds the average grade out of the entire class
func classAverage() -> Double? {
    var totalSum: Double = 0.0
    var headCount: Int = 0
    
    //this uses the struct and takes account of all the grades so that it can divide it by the # of scores it went over (headCount)
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
        
        //this is using the struct to go through the gradeBook array
        for student in gradeBook {
            //this makes sure the index accounts for the 0-index
            let assignmentIndex = assignmentNumber - 1
            //If the index is less than the number of students, it will turn th sum of all grades into a double so that it can perform a calculation of average
            if assignmentIndex < student.grades.count, let grade = Double(student.grades[assignmentIndex]){
                totalSum += grade
                count += 1
            }
        }
        
        //if count is greater than 0, that means it counted correctly and will be able to calculate the average of assignment (every time the for loop runs and accounts every assignment, it tallies the amount of times the loop ran so that it counts for the headCount whihc is the denominator/divisor
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
    //this assumes that the lowest grade is the first grade in array
    var lowestGrade = gradeBook[0].finalGrade
    //this takes the name of the first student in the array, assuming they have the lowest grade
    var lowestGradeStudentName = gradeBook[0].fullName

    //this will go through the gradebook array
    for index in gradeBook.indices {
        let student = gradeBook[index]
        //this compares if the current student in the index is less than the saved index of the lowest score, the var holding the lowest grade will be the current index
        if student.finalGrade < lowestGrade {
            //lowest grade will hold the current student bc their grade is lower than what it was compared to
            lowestGrade = student.finalGrade
            //this changes the var so that it will have the current student w/ the lowest grade
            lowestGradeStudentName = student.fullName
        }
    }

    print("\(lowestGradeStudentName) is the student with the lowest grade: \(lowestGrade)")
    print()
}

//This will find the student who has the highest grade in the class
func classHighestGrade() {
    //this assumes that the highest grade is the first grade in array
    var highestGrade = gradeBook[0].finalGrade
    //this takes the name of the first student in the array, assuming they have the highest grade
    var highestGradeStudentName = gradeBook[0].fullName

    //this will go through the gradebook array
    for index in gradeBook.indices {
        let student = gradeBook[index]
        //this compares if the current student in the index is greater than the saved index of the highest score, the var holding the highest grade will be the current index
        if student.finalGrade > highestGrade {
            //highest grade will hold the current student bc their grade is higher than what it was compared to
            highestGrade = student.finalGrade
            //this changes the var so that it will have the current student w/ the highest grade
            highestGradeStudentName = student.fullName
        }
    }

    print("\(highestGradeStudentName) is the student with the highest grade: \(highestGrade)")
    print()
}

//This function allows users to find the students that fit in between the grade ranges they put in
func studentsByGradeRange() {
    print("Enter the low range you would like to use:")
    
    // this takes what the user put in for the lower range
    if let lowRangeString = readLine() {
        if let lowRange = Double(lowRangeString) {
            print("Enter the high range you would like to use:")
            
            // this takes what the user put in for the higher range
            if let highRangeString = readLine() {
                if let highRange = Double(highRangeString) {
                    // this will go through all the students in the gradeBook array
                    for student in gradeBook {
                        // this checks if the student's final grade falls within the specified range (grade is more than low range inputted and less than high range inputted)
                        if student.finalGrade >= lowRange && student.finalGrade <= highRange {
                            // this will print out the name of students who fit in the range
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

