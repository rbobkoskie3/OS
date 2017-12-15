// Robert Bobkoskie
// CSC 275 Online Midterm Project Solution
// ID: rb868x 3670 Jul  2 20:37 Student.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

public class Student {

        public Student() {
		numStudent++;
        }

	public static int numStudent;				// Count Students
	public final static int maxAssignments = 10;		// Maximum number of Assignments is 10, 0-9
	private double[] studentGrades = new double[maxAssignments];
	private static double[][] assignmentMean = new double[maxAssignments + 1][Midterm.maxStudents];
	private String strStudentName;


	public static void header() {
		System.out.format("%20s", "NAME");
		for (int i = 1; i <= 10; i++ )
			System.out.format("%6d", i);
		System.out.format("%6s", "AVE");
		System.out.format("%n");
	}

	public void printStudentInfo() {
		System.out.format("%20s", getStudentName());
		for (int i = 0; i < maxAssignments; i++)
			System.out.format("%6.1f", studentGrades[i]);
		System.out.format("%6.1f", getStudentMean());
		System.out.format("%n");
	}

        public static void printAssignmentMean() {
		double sum;
                double ave;

		System.out.format("%20s", "ASSIGNMENT AVE");
		for (int i = 0; i < assignmentMean.length; i++) {
			sum = 0;
			ave = 0;

			for (int k = 0; k < assignmentMean[i].length; k++)
				sum += assignmentMean[i][k];
			ave = sum/numStudent;
			System.out.format("%6.1f", ave);
		}
        }

	/////////////////////////////////////////
	// Setters: NOTE that I defined a double[] studentGrades
	// and method setStudentGrade(int, double) to impliment
	// setting student grades
	/////////////////////////////////////////

	public void setStudentGrade(int index, double grade) {
		studentGrades[index] = grade;
	}

	public void setStudentName(String studentName) {
		strStudentName = studentName;
	}

	public static void setAssignmentMean(int k, Student student) {
                double sum = 0;
                double ave = 0;

		for (int i = 0; i < assignmentMean.length - 1; i++) {
                	assignmentMean[i][k] = student.studentGrades[i];
			sum += assignmentMean[i][k];	// Use to derive a mean of assignment means
		}
		ave = sum/(assignmentMean.length - 1);	// Need to divide by (assignmentMean.length - 1), because the last number in assignmentMean.length
							// does not factor into the average, as it IS THE MEAN OF ASSIGNMENT MEANS
		assignmentMean[assignmentMean.length - 1][k] = ave;
		// This is an alternate way to obtain a mean of assignment means, e.g., call the getStudentMean()
		// method for each student. NOTE, if this option is used to calculate the mean of assignment
		// means, then the 'sum += assignmentMean[i][k];' assignment above is not necessary
		// assignmentMean[assignmentMean.length - 1][k] = student.getStudentMean();
        }

	public static void setAssignmentMeanNull(int k) {
                for (int i = 0; i < assignmentMean.length; i++)
                        assignmentMean[i][k] = 0;
        }


	/////////////////////////////////////////
	// Getters
	/////////////////////////////////////////

        public String getStudentName() {
                return strStudentName;
        }

	public double getStudentGrade(int i) {
		return studentGrades[i];
	}

        public double getStudentMean() {
                double sum = 0;
                double ave = 0;

                for (int i = 0; i < studentGrades.length; i++)
                        sum += studentGrades[i];
                ave = sum/studentGrades.length;
                return ave;
        }
}
