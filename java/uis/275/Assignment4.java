// Robert Bobkoskie
// CSC 275 Online Assignment 4 Solution
// ID: 14081 Jul 18 11:03 Assignment4.java
//
// Compiled and verified on System:
//	java -version
//	java version "1.7.0_25"
//	Java(TM) SE Runtime Environment (build 1.7.0_25-b17)
//	Java HotSpot(TM) Client VM (build 23.25-b01, mixed mode)

import java.util.*;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.event.*;


public class Assignment4 {
	public static void main(String[] args) {
		new mainGuiWindow("MAIN GUI");
	}
}


class mainGuiWindow extends JFrame implements ActionListener, ListSelectionListener {
	// Init serialVersionUID to account for compilation warning:
	// javac Assignment4.java -Xlint
	// Assignment4.java:26: warning: [serial] serializable class mainGuiWindow has no definition of
	// serialVersionUID class mainGuiWindow extends JFrame  implements ActionListener, ListSelectionListener {
	private static final long serialVersionUID = 1000001;

	// panels
	private JPanel scrollPanel = new JPanel();
	private JPanel btnPanel = new JPanel();

	// components
	private JButton addButton = new JButton("Add");
	private JButton removeButton = new JButton("Remove");
	private JButton searchButton = new JButton("Search");
	private JButton closeButton = new JButton("Close");
	private JButton helpButton = new JButton("Help");
	private JTextField removeField;
	private JScrollPane scrollPane = new JScrollPane();

	// JList
	DefaultListModel<String> flowerList = new DefaultListModel<String>();
	JList<String> jListFlower  = new JList<String>(flowerList);

	// Constructor
	mainGuiWindow (String title) {

		// Define layout
		scrollPanel.setLayout(new BoxLayout(scrollPanel, BoxLayout.Y_AXIS));
		btnPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));

		// Register listener object with jListFlower
		jListFlower.addListSelectionListener(this);

		// Init an example
		// flowerList.addElement("Chrysanthemum");

		// Add jListFlower to a scrollpane, and add scrollpane to scrollPanel
		scrollPane.getViewport().add(jListFlower);
		scrollPanel.add(scrollPane, BorderLayout.CENTER);

		// Register listener object with buttons as an event listeners
		addButton.addActionListener(this);
		removeButton.addActionListener(this);
		searchButton.addActionListener(this);
		closeButton.addActionListener(this);
		helpButton.addActionListener(this);

		// Add buttons to btnPanel
		btnPanel.add(addButton);
		btnPanel.add(removeButton);
		btnPanel.add(searchButton);
		btnPanel.add(closeButton);
		btnPanel.add(helpButton);

		// frame
		add(BorderLayout.NORTH, scrollPanel);
		add(BorderLayout.SOUTH, btnPanel);
		setTitle(title);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setSize(600, 200);
		// setLocationRelativeTo(null);	// Set location in the center of the screen
		setLocationByPlatform(true);	// Sets whether this Window should appear at the default location for
						// the native windowing system or at the current location
						// (returned by getLocation) the next time the Window is made visible.
		setVisible(true);
		setResizable(false);

	}

	public void actionPerformed(ActionEvent e) {
		Object source = e.getSource();

		if (source == addButton) {
			String flower = getFlower();
			if (flower != null) {
				flowerList.addElement(flower);
				scrollPane.revalidate();
				scrollPane.repaint();
			}

		} else if (source == removeButton) {
			// Get the current selection
			int selection = jListFlower.getSelectedIndex();
			if(selection >= 0) {

				// Add this item to the list and refresh
				flowerList.removeElementAt(selection);
				scrollPane.revalidate();
				scrollPane.repaint();

				// Select (highlight) the next 'selection' in the list for removal
				if(selection >= flowerList.size())
					selection = flowerList.size() - 1;
					jListFlower.setSelectedIndex(selection);
			}

		} else if (source == searchButton) {
			new searchGuiWindow(this, "SEARCH GUI", jListFlower);

		} else if (source == closeButton) {
			setVisible(false);
			dispose();

		} else if (source == helpButton) {
			new helpGuiWindow(this, "HELP GUI");
		}
	}

	// Need this method signature to impliment ListSelectionListener 
	public void valueChanged(ListSelectionEvent event) {

	}

	public String getFlower() {
		String flowerName = "";
		while (flowerName.length() < 1) {
			// flowerName = JOptionPane.showInputDialog(null, "Enter Flower Name");	// Can use this JOptionPane method
												// to return the String value

			// JOptionPane with custom title
			flowerName = JOptionPane.showInputDialog(null,
					"Enter Flower Name",
					"Input String",
					JOptionPane.QUESTION_MESSAGE);

			if (flowerName == null)
				break;
		}
		return flowerName;
	}
}


