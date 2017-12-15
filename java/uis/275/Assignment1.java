// Robert Bobkoskie
// CSC 275 Online Assignment 1 Solution
// ID: rb868x 6466 Jun 10 15:27 Assignment1.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)


import java.util.Scanner;

public class Assignment1 {
	public static void main(String[] args){
		new Assignment1();
	}
	
	// This will act as our program switchboard
	public Assignment1(){
		Scanner input = new Scanner(System.in);
		String[] flowerPack = new String[25];
	
		System.out.println("Welcome to my flower pack interface.");
		System.out.println("Please select a number from the options below");
		System.out.println("");
		
		while(true){
			// Give the user a list of their options
			System.out.println("1: Add an item to the pack.");
			System.out.println("2: Remove an item from the pack.");
			System.out.println("3: Sort the contents of the pack.");
			System.out.println("4: Search for a flower.");
			System.out.println("5: Display the flowers in the pack.");
			System.out.println("0: Exit the flower pack interfact.");
			
			// Get the user input
			int userChoice = input.nextInt();
				
			switch(userChoice){
				case 1: 
					addFlower(flowerPack);
					break;
				case 2: 
					removeFlower(flowerPack);
					break;
				case 3: 
					sortFlowers(flowerPack);
					break;
				case 4: 
					searchFlowers(flowerPack);
					break;
				case 5: 
					displayFlowers(flowerPack);
					break;
				case 0: 
					System.out.println("Thank you for using the flower pack interface. See you again soon!");
					System.exit(0);
			}
		}
		
	}

	private void addFlower(String flowerPack[]) {
		// TODO: Add a flower that is specified by the user

		Scanner input = new Scanner(System.in);
		System.out.print("Enter the name of your flower: ");
		String flower = input.nextLine();

		// Add flower to next null index in flowerPack[]
		for (int i = 0; i < flowerPack.length; i++) {
			if (flowerPack[i] == null) {
				flowerPack[i] = flower;
				System.out.println("FLOWER " + flowerPack[i] + " added at index " + i);
				System.out.println("");
				return;
			}
		}
		System.out.print( "ERROR, FLOWER CAN NOT BE ADDED, LINIT " + flowerPack.length + " REACHED" );
		System.out.println("");
		System.out.println("");
	}

	private void removeFlower(String flowerPack[]) {
		// TODO: Remove a flower that is specified by the user

		Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower to remove: ");
                String flower = input.nextLine();
		int found = 0;

                for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null && flowerPack[i].equals(flower)) {
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

	private void sortFlowers(String flowerPack[]) {
		// TODO: Sort the flowers in the pack (No need to display them here) - Use Selection or Insertion sorts
		// NOTE: Special care is needed when dealing with strings! research the compareTo() method with strings

		int count = 0;

		for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null) {
                                count++;
			}
		}

		String[] flowerArrayNonNull = new String[count];
		int k = 0;
		for (int i = 0; i < flowerPack.length; i++) {
                        if (flowerPack[i] != null) {
                               flowerArrayNonNull[k] = flowerPack[i];
				k++;
                        }
                }
		
		for(int i = 0; i < flowerArrayNonNull.length; i++) {
			String currentMinimum = flowerArrayNonNull[i];
			int currentMinIndex = i;
			
			for(int j = i; j < flowerArrayNonNull.length; j++){
				int result = currentMinimum.compareTo(flowerArrayNonNull[j]);
				if(result > 0){
					currentMinimum = flowerArrayNonNull[j];
					currentMinIndex = j;
				}
			}
			
			if(currentMinIndex != i){
				flowerArrayNonNull[currentMinIndex] = flowerArrayNonNull[i];
				flowerArrayNonNull[i] = currentMinimum;
			}
		}
		
		System.out.println("Sorted Array");
		if (flowerArrayNonNull.length > 0) {
			for(int i = 0; i < flowerArrayNonNull.length; i++){
				System.out.println(flowerArrayNonNull[i]);
			}
		}
		else {
			System.out.println("ARRAY EMPTY, PICK SOME FLOWERS");	
		}
		System.out.println();
	}

	private void searchFlowers(String flowerPack[]) {
		// TODO: Search for a user specified flower

		Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of the flower to search: ");
                String flower = input.nextLine();

		// Experiment with toLowerCase() method for char independance --- IT WORKS
		flower = flower.toLowerCase();
		for (int i = 0; i < flowerPack.length; i++) {
			if (flowerPack[i] != null && flowerPack[i].toLowerCase().equals(flower)) {
				System.out.println(flower + " found at index " + i);
				System.out.println();
				return;
			}
		}
		System.out.println(flower + " Not Found");
		System.out.println();
	}

	private void displayFlowers(String flowerPack[]) {
		// TODO: Display only the unique flowers along with a count of any duplicates
		/*
		 * For example it should say
		 * Roses - 7
		 * Daffodils - 3
		 * Violets - 5
		 */

		// Create an array to hold unique flower names
		String[] flowerName = new String[flowerPack.length];
		boolean empty = true;

		// Search for a flower in flowerPack[], skippng null entries
		for (int i = 0; i < flowerPack.length; i++) {
			if (flowerPack[i] == null)
				continue;

			empty = false;
			boolean found = false;
			for (int k = 0; flowerName[k] != null; k++) {
				if (flowerPack[i].equals(flowerName[k])) {
					found = true;
					break;
				}
			}
			if (!found) {
				int m = 0;
				while (flowerName[m] != null) {
					m++;
				}
				flowerName[m] = flowerPack[i];
				int count = 0;
				for (int j = 0; j < flowerPack.length; j++) {
					if (flowerPack[i].equals( flowerPack[j]))
						count ++;

				}
				System.out.println(flowerPack[i] + " - " + count);
			}
		}
		if (empty)
			System.out.println("ARRAY EMPTY, PICK SOME FLOWERS");

		System.out.println("");
	}
}

