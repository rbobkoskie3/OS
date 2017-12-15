// ID: rb868x 3408 Aug  8 20:32 LinkedListDemo.java
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

public class LinkedListDemo {

        /* ------------
        / Flower class
        ------------ */
	public class Flower {
		String name;
		int count = 0;

		public Flower (String name) {
			this.name = name;
			count = 1;
		}

		public void addcount() {
			count++;
		}

		public boolean isEqual(Flower f) {
			return (f.name.toLowerCase().equals(this.name.toLowerCase()));
		}

		public int compareTo(Flower f) {
			return (f.name.toLowerCase().compareTo(this.name.toLowerCase()));
		}
	}

	/* ------------
	/ Node class
	------------ */ 
	public class Node<E>{
		E item;
		Node<E> next = null;
	}

        /* ------------
        / LinkedList class
        ------------ */
	public class LinkedList<E>{
		private Node<E> head = null;
		private Node<E> tail = null;
		private int counter = 0;

		public LinkedList(){

		}

		public int size(){
			return counter;
		}

		private void append(E item) {
			// add the first node in the head
			if (head == null){
				head = tail = new Node<E>();
				head.item = item;
			}
			else {
				tail.next = new Node<E>();	//add a new node to the end of the list
				tail = tail.next;		//set the tail pointer to that node
				tail.item = item;		//set item to be stored to the end node
			}
			counter++;
		}

		public void add(E item){
			// check for duplicate before adding to the list
			for (Node<E> n = head; n != null; n = n.next) {
				Flower f = (Flower) n.item;
				if (f.isEqual((Flower)item)) {	// If Flower exisits, do not add, incriment count and return
					f.addcount();
					return;
				}
			}
			append(item);	// apend to the tail.
		}

		public boolean remove(String fname) {
			Flower flower = new Flower(fname);

			Node<E> n1 = head;
			for (Node<E> n = head; n != null; n = n.next) {
				if (flower.isEqual((Flower)n.item)) {
					System.out.println("\nRemoving " + fname);
					if (n == head)
						head = head.next;
					else
						n1.next = n.next;
					counter--;
					return true;
				}
				n1 = n;
			}
			System.out.println("\nNot found --- " + fname + " not removed");
			return false;
		}

		public void print() {
			System.out.format("%6s    %-15s        %6s \n", "Index", "Name", "Count");
			System.out.println("---------------------------------------");

			int k = 1;
			Node<E> n = head;
			while (n != null) {
				Flower f = (Flower) n.item;
				System.out.format(" %-6d   %-15s        %2d ", k, f.name, f.count);
				System.out.println("               " + n.next);
				n = n.next;
				k++;
			}
			System.out.println("----------------");
			System.out.println("Total count: " + size());
		}
	}

	public LinkedListDemo() {
		LinkedList<Flower> list = new LinkedList<Flower>();
		String[] flowers = {"First", "Rose", "Junk", "Violet", "junk", "rose", "Rose"};

		for (int i=0; i < flowers.length; i++) {
			Flower flower = new Flower(flowers[i]);
			list.add(flower);
		}
		list.remove("Junki");	// "Junki not in String[] flowers, nothing removed
		list.print();

		list.remove("Junk");   // "Junk not in String[] flowers, will be removed
		list.print();

	}

	public static void main(String[] args) {
		new LinkedListDemo();
		System.out.println("Linked List: LinkedListDemo Complete.");
	}
}
