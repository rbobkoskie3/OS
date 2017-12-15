// Robert Bobkoskie
// CSC 275 Online Lab 5 Solution
// ID: 2776 Jul 17 11:21 Lab05gUI.java
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

public class Lab05gUI  extends JFrame  implements ActionListener, ListSelectionListener {

	// panels
	private JPanel panel = new JPanel();
	private JPanel btnPanel = new JPanel();

	// buttons
	private JButton addButton = new JButton("Add Course");
	private JButton closeButton = new JButton("Close");

	// JList
	private Vector<String> listData = new Vector <String>();
	private JList<String> listbox  = new JList <String>(listData);
	private JScrollPane scrollPane = new JScrollPane();
	private JTextField dataField;


	Lab05gUI (String title) {

		// create panels
		panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
		btnPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));

		// Create the data model and listbox for courses
		listbox.addListSelectionListener(this);

		// Init an example
		listData.addElement("Math");
		listbox.setListData(listData);

		// Add the listbox to a scrolling pane
		scrollPane.getViewport().add(listbox);
		panel.add(scrollPane, BorderLayout.CENTER);

		// Add buttons to btnPanel
		addButton.addActionListener(this);
		closeButton.addActionListener(this);
		btnPanel.add(addButton);
		btnPanel.add(closeButton);

		panel.add(btnPanel);

		// frame
		this.getContentPane().add(BorderLayout.CENTER, panel);
		this.setTitle(title);
		this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		this.setSize(600, 200);
		this.setLocationByPlatform(true);
		this.setVisible(true);
		this.setResizable(false);

	}

	public void actionPerformed(ActionEvent e) {
		Object source = e.getSource();
		if (source == addButton) {
			String course = addCourseDialog();
			if (course != null) {
				listData.addElement(course);
				listbox.setListData(listData);
				scrollPane.revalidate();
				scrollPane.repaint();
			}

		} else if (source == closeButton) {
			setVisible(false);
			dispose();
		}
	}

	// Need this method signature to impliment ListSelectionListener 
	public void valueChanged(ListSelectionEvent event) {

	}

	public String addCourseDialog() {
		String fullName = "";

		while (fullName.length() < 1) {
			fullName = JOptionPane.showInputDialog(null, "Enter course name: ");
			if (fullName == null)
				break;
		}
		return fullName;
	}

	public static void main(String[] args) {
		new Lab05gUI("Lab05 GUI");
	}

}