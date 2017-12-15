// Robert Bobkoskie
// CSC 275 Online Lab 3 Solution
// ID: rb868x 4517 Jun 21 19:44 Lab03CaesarCipher.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

/*
 * Create a program that decodes messages. The messages will be encoded using a Caesar cipher,
 * with each letter being decoded by replacing it with the previous letter in the alphabet. 
**/


import java.util.Scanner;

public class Lab03CaesarCipher {
   public static void main(String[] args) {
	CaesarCipher Julius = new CaesarCipher();
	Julius.displayMenu();
	}
}

class CaesarCipher {

	private String Phrase;
	private char[] alphabet = new char[26];

	public void displayMenu() {
                Scanner input = new Scanner(System.in);

                System.out.println("Lets try some ciphering.");
                System.out.println("Please select a number from the options below");
                System.out.println("");

                while (true) {
                        // Give the user a list of their options
                        System.out.println("1: Decode a message.");
                        System.out.println("2: Encode a message.");
                        System.out.println("3: Display the alphabet.");
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

			String phrase;
                        switch (userChoice) {
                        case 1:
				phrase = getPhrase(); 
                                decodeMessage(phrase);
                                break;
                        case 2:
				phrase = getPhrase();
                                encodeMessage(phrase);
                                break;
                        case 3:
                                displayAlphabet();
                                break;
                        case 0:
                                System.out.println("BYE");
                                System.exit(0);
                        }
                }
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

	public String getPhrase() {
		String Phrase;
		Scanner getPhrase = new Scanner(System.in);
		System.out.println("1: Enter a phrase.");
		Phrase = getPhrase.nextLine();

	return Phrase;
	}

	public void encodeMessage(String messageToEncode) {
                StringBuffer word = new StringBuffer(messageToEncode);
                for (int i = 0; i < word.length(); i++) {
                        char c = messageToEncode.charAt(i);
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
                System.out.println("word = " + word);
		System.out.println("");
	} 

	public void decodeMessage (String messageToDecode) {
		StringBuffer word = new StringBuffer(messageToDecode);
		for (int i = 0; i < word.length(); i++) {
			char c = messageToDecode.charAt(i);
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
		System.out.println("word = " + word);
		System.out.println("");
	}

	public void displayAlphabet() {
		loadData();
	}

}

