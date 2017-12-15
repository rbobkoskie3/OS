// Robert Bobkoskie
// CSC 275 Online Lab 2 Solution
// ID: rb868x 6502 Jun 15 15:18 Contact.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)


/*
 * Create a program that has an object type of Contact. This contact will need
 * to have the following attributes: Name, Birth Date, Phone Number, Address and
 * Eye Color You should write a simple program that prompts the user to create 2
 * new contacts. Once the contacts are created you need to print out their
 * information in a readable manner (completely up to you . but all traits must be
 * displayed). Finally, we need to prompt the user for a new name of the first contact.
 * Once the new name is entered you need to print out the 2 contacts again (the first contacts name should be changed)
**/

import java.util.Scanner;


public class Contact {

	private String name;
	private String birthDate;
	private String phoneNumber;
	private String address;
	private String eyeColor;


	public void setName(String newName) {
		name = newName;
	}

        public void setBirthDate(String newBirthDate) {
                birthDate = newBirthDate;
        }

        public void setPhoneNumber(String newPhoneNumber) {
                phoneNumber = newPhoneNumber;
        }

        public void setAddress(String newAddress) {
                address = newAddress;
        }

        public void setEyeColor(String newEyeColor) {
                eyeColor = newEyeColor;
        }

        public String getName() {
                return name;
        }

        public String getBirthDate() {
                return birthDate;
        }

        public String getPhoneNumber() {
                return phoneNumber;
        }

        public String getAddress() {
                return address;
        }

        public String getEyeColor() {
                return eyeColor;
        }


	public static void main(String[] args) {

		int numContact;
		Scanner intInput = new Scanner(System.in);;
		System.out.println("Please enter the number of contacts: ");
		numContact = intInput.nextInt();

		Contact[] contacts = new Contact[numContact];

		// Set contact attributes
		for (int i = 0; i < numContact; i++) {
			contacts[i] = new Contact();
			String attribute;
                        Scanner strInput = new Scanner(System.in);
			// Scanner attribute = new Scanner(System.in);
			
			System.out.println("Enter a Name for your Contact" + i);
			attribute = strInput.nextLine();
			contacts[i].setName(attribute);

			System.out.println("Enter a Birth Date for your Contact" + i);
			attribute = strInput.nextLine();
			contacts[i].setBirthDate(attribute);

			System.out.println("Enter a Phone Number for your Contact" + i);
			attribute = strInput.nextLine();
			contacts[i].setPhoneNumber(attribute);

			System.out.println("Enter an Address for your Contact" + i);
			attribute = strInput.nextLine();
			contacts[i].setAddress(attribute);

			System.out.println("Enter the Eye Color for your Contact" + i);
			attribute = strInput.nextLine();
			contacts[i].setEyeColor(attribute);
		}

		// Get contact attributes
		for (int i = 0; i < contacts.length; i++) {
			getAttributes(i, contacts[i]);
		}

		// Modify contact attributes
		if (contacts.length > 0) {
			int Contact;
			do {
             	  		System.out.println("Please enter the contact you wish to modify: ");
				for (int i = 0; i < contacts.length; i++) {
					System.out.println(i);
				}
               			Contact = intInput.nextInt();
			} while (Contact > contacts.length -1);
			// DEBUG STATEMENT: System.out.println("Contact = " + Contact + " contacts.length = " + contacts.length);
			modifyAttributes(Contact, contacts);    // Pass in array, e.g., contacts[] to meet requirement of printing out
								// all contact after modifying
		}
		else
			System.out.println("ADD SOME CONTACTS, e.g., choose >0");
	}

	// Modify contact attributes
	public static void modifyAttributes(int i, Contact contacts[]) {
		int Id = i;
		Contact[] contact = contacts;
		Scanner input = new Scanner(System.in);
                System.out.println("Please select a number from the options below");
                System.out.println("");

		while(true) {
			// Give the user a list of their options
                    	System.out.println("1: Modify Name");
               	        System.out.println("2: Modify Birth Date");
               	        System.out.println("3: Modify Phone Number");
			System.out.println("4: Modify Address");
			System.out.println("5: Modify Eye Color");
			System.out.println("6: Print Values for All Contact");
			System.out.println("0: EXIT");

			// Get the user input
			int userChoice = input.nextInt();

			String attribute;
			Scanner strInput = new Scanner(System.in);
			switch(userChoice) {
				case 1:
					System.out.println("Enter new Name");
					attribute = strInput.nextLine();
					contact[Id].setName(attribute);
					break;
				case 2:
					System.out.println("Enter new Birth Date");
					attribute = strInput.nextLine();
					contact[Id].setBirthDate(attribute);
					break;
				case 3:
					System.out.println("Enter new Phone Number");
					attribute = strInput.nextLine();
					contact[Id].setPhoneNumber("attribute");
					break;
				case 4:
					System.out.println("Enter new Address");
                                        attribute = strInput.nextLine();
					contact[Id].setAddress(attribute);
					break;
				case 5:
					System.out.println("Enter new Eye Color");
                                        attribute = strInput.nextLine();
					contact[Id].setEyeColor(attribute);
					break;
				case 6:
					for (int k = 0; k < contact.length; k++) {
						getAttributes(k, contact[k]);
					}
					break;
				case 0:
					System.out.println("BYE");
					System.exit(0);
			}
		}
	}

	// Get contact attributes
	public static void getAttributes(int i, Contact contacts) {
		int Id = i;
		Contact contact = contacts;
		System.out.println("");
		System.out.println("Name for Contact" + Id + ": " + contact.getName());
		System.out.println("Birth Date for Contact" + Id + ": " + contact.getBirthDate());
		System.out.println("Phone # for Contact" + Id + ": " + contact.getPhoneNumber());
		System.out.println("Address for Contact" + Id + ": " + contact.getAddress());
		System.out.println("Eye Color for Contact" + Id + ": " + contact.getEyeColor());
		System.out.println("");
	}
}
