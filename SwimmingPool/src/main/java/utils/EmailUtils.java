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
            // Header hỗ trợ hủy đăng ký (List-Unsubscribe)
            String unsubscribeLink = "https://yourdomain.com/unsubscribe?email=" + toEmail;
            message.setHeader("List-Unsubscribe", "<" + unsubscribeLink + ">");

            // Nội dung HTML của email
            String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px;'>"
                    + "<h2 style='color: #26c680;'>Xác minh đăng ký</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Đây là mã xác minh của bạn tài khoản của bạn.</p>"
                    + "<h1 style='color: #007bff;'>" + code + "</h1>"
                    + "<p>Nếu bạn không yêu cầu đăng ký, vui lòng bỏ qua email này.</p>"
                    + "<hr>"
                    + "<p style='font-size: 0.85em; color: #999;'>"
                    + "Email được gửi tự động từ hệ thống xác minh của chúng tôi. "
                    + "Nếu có câu hỏi, vui lòng liên hệ: <a href='mailto:support@example.com'>support@example.com</a>."
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println(">>> Đã gửi email đến: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendEmail(String toEmail, String subject, String body) {
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
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, "Swimming Pool System", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));

            String htmlContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 8px; overflow: hidden;'>"
                    + "<div style='background-color: #0056b3; color: white; padding: 20px; text-align: center;'>"
                    + "<h2>" + subject + "</h2>"
                    + "</div>"
                    + "<div style='padding: 20px 30px;'>"
                    + body.replace("\n", "<br>")
                    + "</div>"
                    + "<div style='background-color: #f8f9fa; padding: 15px; text-align: center; font-size: 0.85em; color: #6c757d; border-top: 1px solid #ddd;'>"
                    + "<p style='margin: 0;'>This is an automated message. Please do not reply directly to this email.</p>"
                    + "<p style='margin: 5px 0 0 0;'>&copy; " + java.time.Year.now().getValue() + " Swimming Pool Management. All rights reserved.</p>"
                    + "</div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println(">>> Successfully sent email to: " + toEmail);

        } catch (Exception e) {
            throw new RuntimeException("Failed to send email to " + toEmail, e);
        }
    }
}


