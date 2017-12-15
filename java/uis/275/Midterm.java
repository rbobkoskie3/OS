// Robert Bobkoskie
// CSC 275 Online Midterm Project Solution
// ID: rb868x 13558 Jul  1 13:59 Midterm.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

import java.util.Scanner;

public class Midterm {

	public static int maxStudents;
	// Student[] studentList = new Student[maxStudents];
	Student[] studentList;

	public void startProgram() {
		displayWelcomeMessage();
		getMaxStudents();
		displayOptions();
	}

	public void displayWelcomeMessage() {
		System.out.println("Robert Bobkoskie");
		System.out.println("CSC 275 Online Midterm Project Solution");
		System.out.println("");
	}

	public void getMaxStudents() {
                Scanner input = new Scanner(System.in);

                System.out.println("Please enter the number of students in the class: ");
                try {
                        maxStudents = input.nextInt();
                        // The conditional is to enforce the requirement that ONLY
                        // non-negative ints are entered
                        if (maxStudents < 0) {
                                System.out.println ("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE INT");
                                getMaxStudents();
                        }
			studentList = new Student[maxStudents];
                }
                catch (java.util.InputMismatchException IME) {
                        System.out.println ("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE INT");
                        getMaxStudents();
                }
        }

	public void displayOptions() {
		Scanner input = new Scanner(System.in);
                System.out.println("Please choose an action to perform. (Enter single digits only)");
                System.out.println("");

                while (true) {
                        // Give the user a list of their options
                        System.out.println("1: Add a student");
                        System.out.println("2: Remove a studentt");
                        System.out.println("3: Edit Student");
                        System.out.println("4: Remove all students");
			System.out.println("5: List all students");
			System.out.println("0: Exit the program");

                        // Get the user input
                        int userChoice = 0;

                        try {
                                userChoice = input.nextInt();
				// The conditional is to enforce the requirement that ONLY
				// single digit non-negative ints are entered
                        	if (userChoice >= 10 || userChoice < 0) {
                                	System.out.println ("INPUT ERROR, PLEASE ENTER A SINGLE DIGIT NON-NEGATIVE INT");
                                	displayOptions();
                        	}
                        }
                        catch (java.util.InputMismatchException IME) {
                                System.out.println ("INPUT ERROR, PLEASE ENTER A SINGLE DIGIT NON-NEGATIVE INT");
                                displayOptions();
                        }

                        switch (userChoice) {
                        case 1:
				addStudent();
                                break;
                        case 2:
				removeStudent();
                                break;
                        case 3:
				editStudent();
                                break;
			 case 4:
                                removeAllStudents();
                                break;
			case 5:
                                listAllStudents();
                                break;
                        case 0:
                                System.out.println("BYE");
                                System.exit(0);
                        }
                }
        }

	public void addStudent() {
		if (Student.numStudent >= maxStudents) {
			System.out.println ("ERROR, THE MAXIMUM NUMBER OF STUDENT '" + maxStudents + "' HAS BEEN REACHED");
			System.out.println("");
			return;
		}

		Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of the Student to add: ");

                // Use trim() to elimate leading and trailing spaces,
                // e.g., if ' 'john' ' is entered, it will be saved
                // as 'john'
                String studentName = input.nextLine().trim();

		for (int m = 0; m < studentList.length; m++) {
                        if (studentList[m] == null) {
				studentList[m] = new Student();
				studentList[m].setStudentName(studentName);

				setAllGrades(studentList[m]);
				System.out.println("");
				return;
			}
		}
	}

	private void setAllGrades(Student student) {
		for (int i = 1; i <= Student.maxAssignments; i++) {
			setGrade(i, student);
		}
	}

        private void setGrade(int i, Student student) {
                String studentGradeStr;
                Scanner input = new Scanner(System.in);

                do {
                        System.out.println("Enter the grade for " + student.getStudentName() + " assignme #" + i + ":");
                        studentGradeStr = input.nextLine();
                        try {
                                double studentGradeDbl = Double.parseDouble(studentGradeStr);
				if (studentGradeDbl < 0 || studentGradeDbl > 10) {
					System.out.println ("INPUT ERROR, PLEASE ENTER A NUMBER BETWEEN 0-10");
                                        setGrade(i, student);
					break;
                                }
                                student.setStudentGrade(i-1, studentGradeDbl);
                                break;
                        }
                        catch (java.lang.NumberFormatException IME) {
                                System.out.println("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE DOUBLE");
                        }
                } while (true);
        }

        public void removeStudent() {
                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of the Student to remove: ");

                // Use trim() to elimate leading and trailing spaces,
                // e.g., if ' 'john' ' is entered for search string,
		// it will be found as 'john'
                String studentName = input.nextLine().trim();
                int found = 0;

                for (int i = 0; i < studentList.length; i++) {
                        if (studentList[i] != null && studentList[i].getStudentName().equals(studentName)) {
				Student.setAssignmentMeanNull(i);	// Set all assignment grades for student i to 0
                                studentList[i] = null;
                                found++;
				Student.numStudent--;
                        }
                }
                if (found > 0) {
                        System.out.println(studentName + " " + " Removed");
                        System.out.println("");
                }
                else {
                        System.out.print("ERROR, " + studentName + " CAN NOT BE FOUND");
                        System.out.println("");
                        System.out.println("");
                }
        }

