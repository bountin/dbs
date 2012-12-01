package dbs_ws12;

import java.sql.*;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario3 {

    private Connection connection = null;

    public static void main(String[] args) {
        if (args.length <= 5 && args.length >= 3) {
            /*
             * args[1] ... server, 
             * args[2] ... port,
             * args[3] ... database, 
             * args[4] ... username, 
             * args[5] ... password
             */

            Connection conn = null;

            if (args.length == 3) {
                conn = DBConnector.getConnection(args[0], args[1], args[2]);
            } 
            else {
                if (args.length == 4) {
                    conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], "");
                } 
                else {
                    conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], args[4]);
                }
            }

            if (conn != null) {
                Szenario3 s = new Szenario3(conn);

                s.run();
            }

        } 
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

    public Szenario3(Connection connection) {
        this.connection = connection;
    }

    public void run() {
        inflationsAusgleich(0.025);
    }

    /*
     * Beschreibung siehe Angabe
     */
    public void inflationsAusgleich(double inflation) {
        Statement stmt = null;
        PreparedStatement pstmt = null;

        /* Fuegen Sie hier Ihren Code fuer die Loesung ein! */
    }
}
