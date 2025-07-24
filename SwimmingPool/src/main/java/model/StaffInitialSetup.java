package model;

import java.sql.Timestamp;

public class StaffInitialSetup {
    private int userId;
    private boolean isSetupComplete;
    private Timestamp createdAt;

    public StaffInitialSetup() {
    }

    public StaffInitialSetup(int userId, boolean isSetupComplete, Timestamp createdAt) {
        this.userId = userId;
        this.isSetupComplete = isSetupComplete;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isSetupComplete() {
        return isSetupComplete;
    }

    public void setSetupComplete(boolean setupComplete) {
        isSetupComplete = setupComplete;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}