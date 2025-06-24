<%@ page import="model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Poolax - Equipment Shop</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            scroll-behavior: smooth;
            background: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }

        /* ===== NAVBAR STYLES ===== */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0, 92, 170, 0.9);
            padding: 15px 30px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 999;
            backdrop-filter: blur(4px);
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
            color: white;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 500;
        }

        .nav-links a:hover {
            text-decoration: underline;
        }

        .auth {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
        }

        .auth a.login-btn,
        .auth a.register-btn,
        .auth form input[type="submit"] {
            padding: 8px 16px;
            background-color: #ffffff;
            color: #005caa;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
        }

        .auth a.login-btn:hover,
        .auth a.register-btn:hover,
        .auth form input[type="submit"]:hover {
            background-color: #e6e6e6;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            color: white;
            padding: 100px 0 60px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="80" r="2" fill="rgba(255,255,255,0.1)"/></svg>');
        }

        .page-header h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
        }

        .page-header p {
            font-size: 18px;
            opacity: 0.9;
            position: relative;
        }

        /* Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Main Layout */
        .main-layout {
            display: flex;
            gap: 30px;
            align-items: flex-start;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
        }

        .sidebar h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }

        .category-list {
            list-style: none;
        }

        .category-item {
            margin-bottom: 12px;
        }

        .category-link {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            text-decoration: none;
            color: #666;
            border-radius: 8px;
            transition: all 0.3s;
            font-weight: 500;
        }

        .category-link:hover,
        .category-link.active {
            background: #007bff;
            color: white;
            transform: translateX(5px);
        }

        .category-icon {
            margin-right: 12px;
            font-size: 18px;
        }

        /* Filter Section */
        .filter-section {
            margin-top: 30px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .price-range {
            margin-bottom: 15px;
        }

        .price-inputs {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .price-input {
            flex: 1;
            min-width: 120px;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            max-width: calc(50% - 5px);
            background: white;
        }

        .price-actions {
            display: flex;
            gap: 10px;
        }

        .price-actions .btn {
            flex: 1;
            padding: 10px;
            font-size: 14px;
        }

        .btn-cancel {
            background: #f8f9fa;
            color: #6c757d;
            border: 1px solid #ddd;
            transition: all 0.3s;
        }

        .btn-cancel:hover {
            background: #e9ecef;
        }

        /* Content Area */
        .content-area {
            flex: 1;
        }

        /* Search & Sort */
        .search-sort-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            gap: 20px;
        }

        .search-box {
            display: flex;
            flex: 1;
            max-width: 400px;
        }

        .search-input {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-right: none;
            border-radius: 8px 0 0 8px;
            font-size: 14px;
        }

        .search-btn {
            padding: 12px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 0 8px 8px 0;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-btn:hover {
            background: #0056b3;
        }

        .sort-select {
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            background: white;
        }

        .results-info {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }

        /* Equipment Grid */
        .equipment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .equipment-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: all 0.3s;
            border: 1px solid #f0f0f0;
        }

        .equipment-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }

        .equipment-image {
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #007bff;
            position: relative;
        }

        .equipment-content {
            padding: 20px;
        }

        .equipment-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
            line-height: 1.4;
        }

        .equipment-category {
            color: #666;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .equipment-details {
            margin-bottom: 15px;
        }

        .equipment-details div {
            margin-bottom: 6px;
            font-size: 14px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .price {
            color: #007bff;
            font-weight: 600;
            font-size: 16px;
        }

        .stock-info {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 6px;
        }

        .stock-text {
            font-weight: 500;
            font-size: 14px;
        }

        .stock-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .stock-badge.in-stock {
            background: #d4edda;
            color: #155724;
        }

        .stock-badge.low-stock {
            background: #fff3cd;
            color: #856404;
        }

        .stock-badge.out-stock {
            background: #f8d7da;
            color: #721c24;
        }

        .equipment-actions {
            display: flex;
            gap: 8px;
        }

        .btn {
            flex: 1;
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            text-align: center;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-success:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .btn:disabled {
            background: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
            transform: none;
        }

        /* Tabs for Active Rentals */
        .tabs {
            background: white;
            border-radius: 12px;
            margin-top: 40px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .tab-buttons {
            display: flex;
            border-bottom: 1px solid #eee;
        }

        .tab-btn {
            flex: 1;
            padding: 16px 20px;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .tab-btn.active {
            background: #007bff;
            color: white;
        }

        .tab-btn:hover:not(.active) {
            background: #f8f9fa;
        }

        .tab-content {
            display: none;
            padding: 25px;
        }

        .tab-content.active {
            display: block;
        }

        /* Table */
        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }

        .table tr:hover {
            background: #f8f9fa;
        }

        .btn-return {
            background: #ff9800;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: background 0.3s;
        }

        .btn-return:hover {
            background: #f57c00;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
        }

        .close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #999;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s;
        }

        .close:hover {
            background: #f8f9fa;
            color: #333;
        }

        .modal-body {
            padding: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #333;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-input:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0,123,255,0.1);
        }

        .form-input[readonly] {
            background: #f8f9fa;
            color: #666;
        }

        .modal-footer {
            padding: 20px 25px;
            border-top: 1px solid #eee;
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .btn-cancel:hover {
            background: #545b62;
        }

        /* Messages */
        .message {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            font-weight: 500;
            border-left: 4px solid;
        }

        .success {
            background: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        /* Debug section */
        .debug-section {
            background: #f8f9fa;
            padding: 20px;
            margin: 20px 0;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .debug-item {
            margin: 5px 0;
            font-size: 12px;
            font-family: monospace;
        }

        /* ===== FOOTER STYLES ===== */
        footer {
            background: #003e73;
            color: white;
            padding: 30px 10%;
            text-align: center;
        }

        footer p {
            margin-bottom: 5px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-layout {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                position: static;
            }

            .equipment-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }

            .search-sort-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                max-width: none;
            }

            .nav-links {
                flex-direction: column;
            }

            .nav-item {
                margin-right: 0;
                margin-bottom: 2px;
            }
        }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
%>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="home.jsp#about">About Us</a>
        <a href="home.jsp#services">Services</a>
        <a href="home.jsp#gallery">Gallery</a>
        <a href="home.jsp#contact">Contact</a>
        <a href="equipment-rental" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🏊 Equipment Rental
        </a>
    </div>
    <div class="auth">
        <% if (user == null) { %>
        <a class="login-btn" href="login.jsp">Login</a>
        <a class="register-btn" href="register.jsp">Register</a>
        <% } else { %>
        <span>Hello, <a href="userprofile" style="text-decoration:none; color:inherit;">
            <%= user.getFullName() %>
        </a>!</span>
        <form action="logout" method="post" style="display:inline;">
            <input type="submit" value="Logout">
        </form>
        <% } %>
    </div>
</div>

<!-- Spacer tránh bị che -->
<div style="height: 70px;"></div>

<!-- Page Header -->
<div class="page-header">
    <h1>Equipment Shop</h1>
    <p>Find and rent or purchase swimming pool equipment</p>
</div>

<!-- Main Container -->
<div class="container">
    <!-- Messages -->
    <c:if test="${not empty success}">
        <div class="message success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>

    <!-- Main Layout -->
    <div class="main-layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <h3>Filter Categories</h3>
            <ul class="category-list">
                <li class="category-item">
                    <a href="#" class="category-link active" onclick="filterByCategory('all')" id="filter-all">
                        <span class="category-icon">🏊</span>
                        All Equipment
                    </a>
                </li>
                <li class="category-item">
                    <a href="#" class="category-link" onclick="filterByCategory('rental')" id="filter-rental">
                        <span class="category-icon">🔄</span>
                        For Rent Only
                    </a>
                </li>
                <li class="category-item">
                    <a href="#" class="category-link" onclick="filterByCategory('sale')" id="filter-sale">
                        <span class="category-icon">🛒</span>
                        For Sale Only
                    </a>
                </li>
                <li class="category-item">
                    <a href="#" class="category-link" onclick="filterByCategory('both')" id="filter-both">
                        <span class="category-icon">⚡</span>
                        Rent & Sale
                    </a>
                </li>
            </ul>

            <div class="filter-section">
                <h4>Filter By Price</h4>
                <div class="price-range">
                    <div class="price-inputs">
                        <input type="number" class="price-input" placeholder="Min" id="minPrice">
                        <input type="number" class="price-input" placeholder="Max" id="maxPrice">
                    </div>
                    <button class="btn btn-primary" onclick="filterByPrice()" style="width: 100%;">Apply Filter</button>
                </div>
            </div>
        </div>

        <!-- Content Area -->
        <div class="content-area">
            <!-- Tabs -->
            <div class="tabs">
                <div class="tab-buttons">
                    <button class="tab-btn active" onclick="showTab('equipment')">🏊 Equipment Shop</button>
                    <button class="tab-btn" onclick="showTab('rentals')">📋 Active Rentals</button>
                </div>

                <!-- Equipment Tab -->
                <div id="equipment" class="tab-content active">
                    <!-- Search & Sort Bar -->
                    <div class="search-sort-bar">
                        <div class="search-box">
                            <input type="text" class="search-input" placeholder="Search equipment..." id="searchInput">
                            <button class="search-btn" onclick="searchEquipment()">🔍</button>
                        </div>

                        <select class="sort-select" onchange="sortEquipment(this.value)">
                            <option value="name">Sort by Name</option>
                            <option value="price-low">Price: Low to High</option>
                            <option value="price-high">Price: High to Low</option>
                            <option value="availability">Availability</option>
                        </select>
                    </div>

                    <div class="results-info">
                        Showing <span id="resultCount">${not empty equipmentList ? equipmentList.size() : 0}</span> equipment(s)
                    </div>

                    <!-- Equipment Grid -->
                    <div class="equipment-grid" id="equipmentGrid">
                        <c:forEach var="item" items="${equipmentList}">
                            <div class="equipment-card"
                                 data-category="${(item.usageId == 5 && item.rentPrice > 0 && item.salePrice > 0) ? 'both' :
                                                (item.usageId == 1 || (item.usageId == 5 && item.rentPrice > 0)) ? 'rental' :
                                                (item.usageId == 3 || (item.usageId == 5 && item.salePrice > 0)) ? 'sale' : 'none'}"
                                 data-name="${fn:toLowerCase(item.itemName)}"
                                 data-rent-price="${item.rentPrice}"
                                 data-sale-price="${item.salePrice}"
                                 data-usage-id="${item.usageId}">

                                <div class="equipment-image">
                                    🏊‍♂️
                                </div>

                                <div class="equipment-content">
                                    <h4 class="equipment-name">${item.itemName}</h4>
                                    <div class="equipment-category">${item.category}</div>

                                    <div class="equipment-details">
                                        <div><strong>Unit:</strong> ${item.unit}</div>

                                        <c:if test="${item.rentPrice > 0}">
                                            <div class="price-row">
                                                <span>Rent Price:</span>
                                                <span class="price"><fmt:formatNumber value="${item.rentPrice}" type="currency" currencySymbol="$"/></span>
                                            </div>
                                        </c:if>

                                        <c:if test="${item.salePrice > 0}">
                                            <div class="price-row">
                                                <span>Sale Price:</span>
                                                <span class="price"><fmt:formatNumber value="${item.salePrice}" type="currency" currencySymbol="$"/></span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="stock-info">
                                        <span class="stock-text">Available: ${item.availableQuantity}</span>
                                        <span class="stock-badge ${item.availableQuantity == 0 ? 'out-stock' : (item.availableQuantity <= 5 ? 'low-stock' : 'in-stock')}">
                                                ${item.availableQuantity == 0 ? 'Out of Stock' : (item.availableQuantity <= 5 ? 'Low Stock' : 'In Stock')}
                                        </span>
                                    </div>

                                    <div class="equipment-actions">
                                        <c:if test="${item.rentPrice > 0}">
                                            <button class="btn btn-primary"
                                                    onclick="openRentalModal('${item.inventoryId}', '${fn:escapeXml(item.itemName)}', '${item.rentPrice}')"
                                                ${item.availableQuantity == 0 ? 'disabled' : ''}>
                                                🔄 Rent
                                            </button>
                                        </c:if>
                                        <c:if test="${item.salePrice > 0}">
                                            <button class="btn btn-success"
                                                    onclick="openSaleModal('${item.inventoryId}', '${fn:escapeXml(item.itemName)}', '${item.salePrice}')"
                                                ${item.availableQuantity == 0 ? 'disabled' : ''}>
                                                🛒 Buy
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Rentals Tab -->
                <div id="rentals" class="tab-content">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Rental ID</th>
                            <th>Equipment</th>
                            <th>Customer</th>
                            <th>Quantity</th>
                            <th>Date</th>
                            <th>CCCD</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="rental" items="${activeRentals}">
                            <tr>
                                <td>#${rental.rentalId}</td>
                                <td>${not empty rental.itemName ? rental.itemName : rental.inventoryId}</td>
                                <td>${rental.customerName}</td>
                                <td>${rental.quantity}</td>
                                <td><fmt:formatDate value="${rental.rentalDate}" pattern="dd/MM/yyyy"/></td>
                                <td>${rental.customerIdCard}</td>
                                <td><fmt:formatNumber value="${rental.totalAmount}" type="currency" currencySymbol="$"/></td>
                                <td>
                                    <button class="btn-return" onclick="processReturn(${rental.rentalId})">
                                        Return
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Debug Section -->
    <div class="debug-section">
        <h4>🔍 DEBUG INFO:</h4>
        <div><strong>Current Filter:</strong> ${currentFilter}</div>
        <div><strong>Equipment Count:</strong> ${not empty equipmentList ? equipmentList.size() : 0}</div>
        <c:forEach var="item" items="${equipmentList}" varStatus="status">
            <c:if test="${status.index < 5}">
                <div class="debug-item">
                    <strong>${item.itemName}</strong> -
                    Usage ID: ${item.usageId} |
                    Rent: ${item.rentPrice} |
                    Sale: ${item.salePrice} |
                    Type: <span style="color: blue;">
                        <c:choose>
                            <c:when test="${item.rentPrice > 0 && item.salePrice > 0}">BOTH</c:when>
                            <c:when test="${item.rentPrice > 0 && item.salePrice == 0}">RENTAL</c:when>
                            <c:when test="${item.rentPrice == 0 && item.salePrice > 0}">SALE</c:when>
                            <c:otherwise>NONE</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </c:if>
        </c:forEach>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</footer>

<!-- Rental Modal -->
<div id="rentalModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">🔄 Rent Equipment</h3>
            <button class="close" onclick="closeModal('rentalModal')">&times;</button>
        </div>
        <form action="equipment-rental" method="post" onsubmit="handleRentalSubmit(event)">
            <input type="hidden" name="action" value="rental">
            <input type="hidden" name="inventoryId" id="rental_inventoryId">
            <input type="hidden" name="currentFilter" value="${currentFilter}">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Equipment</label>
                    <input type="text" class="form-input" id="rental_itemName" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Customer Name *</label>
                    <input type="text" name="customerName" class="form-input" placeholder="Enter customer name" required>
                </div>
                <div class="form-group">
                    <label class="form-label">CCCD *</label>
                    <input type="text" name="customerIdCard" class="form-input" placeholder="Enter CCCD number" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Quantity *</label>
                    <input type="number" name="quantity" class="form-input" min="1" value="1" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Rental Price</label>
                    <input type="text" class="form-input" id="rental_price" readonly>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('rentalModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Confirm Rental</button>
            </div>
        </form>
    </div>
</div>

<!-- Sale Modal -->
<div id="saleModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">🛒 Purchase Equipment</h3>
            <button class="close" onclick="closeModal('saleModal')">&times;</button>
        </div>
        <form action="equipment-rental" method="post">
            <input type="hidden" name="action" value="sale">
            <input type="hidden" name="inventoryId" id="sale_inventoryId">
            <input type="hidden" name="currentFilter" value="${currentFilter}">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Equipment</label>
                    <input type="text" class="form-input" id="sale_itemName" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Customer Name *</label>
                    <input type="text" name="customerName" class="form-input" placeholder="Enter customer name" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Quantity *</label>
                    <input type="number" name="quantity" class="form-input" min="1" value="1" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Sale Price</label>
                    <input type="text" class="form-input" id="sale_price" readonly>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('saleModal')">Cancel</button>
                <button type="submit" class="btn btn-success">Confirm Purchase</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Filter by category
    function filterByCategory(category) {
        // Remove active class from all links
        document.querySelectorAll('.category-link').forEach(link => {
            link.classList.remove('active');
        });

        // Add active class to clicked link
        document.getElementById('filter-' + category).classList.add('active');

        const cards = document.querySelectorAll('.equipment-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const cardCategory = card.getAttribute('data-category');

            if (category === 'all' || cardCategory === category) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Update result count
        document.getElementById('resultCount').textContent = visibleCount;
    }

    // Search equipment
    function searchEquipment() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const cards = document.querySelectorAll('.equipment-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const name = card.getAttribute('data-name');
            const categoryText = card.querySelector('.equipment-category').textContent.toLowerCase();

            if (name.includes(searchTerm) || categoryText.includes(searchTerm)) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        document.getElementById('resultCount').textContent = visibleCount;
    }

    // Sort equipment
    function sortEquipment(sortBy) {
        const grid = document.getElementById('equipmentGrid');
        const cards = Array.from(grid.querySelectorAll('.equipment-card'));

        cards.sort((a, b) => {
            switch(sortBy) {
                case 'name':
                    return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                case 'price-low':
                    const priceA = Math.min(
                        parseFloat(a.getAttribute('data-rent-price')) || Infinity,
                        parseFloat(a.getAttribute('data-sale-price')) || Infinity
                    );
                    const priceB = Math.min(
                        parseFloat(b.getAttribute('data-rent-price')) || Infinity,
                        parseFloat(b.getAttribute('data-sale-price')) || Infinity
                    );
                    return priceA - priceB;
                case 'price-high':
                    const maxPriceA = Math.max(
                        parseFloat(a.getAttribute('data-rent-price')) || 0,
                        parseFloat(a.getAttribute('data-sale-price')) || 0
                    );
                    const maxPriceB = Math.max(
                        parseFloat(b.getAttribute('data-rent-price')) || 0,
                        parseFloat(b.getAttribute('data-sale-price')) || 0
                    );
                    return maxPriceB - maxPriceA;
                default:
                    return 0;
            }
        });

        // Re-append sorted cards
        cards.forEach(card => grid.appendChild(card));
    }

    // Filter by price
    function filterByPrice() {
        const minPrice = parseFloat(document.getElementById('minPrice').value) || 0;
        const maxPrice = parseFloat(document.getElementById('maxPrice').value) || Infinity;
        const cards = document.querySelectorAll('.equipment-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const rentPrice = parseFloat(card.getAttribute('data-rent-price')) || 0;
            const salePrice = parseFloat(card.getAttribute('data-sale-price'))

            // Get minimum price (for filtering)
            const minCardPrice = Math.min(
                rentPrice > 0 ? rentPrice : Infinity,
                salePrice > 0 ? salePrice : Infinity
            );

            if (minCardPrice >= minPrice && minCardPrice <= maxPrice) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        document.getElementById('resultCount').textContent = visibleCount;
    }

    // Tab switching
    function showTab(tabName) {
        // Hide all tabs
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });

        // Remove active from all buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });

        // Show selected tab
        document.getElementById(tabName).classList.add('active');
        event.target.classList.add('active');
    }

    // Modal functions
    function openRentalModal(inventoryId, itemName, rentPrice) {
        console.log('Opening rental modal:', inventoryId, itemName, rentPrice);

        document.getElementById('rental_inventoryId').value = inventoryId;
        document.getElementById('rental_itemName').value = itemName;
        document.getElementById('rental_price').value = '$' + parseFloat(rentPrice).toFixed(2);
        document.getElementById('rentalModal').style.display = 'block';
    }

    function openSaleModal(inventoryId, itemName, salePrice) {
        console.log('Opening sale modal:', inventoryId, itemName, salePrice);

        document.getElementById('sale_inventoryId').value = inventoryId;
        document.getElementById('sale_itemName').value = itemName;
        document.getElementById('sale_price').value = '$' + parseFloat(salePrice).toFixed(2);
        document.getElementById('saleModal').style.display = 'block';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    function processReturn(rentalId) {
        if (confirm('Are you sure you want to process this return?')) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = 'equipment-rental';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'return';

            const rentalIdInput = document.createElement('input');
            rentalIdInput.type = 'hidden';
            rentalIdInput.name = 'rentalId';
            rentalIdInput.value = rentalId;

            // Add current filter to maintain page state
            const currentFilter = '${currentFilter}';
            if (currentFilter && currentFilter !== 'null') {
                const filterInput = document.createElement('input');
                filterInput.type = 'hidden';
                filterInput.name = 'currentFilter';
                filterInput.value = currentFilter;
                form.appendChild(filterInput);
            }

            form.appendChild(actionInput);
            form.appendChild(rentalIdInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Event listeners
    document.addEventListener('DOMContentLoaded', function() {
        // Search on Enter key
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchEquipment();
            }
        });

        // Auto-hide messages after 5 seconds
        setTimeout(() => {
            document.querySelectorAll('.message').forEach(msg => {
                msg.style.opacity = '0';
                setTimeout(() => {
                    msg.style.display = 'none';
                }, 300);
            });
        }, 5000);

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }

        // Clear price filters button
        const clearFiltersBtn = document.createElement('button');
        clearFiltersBtn.textContent = 'Clear';
        clearFiltersBtn.className = 'btn btn-cancel';
        clearFiltersBtn.style.width = '100%';
        clearFiltersBtn.style.marginTop = '10px';
        clearFiltersBtn.onclick = function() {
            document.getElementById('minPrice').value = '';
            document.getElementById('maxPrice').value = '';
            filterByCategory('all');
        };

        const priceRange = document.querySelector('.price-range');
        if (priceRange) {
            priceRange.appendChild(clearFiltersBtn);
        }

        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // ESC to close modals
            if (e.key === 'Escape') {
                document.querySelectorAll('.modal').forEach(modal => {
                    modal.style.display = 'none';
                });
            }

            // Ctrl + F to focus search
            if (e.ctrlKey && e.key === 'f') {
                e.preventDefault();
                document.getElementById('searchInput').focus();
            }
        });

        // Add tooltips to buttons
        document.querySelectorAll('.btn[disabled]').forEach(btn => {
            btn.title = 'This item is currently out of stock';
        });

        // Add loading state to forms
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function() {
                const submitBtn = form.querySelector('button[type="submit"]');
                if (submitBtn) {
                    submitBtn.textContent = 'Processing...';
                    submitBtn.disabled = true;
                }
            });
        });

        console.log('Equipment Rental System loaded successfully!');
    });

    // Utility functions
    function formatCurrency(amount) {
        return '$' + parseFloat(amount).toFixed(2);
    }

    function refreshPage() {
        window.location.reload();
    }

    // Add smooth scrolling for better UX
    function scrollToTop() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    // Add confirmation for destructive actions
    function confirmAction(message) {
        return confirm(message || 'Are you sure you want to proceed?');
    }
    function handleRentalSubmit(e) {
        e.preventDefault(); // Ngăn form submit mặc định

        // Lấy form từ sự kiện (có thể dùng e.target hoặc querySelector nếu cần)
        const form = e.target;

        // Nếu muốn xác nhận:
        if (!confirm("Are you sure you want to confirm this rental?")) {
            return; // Hủy nếu người dùng chọn Cancel
        }

        // Option 1: Submit lại bằng JS sau khi xử lý
        form.submit(); // Submit thủ công nếu bạn đã validate xong

        // Option 2: Gửi bằng fetch/AJAX (nếu bạn không muốn reload trang)
        /*
        const formData = new FormData(form);
        fetch(form.action, {
            method: "POST",
            body: formData
        })
        .then(response => response.text())
        .then(data => {
            console.log("Rental submitted:", data);
            // Hiển thị thông báo hoặc đóng modal...
        })
        .catch(error => console.error("Error:", error));
        */
    }
</script>
</body>
</html>