class searchGuiWindow extends JDialog implements ActionListener {
	// Init serialVersionUID to account for compilation warning:
	// javac Assignment4.java -Xlint
	// Assignment4.java:26: warning: [serial] serializable class mainGuiWindow has no definition of
	// serialVersionUID class mainGuiWindow extends JFrame  implements ActionListener, ListSelectionListener {
	private static final long serialVersionUID = 1000011;

	// panels
	private JPanel panel = new JPanel();
	private JPanel btnPanel = new JPanel();

	// components
	private JButton searchButton = new JButton("Run Search");
	private JButton closeButton = new JButton("Cancel");
	private JTextArea displayTextArea = new JTextArea(10, 40);
	private JTextField searchTextField = new JTextField(30);
	private JScrollPane scrollPane = new JScrollPane(displayTextArea);
	JLabel searchLabel = new JLabel("String: ");

	// JList
	private JList<String> jListFlower;

	// Constructor
	searchGuiWindow (JFrame parent, String title, JList<String> jlist) {

		super (parent, true);		// Dialog box — A top-level pop-up window with a title
						// and a border that typically takes some form of input from the user.
						// A dialog box can be modal or modeless. For more information about dialog boxes,
						// see An Overview of Dialogs in the How to Make Dialogs page.
						// Modal dialog box — A dialog box that blocks input to some other top-level windows
						// in the application, except for windows created with the dialog box as their owner.
						// The modal dialog box captures the window focus until it is closed, usually in
						// response to a button press.
						// super --- Correlates child JDialog window with the Parent JFrame
						// If not used, multiple child windows can be opeened
		jListFlower = jlist;

		// Define layout
		panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
		btnPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		searchLabel.setLabelFor(searchTextField);

 		// Define JTextArea
        	displayTextArea.setWrapStyleWord(true);
        	displayTextArea.setEditable(false);

		// Define scrollPane
		scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

		// Register listener object with buttons as an event listeners
		searchButton.addActionListener(this);
		closeButton.addActionListener(this);

		// Add components to btnPanel
		btnPanel.add(searchLabel);
		btnPanel.add(searchTextField);
		btnPanel.add(searchButton);
		btnPanel.add(closeButton);

		// Add scrollPane and btnPanel to panel
		panel.add(scrollPane);
		panel.add(btnPanel);

		// frame
		add(BorderLayout.CENTER, panel);
		setTitle(title);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		pack();
		// setSize(600, 200);
		// setLocationRelativeTo(null);	// Set location in the center of the screen
		// setLocationByPlatform(true);	// Sets whether this Window should appear at the default location for
						// the native windowing system or at the current location
						// (returned by getLocation) the next time the Window is made visible.

		// Define search Window location based on parent window
		if (parent != null) {
			Dimension parentSize = parent.getSize();
			Point p = parent.getLocation();
			setLocation(p.x + 5 , p.y + parentSize.height-35);
		}
		setVisible(true);
		setResizable(false);

	}

	public void actionPerformed(ActionEvent e) {
		Object source = e.getSource();
		if (source == searchButton) {

			boolean found = false;
			displayTextArea.setText(null);
			displayTextArea.append("---- Search Result ----\n");

			if (searchTextField.getText().length() > 0) {
				for (int i = 0; i < jListFlower.getModel().getSize(); i++) {
					String str = jListFlower.getModel().getElementAt(i).toString();
					if (str.toLowerCase().contains(searchTextField.getText().toLowerCase())) {
						displayTextArea.append(str + "\n");
						// System.out.println(str + "\n");	// DEBUG, print result to console
						found = true;
					}
				}
			searchTextField.setText(null);
			}

			if (!found)
				displayTextArea.append("<No flowers found containing the string \"" + searchTextField.getText() + "\">");

		} else if (source == closeButton) {
			setVisible(false);
			dispose();
		}
	}
}


