// Robert Bobkoskie
// CSC 275 Online Assignment 2 Solution
// ID: rb868x 8936 Jul 23 17:01 Assignment2_V2.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

import java.util.Scanner;

public class Assignment2_V2 {
	public static void main(String[] args) {
		new Assignment2_V2();
	}

	// This will act as our program switchboard
	public Assignment2_V2() {
		Scanner input = new Scanner(System.in);
		Flower_V2[] flowerPack = new Flower_V2[25];

		System.out.println("Welcome to my flower pack interface.");
		System.out.println("Please select a number from the options below");
		System.out.println("");

		while (true) {
			// Give the user a list of their options
			System.out.println("1: Add an item to the pack.");
			System.out.println("2: Remove an item from the pack.");
			System.out.println("3: Search for a flower.");
			System.out.println("4: Display the flowers in the pack.");
			System.out.println("0: Exit the flower pack interfact.");

			// Get the user input
			int userChoice = input.nextInt();

			switch (userChoice) {
			case 1:
				addFlower(flowerPack);
				break;
			case 2:
				removeFlower(flowerPack);
				break;
			case 3:
				searchFlowers(flowerPack);
				break;
			case 4:
				displayFlowers(flowerPack);
				break;
			case 0:
				System.out
						.println("Thank you for using the flower pack interface. See you again soon!");
				System.exit(0);
			}
		}

	}

	private void addFlower(Flower_V2 flowerPack[]) {
		// TODO: Add a flower that is specified by the user

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower: ");
                String flowerName = input.nextLine();

		System.out.print("Enter the color of your flower: ");
                String flowerColor = input.nextLine();

		String flowerThorns;
		do {
			System.out.println("Does the flower have thorns, y/n: ");
			flowerThorns = input.nextLine();
		} while (!flowerThorns.equalsIgnoreCase("y") && !flowerThorns.equalsIgnoreCase("n"));
		boolean hasThorns = false;
		if (flowerThorns.equalsIgnoreCase("y"))
			hasThorns = true;

		String flowerScent;
                do {
                        System.out.println("Does the flower have a scent, y/n: ");
                        flowerScent = input.nextLine();
                } while (!flowerScent.equalsIgnoreCase("y") && !flowerScent.equalsIgnoreCase("n"));
                boolean hasScent = false;
                if (flowerScent.equalsIgnoreCase("y"))
                        hasScent = true;

                // Add flower to next null index in flowerPack[]
                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] == null) {
				flowerPack[i] = new Flower_V2(flowerName, flowerColor, hasThorns, hasScent);
                                // flowerPack[i].setFlowerName(flowerName);   // Test a setter, not needed due to constructor in Flower_V2 class
                                System.out.println("FLOWER " + flowerPack[i].getFlowerName() + " added at index " + i);
                                System.out.println("");
                                return;
                        }
                }
                System.out.print( "ERROR, FLOWER CAN NOT BE ADDED, LINIT " + flowerPack.length + " REACHED" );
                System.out.println("");
                System.out.println("");
        }

	private void removeFlower(Flower_V2 flowerPack[]) {
		// TODO: Remove a flower that is specified by the user

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower to remove: ");
                String flower = input.nextLine();
                int found = 0;

                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null && flowerPack[i].getFlowerName().equals(flower)) {
                                flowerPack[i] = null;
                                found++;
                        }
                }
                if (found > 0) {
                        System.out.println(found + " " +  flower + " removed");
                        System.out.println("");
                }
                else {
                        System.out.print("ERROR, " + flower + " CAN NOT BE FOUND");
                        System.out.println("");
                        System.out.println("");
                }
	}

	private void searchFlowers(Flower_V2 flowerPack[]) {
		// TODO: Search for a user specified flower

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of the flower to search: ");
                String flower = input.nextLine();

                // Experiment with toLowerCase() method for char independance --- IT WORKS
                flower = flower.toLowerCase();
                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null && flowerPack[i].getFlowerName().toLowerCase().equals(flower)) {
                                System.out.println(flower + " found at index " + i);
                                System.out.println();
                                return;
                        }
                }
                System.out.println(flower + " Not Found");
                System.out.println();
	}

	private void displayFlowers(Flower_V2 flowerPack[]) {
		// TODO: Display only the unique flowers along with a count of any
		// duplicates
		/*
		 * For example it should say Roses - 7 Daffodils - 3 Violets - 5
		 */

                // Create an array to hold unique flower names
                Flower_V2[] flowerObject = new Flower_V2[flowerPack.length];
                boolean empty = true;
		int countScent = 0;
		int countThorns = 0;

		// Give the user a list of their options
                System.out.println("1: Search by Flower Name.");
                System.out.println("2: Search by Flower Color.");

                // Get the user input
		boolean searchFlowerName = true;
		Scanner input = new Scanner(System.in);
                int userChoice = input.nextInt();

		switch (userChoice) {
		case 1:
			// Search by Flower Nmae --- boolean searchFlowerName is default to true
                        break;
		case 2:
			// Search by Flower Color --- searchFlowerName == false
			searchFlowerName = false;
			break;
                }

                // Search for an Flower object in flowerPack[], skippng null entries
                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] == null)
                                continue;
			if (flowerPack[i].getFlowerThorns())
				 countThorns++;
			if (flowerPack[i].getFlowerScent())
				countScent++;
                        empty = false;
                        boolean found = false;
                        for (int k = 0; flowerObject[k] != null; k++) {
				if (searchFlowerName) {
                                	if (flowerPack[i].getFlowerName().equals(flowerObject[k].getFlowerName())) {
                                       		found = true;
                                       		break;
					}
				}
				else {
					if (flowerPack[i].getFlowerColor().equals(flowerObject[k].getFlowerColor())) {
						found = true;
						break;
					}
				}
                        }
                        if (!found) {
                                int m = 0;
                                while (flowerObject[m] != null) {
                                        m++;
                                }
                                flowerObject[m] = flowerPack[i];
                                int countTrait = 0;
                                for (int j = 0; j < flowerPack.length; j++) {
					if (flowerPack[j] != null) {
						if (searchFlowerName) {
                                       			if (flowerPack[i].getFlowerName().equals(flowerPack[j].getFlowerName()))
                                                		countTrait++;
						}
						else {
							if (flowerPack[i].getFlowerColor().equals(flowerPack[j].getFlowerColor()))
								countTrait++;
						}
					}
                                }
				if (searchFlowerName)
                                	System.out.println(flowerPack[i].getFlowerName() + " - " + countTrait);
				else {
					System.out.println(flowerPack[i].getFlowerColor() + " - " + countTrait);
				}
                        }
                }
                if (empty)
                        System.out.println("ARRAY EMPTY, PICK SOME FLOWERS");
		else {
			System.out.println("There are " + countThorns + " Flowers with thorns in the flowerpack");
			System.out.println("There are " + countScent + " Flowers with scent in the flowerpack");
		}
                System.out.println("");
	}
}
