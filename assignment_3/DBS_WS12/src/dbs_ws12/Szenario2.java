package dbs_ws12;

import java.sql.*;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario2 {

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
                Szenario2 s = new Szenario2(conn);

                if (args[0].equals("a")) {
                    s.runTransactionA();
                } else {
                    s.runTransactionB();
                }
            }

        } 
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

    public Szenario2(Connection connection) {
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

        /*
         * Abfrage 1:
         * Ermitteln Sie Typ, Ort und die Anzahl betroffener Personen 
         * aller Einsaetze, bei denen die Mannschaft mit der ID 10 
         * beteiligt war und sortieren Sie das Ergebnis nach Anzahl
         * der betroffenden Personen in absteigender Reihenfolge. 
         * Geben Sie alle Daten auf der Konsole aus.
         */
            
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
         * Ermitteln Sie zu jedem Typ ('Brand', 'Unfall', 'Hochwasser' oder 'Sonstiges', 
         * zu dem bereits ein Ereignis gespeichert wurde, aus, wie viele Ereignisse es
         * von diesem Typ bereits gab und sortieren Sie das Ergebnis nach der Summe 
         * der Ereignisse absteigend. Geben Sie alle Daten auf der Konsole aus.
         */
            
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

            stmt.executeUpdate("INSERT INTO Ereignis (Zeitpunkt, Ort, Typ, AnzBPers) " +
                               "VALUES ('2012-06-15 19:02', 'Hauptstrasse 18', " +
                               "'Brand', 10 )");

            stmt.close();
            
            System.out.println("Ein Ereignis wurde hinzugefuegt ...");
            
            wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");

            connection.commit();
        } 
        catch (SQLException ex) {
            Logger.getLogger(Szenario2.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(Szenario2.class.getName()).log(Level.SEVERE, null, ex);
        }
        /*
         * ################################################################################
         */
    }
}
