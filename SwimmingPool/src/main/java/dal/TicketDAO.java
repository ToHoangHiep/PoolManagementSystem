package dal;

import model.Ticket;
import model.Ticket.TicketTypeName;
import utils.DBConnect;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class TicketDAO {

    public static int getTicketTypeIdByEnum(Ticket.TicketTypeName type) throws SQLException {
        String sql = "SELECT id FROM TicketType WHERE type_name = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type.name());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("id");
            throw new SQLException("Không tìm thấy loại vé: " + type.name());
        }
    }

    public static BigDecimal getTicketTypePrice(Ticket.TicketTypeName type) throws SQLException {
        String sql = "SELECT price FROM TicketType WHERE type_name = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type.name());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getBigDecimal("price");
            throw new SQLException("Không tìm thấy giá vé cho loại: " + type.name());
        }
    }

    public boolean updateTicketStatus(int ticketId, Ticket.TicketStatus ticketStatus, Ticket.PaymentStatus paymentStatus) throws SQLException {
        String sql = "UPDATE Ticket SET ticket_status = 'Active', payment_status = 'Paid' WHERE ticket_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            System.out.println(stmt.executeUpdate());
            return stmt.executeUpdate() > 0;
        }
    }



    // Xóa vé
    public boolean deleteTicketById(int ticketId) throws SQLException {
        String sql = "DELETE FROM Ticket WHERE ticket_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            return stmt.executeUpdate() > 0;
        }
    }

    public Integer saveTicket(Ticket ticket) {
        String sql = "INSERT INTO Ticket (user_id, ticket_type_id, quantity, start_date, end_date, " +
                "ticket_status, payment_status, payment_id, total, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, ticket.getUserId());
            stmt.setInt(2, ticket.getTicketTypeId());
            stmt.setInt(3, ticket.getQuantity());
            stmt.setDate(4, Date.valueOf(ticket.getStartDate()));
            stmt.setDate(5, Date.valueOf(ticket.getEndDate()));
            stmt.setString(6, ticket.getTicketStatus().name());
            stmt.setString(7, ticket.getPaymentStatus().name());

            if (ticket.getPaymentId() != null) {
                stmt.setInt(8, ticket.getPaymentId());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }

            stmt.setBigDecimal(9, ticket.getTotal());
            stmt.setTimestamp(10, Timestamp.valueOf(ticket.getCreatedAt()));

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Inserting ticket failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // trả về ticket_id mới sinh
                } else {
                    throw new SQLException("Inserting ticket failed, no ID obtained.");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }


}
