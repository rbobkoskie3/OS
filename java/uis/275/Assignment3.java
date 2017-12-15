// Robert Bobkoskie
// CSC 275 Online Assignment 3 Solution 
// ID: rb868x 10188 Jul 13 13:42 Assignment3.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)
/*
 * 1. Read in a text file, location determined by you.
 * 2. Prompt the user to encode or decode the file
 * 3. Write the encode or decoded message to a file in the same directory with the same name as the original but with either 'Encoded' or 'Decoded' appended to the name.
**/


import java.io.*;
import java.util.*;


public class Assignment3 {
	public static void main(String[] args) {
		CaesarCipher Julius = new CaesarCipher();
		try {
			Julius.setUseNewLine(true);
			Julius.displayMenu();
		} catch (IOException E1) {
			System.out.println ("ERROR: IO EXCEPTION");
		}
	}
}

class CaesarCipher {
	private char[] alphabet = new char[26];
	private boolean useNewLine = true;

	public void setUseNewLine(boolean var) {
		if (!var)
			useNewLine = false;
		else
			useNewLine = true;
	}

	public void displayMenu() throws FileNotFoundException, IOException {
		Scanner input = new Scanner(System.in);
		String fileName;
		File file;

		System.out.println("This program will encode or decode alpha chars in a file.");
		System.out.println("The encoded or decoded message will be written to a file in the same directory with the same name as the original but with either 'Encoded' or 'Decoded' appended to the name");
		System.out.println("Select a number from the options below");
		System.out.println("");

		while (true) {
			// Give the user a list of their options
			System.out.println("1: Decode a file.");
			System.out.println("2: Encode a file.");
			System.out.println("3: Display the alphabet.");
			System.out.println("4: Print a file.");
			System.out.println("0: Exit the program.");

			// Get the user input
			int userChoice = 0;
			try {
				userChoice = input.nextInt();
			}
			catch (java.util.InputMismatchException IME) {
				System.out.println ("INPUT ERROR, PLEASE ENTER AN INT");
				System.out.println("");
				displayMenu();
			}

			switch (userChoice) {
			case 1:
				fileName = getFileName("Enter the name of the file to decode: ", ".encode");
				if (fileName == null)
                                        displayMenu();

				file = new File(fileName);
				if (file.isFile() && file.canRead()) {
					System.out.println ("DECODING FILE: "  + file.getAbsolutePath());
                                        decodeMessage(file);
					System.out.println ("");
                                } else {
                                        System.out.println ("EXITING PROGRAM" + file.getAbsolutePath() + " is not readable");
					System.exit(1);
                                }
				break;
			case 2:
				fileName = getFileName("Enter the name of the file to encode: ", "");
				if (fileName == null)
                                        displayMenu();

				file = new File(fileName);
				if (file.isFile() && file.canRead()) {
					System.out.println ("ENCODING FILE: "  + file.getAbsolutePath());
                                        encodeMessage(file);
					System.out.println ("");
                                } else {
                                        System.out.println ("EXITING PROGRAM" + file.getAbsolutePath() + " is not readable");
                                        System.exit(1);
                                }
				break;
			case 3:
				System.out.println ("");
				displayAlphabet();
				break;
			case 4:
				fileName = getFileName("Enter the name of the file to print: ", "");
				if (fileName == null)
                                        displayMenu();

                                file = new File(fileName);
				if (file.isFile() && file.canRead()) {
					System.out.println ("PRINTING FILE: "  + file.getAbsolutePath());
                                	printFile(file);
					System.out.println ("");
				} else {
                                        System.out.println ("EXITING PROGRAM" + file.getAbsolutePath() + " is not readable");
                                        System.exit(1);
                                }
                                break;
			case 0:
				System.out.println("BYE");
				System.exit(0);
			}
		}
	}

