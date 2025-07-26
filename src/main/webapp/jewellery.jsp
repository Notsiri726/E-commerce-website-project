<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int cartCount = 0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement stmt = conn.prepareStatement("SELECT SUM(quantity) as total FROM cart WHERE customer_id = ?");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            cartCount = rs.getInt("total");
        }
        conn.close();
    } catch (Exception ex) {
        cartCount = 0;
    }

    String category = "jewellery";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Jewellery - Cyrokart</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            display: flex;
            background-color: #dfe6e9;
            transition: background-color 0.3s, color 0.3s;
        }

        body.dark-mode {
            background-color: #1c1c1c;
            color: #fff;
        }

              .sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: 220px;
    height: 100vh;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
    overflow-y: auto;
    z-index: 1000;

    background-color: rgba(190, 218, 217, 0.4); /* #bedad9 with transparency */
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    border-right: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow:
        0 0 20px rgba(255, 255, 255, 0.7),
        0 0 40px rgba(255, 255, 255, 0.8),
        inset 0 0 20px rgba(255, 255, 255, 0.5);
}
@keyframes whitePulseBright {
    0%, 100% {
        box-shadow:
            0 0 20px rgba(255, 255, 255, 0.7),
            0 0 40px rgba(255, 255, 255, 0.8),
            inset 0 0 20px rgba(255, 255, 255, 0.5);
    }
    50% {
        box-shadow:
            0 0 30px rgba(255, 255, 255, 0.9),
            0 0 60px rgba(255, 255, 255, 1),
            inset 0 0 25px rgba(255, 255, 255, 0.7);
    }
}

