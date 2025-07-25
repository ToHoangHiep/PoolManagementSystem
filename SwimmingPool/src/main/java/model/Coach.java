package model;

public class Coach {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String gender;
    private String bio;
    private String profilePicture;
    private String status; // "Active" or "Inactive"

    public Coach() {}

    public Coach(int id, String fullName, String email, String phone, String gender,
                 String bio, String profilePicture, String status) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.bio = bio;
        this.profilePicture = profilePicture;
        this.status = status;
    }

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Helper methods
    public boolean isActive() {
        return "Active".equalsIgnoreCase(status);
    }

    public void setActive(boolean isActive) {
        this.status = isActive ? "Active" : "Inactive";
    }
}
