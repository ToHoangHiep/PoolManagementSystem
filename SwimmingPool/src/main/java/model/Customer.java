package model;

import java.sql.Date;
import java.text.SimpleDateFormat;

public class Customer {
    private int userId;
    private String fullName;
    private String phoneNumber;
    private Date dob;
    private String gender;
    private String address;
    private String profilePicture;
    private String email;

    public Customer() {}

    public Customer(int userId, String fullName, String phoneNumber, Date dob, String gender,
                    String address, String profilePicture, String email) {
        this.userId = userId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.dob = dob;
        this.gender = gender;
        this.address = address;
        this.profilePicture = profilePicture;
        this.email = email;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDobString() {
        if (dob == null) return "";
        return new SimpleDateFormat("yyyy-MM-dd").format(dob);
    }
}
