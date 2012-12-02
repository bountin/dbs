package dbs_ws12;

import java.sql.*;
import java.math.BigDecimal;
import java.util.Scanner;
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

	    try {
		    connection.setAutoCommit(false);

		    // 1.: Alle Personen befördern, die bereits seit 2 Jahren dabei sind
		    CallableStatement cs = connection.prepareCall("{call p_erhoehe_dienstgrad(?}");
		    cs.setInt(1, 2);

		    // 2.: PreparedStatement für Erhöhung des Gehalts eines Dienstgrades
		    pstmt = connection.prepareStatement("UPDATE dienstgrad SET basisgehalt = ? WHERE id = ?");

		    // 3.: Inflationserhöhung
		    Statement stmt2 = connection.createStatement();
		    ResultSet rs2 = stmt2.executeQuery("SELECT id, basisgehalt FROM dienstgrad");
		    while (rs2.next()) {
			    double gehalt = rs2.getDouble("basisgehalt");
			    double percentage = inflation;
			    if (gehalt < 750)
				    percentage *= 2.5;
			    else if (gehalt < 1250)
				    percentage *= 2.0;
			    else if (gehalt < 1750)
				    percentage *= 1.5;
			    else if (gehalt > 5000)
				    percentage *= 0.5;
			    else
			        percentage *= 1;

			    pstmt.setInt(2, rs2.getInt("id"));
			    pstmt.setDouble(1, gehalt * (1 + percentage));
		    }

		    // 4.: Resultate anzeigen
		    Statement stmt4 = connection.createStatement();
		    ResultSet rs4 = stmt4.executeQuery(
			    "SELECT p.id, vorname, nachname, basisgehalt + f_bonus(p.id)\n" +
			    "FROM person p\n" +
			    "JOIN dienstgrad d ON p.dienstgrad = d.id\n" +
			    "ORDER BY 1"
		    );

		    System.out.printf("%5s %30s %30s %8s\n", "ID", "Vorname", "Nachname", "Gehalt");
		    System.out.println("----------------------------------------------------------------------------");
		    while (rs4.next()) {
			    System.out.printf("%5d %30s %30s %8.2f\n", rs4.getInt(1), rs4.getString(2), rs4.getString(3), rs4.getDouble(4));
		    }

		    connection.rollback();
	    } catch (SQLException e) {
		    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
	    }
    }
}
