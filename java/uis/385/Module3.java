// Robert Bobkoskie
// ID: rb868x 6159 Sep 16 16:23 Module3.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

import java.util.*;

public class Module3 {

	public static void main(String[] args) {
		TestDriver();
	}

	public static void TestDriver() {

		// Test data, Ints and Chars
		Integer[] intArrayEven = {-1, 2, 3, 5, 6, 7};
		Integer[] intArrayOdd = {1, 2, 3, 5, 6};
		Integer[] intArrayEmpty = {};
                Integer[] intForTest = {-1, 0, 1, 3, 4, 6, 7, 100};

		Character[] charArrayEven = {'=', 'b', 'c', 'e', 'f', 'g'};
                Character[] charArrayOdd = {'a', 'b', 'c', 'e', 'f'};
                Character[] charArrayEmpty = {};
                Character[] charForTest = {'=', 'a', 'b', 'd', 'e', 'f', 'g', 'h'};

		// Arrays for capturing test results
		// NOTE that the precondition is that intForTest.length == charForTest.length
		// if this condition is not met, then java.lang.ArrayIndexOutOfBoundsException
		// may occur
		Integer[] testResultsEven = new Integer[intForTest.length];
		Integer[] testResultsOdd = new Integer[intForTest.length];
		Integer[] testResultsEmpty = new Integer[intForTest.length];

		// Arrays with Expected Results
		Integer[] expectedResultsEvenInt = {0, 1, 1, 2, 3, 4, 5, 7};
		Integer[] expectedResultsOddInt = {0, 0, 0, 2, 3, 4, 6, 6};
		Integer[] expectedResultsEvenChar = {0, 1, 1, 3, 3, 4, 5, 7};
                Integer[] expectedResultsOddChar = {0, 0, 1, 3, 3, 4, 6, 6};
		Integer[] expectedResultsEmpty = {0};


		BinarySearch test = new BinarySearch();

                String result = "FAIL";

		// Test Suite 1: Integers
		System.out.println("Test Suite 1: Integers");
		System.out.format("%23s %11s %4s %4s %4s %n", "ARRAY", "INT", "INDEX", "EXP-RSLT", "PASS/FAIL");

		// Verify for a non-empty array with an Even number of elements
		for (int i=0; i<intForTest.length; i++) {
			result = "FAIL";	// Init to 'FAIL' state
			testResultsEven[i] = test.binarySearch(intArrayEven, intForTest[i]);
			if (testResultsEven[i] == expectedResultsEvenInt[i])
				result = "PASS";
			System.out.format("RESULT: %20s %4d %5d %6d %8s %n", Arrays.toString(intArrayEven), intForTest[i], testResultsEven[i], expectedResultsEvenInt[i], result);
		}

		// Verify for a non-empty array with an Odd number of elements
                for (int i=0; i<intForTest.length; i++) {
			result = "FAIL";	// Init to 'FAIL' state
                        testResultsOdd[i] = test.binarySearch(intArrayOdd, intForTest[i]);
                        if (testResultsOdd[i] == expectedResultsOddInt[i])
                                result = "PASS";
                        System.out.format("RESULT: %20s %4d %5d %6d %8s %n", Arrays.toString(intArrayOdd), intForTest[i], testResultsOdd[i], expectedResultsOddInt[i], result);
                }

		// Verify for an empty array, Note that only one test is necessary to verify adding an element to an empty array
		int verifyEmptyInt = 1;
		result = "FAIL";	// Init to 'FAIL' state
		testResultsEmpty[0] = test.binarySearch(intArrayEmpty, verifyEmptyInt);
		if (testResultsEmpty[0] == expectedResultsEmpty[0])
			result = "PASS";
		System.out.format("RESULT: %20s %4d %5d %6d %8s %n", Arrays.toString(intArrayEmpty), verifyEmptyInt, testResultsEmpty[0], expectedResultsEmpty[0], result);


		// Test Suite 2: Characters
                System.out.println("\n\nTest Suite 2: Characters");
		System.out.format("%23s %11s %4s %4s %4s %n", "ARRAY", "INT", "INDEX", "EXP-RSLT", "PASS/FAIL");

		// Verify for a non-empty array with an Even number of elements
                for (int i=0; i<charForTest.length; i++) {
                        result = "FAIL";        // Init to 'FAIL' state
                        testResultsEven[i] = test.binarySearch(charArrayEven, charForTest[i]);
                        if (testResultsEven[i] == expectedResultsEvenChar[i])
                                result = "PASS";
                        System.out.format("RESULT: %20s %4c %5d %6d %8s %n", Arrays.toString(intArrayEven), charForTest[i], testResultsEven[i], expectedResultsEvenChar[i], result);
                }
                // Verify for a non-empty array with an Odd number of elements
                for (int i=0; i<charForTest.length; i++) {
                        result = "FAIL";        // Init to 'FAIL' state
                        testResultsOdd[i] = test.binarySearch(charArrayOdd, charForTest[i]);
                        if (testResultsOdd[i] == expectedResultsOddChar[i])
                                result = "PASS";
                        System.out.format("RESULT: %20s %4c %5d %6d %8s %n", Arrays.toString(intArrayOdd), charForTest[i], testResultsOdd[i], expectedResultsOddChar[i], result);
                }

                // Verify for an empty array, Note that only one test is necessary to verify adding an element to an empty array
                char verifyEmptyChar = 'A';
                result = "FAIL";        // Init to 'FAIL' state
                testResultsEmpty[0] = test.binarySearch(charArrayEmpty, verifyEmptyChar);
                if (testResultsEmpty[0] == expectedResultsEmpty[0])
                        result = "PASS";
                System.out.format("RESULT: %20s %4c %5d %6d %8s %n", Arrays.toString(charArrayEmpty), verifyEmptyChar, testResultsEmpty[0], expectedResultsEmpty[0], result);
	}
}

class BinarySearch {

	// ---------------------------------------------------------
	public int binarySearch(Comparable[] objArray, Comparable searchObj) {

		int low = 0;
		int high = objArray.length - 1;
		int mid = 0;
		int loc = 0;

		while (low <= high) {
			mid = (low + high) / 2;
			if (objArray[mid].compareTo(searchObj) < 0) {
				low = mid + 1;
				loc = low;
			}
			else if (objArray[mid].compareTo(searchObj) > 0) {
				high = mid - 1;
				loc = high;
			}
			else
				return mid;
		}

		Comparable arrayLength = objArray.length;
		if (objArray.length == 0)
			return 0;
		else
			return loc + 1;
	}
	// ---------------------------------------------------------
}
