package validate;

import model.Ticket;

import java.time.LocalDate;

public class TicketValid {

    // Trả về true nếu ngày kết thúc hợp lệ với loại vé
    public static boolean isEndDateValid(Ticket.TicketTypeName type, LocalDate start, LocalDate end) {
        LocalDate expectedEnd;

        switch (type) {
            case Single:
                expectedEnd = start;
                break;
            case Monthly:
                expectedEnd = start.plusMonths(1);
                break;
            case ThreeMonthly:
                expectedEnd = start.plusMonths(3);
                break;
            case SixMonthly:
                expectedEnd = start.plusMonths(6);
                break;
            case Year:
                expectedEnd = start.plusYears(1);
                break;
            default:
                return false;
        }

        return end.equals(expectedEnd);
    }
}
