package validate;

import model.Ticket;
import java.time.LocalDate;

public class TicketValid {

    // Hàm tính ngày kết thúc dựa vào loại vé
    public static LocalDate calculateEndDate(Ticket.TicketTypeName type, LocalDate startDate) {
        switch (type) {
            case Single:
                return startDate.plusDays(1);
            case Monthly:
                return startDate.plusDays(30);
            case ThreeMonthly:
                return startDate.plusDays(90);
            case SixMonthly:
                return startDate.plusDays(180);
            case Year:
                return startDate.plusDays(365);
            default:
                return null;
        }
    }

    // Hàm kiểm tra ngày kết thúc có đúng theo loại vé không
    public static boolean isEndDateValid(Ticket.TicketTypeName type, LocalDate start, LocalDate end) {
        LocalDate expectedEnd = calculateEndDate(type, start);
        return expectedEnd != null && expectedEnd.equals(end);
    }
}
