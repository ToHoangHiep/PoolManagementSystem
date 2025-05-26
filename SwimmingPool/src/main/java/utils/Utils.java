package utils;

import kong.unirest.HttpResponse;
import kong.unirest.JsonNode;
import kong.unirest.Unirest;
import kong.unirest.UnirestException;

public class Utils {
    public static boolean CheckIfEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static JsonNode SendEmail(String from, String to, String subject, String body) throws UnirestException {
        HttpResponse<JsonNode> request = Unirest.post("https://api.mailgun.net/v3/" + System.getenv("MAILGUN_DOMAIN") + "/messages")
                .basicAuth("api", System.getenv("MAILGUN_API_KEY"))
                .queryString("from", from)
                .queryString("to", to)
                .queryString("subject", subject)
                .queryString("text", body)
                .asJson();
        return request.getBody();
    }
}

