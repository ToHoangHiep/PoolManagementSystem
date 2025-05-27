package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailUtils {

    private static final String USERNAME = "tohoanghiep240503@gmail.com";
    private static final String PASSWORD = "eqoeqavflpbnigri"; // App Password

    public static void send(String toEmail, String subject, String code) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            // Tạo nội dung email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, "Hệ thống xác minh", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setReplyTo(InternetAddress.parse(USERNAME));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));


            // Nội dung HTML của email
            String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px;'>"
                    + "<h2 style='color: #26c680;'>Xác minh đăng ký</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Đây là mã xác minh của bạn tài khoản của bạn.</p>"
                    + "<h1 style='color: #007bff;'>" + code + "</h1>"
                    + "<p>Nếu bạn không yêu cầu đăng ký, vui lòng bỏ qua email này.</p>"
                    + "<hr>"
                    + "<p style='font-size: 0.85em; color: #999;'>"
                    + "Email được gửi tự động từ hệ thống xác minh của chúng tôi. Nếu có câu hỏi, vui lòng liên hệ: "
                    + "<a href='mailto:support@example.com'>support@example.com</a></p>"
                    + "</div>";


            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println(">>> Đã gửi email đến: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
