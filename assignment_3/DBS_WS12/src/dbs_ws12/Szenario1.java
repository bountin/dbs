package dbs_ws12;

import java.sql.*;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario1 {

    private Connection connection = null;

    public static void main(String[] args) {
        if (args.length <= 6 && args.length >= 4) {
            /*
             * args[0] ... type -> [a|b],
             * args[1] ... server,
             * args[2] ... port,
             * args[3] ... database,
             * args[4] ... username,
             * args[5] ... password
             */

            Connection conn = null;

            if (args.length == 4) {
                conn = DBConnector.getConnection(args[1], args[2], args[3]);
            }
            else {
                if (args.length == 5) {
                    conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], "");
                }
                else {
                    conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], args[5]);
                }
            }

            if (conn != null) {
                Szenario1 s = new Szenario1(conn);

                if (args[0].equals("a")) {
                    s.runTransactionA();
                }
                else {
                    s.runTransactionB();
                }
            }
        }
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

    public Szenario1(Connection connection) {
        this.connection = connection;
    }

    /*
     * Beschreibung siehe Angabe
     */
    public void runTransactionA() {
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");
        /*
         * ################################################################################
         */

        System.out.println("Transaktion A Start");

        /*
         * Setzen Sie das aus Ihrer Sicht passende Isolation-Level:
         */

	    try {
		    connection.setAutoCommit(false);
		    connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);

	    /*
		 * Abfrage 1:
		 * Ermitteln Sie das Durchschnittsalter jener Personen, welche
		 * zumindest an einem der letzten drei Wettkaempfe teilgenommen
		 * haben und geben Sie dieses auf der Konsole aus.
		 */

			Statement stmt1 = connection.createStatement();

		    ResultSet rs1 = stmt1.executeQuery(
			    "WITH personen(id) AS (\n" +
			    "        SELECT DISTINCT pwk.person_id\n" +
			    "        FROM wettkampf_teilnahme wkt\n" +
			    "        JOIN pers_wktruppe pwk ON pwk.wktruppe_id = wkt.wktruppe_id\n" +
			    "        WHERE wkt.wettkampf_id IN (\n" +
			    "                SELECT id\n" +
			    "                FROM wettkampf\n" +
			    "                ORDER BY bis DESC\n" +
			    "                LIMIT 3\n" +
			    "        )\n" +
			    ")\n" +
			    "SELECT avg(age(geburtstag)), EXTRACT( EPOCH FROM avg(age(geburtstag)) )\n" +
			    "FROM person\n" +
			    "WHERE id IN (SELECT * FROM personen);"
		    );

		    rs1.next();
		    System.out.println("\tAVG 1: " + rs1.getString(1));
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        wait("Druecken Sie <ENTER> zum Fortfahren ...");
        /*
         * ################################################################################
         */

        /*
         * Abfrage 2:
         * Ermitteln Sie das Durschnittsalter aller
         * Personen und geben Sie dieses auf der der Konsole aus.
         */

		    Statement stmt2 = connection.createStatement();

		    ResultSet rs2 = stmt2.executeQuery(
			    "SELECT avg(age(geburtstag)), EXTRACT( EPOCH FROM avg(age(geburtstag)) )\n" +
			    "FROM person;"
		    );

		    rs2.next();
		    System.out.println("\tAVG 2: " + rs2.getString(1));

        /*
         * Geben Sie das Verhaeltnis der beiden abgefragten Werte aus
         */

		    System.out.println("\tVerhältnis: " + rs2.getDouble(2) / rs1.getDouble(2));

        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
        /*
         * ################################################################################
         */

        /*
         * Beenden Sie die Transaktion
         */

	    } catch (SQLException e) {
		    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
	    }

        System.out.println("Transaktion A Ende");
    }

    public void runTransactionB() {
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");

        System.out.println("Transaktion B Start");

        try {
            Statement stmt = connection.createStatement();

            stmt.executeUpdate("INSERT INTO Person (id, Vorname, Nachname, Geburtstag, Beitrittstag, " +
                               "Telefon, Dienstgrad, Dienstgrad_aenderung, Mannschaft) VALUES (" +
                               "10, 'Samuel', 'Sanchez', '1954-07-23', current_date, " +
                               "'993248', 4, current_date, 30);");

            stmt.close();

            System.out.println("Eine Person wurde hinzugefuegt ...");

            wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");

            connection.commit();
        }
        catch (SQLException ex) {
            Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
        }

        System.out.println("Transaktion B Ende");
        /*
         * ################################################################################
         */
    }

    private static void wait(String message) {
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        Scanner s = new Scanner(System.in);
        try {
            System.out.println(message);
            s.nextLine();
        }
        catch (Exception ex) {
            Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
        }
        /*
         * ################################################################################
         */
    }
}