	public String getFileName(String message, String ext) {
		final String extension = ext;
		String userInput;
		Scanner input = new Scanner(System.in);
                File dir = new File(System.getProperty("user.dir"));
		// Print a list of file without using filter
                // String[] files = dir.list();

		System.out.println("");
                System.out.print(message + dir.getAbsolutePath() + "', or X to exit: <String file name>/X ");
                System.out.println("");

                // Print a list of file --- USE filter
		String[] files = dir.list(new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.endsWith(extension);
    			}
		});


                for (int i = 0; i < files.length; i++)
                        System.out.println("\t" +files[i]);
                System.out.println("");
                userInput = input.nextLine();
                if (userInput.equalsIgnoreCase("X"))
			return null;
		return userInput;
	}

        public void printFile(File file) throws FileNotFoundException {
                Scanner s = null;
                try {
                        s = new Scanner(new BufferedReader(new FileReader(file)));
			if (useNewLine)
                        	s.useDelimiter("\\n");
                        System.out.println ("");
                        while (s.hasNext())
                                System.out.println(s.next());
                } finally {
                        if (s != null)
                                s.close();
                }
        }

	public void decodeMessage (File file) throws FileNotFoundException, IOException {
		// Add ".someExtension" to String preOutputFileName so that the regex
		// expression "\\..*$" for replace all chars following a . is satisfied
		String preOutputFileName = (file.getName() + ".someExtension");

		// Strings are immutable, to account for exisitng .[encode | .decode]
		// extensions, need two Strings: preOutputFileName, outputFileName
		String outputFileName = preOutputFileName.replaceAll("\\..*$", ".decode");

		File outFile = new File(outputFileName);
		Scanner s = null;
		PrintWriter outPut = new PrintWriter(new FileWriter(outFile));

		try {
			s = new Scanner(new BufferedReader(new FileReader(file)));
			if (useNewLine)
				s.useDelimiter("\\n");
			while (s.hasNext()) {

				StringBuffer word = new StringBuffer(s.next());
				for (int i = 0; i < word.length(); i++) {
					char c = word.charAt(i);
					if (Character.isLetter(c)) {
						c = Character.toUpperCase(c);

						if (c == 'A')
							word.setCharAt(i, 'Z');
						else {
							c--;
							word.setCharAt(i, c);
						}
					}
				}
				outPut.println(word);
			}
		} finally {
			if (s != null)
				s.close();
				outPut.close();
		}
	} 

        public void encodeMessage (File file) throws FileNotFoundException, IOException {
                // Add ".someExtension" to String preOutputFileName so that the regex
                // expression "\\..*$" for replace all chars following a . is satisfied
                String preOutputFileName = (file.getName() + ".someExtension");

                // Strings are immutable, to account for exisitng .[encode | .decode]
                // extensions, need two Strings: preOutputFileName, outputFileName
                String outputFileName = preOutputFileName.replaceAll("\\..*$", ".encode");

                File outFile = new File(outputFileName);
                Scanner s = null;
                PrintWriter outPut = new PrintWriter(new FileWriter(outFile));

                try {
                        s = new Scanner(new BufferedReader(new FileReader(file)));
			if (useNewLine)
                                s.useDelimiter("\\n");
                        while (s.hasNext()) {

                                StringBuffer word = new StringBuffer(s.next());
                                for (int i = 0; i < word.length(); i++) {
                                        char c = word.charAt(i);
                                        if (Character.isLetter(c)) {
                                                c = Character.toUpperCase(c);

                                                if (c == 'Z')
                                                        word.setCharAt(i, 'A');
                                                else {
                                                        c++;
                                                        word.setCharAt(i, c);
                                                }
                                        }
                                }
                                outPut.println(word);
                        }
                } finally {
                        if (s != null)
                                s.close();
                                outPut.close();
                }
        }

	public void displayAlphabet() {
		loadData();
	}

        public void loadData() {
                // Display the cipher table. Note that the method loadData()
                // was not explicitly used to encode/decose messages.
                // Encoding and decoding was accomplished by coding dirctly
                // in the methods: encodeMessage(), decodeMessage().

                // To get create the alphabet, typecast the int fro the for loop
                // to alphabet[i - 1], then increment '++'
                alphabet[0] = 'A';
                for (int i = 1; i < 26; i++) {
                        char c = alphabet[i - 1];
                        c++;
                        alphabet[i] = c;
                }
                System.out.println("A = Z");
                for (int i = 1; i < 26; i++)
                        System.out.println(alphabet[i] + " = " + alphabet[i - 1]);
                System.out.println("");
        }
}
