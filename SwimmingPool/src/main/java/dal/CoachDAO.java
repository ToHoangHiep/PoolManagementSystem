package dal;

import model.Coach;
import java.sql.*;
import java.util.*;

public class CoachDAO {
    private Connection conn;

    public CoachDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Coach> getAllCoaches() throws SQLException {
        List<Coach> list = new ArrayList<>();
        String sql = "SELECT * FROM Coaches";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Coach c = new Coach();
                c.setId(rs.getInt("id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setPhoneNumber(rs.getString("phone_number"));
                c.setGender(rs.getString("gender"));
                c.setBio(rs.getString("bio"));
                c.setProfilePicture(rs.getString("profile_picture"));
                list.add(c);
            }
        }
        return list;
    }
}