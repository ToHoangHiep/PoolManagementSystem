package dal;

import model.Ticket;
import model.Ticket.TicketTypeName;
import utils.DBConnect;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {

    public static int getTicketTypeIdByEnum(Ticket.TicketTypeName type) throws SQLException {
        String sql = "SELECT id FROM TicketType WHERE type_name = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type.name());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id");
                System.out.println("Debug: TicketType ID for " + type.name() + ": " + id);
                return id;
            }
            System.out.println("Debug: No TicketType ID found for " + type.name());
            throw new SQLException("Không tìm thấy loại vé: " + type.name());
        }
    }

    public static BigDecimal getTicketTypePrice(Ticket.TicketTypeName type) throws SQLException {
        String sql = "SELECT price FROM TicketType WHERE type_name = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type.name());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal price = rs.getBigDecimal("price");
                System.out.println("Debug: TicketType Price for " + type.name() + ": " + price);
                return price;
            }
            System.out.println("Debug: No TicketType Price found for " + type.name());
            throw new SQLException("Không tìm thấy giá vé cho loại: " + type.name());
        }
    }

    public boolean updateTicketStatus(int ticketId, Ticket.TicketStatus ticketStatus, Ticket.PaymentStatus paymentStatus) throws SQLException {
        String sql = "UPDATE Ticket SET ticket_status = 'Active', payment_status = 'Paid' WHERE ticket_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            int rows = stmt.executeUpdate();
            System.out.println("Debug: Update Ticket Status for ID " + ticketId + ": Rows affected = " + rows);
            return rows > 0;
        }
    }

    public Integer saveTicket(Ticket ticket) {
        String sql = "INSERT INTO Ticket (user_id, ticket_type_id, quantity, start_date, end_date, " +
                "ticket_status, payment_status, payment_id, total, created_at, customer_name, customer_id_card) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            stmt.setString(11, ticket.getCustomerName());
            stmt.setString(12, ticket.getCustomerIdCard());

            int affectedRows = stmt.executeUpdate();
            System.out.println("Debug: Save Ticket - Rows affected: " + affectedRows + ", Total: " + ticket.getTotal());

            if (affectedRows == 0) {
                throw new SQLException("Inserting ticket failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int id = generatedKeys.getInt(1);
                    System.out.println("Debug: Generated Ticket ID: " + id);
                    return id;
                } else {
                    throw new SQLException("Inserting ticket failed, no ID obtained.");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Debug: SQLException in saveTicket: " + e.getMessage());
            return null;
        }
    }

    public Ticket getById(int ticketId) throws SQLException {
        String sql = "SELECT t.*, tt.price AS ticket_price, tt.type_name AS ticket_type_name " +
                "FROM Ticket t " +
                "LEFT JOIN TicketType tt ON t.ticket_type_id = tt.id " +
                "WHERE t.ticket_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Ticket ticket = new Ticket();
                    ticket.setTicketId(rs.getInt("ticket_id"));
                    ticket.setUserId(rs.getInt("user_id"));
                    ticket.setTicketTypeId(rs.getInt("ticket_type_id"));
                    ticket.setTicketTypeName(rs.getString("ticket_type_name"));
                    ticket.setPrice(rs.getBigDecimal("ticket_price"));
                    ticket.setQuantity(rs.getInt("quantity"));
                    ticket.setStartDate(rs.getDate("start_date").toLocalDate());
                    ticket.setEndDate(rs.getDate("end_date").toLocalDate());
                    ticket.setTicketStatus(Ticket.TicketStatus.valueOf(rs.getString("ticket_status")));
                    ticket.setPaymentStatus(Ticket.PaymentStatus.valueOf(rs.getString("payment_status")));
                    ticket.setPaymentId(rs.getInt("payment_id") != 0 ? rs.getInt("payment_id") : null);
                    ticket.setTotal(rs.getBigDecimal("total"));
                    ticket.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    ticket.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    ticket.setCustomerName(rs.getString("customer_name"));
                    ticket.setCustomerIdCard(rs.getString("customer_id_card"));

                    System.out.println("Debug: Get Ticket by ID " + ticketId + " - Total: " + ticket.getTotal() + ", Type: " + ticket.getTicketTypeName());

                    return ticket;
                }
            }
        }
        System.out.println("Debug: No Ticket found for ID " + ticketId);
        return null;
    }

    public List<Ticket> getTicketsByIds(List<Integer> ids) throws SQLException {
        if (ids.isEmpty()) return new ArrayList<>();

        String sql = "SELECT t.*, tt.price AS ticket_price, tt.type_name AS ticket_type_name " +
                "FROM Ticket t " +
                "LEFT JOIN TicketType tt ON t.ticket_type_id = tt.id " +
                "WHERE t.ticket_id IN (" + String.join(",", ids.stream().map(i -> "?").toArray(String[]::new)) + ")";

        List<Ticket> tickets = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Ticket ticket = new Ticket();
                    ticket.setTicketId(rs.getInt("ticket_id"));
                    ticket.setUserId(rs.getInt("user_id"));
                    ticket.setTicketTypeId(rs.getInt("ticket_type_id"));
                    ticket.setTicketTypeName(rs.getString("ticket_type_name"));
                    ticket.setPrice(rs.getBigDecimal("ticket_price"));
                    ticket.setQuantity(rs.getInt("quantity"));
                    ticket.setStartDate(rs.getDate("start_date").toLocalDate());
                    ticket.setEndDate(rs.getDate("end_date").toLocalDate());
                    ticket.setTicketStatus(Ticket.TicketStatus.valueOf(rs.getString("ticket_status")));
                    ticket.setPaymentStatus(Ticket.PaymentStatus.valueOf(rs.getString("payment_status")));
                    ticket.setPaymentId(rs.getInt("payment_id") != 0 ? rs.getInt("payment_id") : null);
                    BigDecimal total = rs.getBigDecimal("total");
                    ticket.setTotal(total != null ? total : BigDecimal.ZERO);  // Fix null → 0
                    ticket.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    ticket.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    ticket.setCustomerName(rs.getString("customer_name"));
                    ticket.setCustomerIdCard(rs.getString("customer_id_card"));

                    System.out.println("Debug: Get Ticket by IDs - ID " + ticket.getTicketId() + ", Total: " + ticket.getTotal());

                    tickets.add(ticket);
                }
            }
        }
        System.out.println("Debug: Get Tickets by IDs " + ids + " - Found: " + tickets.size());
        return tickets;
    }
}