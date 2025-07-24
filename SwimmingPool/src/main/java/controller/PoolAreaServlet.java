package controller;

import dal.PoolAreaDAO;
import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.PoolArea;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/pool-area")
public class PoolAreaServlet extends HttpServlet {
    private PoolAreaDAO dao;

    @Override
    public void init() {
        dao = new PoolAreaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String searchKeyword = request.getParameter("searchKeyword");

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PoolArea area = dao.selectById(id);
                List<MaintenanceLog> maintenanceLogs = dao.getMaintenanceLogsForPool(id);
                List<MaintenanceRequest> maintenanceRequests = dao.getMaintenanceRequestsForPool(id);

                request.setAttribute("area", area);
                request.setAttribute("maintenanceLogs", maintenanceLogs);
                request.setAttribute("maintenanceRequests", maintenanceRequests);
                request.getRequestDispatcher("pool-area-form.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (dao.isInUse(id)) {
                    request.setAttribute("error", "Không thể xóa khu vực bể bơi này vì nó đang có dữ liệu liên quan trong nhật ký hoặc yêu cầu bảo trì.");
                } else {
                    dao.delete(id);
                }

                List<PoolArea> areas;
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    areas = dao.searchPoolAreas(searchKeyword.trim());
                    request.setAttribute("searchKeyword", searchKeyword);
                } else {
                    areas = dao.selectAll();
                }

                for (PoolArea poolArea : areas) {
                    if (dao.isUnderMaintenanceOrProblem(poolArea.getId())) {
                        request.setAttribute("poolStatus_" + poolArea.getId(), "Đang bảo trì/Có vấn đề");
                    } else {
                        request.setAttribute("poolStatus_" + poolArea.getId(), "Hoạt động bình thường");
                    }
                }
                request.setAttribute("areas", areas);
                request.getRequestDispatcher("pool-area.jsp").forward(request, response);

            } else if ("add".equals(action)) {
                request.setAttribute("area", new PoolArea());
                request.getRequestDispatcher("pool-area-form.jsp").forward(request, response);
            }
            else {
                List<PoolArea> areas;
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    areas = dao.searchPoolAreas(searchKeyword.trim());
                    request.setAttribute("searchKeyword", searchKeyword);
                } else {
                    areas = dao.selectAll();
                }

                for (PoolArea poolArea : areas) {
                    if (dao.isUnderMaintenanceOrProblem(poolArea.getId())) {
                        request.setAttribute("poolStatus_" + poolArea.getId(), "Đang bảo trì/Có vấn đề");
                    } else {
                        request.setAttribute("poolStatus_" + poolArea.getId(), "Hoạt động bình thường");
                    }
                }

                request.setAttribute("areas", areas);
                request.getRequestDispatcher("pool-area.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        PoolArea area = new PoolArea();

        try {
            String action = request.getParameter("action");

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String type = request.getParameter("type");
            String waterDepthStr = request.getParameter("waterDepth");
            String lengthStr = request.getParameter("length");
            String widthStr = request.getParameter("width");
            String maxCapacityStr = request.getParameter("maxCapacity");

            double depth = 0;
            double length = 0;
            double width = 0;
            int capacity = 0;

            try {
                if (waterDepthStr != null && !waterDepthStr.trim().isEmpty()) {
                    depth = Double.parseDouble(waterDepthStr);
                }
                if (lengthStr != null && !lengthStr.trim().isEmpty()) {
                    length = Double.parseDouble(lengthStr);
                }
                if (widthStr != null && !widthStr.trim().isEmpty()) {
                    width = Double.parseDouble(widthStr);
                }
                if (maxCapacityStr != null && !maxCapacityStr.trim().isEmpty()) {
                    capacity = Integer.parseInt(maxCapacityStr);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Dữ liệu nhập vào không hợp lệ cho các trường số (độ sâu, chiều dài, chiều rộng, sức chứa). Vui lòng nhập số hợp lệ.");
                area.setName(name);
                area.setDescription(description);
                area.setType(type);
                request.setAttribute("area", area);
                request.getRequestDispatcher("pool-area-form.jsp").forward(request, response);
                return;
            }

            area.setName(name);
            area.setDescription(description);
            area.setType(type);
            area.setWaterDepth(depth);
            area.setLength(length);
            area.setWidth(width);
            area.setMaxCapacity(capacity);

            if ("insert".equals(action)) {
                dao.insert(area);
            } else if ("update".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    area.setId(Integer.parseInt(idParam));
                    dao.update(area);
                } else {
                    request.setAttribute("error", "Không thể cập nhật: thiếu ID khu vực bể bơi.");
                    request.setAttribute("area", area);
                    request.getRequestDispatcher("pool-area-form.jsp").forward(request, response);
                    return;
                }
            }

            response.sendRedirect("pool-area");

        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            area.setName(request.getParameter("name"));
            area.setDescription(request.getParameter("description"));
            area.setType(request.getParameter("type"));
            try {
                area.setWaterDepth(Double.parseDouble(request.getParameter("waterDepth")));
                area.setLength(Double.parseDouble(request.getParameter("length")));
                area.setWidth(Double.parseDouble(request.getParameter("width")));
                area.setMaxCapacity(Integer.parseInt(request.getParameter("maxCapacity")));
            } catch (NumberFormatException ex) {
                // Ignore this error, as it means the number fields were already invalid
            }
            request.setAttribute("area", area);
            request.getRequestDispatcher("pool-area-form.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi không mong muốn: " + e.getMessage(), e);
        }
    }
}