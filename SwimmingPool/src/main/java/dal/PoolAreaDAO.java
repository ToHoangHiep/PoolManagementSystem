package dal;

import model.PoolArea;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PoolAreaDAO {
    private Connection connection;

    public PoolAreaDAO(Connection connection) {
        this.connection = connection;
    }

    public List<PoolArea> getAll() throws SQLException {
        List<PoolArea> list = new ArrayList<>();
        String sql = "SELECT * FROM Pool_Area";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PoolArea area = new PoolArea(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description")
                );
                list.add(area);
            }
        }
        return list;
    }

    public void insert(PoolArea poolArea) throws SQLException {
        String sql = "INSERT INTO Pool_Area (name, description) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, poolArea.getName());
            stmt.setString(2, poolArea.getDescription());
            stmt.executeUpdate();
        }
    }

    public boolean isInUse(int id) throws SQLException {
        String sql = "SELECT COUNT(*) FROM maintenance_log WHERE pool_area_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }


    public void deleteById(int id) throws SQLException {
        String sql = "DELETE FROM Pool_Area WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
