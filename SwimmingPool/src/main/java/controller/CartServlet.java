package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Cart;
import model.CartItem;
import model.Ticket;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        System.out.println("Debug: doGet CartServlet - Cart items: " + (cart.getItems() != null ? cart.getItems().size() : 0) + ", Total: " + cart.getTotal());

        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        System.out.println("Debug: doPost CartServlet - Action: " + action);

        try {
            if ("remove".equals(action)) {
                int index = Integer.parseInt(request.getParameter("index"));
                cart.removeItem(index);
                System.out.println("Debug: Removed item at index " + index + ", New cart items: " + cart.getItems().size());
                request.setAttribute("success", "Đã xóa item khỏi giỏ!");

            } else if ("update".equals(action)) {
                int index = Integer.parseInt(request.getParameter("index"));
                int newQty = Integer.parseInt(request.getParameter("newQty"));
                cart.updateItemQty(index, newQty);
                System.out.println("Debug: Updated qty at index " + index + " to " + newQty + ", New total: " + cart.getTotal());
                request.setAttribute("success", "Đã cập nhật số lượng!");

            } else if ("checkout".equals(action)) {
                if (cart.isEmpty()) {
                    System.out.println("Debug: Checkout failed - Cart empty");
                    request.setAttribute("error", "Giỏ hàng rỗng!");
                } else {
                    System.out.println("Debug: Checkout successful - Redirect to payment");
                    response.sendRedirect("payment?action=confirm&for=ticket");
                    return;
                }
            }

            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("Debug: NumberFormatException in doPost: " + e.getMessage());
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Debug: Exception in doPost: " + e.getMessage());
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}