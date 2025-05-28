package model;

import java.sql.Date;
import java.text.SimpleDateFormat;

public class UserProfile {
    private int userId;
    private String fullName;
    private String phoneNumber;
    private String gender;
    private String address;
    private Date dob;
    private String email;
    private String profile_picture; // đường dẫn ảnh đại diện

    // Constructors
    public UserProfile() {}

    public UserProfile(int userId, String fullName, String phoneNumber, String gender,
                       String address, Date dob, String email, String profile_picture) {
        this.userId = userId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.address = address;
        this.dob = dob;
        this.email = email;
        this.profile_picture = profile_picture;
    }

    // Getters and setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getDobString() {
        if (dob != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.format(dob);
        } else {
            return "";
        }
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getProfile_picture(){
        return profile_picture;
    }

    public void setProfile_picture(String profile_picture){
        this.profile_picture = profile_picture;
    }
}
