//Inderpreet_Singh
//CSCI_381 Project #2
//JDBC GUI For Project#2
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;

public class BIClass {

    private Connection connection; // Class-level variable to hold the connection

    private JTextField serverNameField, portNumberField, databaseNameField, usernameField;
    private JPasswordField passwordField;
    private JFrame loginFrame, commandFrame;
    private JTextArea sqlCommandsArea, resultsArea;

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new BIClass().createAndShowLoginGUI();
        });
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
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                attemptLogin();
            }
        });
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

        String connectionUrl = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";" + "databaseName="
                + databaseName + ";username=" + username + ";password=" + password + ";encrypt=true;trustServerCertificate=true";

        try {
            connection = DriverManager.getConnection(connectionUrl);
            // If the connection is successful, show a message and proceed to the next steps
            JOptionPane.showMessageDialog(loginFrame, "Login successful!", "Success", JOptionPane.INFORMATION_MESSAGE);
            createAndShowCommandGUI();
        } catch (Exception ex) {
            // If an exception occurs, show an error message
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
        executeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                executeSQLCommands();
            }
        });
        panel.add(executeButton, BorderLayout.SOUTH);

        JButton selectFileButton = new JButton("Select File");
        selectFileButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                selectSQLFile();
            }
        });
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

            // Split SQL commands by semicolon
            String[] commands = sqlCommands.split(";");

            for (String command : commands) {
                // Trim leading and trailing whitespaces
                command = command.trim();

                // Skip empty commands
                if (command.isEmpty()) {
                    continue;
                }

                // Display the SQL command in the GUI
                resultsArea.append("Executing: " + command + "\n");

                // Execute the SQL command
                boolean hasResults = stmt.execute(command);

                // Display results if there are any
                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        // Convert ResultSet to 2D Object array for JTable
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();
                        
                        // Dynamic resizing of data array
                        ArrayList<Object[]> dataList = new ArrayList<>();
                        
                        while (rs.next()) {
                            Object[] row = new Object[columnCount];
                            for (int i = 0; i < columnCount; i++) {
                                row[i] = rs.getObject(i + 1);
                            }
                            dataList.add(row);
                        }

                        // Create JTable with the data
                        Object[][] data = dataList.toArray(new Object[0][]);

                        // Create column names array
                        String[] columnNames = new String[columnCount];
                        for (int i = 0; i < columnCount; i++) {
                            columnNames[i] = metaData.getColumnLabel(i + 1);
                        }
                        JTable table = new JTable(data, columnNames);

                        // Display the table in a scroll pane
                        JScrollPane scrollPane = new JScrollPane(table);
                        JOptionPane.showMessageDialog(commandFrame, scrollPane, "Results", JOptionPane.PLAIN_MESSAGE);
                    }
                }
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(commandFrame, "Error executing SQL commands.", "Error", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }
    }
}