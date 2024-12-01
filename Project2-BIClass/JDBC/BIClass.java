//Inderpreet Singh
//CSCI-381
//Project #2
//GUI

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;

public class BIClass {

    private Connection connection; // Class-level variable to hold the connection

    private JTextField serverNameField, portNumberField, databaseNameField, usernameField;
    private JPasswordField passwordField;
    private JFrame loginFrame, commandFrame;
    private JTextArea sqlCommandsArea, resultsArea;

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new BIClass().createAndShowLoginGUI());
    }

    private void createAndShowLoginGUI() {
        loginFrame = new JFrame("Database Login");
        loginFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        loginFrame.setSize(400, 300);

        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout(6, 2));

        panel.add(new JLabel("Server Name:"));
        serverNameField = new JTextField();
        panel.add(serverNameField);

        panel.add(new JLabel("Port Number:"));
        portNumberField = new JTextField();
        panel.add(portNumberField);

        panel.add(new JLabel("Database Name:"));
        databaseNameField = new JTextField();
        panel.add(databaseNameField);

        panel.add(new JLabel("Username:"));
        usernameField = new JTextField();
        panel.add(usernameField);

        panel.add(new JLabel("Password:"));
        passwordField = new JPasswordField();
        panel.add(passwordField);

        JButton loginButton = new JButton("Login");
        loginButton.addActionListener(e -> attemptLogin());
        panel.add(loginButton);

        loginFrame.getContentPane().add(BorderLayout.CENTER, panel);
        loginFrame.setVisible(true);
    }

    private void attemptLogin() {
        String serverName = serverNameField.getText();
        String portNumber = portNumberField.getText();
        String databaseName = databaseNameField.getText();
        String username = usernameField.getText();
        char[] passwordChars = passwordField.getPassword();
        String password = new String(passwordChars);

        String connectionUrl = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";" +
                                "databaseName=" + databaseName + ";" +
                                "user=" + username + ";" +
                                "password=" + password + ";" +
                                "encrypt=true;trustServerCertificate=true";

        try {
            connection = DriverManager.getConnection(connectionUrl);
            JOptionPane.showMessageDialog(loginFrame, "Login successful!", "Success", JOptionPane.INFORMATION_MESSAGE);
            createAndShowCommandGUI();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(loginFrame, "Login failed. Please check your credentials and try again.", "Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void createAndShowCommandGUI() {
        commandFrame = new JFrame("Execute SQL Commands");
        commandFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        commandFrame.setSize(800, 600);

        JPanel panel = new JPanel(new BorderLayout());

        sqlCommandsArea = new JTextArea();
        JScrollPane commandsScrollPane = new JScrollPane(sqlCommandsArea);
        panel.add(commandsScrollPane, BorderLayout.WEST);

        resultsArea = new JTextArea();
        resultsArea.setEditable(false);
        JScrollPane resultsScrollPane = new JScrollPane(resultsArea);
        panel.add(resultsScrollPane, BorderLayout.CENTER);

        JButton executeButton = new JButton("Execute SQL Commands");
        executeButton.addActionListener(e -> executeSQLCommands());
        panel.add(executeButton, BorderLayout.SOUTH);

        JButton selectFileButton = new JButton("Select File");
        selectFileButton.addActionListener(e -> selectSQLFile());
        panel.add(selectFileButton, BorderLayout.NORTH);

        commandFrame.getContentPane().add(BorderLayout.CENTER, panel);
        commandFrame.setVisible(true);
    }

    private void selectSQLFile() {
        JFileChooser fileChooser = new JFileChooser();
        int result = fileChooser.showOpenDialog(commandFrame);

        if (result == JFileChooser.APPROVE_OPTION) {
            File selectedFile = fileChooser.getSelectedFile();

            try (BufferedReader fileReader = new BufferedReader(new FileReader(selectedFile))) {
                StringBuilder fileContents = new StringBuilder();
                String line;
                while ((line = fileReader.readLine()) != null) {
                    fileContents.append(line).append("\n");
                }
                sqlCommandsArea.setText(fileContents.toString());
            } catch (IOException e) {
                JOptionPane.showMessageDialog(commandFrame, "Error reading SQL file.", "Error", JOptionPane.ERROR_MESSAGE);
                e.printStackTrace();
            }
        }
    }

    private void executeSQLCommands() {
        try (Statement stmt = connection.createStatement()) {
            String sqlCommands = sqlCommandsArea.getText();

            // Split SQL commands by "GO" (case insensitive)
            String[] commands = sqlCommands.split("(?i)\\bGO\\b");

            for (String command : commands) {
                command = command.trim();

                if (command.isEmpty()) {
                    continue;
                }

                long startTime = System.currentTimeMillis(); // Start timing execution
                resultsArea.append("Executing: " + command + "\n");

                try {
                    boolean hasResults = stmt.execute(command);

                    if (hasResults) {
                        // If the command returns a ResultSet, display it in a JTable
                        try (ResultSet rs = stmt.getResultSet()) {
                            if (rs != null && rs.isBeforeFirst()) { // Check if the ResultSet is not empty
                                displayResultsInTable(rs);
                            } else {
                                resultsArea.append("Query executed, but no results to display.\n");
                            }
                        }
                    } else {
                        // Handle non-ResultSet commands like INSERT, UPDATE, DELETE, or DDL
                        int updateCount = stmt.getUpdateCount();
                        long executionTime = System.currentTimeMillis() - startTime; // Calculate execution time
                        resultsArea.append("Command executed successfully.\n");
                        JOptionPane.showMessageDialog(commandFrame, "Command executed successfully!\n" +
                                "Rows affected: " + updateCount + "\n" +
                                "Execution time: " + executionTime + " ms", "Execution Result", JOptionPane.INFORMATION_MESSAGE);
                    }
                } catch (Exception innerEx) {
                    resultsArea.append("Error executing command: " + innerEx.getMessage() + "\n");
                    innerEx.printStackTrace();
                }
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(commandFrame, "Error executing SQL commands.", "Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }

    private void displayResultsInTable(ResultSet rs) throws Exception {
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        // Extract column names
        String[] columnNames = new String[columnCount];
        for (int i = 0; i < columnCount; i++) {
            columnNames[i] = metaData.getColumnLabel(i + 1);
        }

        // Extract data rows
        ArrayList<Object[]> data = new ArrayList<>();
        while (rs.next()) {
            Object[] row = new Object[columnCount];
            for (int i = 0; i < columnCount; i++) {
                row[i] = rs.getObject(i + 1);
            }
            data.add(row);
        }

        // If no rows, inform the user
        if (data.isEmpty()) {
            JOptionPane.showMessageDialog(commandFrame, "Query executed, but no data found.", "Information", JOptionPane.INFORMATION_MESSAGE);
            return;
        }

        // Create and display JTable
        JTable table = new JTable(new DefaultTableModel(data.toArray(new Object[0][]), columnNames));
        JScrollPane scrollPane = new JScrollPane(table);

        JDialog tableDialog = new JDialog(commandFrame, "Query Results", true);
        tableDialog.getContentPane().add(scrollPane);
        tableDialog.setSize(800, 400);
        tableDialog.setLocationRelativeTo(commandFrame);
        tableDialog.setVisible(true);
    }
}
