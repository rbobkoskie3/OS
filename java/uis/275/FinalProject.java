// Robert Bobkoskie
// CSC 275 Online Final Project Solution
// ID: rb868x 14197 Jul 29 18:50 FinalProject.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)


import java.util.Scanner;


/* -----------------
 class FinalProject
----------------- */

public class FinalProject {
	public static void main(String[] args) {
		new FinalProject();
	}

	// Vars for Linked List
	Node head = null;
	Node temp;

	// This will act as our program switchboard
	public FinalProject() {
		Scanner input = new Scanner(System.in);

		System.out.println("Welcome to my new flower pack interface, implimenting a linked list.");
		displayOptions();
		System.out.println("");
	}

	public void displayOptions() {
		Scanner input = new Scanner(System.in);
		int userChoice = 0;

		System.out.println("Please select a number from the options below");
		System.out.println("");

		while (true) {
			// Give the user a list of their options
			System.out.println("1: Add an item to the pack.");
			System.out.println("2: Remove an item from the pack.");
			System.out.println("3: Search for a flower.");
			System.out.println("4: Display the flowers in the pack.");
			System.out.println("5: Remove all flowers from the pack.");
			System.out.println("0: Exit the flower pack interfact.");

			// Get the user input

			try {
                                userChoice = input.nextInt();
                                // The conditional is to enforce the requirement that
                                // non-negative ints are entered
                                if (userChoice < 0) {
                                        System.out.println ("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE INT");
                                        displayOptions();
                                }
				if (userChoice > 5) {
					System.out.println ("INPUT ERROR: " + userChoice + " MOT IMPLIMENTED");
                                        displayOptions();
                                }
                        }
                        catch (java.util.InputMismatchException IME) {
                                System.out.println ("INPUT ERROR, PLEASE ENTER A NON-NEGATIVE INT");
                                displayOptions();
                        }


			switch (userChoice) {
			case 1:
				addFlower();
				break;
			case 2:
				removeFlower();
				break;
			case 3:
				searchFlowers();
				break;
			case 4:
				displayFlowers();
				break;
			case 5:
				removeAlllowers();
				break;
			case 0:
				System.out.println("BYE");
				System.exit(0);
			}
		}

	}

	private void addFlower() {
		// TODO: Add a flower that is specified by the user

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower: ");
                String flowerName = input.nextLine();

                System.out.print("Enter the color of your flower: ");
                String flowerColor = input.nextLine();

                String flowerThorns;
                do {
                        System.out.print("Does the flower have thorns, y/n: ");
                        flowerThorns = input.nextLine();
                } while (!flowerThorns.equalsIgnoreCase("y") && !flowerThorns.equalsIgnoreCase("n"));
                boolean hasThorns = false;
                if (flowerThorns.equalsIgnoreCase("y"))
                        hasThorns = true;

		System.out.print("Enter the scent of your flower: ");
                String flowerScent = input.nextLine();
		System.out.println("");

		// Create, compare Flower Name (mark as duplicate if Flower Name exists in pack)
		// and prefix Flower object to the head of the Linked List
		Flower f = new Flower(flowerName, flowerColor, hasThorns, flowerScent);
		compareFlowerName(f);	// compare and mark as duplicate if Flower Name found in pack
		preFixFlower(f);
	}

        private void compareFlowerName(Flower f) {
                Node p;
                p = head;

                if (p == null) {
                        return;
                }

                while (p != null) {
                        if (p.getFlower().compareName(f.getName()))
                                f.setIsDuplicatName(true);
                        p = p.getNext();
                }
        }

	private void preFixFlower(Flower flower) {
		// Insert at the head, e.g.,
		// if 1, 2,3 is entered in that order,
		// then the Linked List will have order 3, 2, 1
		temp = head;
		head = new Node(flower, temp);
	}

	private void removeAlllowers() {
		Scanner input = new Scanner(System.in);
                String confirmRemove;

                do {
                        System.out.println("There are " + Flower.flowerCount + " Flowers in the pack - REMOVE ALL FLOWERS, y/n: ");
                        confirmRemove = input.nextLine();
                } while (!confirmRemove.equalsIgnoreCase("y") && !confirmRemove.equalsIgnoreCase("n"));

                if (confirmRemove.equalsIgnoreCase("n")) {
                        System.out.println("");
                        return;
                }
                System.out.println("REMOVING All FLOWERS");
                head = null;
                temp = null;
                Flower.flowerCount = 0;
                System.out.println("");
	}

	/* =============================================================
	// This method 'removeFlower()' will remove (if found) A
	// SINGLE (the FIRST instance) of a Flower by name
        private void removeFlower() {
                // TODO: Remove a flower that is specified by the user

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower to remove: ");
                String flowerName = input.nextLine();

                Node prev, del;
                del = head;
                prev = null;

                while (del != null) {
			// This logic will delete ONLY ONE (the first instance) of the flower (if found)
                        if (del.getFlower().getName().equals(flowerName)) {
                                break;  // If flowerName is found - break the while loop
                        }
                        prev = del;
                        del = del.getNext();
                }

                if (del == null) {
                        System.out.println(flowerName + " Not Found" + "\n");
                } else {
                        if (del == head) {
                                head = head.getNext();
                        } else prev.setNext(del.getNext());     // Remove the Node by setting
                                                                // the previous Node to point
                                                                // to the next node

                System.out.println("Removing: " + flowerName + "\n");
                Flower.flowerCount--;
                }
        }
	============================================================= */

