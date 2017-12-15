// Robert Bobkoskie
// CSC 275 Online Lab 4 Solution 
// ID: rb868x 4685 Jul 13 13:40 Lab04javaIO.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

import java.io.*;
import java.util.*;


public class Lab04javaIO {

	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println ("USAGE: java Lab04javaIO <FILE>");
			System.exit(1);
		}
		File file = new File(args[0]);
		JavaIO initJavaIO = new JavaIO(file);
		initJavaIO.startProgram();
	}
}

class JavaIO {

	public JavaIO() {

	}

	public JavaIO(File file) {
		this.file = file;

	}

	private File file;

	public void startProgram() {
		System.out.println ("This program will either read data from '" + file.getAbsolutePath() + "', if the file exists");
		System.out.println ("Or, write data to '" + file.getAbsolutePath() + "', NOTE if the file exists, it will be overwritten");
		System.out.println("");
		try {
			readWriteFile();
		} catch (IOException E2) {
			System.out.println ("ERROR: IO EXCEPTION");
		}
        }

        public void readWriteFile() throws IOException {
		Scanner input = new Scanner(System.in);
		String userInput;

		if (file.isFile()) {
			do {
				System.out.print("File " + file + " exists. Enter R to read or W to overwrite this file: R/W? ");
                        	userInput = input.nextLine();
                	} while (!userInput.equalsIgnoreCase("R") && !userInput.equalsIgnoreCase("W"));


			if (userInput.equalsIgnoreCase("R")) {
				if (file.canRead()) {
					// User chooses to load previous file, and file exists
					readFile();
				} else {
					System.out.println (file.getAbsolutePath() + " is not readable");
					System.out.println ("");
					getNewFile();
				}
			} else {
				// User chooses to write file, and file exists, e.g., file will be overwritten
				if (file.canWrite()) {
					System.out.println("");
					askQuestions();
				} else {
					System.out.println (file.getAbsolutePath() + " is not writable");
					System.out.println ("");
					getNewFile();
				}
			}

		} else {
			System.out.print("File '" + file + "' does not exist. Enter W to write a new file: '" + file.getAbsolutePath() + "', or X to exit: W/X ");
			userInput = input.nextLine();


			if (userInput.equalsIgnoreCase("X"))
				System.exit(1);

			// User chooses to write a new file
			System.out.println("");
			file.createNewFile();
			askQuestions();
		}
	}

	public void getNewFile() throws IOException {
		Scanner input = new Scanner(System.in);
		String userInput;
		File dir = new File(System.getProperty("user.dir"));
		String[] files = new String[dir.list().length];

		System.out.print("File '" + file + "' may be neither readable nor writable. Enter the name of a new file in: '" + dir.getAbsolutePath() + "', or X to exit: <String file name>/X ");
		System.out.println("");

		files = dir.list();
		for (int i = 0; i < files.length; i++)
			System.out.println(files[i]);
		System.out.println("");
		userInput = input.nextLine();
		if (userInput.equalsIgnoreCase("X"))
			System.exit(1);

		// User chooses to write a new file
		System.out.println("");
		File file = new File(userInput);
		JavaIO newJavaIO = new JavaIO(file);
		newJavaIO.startProgram();
	}

	public void readFile() throws FileNotFoundException {
		Scanner s = null;
		try {
			s = new Scanner(new BufferedReader(new FileReader(file)));
			s.useDelimiter("\\?");
			System.out.println ("");
			while (s.hasNext())
				System.out.println(s.next().trim());
		} finally {
			if (s != null)
				s.close();
		}
	}

	public void askQuestions() throws FileNotFoundException, IOException {
		String[] questions = {
			"What is the command 'uname' used for? ",
			"How would you determine the run-level for a server? ",
			"What command would give the routing information, socket/port information on a server? ",
			"How would you determine the last time a server was re-booted? ",
			"How would you determine what groups $USER  belongs to? ",
			"What command would give the routing information on a server? ",
			"How would you determine the IP Address of a server? "};

		PrintWriter outFile = new PrintWriter(new FileWriter(file));

		Scanner scanner = new Scanner(System.in);
		String question, answer;

		for (int i = 0; i < questions.length; i++) {
			System.out.print(questions[i]);
			answer = scanner.nextLine();
			outFile.println(questions[i] + answer);
		}
		outFile.close();
	}
}
