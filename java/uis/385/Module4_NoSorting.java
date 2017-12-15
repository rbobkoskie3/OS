// Robert Bobkoskie
// ID: rb868x 2797 Mar 19 19:14 Module4_NoSorting.java
//
// Compiled and verified on System:
//      java -version
//      java version "1.6.0_26"
//      cat /etc/redhat-release
//      Red Hat Enterprise Linux Server release 5.6 (Tikanga)

import java.util.*;

public class Module4_NoSorting {

	public static void main(String[] args) {

		// Test Data, Assume Data sets do NOT have duplicate elements.
		// Note that sets do not need to be sorted
                String[] strArray001 = {"0001", "0011", "0111", "1111", "0110", "1001"};
                String[] strArray002 = {"0001", "0011", "0111", "1111", "0110", "1001"};
		String[] strArray004 = {"0001", "0011", "0111", "1111", "0110", "1001"};
		// String[] strArray003 = {"1111", "1110", "0010", "0000"};
		// String[] strArray003 = {"0000", "0011", "1111", "0000"};
		String[] strArray003 = {"0001", "0011", "0111", "1111", "0110", "1001"};
                Object[] objArray = {strArray001, strArray002, strArray003, strArray004};

		// Instansiate CommonElements and call findCommonElements and getComparisons methods
		CommonElements algo = new CommonElements();
		Comparable[] showCommon = algo.findCommonElements(objArray);
		System.out.println("Common Elements");
		for (int i = 0; i < showCommon.length; i++) {
			if (showCommon[i] != null)
				System.out.println(showCommon[i]);
		}
		System.out.println("Number of Comparisons: " + algo.getComparisons());

	}
}

class CommonElements {

	private int comparisons = 0;
	private int numCommon = 0;

	public int getComparisons() {
		return comparisons;
	}

	public Comparable[] findCommonElements (Object[] collections) {

		String[] queryCollection = (String[])collections[0];
		ArrayList<String> queryAgainst = new ArrayList<String>();
		Comparable[] common = new Comparable[100];

		// Find the smallest Collection --- to use as the 'query' Collection
		comparisons +=1;
		for (int i = 0; i < collections.length; i++) {
			comparisons +=1;
			String[] compare = (String[])collections[i];
			if (compare.length <= queryCollection.length) {
				comparisons +=1;
				queryCollection = compare;
			}
			// Create an ArrayList to hold all the Elements passed in.
			queryAgainst.addAll(Arrays.asList(compare));

		}

		// Search the ArrayList looking for matches in all N Collections
		comparisons +=1;
		for (int i = 0; i < queryCollection.length; i++) {
			numCommon = 0;
			comparisons +=1;
			for (int j = 0; j < queryAgainst.size(); j++) {
				comparisons +=1;
				// System.out.println("queryAgainst.get(j) "+ queryAgainst.get(j));   //DEBUG
				if (queryCollection[i] == queryAgainst.get(j)) {
					comparisons +=1;
					numCommon +=1;
				}
			}
			if (numCommon == collections.length) {
				common[i] = queryCollection[i];
			}
		}

		return common;
	}
}
