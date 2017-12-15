// Robert Bobkoskie
// CSC 275 Online Lab 5 Solution
// ID: 5313 Jul 17 15:25 Lab05gUI_NW.java
//
// Compiled and verified on System:
//	java -version
//	java version "1.7.0_25"
//	Java(TM) SE Runtime Environment (build 1.7.0_25-b17)
//	Java HotSpot(TM) Client VM (build 23.25-b01, mixed mode)


import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.event.*;

import java.util.*;


public class Lab05gUI_NW extends JFrame {

	// panels
	private JPanel buttonPanel = new JPanel();
	private JPanel textPanel = new JPanel();

	// components
	JButton closeButton = new JButton("Close");
	JButton addCourseButton = new JButton("Add Course");
	JButton displayAllButton = new JButton("Display All To Console");
	static JTextField enterField = new JTextField("COURSE NAME - PRESS <ENTER>");
	static JTextArea displayField = new JTextArea(10, 40);
	static JScrollPane scrollPane = new JScrollPane(displayField);

	// ArrayList<String>, and associated methods are used to debug, e.g.,
	// output courses to console
	private static ArrayList<String> courseList = new ArrayList<String>();

	public Lab05gUI_NW(String title) {	// String title added to make Constructor signature unique
		setTitle(title);
	}

	public Lab05gUI_NW() {
		// Define layout
		textPanel.setLayout(new BoxLayout(textPanel, BoxLayout.Y_AXIS));
		buttonPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		//scrollPane.getViewport().add(displayField);

		// Define JTextArea
        	displayField.setWrapStyleWord(true);
        	displayField.setEditable(false);

		// Define scrollPane
		scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

		// add components to panels
		buttonPanel.add(addCourseButton);
		buttonPanel.add(closeButton);
		textPanel.add(scrollPane);

		// JFrame properties
		add(buttonPanel, BorderLayout.SOUTH);
		add(textPanel, BorderLayout.NORTH);

		setSize(400, 300);
		setTitle("Lab05 GUI");
		setLocationRelativeTo(null);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setVisible(true);
	}

	public static void setCourseList(String course) {
		courseList.add(course);
	}

	public static int getCourseListLength() {
		return courseList.size();
	}

	public static String getCourseList(int i) {
		return courseList.get(i);
	}

	public static void removeCourse(int i) {
		courseList.remove(i);
	}

	public void setJframe() {
		setSize(400, 200);
		// setLocationRelativeTo(null);
		setLocation(800, 400);	// Locate this frame off the main frame
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	public void setAddFrame() {
		setLayout(new BorderLayout());
		buttonPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		buttonPanel.add(displayAllButton);
		buttonPanel.add(closeButton);
		add(buttonPanel, BorderLayout.SOUTH);

		textPanel.add(enterField);
		add(textPanel, BorderLayout.NORTH);
	}

	public void setVis() {
		setVisible(true);
	}


	public static void main(String[] args) {
		Lab05gUI_NW myCourses = new Lab05gUI_NW();

		HandleEvents.ButtonHandlerAddCourses addCourses = new HandleEvents.ButtonHandlerAddCourses();
		myCourses.addCourseButton.addActionListener(addCourses);

		HandleEvents.ButtonHandlerClose close = new HandleEvents.ButtonHandlerClose();
		myCourses.closeButton.addActionListener(close);
	}
}

class HandleEvents {

	public static class TextHandler implements ActionListener {	// TextHandler will display added course real time in Display window
		public void actionPerformed(ActionEvent e) {
			Lab05gUI_NW.setCourseList(Lab05gUI_NW.enterField.getText());
			Lab05gUI_NW.displayField.append(Lab05gUI_NW.enterField.getText() + "\n");
			Lab05gUI_NW.scrollPane.revalidate();
			Lab05gUI_NW.scrollPane.repaint();
			Lab05gUI_NW.enterField.setText(null);
		}
	}

	// This methos is only for for Debugging, e.g., print courseList to console
	public static class ButtonHandlerDisplayAll implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			String courseList = null;
			StringBuilder result = new StringBuilder();

			for (int i = 0; i < Lab05gUI_NW.getCourseListLength(); i++) {
				result.append(Lab05gUI_NW.getCourseList(i)).append("\n");
			}
			courseList = result.toString();
			// System.out.println(courseList);	// For debugging, e.g., print courseList to console
		}
	}
	
	public static class ButtonHandlerClose implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			System.exit(0);
		}
	}

	public static class ButtonHandlerAddCourses implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			Lab05gUI_NW newFrame = new Lab05gUI_NW("Add Course");
			newFrame.setJframe();
			newFrame.setAddFrame();
			newFrame.setVis();

			ButtonHandlerDisplayAll displayAll = new ButtonHandlerDisplayAll();
			newFrame.displayAllButton.addActionListener(displayAll);

			TextHandler text = new TextHandler();
			Lab05gUI_NW.enterField.addActionListener(text);

			HandleEvents.ButtonHandlerClose close = new HandleEvents.ButtonHandlerClose();
			newFrame.closeButton.addActionListener(close);
		}
	}
}