<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null || user.getRole().getId() != 5) {
        response.sendRedirect("error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Poolax - Cửa Hàng Thuê Thiết Bị</title>
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
            background: #f4fff7;
            color: #28a745;
            border-left-color: #28a745;
        }

        .error {
            background: #fff4f4;
            color: #dc3545;
            border-left-color: #dc3545;
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

<!-- Navbar -->
<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="staff_dashboard.jsp" class="nav-link">Trang chủ</a>
        <a href="purchase" class="nav-link">Vé Bơi</a>
        <a href="equipment?mode=transaction_history" class="nav-link">📜 Lịch Sử Giao Dịch</a>
        <a href="equipment?mode=rental" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🛒 Thuê Thiết Bị
        </a>
        <a href="equipment?mode=buy" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🛒 Mua Thiết Bị
        </a>
        <a href="cart" class="nav-link">
            🛒 Xem Giỏ Hàng <span>(${not empty sessionScope.cart ? sessionScope.cart.items.size() : 0})</span>
        </a>
    </div>
    <div class="auth">
        <% if (user == null) { %>
        <a class="login-btn" href="login.jsp">Đăng Nhập</a>
        <a class="register-btn" href="register.jsp">Đăng Ký</a>
        <% } else { %>
        <span>Xin chào, <a href="userprofile" style="text-decoration:none; color:inherit;">
            <%= user.getFullName() %>
        </a>!</span>
        <form action="logout" method="post" style="display:inline;">
            <input type="submit" value="Đăng Xuất">
        </form>
        <% } %>
    </div>
</div>

<!-- Spacer tránh bị che -->
<div style="height: 70px;"></div>

<!-- Page Header -->
<div class="page-header">
    <h1>Cửa Hàng Thuê Thiết Bị</h1>
    <p>Tìm và thuê thiết bị hồ bơi</p>
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
            <h3>Lọc Danh Mục</h3>
            <ul class="category-list">
                <li class="category-item">
                    <a href="#" class="category-link active" onclick="filterByCategory('all')" id="filter-all">
                        <span class="category-icon">🏊</span>
                        Tất Cả Danh Mục
                    </a>
                </li>
            </ul>

            <div class="filter-section">
                <h4>Lọc Theo Giá</h4>
                <div class="price-range">
                    <div class="price-inputs">
                        <input type="number" class="price-input" placeholder="Tối Thiểu" id="minPrice">
                        <input type="number" class="price-input" placeholder="Tối Đa" id="maxPrice">
                    </div>
                    <button class="btn btn-primary" onclick="filterByPrice()" style="width: 100%;">Áp Dụng Lọc</button>
                </div>
            </div>
        </div>

        <!-- Content Area -->
        <div class="content-area">
            <!-- Tabs -->
            <div class="tabs">
                <div class="tab-buttons">
                    <button class="tab-btn active" onclick="showTab('equipment')">🏊 Thiết Bị Cho Thuê</button>
                    <button class="tab-btn" onclick="showTab('rentals')">📋 Đang Thuê</button>
                </div>

                <!-- Equipment Tab -->
                <div id="equipment" class="tab-content active">
                    <!-- Search & Sort Bar -->
                    <div class="search-sort-bar">
                        <div class="search-box">
                            <input type="text" class="search-input" placeholder="Tìm thiết bị..." id="searchInput">
                            <button class="search-btn" onclick="searchEquipment()">🔍</button>
                        </div>

                        <select class="sort-select" onchange="sortEquipment(this.value)">
                            <option value="name">Sắp xếp theo Tên</option>
                            <option value="price-low">Giá: Thấp đến Cao</option>
                            <option value="price-high">Giá: Cao đến Thấp</option>
                            <option value="availability">Tình Trạng Có Sẵn</option>
                        </select>
                    </div>

                    <div class="results-info">
                        Hiển thị <span id="resultCount">${not empty equipmentList ? equipmentList.size() : 0}</span> thiết bị
                    </div>

                    <!-- Equipment Grid -->
                    <div class="equipment-grid" id="equipmentGrid">
                        <c:forEach var="item" items="${equipmentList}">
                            <div class="equipment-card"
                                 data-category="${item.category}"
                                 data-name="${fn:toLowerCase(item.itemName)}"
                                 data-rent-price="${item.rentPrice}"
                                 data-sale-price="${item.salePrice}"
                                 data-usage-id="${item.usageId}"
                                 data-quantity="${item.quantity}">

                                <div class="equipment-image">
                                    🏊‍♂️
                                </div>

                                <div class="equipment-content">
                                    <h4 class="equipment-name">${item.itemName}</h4>
                                    <div class="equipment-category">${item.category}</div>

                                    <div class="equipment-details">
                                        <div><strong>Đơn vị:</strong> ${item.unit}</div>

                                        <c:if test="${item.rentPrice > 0}">
                                            <div class="price-row">
                                                <span>Giá Thuê:</span>
                                                <span class="price">
                                                    <c:if test="${not empty item.rentPrice && item.rentPrice != ''}"><fmt:formatNumber value="${item.rentPrice}" type="currency" currencyCode="VND"/></c:if>
                                                </span>
                                            </div>
                                        </c:if>

                                        <c:if test="${item.salePrice > 0}">
                                            <div class="price-row">
                                                <span>Giá Bán:</span>
                                                <span class="price"><fmt:formatNumber value="${item.salePrice}" type="currency" currencyCode="VND"/></span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="stock-info">
                                        <span class="stock-text">Có sẵn: ${item.quantity}</span>
                                        <span class="stock-badge ${item.quantity == 0 ? 'out-stock' : (item.quantity <= 5 ? 'low-stock' : 'in-stock')}">
                                                ${item.quantity == 0 ? 'Hết Hàng' : (item.quantity <= 5 ? 'Sắp Hết' : 'Còn Hàng')}
                                        </span>
                                    </div>

                                    <div class="equipment-actions">
                                        <c:if test="${item.rentPrice > 0}">
                                            <!-- Nút Rent: Gọi modal với redirectTo='cart' -->
                                            <button class="btn btn-primary btn-sm"
                                                    onclick="openRentalModal('${item.inventoryId}', '${fn:escapeXml(item.itemName)}', '${item.rentPrice}', 'cart', '${item.quantity}')"
                                                ${item.quantity == 0 ? 'disabled' : ''}>
                                                🔄 Thuê Ngay
                                            </button>

                                            <!-- Nút Add to Cart: Gọi modal với redirectTo='rental' -->
                                            <button class="btn btn-primary btn-sm"
                                                    onclick="openRentalModal('${item.inventoryId}', '${fn:escapeXml(item.itemName)}', '${item.rentPrice}', 'rental', '${item.quantity}')"
                                                ${item.quantity == 0 ? 'disabled' : ''}>
                                                🛒 Thêm Vào Giỏ
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
                            <th>ID Thuê</th>
                            <th>Thiết Bị</th>
                            <th>Khách Hàng</th>
                            <th>Số Lượng</th>
                            <th>Ngày Thuê</th>
                            <th>CCCD</th>
                            <th>Tổng Tiền</th>
                            <th>Hành Động</th>
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
                                <td><fmt:formatNumber value="${rental.totalAmount}" type="currency" currencyCode="VND"/></td>
                                <td class="actions">
                                    <!-- Return Button -->
                                    <button class="btn-return" onclick="processReturn(${rental.rentalId})" title="Trả thiết bị bình thường">
                                        ✅ Trả
                                    </button>

                                    <!-- Report Issue Button -->
                                    <button class="btn-report" onclick="reportIssue(${rental.rentalId})" title="Báo hỏng, mất, hoặc quá hạn">
                                        ⚠️ Báo Cáo
                                    </button>

                                    <!-- Optional: View Details Button -->
                                        <%--                                    <button class="btn-view" onclick="viewRentalDetails(${rental.rentalId})" title="View rental details">--%>
                                        <%--                                        👁️ View--%>
                                        <%--                                    </button>--%>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p>© 2025 SwimmingPool. All rights reserved.</p>
        <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
    </footer>

    <!-- Rental Modal -->
    <div id="rentalModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">🔄 Thuê Thiết Bị</h3>
                <button class="close" onclick="closeModal('rentalModal')">×</button>
            </div>
            <form action="equipment" method="post">
                <input type="hidden" name="action" value="rental">
                <input type="hidden" name="mode" value="rental">
                <input type="hidden" name="inventoryId" id="rental_inventoryId">
                <input type="hidden" name="rentPrice" id="rental_hiddenPrice">
                <input type="hidden" id="availableQuantity" value="0">

                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Thiết Bị</label>
                        <input type="text" class="form-input" id="rental_itemName" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tên Khách Hàng *</label>
                        <input type="text" name="customerName" class="form-input" placeholder="Nhập tên khách hàng" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số CMND *</label>
                        <input type="text" name="customerIdCard" class="form-input" placeholder="Nhập số CMND" required maxlength="10" pattern="\d{10}" id="customerIdCard">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số Lượng *</label>
                        <input type="number" name="quantity" class="form-input" min="1" value="1" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giá Thuê</label>
                        <input type="text" class="form-input" id="rental_price" readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('rentalModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm Vào Giỏ</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function filterByCategory(categoryId) {
            console.log('Filtering by category:', categoryId);

            document.querySelectorAll('.category-link').forEach(link => {
                link.classList.remove('active');
            });

            const activeLink = document.getElementById('filter-' + (categoryId === 'all' ? 'all' : categoryId));
            if (activeLink) {
                activeLink.classList.add('active');
            }

            const cards = document.querySelectorAll('.equipment-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');

                if (categoryId === 'all' || cardCategory == categoryId) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            updateResultCount(visibleCount);
        }

        function hideCategoryFilters() {
            console.log('Hiding category filters, keeping only "All Categories"');

            const categoryItems = document.querySelectorAll('.category-item');
            categoryItems.forEach((item, index) => {
                // Giữ lại item đầu tiên (All Categories), ẩn các item còn lại
                if (index > 0) {
                    item.style.display = 'none';
                }
            });

            console.log(`Hidden ${categoryItems.length - 1} category filters`);
        }

        function searchEquipment() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
            console.log('Searching for:', searchTerm);

            const cards = document.querySelectorAll('.equipment-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const name = card.getAttribute('data-name') || '';
                const categoryText = card.querySelector('.equipment-category')?.textContent.toLowerCase() || '';
                const equipmentName = card.querySelector('.equipment-name')?.textContent.toLowerCase() || '';

                if (name.includes(searchTerm) ||
                    categoryText.includes(searchTerm) ||
                    equipmentName.includes(searchTerm)) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            updateResultCount(visibleCount);
        }

        function clearSearch() {
            document.getElementById('searchInput').value = '';
            searchEquipment();
        }

        function sortEquipment(sortBy) {
            console.log('Sorting by:', sortBy);

            const grid = document.getElementById('equipmentGrid');
            const cards = Array.from(grid.querySelectorAll('.equipment-card'));

            cards.sort((a, b) => {
                switch(sortBy) {
                    case 'name':
                        const nameA = a.getAttribute('data-name') || '';
                        const nameB = b.getAttribute('data-name') || '';
                        return nameA.localeCompare(nameB);

                    case 'price-low':
                        const priceA = parseFloat(a.getAttribute('data-rent-price')) || Infinity;
                        const priceB = parseFloat(b.getAttribute('data-rent-price')) || Infinity;
                        return priceA - priceB;

                    case 'price-high':
                        const priceAHigh = parseFloat(a.getAttribute('data-rent-price')) || 0;
                        const priceBHigh = parseFloat(b.getAttribute('data-rent-price')) || 0;
                        return priceBHigh - priceAHigh;

                    case 'availability':
                        const qtyA = getQuantityFromCard(a);
                        const qtyB = getQuantityFromCard(b);
                        return qtyB - qtyA; // High to low availability

                    default:
                        return 0;
                }
            });

            grid.innerHTML = '';
            cards.forEach(card => grid.appendChild(card));
        }

        function filterByPrice() {
            const minPrice = parseFloat(document.getElementById('minPrice').value) || 0;
            const maxPrice = parseFloat(document.getElementById('maxPrice').value) || Infinity;

            console.log('Filtering by price range:', minPrice, 'to', maxPrice);

            const cards = document.querySelectorAll('.equipment-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const rentPrice = parseFloat(card.getAttribute('data-rent-price')) || 0;

                if (rentPrice >= minPrice && rentPrice <= maxPrice) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            updateResultCount(visibleCount);
        }

        function clearPriceFilter() {
            document.getElementById('minPrice').value = '';
            document.getElementById('maxPrice').value = '';
            filterByCategory('all'); // Reset to show all
        }

        function showTab(tabName) {
            console.log('Switching to tab:', tabName);

            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });

            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });

            const selectedTab = document.getElementById(tabName);
            if (selectedTab) {
                selectedTab.classList.add('active');
            }

            event.target.classList.add('active');
        }

        function openRentalModal(inventoryId, itemName, rentPrice, redirectTo, availableQuantity) {
            console.log('Opening rental modal:', {
                inventoryId: inventoryId,
                itemName: itemName,
                rentPrice: rentPrice,
                redirectTo: redirectTo,
                availableQuantity: availableQuantity
            });

            if (!inventoryId || !itemName || !rentPrice) {
                console.error('Missing required parameters for rental modal');
                alert('Lỗi: Thiếu thông tin sản phẩm. Vui lòng thử lại.');
                return;
            }

            document.getElementById('rental_inventoryId').value = inventoryId;
            document.getElementById('rental_itemName').value = itemName;
            document.getElementById('rental_price').value = formatCurrency(rentPrice);
            document.getElementById('rental_hiddenPrice').value = rentPrice;
            document.getElementById('availableQuantity').value = availableQuantity;

            let redirectInput = document.getElementById('redirectToInput');
            if (!redirectInput) {
                redirectInput = document.createElement('input');
                redirectInput.type = 'hidden';
                redirectInput.id = 'redirectToInput';
                redirectInput.name = 'redirectTo';
                document.querySelector('#rentalModal form').appendChild(redirectInput);
            }
            redirectInput.value = redirectTo || 'rental';

            const form = document.querySelector('#rentalModal form');
            form.querySelector('input[name="customerName"]').value = '';
            form.querySelector('input[name="customerIdCard"]').value = '';
            form.querySelector('input[name="quantity"]').value = '1';

            document.getElementById('rentalModal').style.display = 'block';

            setTimeout(() => {
                const customerNameField = form.querySelector('input[name="customerName"]');
                if (customerNameField) {
                    customerNameField.focus();
                }
            }, 100);
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function processReturn(rentalId) {
            if (confirmAction('Bạn có chắc chắn muốn xử lý trả thiết bị này?')) {
                console.log('Processing return for rental ID:', rentalId);

                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'equipment';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'return';

                const rentalIdInput = document.createElement('input');
                rentalIdInput.type = 'hidden';
                rentalIdInput.name = 'rentalId';
                rentalIdInput.value = rentalId;

                const modeInput = document.createElement('input');
                modeInput.type = 'hidden';
                modeInput.name = 'mode';
                modeInput.value = 'rental';

                form.appendChild(actionInput);
                form.appendChild(rentalIdInput);
                form.appendChild(modeInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function reportIssue(rentalId) {
            if (confirmAction('Báo cáo vấn đề cho lần thuê này?')) {
                console.log('Reporting issue for rental ID:', rentalId);
                location.href = 'compensation?action=create&rentalId=' + rentalId;
            }
        }

        function validateRentalForm(form) {
            const customerName = form.querySelector('input[name="customerName"]').value.trim();
            const customerIdCard = form.querySelector('input[name="customerIdCard"]').value.trim();
            const quantity = parseInt(form.querySelector('input[name="quantity"]').value);
            const availableQuantity = parseInt(document.getElementById('availableQuantity').value);

            if (!customerName) {
                alert('Vui lòng nhập tên khách hàng');
                return false;
            }

            if (!/^\d{10}$/.test(customerIdCard)) {
                alert('Số CMND phải là số và đúng 10 chữ số');
                return false;
            }

            if (!quantity || quantity < 1) {
                alert('Vui lòng nhập số lượng hợp lệ');
                return false;
            }

            if (quantity > availableQuantity) {
                alert('Số lượng thuê không được vượt quá số lượng có sẵn');
                return false;
            }

            return true;
        }

        function updateResultCount(count) {
            const resultCountElement = document.getElementById('resultCount');
            if (resultCountElement) {
                resultCountElement.textContent = count;
            }
        }

        function getQuantityFromCard(card) {
            const stockText = card.querySelector('.stock-text');
            if (stockText) {
                const text = stockText.textContent;
                const match = text.match(/Có sẵn:\s*(\d+)/);
                return match ? parseInt(match[1]) : 0;
            }
            return 0;
        }

        function formatCurrency(amount) {
            try {
                const numAmount = parseFloat(amount);
                if (isNaN(numAmount)) return 'N/A';
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(numAmount);
            } catch (error) {
                console.error('Error formatting currency:', error);
                return amount.toString();
            }
        }

        function refreshPage() {
            window.location.reload();
        }

        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        function confirmAction(message) {
            return confirm(message || 'Bạn có chắc chắn muốn tiếp tục?');
        }

        document.addEventListener('DOMContentLoaded', function() {
            console.log('Initializing Equipment Rental System...');

            hideCategoryFilters();

            const cards = document.querySelectorAll('.equipment-card');
            let visibleCount = 0;
            cards.forEach(card => {
                if (card.getAttribute('data-usage-id') !== '2') {
                    card.style.display = 'none';
                } else {
                    visibleCount++;
                }
            });
            updateResultCount(visibleCount);

            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        searchEquipment();
                    }
                });

                searchInput.addEventListener('input', function() {
                    clearTimeout(this.searchTimeout);
                    this.searchTimeout = setTimeout(() => {
                        searchEquipment();
                    }, 300);
                });
            }

            const minPriceInput = document.getElementById('minPrice');
            const maxPriceInput = document.getElementById('maxPrice');

            if (minPriceInput && maxPriceInput) {
                [minPriceInput, maxPriceInput].forEach(input => {
                    input.addEventListener('keypress', function(e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            filterByPrice();
                        }
                    });
                });
            }

            window.onclick = function(event) {
                if (event.target.classList.contains('modal')) {
                    event.target.style.display = 'none';
                }
            };

            setTimeout(() => {
                document.querySelectorAll('.message').forEach(msg => {
                    msg.style.transition = 'opacity 0.3s';
                    msg.style.opacity = '0';
                    setTimeout(() => {
                        if (msg.parentNode) {
                            msg.parentNode.removeChild(msg);
                        }
                    }, 300);
                });
            }, 5000);

            const priceRange = document.querySelector('.price-range');
            if (priceRange) {
                const clearFiltersBtn = document.createElement('button');
                clearFiltersBtn.textContent = 'Xóa Lọc';
                clearFiltersBtn.className = 'btn btn-cancel';
                clearFiltersBtn.style.width = '100%';
                clearFiltersBtn.style.marginTop = '10px';
                clearFiltersBtn.type = 'button';
                clearFiltersBtn.onclick = clearPriceFilter;
                priceRange.appendChild(clearFiltersBtn);
            }

            document.addEventListener('keydown', function(e) {
                // ESC to close modals
                if (e.key === 'Escape') {
                    document.querySelectorAll('.modal').forEach(modal => {
                        modal.style.display = 'none';
                    });
                }

                if (e.ctrlKey && e.key === 'f') {
                    e.preventDefault();
                    const searchInput = document.getElementById('searchInput');
                    if (searchInput) {
                        searchInput.focus();
                        searchInput.select();
                    }
                }
            });

            document.querySelectorAll('.btn[disabled]').forEach(btn => {
                btn.title = 'Sản phẩm này hiện hết hàng';
            });

            document.querySelectorAll('form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    if (this.closest('#rentalModal')) {
                        if (!validateRentalForm(this)) {
                            e.preventDefault();
                            return false;
                        }
                    }

                    const submitBtn = this.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        const originalText = submitBtn.textContent;
                        submitBtn.textContent = 'Đang Xử Lý...';
                        submitBtn.disabled = true;

                        setTimeout(() => {
                            submitBtn.textContent = originalText;
                            submitBtn.disabled = false;
                        }, 10000);
                    }
                });
            });

            filterByCategory('all');


            console.log('Equipment Rental System initialized successfully!');
            console.log(`Found ${cards.length} equipment items, showing ${visibleCount} with usageId=2`);
        });


        if ('performance' in window) {
            window.addEventListener('load', function() {
                setTimeout(() => {
                    const perfData = performance.getEntriesByType('navigation')[0];
                    console.log('Page Load Time:', Math.round(perfData.loadEventEnd - perfData.loadEventStart), 'ms');
                }, 0);
            });
        }
    </script>
</body>
</html>