	// =============================================================
        // This method 'removeFlower()' will remove (if found) ALL
        // instances of a Flower by name
	private void removeFlower() {
		// TODO: Remove a flower that is specified by the user

                int numRemoved = 0;
                Node prev, del;
                del = head;
                prev = null;
                boolean found = false;

                if (del == null) {
                        System.out.println("ADD SOME FLOWERS" + "\n");
                        return;
                }

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of your flower to remove: ");
                String flowerName = input.nextLine();

                while (del != null) {
                        found = false;
                        // This logic will delete ALL instances of the flower (if found)
                        if (del.getFlower().getName().equals(flowerName)) {

                                // Remove the Node by setting the previous Node to point to the next node
                                // Special treatment for the 'head' node
                                if (del == head) {
                                        head = head.getNext();
                                        found = true;
                                } else {
                                        prev.setNext(del.getNext());
                                        found = true;
                                }
                                numRemoved++;
                        }
                        // If Item NOT found, prev IS incrimented to del. E.g., if Item found,
                        // the Node del is removed - prev would point to GARBAGE
                        if (!found) {
                                prev = del;
                        }
                        del = del.getNext();
                }
                Flower.flowerCount -= numRemoved;
                if (numRemoved == 0)
                        System.out.println(flowerName + " Not Found" + "\n");
                else
                        System.out.println("Removing: " + numRemoved + " " + flowerName + "\n");
        }
	// ============================================================= */

	private void searchFlowers() {
		// TODO: Search for a user specified flower

                Node p;
                p = head;

                if (p == null) {
                        System.out.println("ADD SOME FLOWERS" + "\n");
                        return;
                }

                Scanner input = new Scanner(System.in);
                System.out.print("Enter the name of the flower to search: ");
                String flowerName = input.nextLine();

                boolean found = false;
                while (p != null) {
                        String searchName = p.getFlower().getName().toLowerCase();
                        if (flowerName.toLowerCase().equals(searchName)) {
                                found = true;
                                System.out.println("FOUND: " + p.getFlower().getName());
                                System.out.println("  Color - " + p.getFlower().getColor());
                                System.out.println("  Scent - " + p.getFlower().getScent());
                                System.out.println("  Has Thorns: " + p.getFlower().isThorns() + "\n");
                        }
                        p = p.getNext();
                }

                if (!found)
                        System.out.println("DID NOT FIND NAME: " + flowerName + "\n");
	}

        private int countFlower(Flower f) {
                Node p;
                p = head;
		int numFlower = 0;

                while (p != null) {
			if (f.compareName(p.getFlower().getName()))
                        // if (p.getFlower().compareName(f.getName()))
				numFlower++;
                        p = p.getNext();
                }
		return numFlower;
        }

	private void displayFlowers() {
		// TODO: Display only the unique flowers along with a count of any duplicates
		// For example it should say Roses - 7 Daffodils - 3 Violets - 5

		Node p;
                p = head;
		if (p == null) {
			System.out.println("ADD SOME FLOWERS" + "\n");
			return;
		}

		while (p != null) {
			// If there are more than 1 Flower with the same Name, display only once, e.g.,
			/* if there are 2 rose in the pack, display
			 >  2 - rose, NOT
			 >  2 - rose
			    2 - rose
			*/
			if (!p.getFlower().getIsDuplicatName()) {
				System.out.println(countFlower(p.getFlower()) + " - " + p.getFlower().getName());
			}
                        p = p.getNext();
                }
		System.out.println("");
	}
}


/* -----------------
 class Flower
----------------- */

class Flower {
	// Declare attributes here
	private String name;
	private String color;
	private boolean thorns;
	private String scent;
	static int flowerCount = 0;		// Global count of all flowers in pack
	private boolean isDuplicatName = false;	// boolean var to count flowers for display

	public Flower() {

	}

	public Flower(String name, String color, boolean thorns, String scent) {
		this.name = name;
		this.color = color;
		this.thorns = thorns;
		this.scent = scent;

		flowerCount++;
		isDuplicatName = false;
	}

	public boolean compareName(String name) {
                if (this.name.equals(name))
                        return true;
                return false;
        }

	public void setIsDuplicatName(boolean isDuplicatName) {
                this.isDuplicatName = isDuplicatName;
        }

	public void setName(String name) {
		this.color = color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public void setThorns(boolean thorns) {
		this.thorns = thorns;
	}

	public void setScent(String scent) {
		this.scent = scent;
	}

        public boolean getIsDuplicatName() {
                return isDuplicatName;
        }

	public String getName() {
		return name;
	}

	public String getColor() {
		return color;
	}

	public boolean isThorns() {
		return thorns;
	}

	public String getScent() {
		return scent;
	}
}


/* -----------------
 class Node
----------------- */

class Node {

	private Flower item;
	private Node next;

	public Node( ) {

	}

	public Node(Flower flower, Node node) {
	setFlower(flower);
	setNext(node);
	}

	public Flower getFlower() {
		return item;
	}

	public Node getNext() {
		return next;
	}

	public void setFlower(Flower item) {
		this.item = item;
	}

	public void setNext(Node next) {
		this.next = next;
	}
}