.sidebar {
    animation: whitePulseBright 2.5s ease-in-out infinite;
}
.main {
    margin-left: 240px; /* ✅ Leaves room for the fixed sidebar */
    padding: 30px 50px;
}


        .sidebar button {
    background: white;
    color: #333;
    border: 1px solid #ccc;
    width: 100%;
    padding: 12px 16px;
    font-size: 15px;
    border-radius: 8px;
    cursor: pointer;
    margin-bottom: 14px;
    height: 46px;
    text-align: left;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

        .sidebar button:hover {
            background-color: #e3f1f1;
        }

        .main {
            flex: 1;
            padding: 30px 50px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .dark-toggle {
            margin-left: 20px;
            cursor: pointer;
            font-size: 24px;
        }

        .products {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
            gap: 25px;
        }

        .product-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            padding: 20px;
            text-align: center;
            transition: transform 0.2s;
        }

        .dark-mode .product-card {
            background: #333;
            color: #fff;
        }
.dark-mode .wishlist-highlighted {
    background-color: #ffe6e6 !important;
}

        .product-card:hover {
            transform: scale(1.03);
        }

        .product-card img {
            max-width: 100%;
            height: 180px;
            object-fit: contain;
            margin-bottom: 10px;
        }

        .product-card .description {
            font-weight: 600;
            font-size: 18px;
            margin: 10px 0 5px;
        }
.dark-mode .product-card .description {
    color: #F00024; /* You can choose any light color you prefer */
}

        .product-card .price {
            color: #27ae60;
            font-size: 18px;
            margin-bottom: 10px;
        }

        a { text-decoration: none; color: inherit; }
        .wishlist-highlighted {
    background-color: #ffe6e6;
    transition: background-color 0.3s;
}
.wishlist-toast {
    position: fixed;
    bottom: 30px;
    right: 30px;
    background-color: #28a745;
    color: #fff;
    padding: 10px 18px;
    border-radius: 6px;
    font-size: 14px;
    z-index: 9999;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    animation: slideIn 0.3s ease-out;
    opacity: 1;
    transition: opacity 0.5s ease;
    max-width: 250px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.wishlist-toast.fade-out {
    opacity: 0;
    transition: opacity 0.5s ease;
}
        @keyframes slideIn {
    from { transform: translateY(20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}.topbar-buttons {
    display: flex;
    align-items: center;
    gap: 40px;
    font-size: 20px;
}

.icon-btn {
    text-decoration: none;
    color: inherit;
    cursor: pointer;
    transition: transform 0.2s, color 0.3s;
}

.icon-btn:hover {
    transform: scale(1.15);
    color: #2c3e50;
}

body.dark-mode .icon-btn:hover {
    color: #f1c40f;
}

    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <button onclick="location.href='profile.jsp'">👤 My Profile</button>
    <button onclick="location.href='my_orders.jsp'">📦 My Orders</button>
    <button onclick="location.href='wishlist.jsp'">❤️ My Wishlist</button>
    <button onclick="location.href='electronics.jsp'">🔌 Electronics</button>
<button onclick="location.href='fashion.jsp'">👗 Fashion</button>
<button onclick="location.href='jewellery.jsp'">💍 Jewellery</button>
<button onclick="location.href='general.jsp'">📦 General</button>
<button onclick="openAddCashPopup()">💰 Add Cash</button>
<button onclick="location.href='index.jsp'">🚪 Logout</button>
</div>

<!-- Main Content -->
<div class="main">
    <div class="topbar">
    <a href="customer_dashboard.jsp" class="icon-btn" title="Home"><h1>🏠</h1></a>
        <h1>💎 Jewellery</h1>
        <div style="display: flex; align-items: center; gap: 20px;">
            <span class="dark-toggle" onclick="toggleDarkMode()" id="modeIcon">🌙</span>
            <a href="cart.jsp" style="text-decoration: none; font-size: 18px; color: inherit;">
                🛒 <strong>Cart (<span id="cartCount"><%= cartCount %></span>)</strong>
            </a>
        </div>
    </div>

  <div class="products">
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE category = ? AND is_hot = 0");
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                boolean inWishlist = false;
                try {
                    Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
                    PreparedStatement ps = conn2.prepareStatement("SELECT * FROM wishlist WHERE customer_id = ? AND product_id = ?");
                    ps.setInt(1, customerId);
                    ps.setInt(2, rs.getInt("id"));
                    ResultSet rws = ps.executeQuery();
                    inWishlist = rws.next();
                    rws.close();
                    ps.close();
                    conn2.close();
                } catch (Exception ex) {
                    inWishlist = false;
                }
    %>
    <div class="product-card <%= inWishlist ? "wishlist-highlighted" : "" %>">
        <a href="product.jsp?id=<%= rs.getInt("id") %>">
            <img src="<%= request.getContextPath() %>/<%= rs.getString("image_url") %>" alt="Product Image">
            <div class="description"><%= rs.getString("name") %></div>
            <div class="price">₹<%= rs.getString("price") %></div>
        </a>
        <button 
            class="wishlist-btn" 
            onclick="addToWishlist(<%= rs.getInt("id") %>, this)" 
            style="background: none; border: none; cursor: pointer; font-size: 20px; margin-top: 8px;">
            <%= inWishlist ? "❤️" : "🤍" %>
        </button>
    </div>
    <%
            }
            conn.close();
        } catch (Exception e) {
            out.println("Error loading jewellery products: " + e.getMessage());
        }
    %>
</div>

</div>

<script>
    function toggleDarkMode() {
        const body = document.body;
        const modeIcon = document.getElementById("modeIcon");
        body.classList.toggle("dark-mode");
        const darkModeEnabled = body.classList.contains("dark-mode");
        modeIcon.textContent = darkModeEnabled ? "☀️" : "🌙";
        document.cookie = "darkMode=" + (darkModeEnabled ? "true" : "false") + "; path=/";
    }

    window.onload = function () {
        if (document.cookie.includes("darkMode=true")) {
            document.body.classList.add("dark-mode");
            const modeIcon = document.getElementById("modeIcon");
            if (modeIcon) modeIcon.textContent = "☀️";
        }
    };
</script>
<script>
function addToWishlist(productId, buttonElement) {
    fetch('AddToWishlistServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'productId=' + productId
    })
    .then(response => response.text())
    .then(data => {
        const trimmed = data.trim();

        if (trimmed === 'added') {
            showToast("✅ Added to your Wishlist");
            buttonElement.innerHTML = "❤️";

            const card = buttonElement.closest(".product-card");
            if (card) card.classList.add("wishlist-highlighted");

        } else if (trimmed === 'exists') {
            showToast("Already in Wishlist");
        } else if (trimmed === 'unauthorized') {
            showToast("Please log in to use Wishlist ❗");
        } else {
            showToast("Something went wrong ❌");
        }
    })
    .catch(() => {
        showToast("Something went wrong ❌");
    });
}

function showToast(message) {
    const existing = document.querySelector(".wishlist-toast");
    if (existing) existing.remove();

    const toast = document.createElement('div');
    toast.className = 'wishlist-toast';
    toast.innerText = message;

    document.body.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('fade-out');
        setTimeout(() => toast.remove(), 500);
    }, 2000);
}
</script>
<%
    
    double currentBalance = 0.0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement ps = conn.prepareStatement("SELECT wallet_balance FROM customers WHERE id = ?");
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            currentBalance = rs.getDouble("wallet_balance");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div id="addCashModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%);
    background:white; padding:30px; border-radius:10px; box-shadow:0 0 20px rgba(0,0,0,0.2); z-index:1000; width:320px;">
    <h3 style="margin-bottom:15px;">Add Money to Wallet</h3>
    <p style="margin-bottom:15px; font-size:15px; color:#2c3e50;">
        💼 Current Balance: <strong style="color:#27ae60;">₹<%= String.format("%.2f", currentBalance) %></strong>
    </p>
    <form action="AddCashServlet" method="post">
        <input type="number" name="amount" placeholder="Enter amount (₹)" min="1" required
            style="width:100%; padding:10px; margin-bottom:15px; border-radius:5px; border:1px solid #ccc;" />
        <button type="submit" style="width:100%; background-color:#27ae60; color:white; padding:10px; border:none; border-radius:5px; cursor:pointer;">Add</button>
    </form>
    <button onclick="closeAddCashPopup()" style="margin-top:10px; background:none; border:none; color:red; cursor:pointer;">Close</button>
</div>

<script>
    function openAddCashPopup() {
        document.getElementById("addCashModal").style.display = "block";
    }
    function closeAddCashPopup() {
        document.getElementById("addCashModal").style.display = "none";
    }
</script>
<script>
function updateCartCountFromServer() {
    fetch("<%= request.getContextPath() %>/CartCountServlet")
        .then(res => res.json())
        .then(data => {
            const cartCountEl = document.getElementById("cartCount");
            if (cartCountEl && data.count !== undefined) {
                cartCountEl.textContent = data.count;
            }
        })
        .catch(err => {
            console.error("🛒 Failed to update cart count:", err);
        });
}

document.addEventListener("DOMContentLoaded", function () {
    updateCartCountFromServer(); // Initial count

    // Auto-refresh every 3 seconds (optional)
    setInterval(updateCartCountFromServer, 3000);
});
</script>

</body>
</html>
