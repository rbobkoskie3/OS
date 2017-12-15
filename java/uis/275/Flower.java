// Robert Bobkoskie
// CSC 275 Online Assignment 2 Solution
// ID: rb868x 1763 Jul 24 13:03 Flower.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)
// This should be in it.s own file

public class Flower {
	// Declare attributes here
	private String Name, Color;
	private boolean Thorns, Scent;
	private int Count = 0;

	public Flower(){
		
	}
	
	// Create an overridden constructor here
	public Flower(String name, String color, boolean hasThorns, boolean hasScent) {
		Name = name;
		Color = color;
		Thorns = hasThorns;
		Scent = hasScent;
		Count = 1;
	}
	
	//Create accessors and mutators for your triats.

	public void setFlowerName(String newName) {
		Name = newName;
	}

        public void setFlowerColor(String newColor) {
                Color = newColor;
        }

        public void setFlowerThorns(boolean hasThorns) {
                Thorns = hasThorns;
        }

        public void setFlowerScent(boolean hasScent) {
                Scent = hasScent;
        }


	public String getFlowerName() {
		return Name;
	}

        public String getFlowerColor() {
                return Color;
        }

        public boolean getFlowerThorns() {
                return Thorns;
        }

        public boolean getFlowerScent() {
                return Scent;
        }

	public boolean compareAllTrais (String name, String color, boolean hasThorns, boolean hasScent) {
                if (Name.equals(name) && Color.equals(color) && Thorns == hasThorns && Scent == hasScent)
			return true;
		return false;
	}

	public void increaseCount() {
		Count++;
	}

	public int getCount() {
		return Count;
	}

}

