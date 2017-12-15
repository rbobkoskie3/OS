// Robert Bobkoskie
// CSC 275 Online Lab 1 Solution
// ID: rb868x 3126 Jun  5 18:32 Lab01Array.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)


/*
Create a program that has an array of length 100 which will automatically be filled with randomly generated numbers between 1-100 each time the program is run. Have the program ask the user to enter a number between 1 and 100. Check to see if that number is one of the values in the array. If it is display .We found your number XX at position YY in the array. If the number is not in the array tell the user that no match was found
*/

import java.util.Random;
import java.util.Scanner;


public class Lab01Array {
   public static void main(String[] args) {

      int[] myArray = new int[100];
      Random randomNumber = new Random();
      String newLine = System.getProperty("line.separator");
      boolean verify = true;
      // boolean verify = false; 
      int foundHere = 0;
      int foundInt = 0;

      for (int i = 0; i < myArray.length; i++) {
         myArray[i] = randomNumber.nextInt(100)+1;  // Add'1' to shift range 1-100
                                                    // Quick and dirty test in shell,
                                                    // create a large array,
                                                    // e.g., int[] myArray = new int[10000];
                                                    // then verify lower bound, e.g., java Lab01Array |grep ': 0$'
                                                    //  verify lower bound, e.g., java Lab01Array |grep ': 1$'
                                                    // then verify upper bound, e.g., java Lab01Array |grep ': 100$'
                                                    // verify upper bound, e.g., java Lab01Array |grep ': 101$'
      }

      // Verify the array, confirm 100 elements: 0-99
      if (verify) {
         System.out.println(newLine + "Verify the array, confirm 100 elements, Index 0-99:");
         for (int i = 0; i < myArray.length; i++) {
            System.out.println("Index " + i + " is: " + myArray[i]);
         }
         System.out.println();
      }

      Scanner input = new Scanner(System.in);
      int searchInt;
      System.out.println("Please enter an integer from 1-100 to search for: ");
      searchInt = input.nextInt();

      boolean found = false;
      for (int i = 0; i < myArray.length; i++) { 
         if (searchInt == myArray[i]) {
            found = true;
            foundHere = i;
            foundInt =  myArray[i];  // Note, can simply use the number entered by user,
                                         // but, will use the number in the array to verify index
            break; // Exits the loop, e.g., short circuit the loop
         }
      }

      if(found){
         System.out.println("Found " + foundInt + " at index = " + foundHere);
      }
      else {
         System.out.println(searchInt + " not found, try again");
      }
   }
}