class helpGuiWindow extends JDialog implements ActionListener {
	// Init serialVersionUID to account for compilation warning:
	// javac Assignment4.java -Xlint
	// Assignment4.java:26: warning: [serial] serializable class mainGuiWindow has no definition of
	// serialVersionUID class mainGuiWindow extends JFrame  implements ActionListener, ListSelectionListener {
	private static final long serialVersionUID = 1000100;

	// panels
	private JPanel panel = new JPanel();
	private JPanel btnPanel = new JPanel();

	// components
	private JButton searchButton = new JButton("HELP Searching Flowers");
	private JButton addButton = new JButton("Help Adding Flowers");
	private JButton removeButton = new JButton("HELP Removing Flowers");
	private JButton closeButton = new JButton("Cancel");
	private JTextArea displayTextArea = new JTextArea(10, 40);
	private JScrollPane scrollPane = new JScrollPane(displayTextArea);
	JLabel searchLabel = new JLabel("For Help Click: ");


	// Constructor
	helpGuiWindow (JFrame parent, String title) {

		super (parent, true);		// Dialog box — A top-level pop-up window with a title
						// and a border that typically takes some form of input from the user.
						// A dialog box can be modal or modeless. For more information about dialog boxes,
						// see An Overview of Dialogs in the How to Make Dialogs page.
						// Modal dialog box — A dialog box that blocks input to some other top-level windows
						// in the application, except for windows created with the dialog box as their owner.
						// The modal dialog box captures the window focus until it is closed, usually in
						// response to a button press.
						// super --- Correlates child JDialog window with the Parent JFrame
						// If not used, multiple child windows can be opeened

		// Define layout
		panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
		btnPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		searchLabel.setLabelFor(btnPanel);

 		// Define JTextArea
        	displayTextArea.setWrapStyleWord(true);
        	displayTextArea.setEditable(false);

		// Define scrollPane
		scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

		// Register listener object with buttons as an event listeners
		searchButton.addActionListener(this);
		addButton.addActionListener(this);
		removeButton.addActionListener(this);
		closeButton.addActionListener(this);

		// Add components to btnPanel
		btnPanel.add(searchLabel);
		btnPanel.add(searchButton);
		btnPanel.add(addButton);
		btnPanel.add(removeButton);
		btnPanel.add(closeButton);

		// Add scrollPane and btnPanel to panel
		panel.add(scrollPane);
		panel.add(btnPanel);

		// frame
		add(BorderLayout.CENTER, panel);
		setTitle(title);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		pack();
		// setSize(600, 200);
		// setLocationRelativeTo(null);	// Set location in the center of the screen
		// setLocationByPlatform(true);	// Sets whether this Window should appear at the default location for
						// the native windowing system or at the current location
						// (returned by getLocation) the next time the Window is made visible.

		// Define search Window location based on parent window
		if (parent != null) {
			Dimension parentSize = parent.getSize();
			Point p = parent.getLocation();
			setLocation(p.x + 5 , p.y + parentSize.height-35);
		}
		setVisible(true);
		setResizable(false);

	}

	public void actionPerformed(ActionEvent e) {
		Object source = e.getSource();
		if (source == searchButton) {
			displayTextArea.setText(null);
			displayTextArea.append("From the MAIN GUI Window:\n\n");
			displayTextArea.append(" 1. Click Search\n");
			displayTextArea.append("  - From the SEARCH GUI Window:\n");
			displayTextArea.append("  - Add a String in the text field, and click Run Search");

		} else if (source == addButton) {
			displayTextArea.setText(null);
			displayTextArea.append("From the MAIN GUI Window:\n\n");
			displayTextArea.append(" 1. Click Add\n");
			displayTextArea.append("  - From the popup Window:\n");
			displayTextArea.append("  - Add a flower in the text field, and click OK");

		} else if (source == removeButton) {
			displayTextArea.setText(null);
			displayTextArea.append("From the MAIN GUI Window:\n\n");
			displayTextArea.append(" 1. Secect a flower to remove by:\n");
			displayTextArea.append("  - Highlighting an entry in the text area by clicking on it\n");
			displayTextArea.append("  - Click Remove\n");

		} else if (source == closeButton) {
			setVisible(false);
			dispose();
		}
	}
}