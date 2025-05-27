package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailUtils {

    // Thay thế bằng email thật và App Password của bạn
    private static final String USERNAME = "tohoanghiep240503@gmail.com";
    private static final String PASSWORD = "eqoe qavf lpbn igri"; // App Password tạo ở bước 3

    public static void send(String toEmail, String subject, String messageText) {
        Properties props = new Properties();

        // Cấu hình Gmail SMTP
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Tạo session có xác thực
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            // Tạo nội dung mail
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(messageText);

            // Gửi mail
            Transport.send(message);
            System.out.println(">>> Đã gửi email đến: " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
