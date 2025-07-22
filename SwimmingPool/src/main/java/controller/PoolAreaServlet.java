package controller;

import dal.PoolAreaDAO;
import model.PoolArea;
import utils.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/pool-area")
public class PoolAreaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try (Connection conn = DBConnect.getConnection()) {
            PoolAreaDAO dao = new PoolAreaDAO(conn);
            List<PoolArea> list = dao.getAll();
            System.out.println(">>> GET: Loaded " + list.size() + " pool areas.");
            req.setAttribute("poolAreas", list);
            req.getRequestDispatcher("/pool_area.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading pool areas", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try (Connection conn = DBConnect.getConnection()) {
            PoolAreaDAO dao = new PoolAreaDAO(conn);

            if ("add".equals(action)) {
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                dao.insert(new PoolArea(name, description));
                req.setAttribute("success", "Pool area added.");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                if (dao.isInUse(id)) {
                    req.setAttribute("error", "Cannot delete: This pool area is being used in maintenance logs.");
                } else {
                    dao.deleteById(id);
                    req.setAttribute("success", "Deleted successfully.");
                }
            }

            // Reload list and forward
            List<PoolArea> list = dao.getAll();
            req.setAttribute("poolAreas", list);
            req.getRequestDispatcher("/pool_area.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing pool area action", e);
        }
    }
}