        public void editStudent() {
		Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of the Student to edit: ");

		// Use trim() to elimate leading and trailing spaces,
		// e.g., if ' 'john' ' is entered for search string,
		// it will be found as 'john'
                String studentName = input.nextLine().trim();
		int i;
		boolean found = false;

		for (i = 0; i < studentList.length; i++) {
			if (studentList[i] != null && studentList[i].getStudentName().equals(studentName)) {
				found = true;
				displayChoices(studentList[i]);
                        }
		}
		if (!found) {
			System.out.print("ERROR, " + studentName + " CAN NOT BE FOUND");
                        System.out.println("");
               	        System.out.println("");
                }
	}

	private void displayChoices(Student student) {
		Scanner input = new Scanner(System.in);
                System.out.println("Please choose an attribute to modify");
                System.out.println("");

        	while (true) {
                        // Give the user a list of their options
                        System.out.println("1 - Assignment 1");
                        System.out.println("2 - Assignment 2");
                        System.out.println("3 - Assignment 3");
                        System.out.println("4 - Assignment 4");
                	System.out.println("5 - Assignment 5");
                	System.out.println("6 - Assignment 6");
                	System.out.println("7 - Assignment 7");
                	System.out.println("8 - Assignment 8");
                	System.out.println("9 - Assignment 9");
                	System.out.println("10 - Assignment 10");
                	System.out.println("11 - Name");
                        System.out.println("12 - Exit");

                        // Get the user input
                        int userChoice = 0;
                        try {
                                userChoice = input.nextInt();
                                // The conditional is to enforce the requirement that ONLY
                                // non-negative ints are entered
                                if (userChoice < 0) {
                                	System.out.println ("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE INT");
                                	displayChoices(student);
                                }
                        }
                        catch (java.util.InputMismatchException IME) {
                                System.out.println ("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE INT");
                                displayChoices(student);
                        }

			if (userChoice <= Student.maxAssignments)	// Conditional used to keep getStudentGrade[] throwing 'ArrayIndexOutOfBoundsException'
				System.out.println ("Modifying Assignment " + userChoice + " for  " + student.getStudentName() + ", existing grade = " + student.getStudentGrade(userChoice - 1));	
			else	// > 10 , e.g., print out student name for any int > 10
				System.out.println ("Student name " + student.getStudentName());

                        switch (userChoice) {
                        case 1:
				setGrade(userChoice, student);
				break;
			case 2:
                                setGrade(userChoice, student);
                                break;
                        case 3:
                                setGrade(userChoice, student);
                                break;
                        case 4:
                                setGrade(userChoice, student);
                                break;
                        case 5:
                                setGrade(userChoice, student);
                                break;
                        case 6:
                                setGrade(userChoice, student);
                                break;
                        case 7:
                                setGrade(userChoice, student);
                                break;
                        case 8:
                                setGrade(userChoice, student);
                                break;
                        case 9:
                                setGrade(userChoice, student);
                                break;
                        case 10:
                                setGrade(userChoice, student);
                                break;
                        case 11:
				Scanner name = new Scanner(System.in);
				System.out.print("Enter the new name of the Student: ");
                		String studentName = name.nextLine();
				student.setStudentName(studentName);
                                break;
			case 12:
				System.out.println("BYE");
                                return;

			}
		}
	}

        public void removeAllStudents() {
		Scanner input = new Scanner(System.in);
		String confirmRemove;
		do {
			System.out.println("Are you sure you want to remove ALL students, y/n: ");
			confirmRemove = input.nextLine();
		} while (!confirmRemove.equalsIgnoreCase("y") && !confirmRemove.equalsIgnoreCase("n"));

		if (confirmRemove.equalsIgnoreCase("n")) {
			System.out.println("");
			return;
		}
		System.out.println("REMOVING All STUDENTS");
		for (int i = 0; i < studentList.length; i++) {
			Student.setAssignmentMeanNull(i);	// Set all assignment grades for student i to 0
			studentList[i] = null;
			Student.numStudent = 0;
		}
		System.out.println("");
        }

	public void listAllStudents() {
		boolean empty = true;

		// System.out.println("Name \t 1 \t  2 \t 3 \t 4 \t 5 \t 6 \t 7 \t 8 \t 9 \t 10");
		Student.header();
                // Search for students in studentList[], skippng null entries
                for (int i = 0; i < studentList.length; i++) {
                        if (studentList[i] == null)
                                continue;

                        // String studentNmae = studentList[i].getStudentName();
			studentList[i].setAssignmentMean(i, studentList[i]);
			studentList[i].printStudentInfo();
                        empty = false;
                }
                if (empty)
                        System.out.println("ARRAY EMPTY, ADD UP TO " + maxStudents + " STUDENTS");
		else
			Student.printAssignmentMean();
                System.out.println("");
	}
}
