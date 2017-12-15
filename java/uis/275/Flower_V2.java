// Robert Bobkoskie
// CSC 275 Online Assignment 2 Solution
// ID: rb868x 1406 Jul 23 17:04 Flower_V2.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)
// This should be in it.s own file

public class Flower_V2 {
	// Declare attributes here
	private String Name, Color;
	private boolean Thorns, Scent;


	public Flower_V2(){
		
	}
	
	// Create an overridden constructor here
	public Flower_V2(String name, String color, boolean hasThorns, boolean hasScent) {
		Name = name;
		Color = color;
		Thorns = hasThorns;
		Scent = hasScent;
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

}
