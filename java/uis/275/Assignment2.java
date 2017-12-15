// Robert Bobkoskie
// CSC 275 Online Assignment 2 Solution
// ID: rb868x 7009 Jul 24 13:03 Assignment2.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

import java.util.Scanner;

public class Assignment2 {
	public static void main(String[] args) {
		new Assignment2();
	}

	// This will act as our program switchboard
	public Assignment2() {
		Scanner input = new Scanner(System.in);
		Flower[] flowerPack = new Flower[25];

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

	private void addFlower(Flower flowerPack[]) {
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


                // Count flowers with matching attributes in the flowerPack[], e.g.,
		// if flower is a duplicate entry, increaseCount() and  return, i.e.,
		// do not add to pack
                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null) {
				if (flowerPack[i].compareAllTrais (flowerName, flowerColor, hasThorns, hasScent)) {
					flowerPack[i].increaseCount();
					System.out.println(flowerName + " Not added (it is 'counted') to pack, it is a duplicate entry");
					System.out.println("");
                                	return;
				}
				
                        }
                }

		// Add only unique (must nat have matching traits: flowerName, flowerColor, hasThorns. hasScent)
		// flower to next null index in flowerPack[]
		for (int m = 0; m < flowerPack.length; m++) {
			if (flowerPack[m] == null) {
				flowerPack[m] = new Flower(flowerName, flowerColor, hasThorns, hasScent);
				System.out.println("FLOWER " + flowerPack[m].getFlowerName() + " added at index " + m);
				System.out.println("");
				return;
			}
		}
                System.out.print( "ERROR, FLOWER CAN NOT BE ADDED, LINIT " + flowerPack.length + " REACHED" );
                System.out.println("");
                System.out.println("");
        }

	private void removeFlower(Flower flowerPack[]) {
		// TODO: Remove a flower that is specified by the user

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower to remove: ");
                String flower = input.nextLine();
                int found = 0;

                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null && flowerPack[i].getFlowerName().equals(flower)) {
				found+=flowerPack[i].getCount();
                                flowerPack[i] = null;
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

	private void searchFlowers(Flower flowerPack[]) {
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

	private void displayFlowers(Flower flowerPack[]) {
		// TODO: Display only the unique flowers along with a count of any
		// duplicates
		/*
		 * For example it should say Roses - 7 Daffodils - 3 Violets - 5
		 */

		boolean empty = true;
                // Search for an Flower object in flowerPack[], skippng null entries
                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] == null)
                                continue;

			int count = flowerPack[i].getCount();
			String name = flowerPack[i].getFlowerName();
			String color = flowerPack[i].getFlowerColor();
			String hasThorns = flowerPack[i].getFlowerThorns() ? "with thorns": "without thorns";
			String hasSecnt = flowerPack[i].getFlowerScent() ? "with scent": "without scent";
			System.out.println("There are " + count + " Flowers named " + name + " colored " + color + " " + hasThorns +  " " + hasSecnt + " in the flowerpack");
			empty = false;
		}
                if (empty)
                        System.out.println("ARRAY EMPTY, PICK SOME FLOWERS");

                System.out.println("");
	}
}
