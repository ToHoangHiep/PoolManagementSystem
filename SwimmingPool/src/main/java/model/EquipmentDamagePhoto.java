package model;

import java.sql.Timestamp;

public class EquipmentDamagePhoto {
    private int photoId;
    private int compensationId;
    private String photoPath;
    private String photoDescription;
    private Timestamp uploadedAt;

    // Default constructor
    public EquipmentDamagePhoto() {
        this.uploadedAt = new Timestamp(System.currentTimeMillis());
    }

    // Constructor with essential fields
    public EquipmentDamagePhoto(int compensationId, String photoPath) {
        this();
        this.compensationId = compensationId;
        this.photoPath = photoPath;
    }

    // Getters and Setters
    public int getPhotoId() {
        return photoId;
    }

    public void setPhotoId(int photoId) {
        this.photoId = photoId;
    }

    public int getCompensationId() {
        return compensationId;
    }

    public void setCompensationId(int compensationId) {
        this.compensationId = compensationId;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public String getPhotoDescription() {
        return photoDescription;
    }

    public void setPhotoDescription(String photoDescription) {
        this.photoDescription = photoDescription;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
