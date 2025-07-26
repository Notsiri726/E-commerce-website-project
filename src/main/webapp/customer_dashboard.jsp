<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Set, java.util.HashSet" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Boolean wishlistRemoved = (Boolean) session.getAttribute("wishlistRemoved");
    Boolean wishlistAdded = (Boolean) session.getAttribute("wishlistAdded");
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

%>
<%
    // Fetch wishlist product IDs for current customer
    Set<Integer> wishlistProductIds = new HashSet<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement stmt = conn.prepareStatement("SELECT product_id FROM wishlist WHERE customer_id = ?");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            wishlistProductIds.add(rs.getInt("product_id"));
        }
        conn.close();
    } catch (Exception e) {
        // log error if needed
    }
%>

<%
String selectedCategory = request.getParameter("category");
String query = "SELECT * FROM products WHERE is_hot = 1";


if (selectedCategory != null && !selectedCategory.isEmpty()) {
    query += " WHERE category = '" + selectedCategory + "' AND is_hot = 0";
} else {
    query += " WHERE is_hot = 1";
}

%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
          
            background-color: #dfe6e9;
            transition: background-color 0.3s, color 0.3s;
        }

        body.dark-mode {
            background-color: #1c1c1c;
            color: #fff;
        }

        .toast {
            position: fixed;
            top: 100px;
            right: 20px;
            padding: 12px 20px;
            border-radius: 18px;
            color: white;
            z-index: 999;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            animation: fadeout 3s forwards;
        }

        .toast.success { background-color: #27ae60; }
        .toast.danger { background-color: #e74c3c; }

        @keyframes fadeout {
            0% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; display: none; }
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

         .sidebar button:hover {
        background-color: #e3f1f1 !important;
    }

        .main {
    margin-left: 240px; /* ✅ Leaves room for the fixed sidebar */
    padding: 30px 50px;
}

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .search-bar {
            display: flex;
            align-items: center;
        }

        .search-bar input {
            padding: 12px 16px;
            width: 420px;
            border-radius: 30px;
            border: 1px solid #ccc;
            font-size: 16px;
            outline: none;
            transition: box-shadow 0.3s;
        }

        .search-bar input:focus {
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.5);
        }

        .dark-toggle {
            margin-left: 20px;
            cursor: pointer;
            font-size: 24px;
        }

        .hot-deals {
            font-size: 30px;
            color: #e67e22;
            font-weight: bold;
            margin: 20px 0 10px;
            animation: glow 1.5s infinite alternate;
        }

        @keyframes glow {
            from { text-shadow: 0 0 5px #e67e22; }
            to { text-shadow: 0 0 20px #e67e22, 0 0 30px #e67e22; }
        }

        .categories {
            margin: 20px 0;
        }

        .categories button {
            padding: 10px 22px;
            margin-right: 10px;
            background-color: #2980b9;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s;
        }

        .categories button:hover {
            background-color: #3498db;
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
.dark-mode .product-card .description {
    color: #F00024; /* You can choose any light color you prefer */
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

        .product-card .price {
            color: #27ae60;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .wishlist-form button {
            background: none;
            border: none;
            font-size: 22px;
            color: #e74c3c;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .wishlist-form button:hover {
            transform: scale(1.3);
        }

        @media (max-width: 768px) {
            .search-bar input {
                width: 250px;
            }
        }
        .category-button {
    background: linear-gradient(135deg, #74b9ff, #a29bfe);
    padding: 12px 24px;
    color: white;
    border-radius: 30px;
    text-decoration: none;
    font-weight: 600;
    font-size: 16px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.category-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}
        
    </style>
    <style>
    #scrollToTopBtn {
        position: fixed;
        bottom: 80px;
        right: 30px;
        background: rgba(255, 255, 255, 0.15);
        border: 2px solid #74b9ff;
        color: #74b9ff;
        padding: 12px 16px;
        border-radius: 50%;
        cursor: pointer;
        font-size: 24px;
        z-index: 999;
        backdrop-filter: blur(6px);
        box-shadow: 0 0 12px rgba(116, 185, 255, 0.5);
        transition: all 0.3s ease;
        display: none;
        animation: floatGlow 2s infinite ease-in-out;
    }

    #scrollToTopBtn:hover {
        transform: scale(1.1);
        box-shadow: 0 0 20px #74b9ff;
    }

    @keyframes floatGlow {
        0%   { box-shadow: 0 0 10px #74b9ff; }
        50%  { box-shadow: 0 0 20px #a29bfe; }
        100% { box-shadow: 0 0 10px #74b9ff; }
    }
    .fixed-icons {
    position: fixed;
    top: 20px;
    right: 20px;
    display: flex;
    gap: 16px;
    z-index: 999;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease;
}

.fixed-icons.show {
    opacity: 1;
    visibility: visible;
}

.fixed-icons .icon-btn {
    background: rgba(255, 255, 255, 0.15);
    border: 2px solid #2980b9;
    color: #2980b9;
    border-radius: 50%;
    font-size: 22px;
    padding: 10px 13px;
    backdrop-filter: blur(6px);
    box-shadow: 0 0 12px rgba(52, 152, 219, 0.4);
    cursor: pointer;
    transition: all 0.3s ease;
}

.dark-mode .fixed-icons .icon-btn {
    border-color: #f1c40f;
    color: #f1c40f;
    box-shadow: 0 0 12px rgba(241, 196, 15, 0.4);
}

.fixed-icons .icon-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 0 18px currentColor;
}
    html {
  scroll-behavior: smooth;
}
    .topbar-buttons {
    display: flex;
    align-items: center;
    gap: 20px;
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
<script>
    // Scroll-to-top visibility toggle
    window.onscroll = function () {
        const btn = document.getElementById("scrollToTopBtn");
        if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
            btn.style.display = "block";
        } else {
            btn.style.display = "none";
        }
    };

    // Scroll to top function
    function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'  // ✅ This line enables smooth animation
    });
}

</script>
    

    
</head>


<body>
<div class="background-glass-layer"></div>






<% if (wishlistRemoved != null && wishlistRemoved) { %>
    <div class="toast danger">❌ Removed from your Wishlist!</div>
    <% session.removeAttribute("wishlistRemoved"); %>
<% } else if (wishlistAdded != null && wishlistAdded) { %>
    <div class="toast success">♥ Added to your Wishlist!</div>
    <% session.removeAttribute("wishlistAdded"); %>
<% } %>

<div class="sidebar">

    <button onclick="location.href='profile.jsp'" style="
        margin-bottom: 12px;
        padding: 12px 16px;
        background-color: white;
        color: #333;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 16px;
        text-align: left;
        cursor: pointer;
    ">👤 My Profile</button>

    <button onclick="location.href='my_orders.jsp'" style="
        margin-bottom: 12px;
        padding: 12px 16px;
        background-color: white;
        color: #333;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 16px;
        text-align: left;
        cursor: pointer;
    ">📦 My Orders</button>

    <button onclick="location.href='wishlist.jsp'" style="
        margin-bottom: 12px;
        padding: 12px 16px;
        background-color: white;
        color: #333;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 16px;
        text-align: left;
        cursor: pointer;
    ">❤️ My Wishlist</button>
    
    <button onclick="openAddCashPopup()" style="
    margin-bottom: 12px;
    padding: 12px 16px;
    background-color: white;
    color: #333;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 16px;
    text-align: left;
    cursor: pointer;
">💰 Add Cash</button>
    

    <button onclick="location.href='index.jsp'" style="
        margin-bottom: 12px;
        padding: 12px 16px;
        background-color: white;
        color: #333;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 16px;
        text-align: left;
        cursor: pointer;
    ">🚪 Logout</button>
    
    
</div>


<div class="main">
    <div class="topbar" style="display: flex; justify-content: space-between; align-items: center;">
     <a href="customer_dashboard.jsp" class="icon-btn" title="Home"><h1>🏠</h1></a>
    <h1>Welcome to CyroKart 🛍️</h1>

    <!-- 🔍 Search + Dark Mode + Cart -->
<div style="display: flex; align-items: center; gap: 20px;">
    
    <!-- ✅ Wrap input in form -->
    <form action="search.jsp" method="get" style="display: flex; align-items: center; gap: 10px;">
        <input type="text" name="query" placeholder="Search for products..." 
               style="padding: 12px 16px; border-radius: 30px; border: 1px solid #ccc; font-size: 16px;">
        <button type="submit" style="padding: 8px 16px; border-radius: 25px; border: none; background-color: #2980b9; color: white;">
            🔍
        </button>
    </form>

    <!-- Dark Mode Toggle -->
    <span class="dark-toggle" onclick="toggleDarkMode()" id="modeIcon" style="cursor: pointer;">🌙</span>

    <!-- Cart Icon -->
    <a href="cart.jsp" style="text-decoration: none; font-size: 18px; color: inherit;">
        🛒 <strong>Cart (<span id="cartCount"><%= cartCount %></span>)</strong>
    </a>
</div>

</div>


    <div class="hot-deals">🔥 Grab your best deals with CyroKart</div>

    <div class="categories" style="margin: 30px 0; display: flex; gap: 16px; flex-wrap: wrap;">
    <a href="electronics.jsp" class="category-button">📱 Electronics</a>
    <a href="fashion.jsp" class="category-button">👗 Fashion</a>
    <a href="jewellery.jsp" class="category-button">💎 Jewellery</a>
    <a href="general.jsp" class="category-button">📦 General</a>
</div>



    <div class="products">
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM products");

                while (rs.next()) {
        %>
        <div class="product-card">
   <%
    int productId = rs.getInt("id");
    boolean inWishlist = wishlistProductIds.contains(productId);
%>
<div class="product-card" style="<%= inWishlist ? "background-color: #ffe6e6;" : "" %>">
    <a href="product.jsp?id=<%= productId %>" style="text-decoration: none; color: inherit;">
        <img src="<%= request.getContextPath() %>/<%= rs.getString("image_url") %>" alt="Product Image">
        <div class="description"><%= rs.getString("name") %></div>
        <div class="price">₹<%= rs.getString("price") %></div>
    </a>

    <!-- ♥ Wishlist Form Button -->
  <form onsubmit="highlightAndAddToWishlist(event, <%= productId %>, this)" style="margin-top: 8px;">
    <button type="submit" 
            title="Add to Wishlist" 
            style="background: none; border: none; cursor: pointer; font-size: 20px;">
        <span class="heart-icon"><%= inWishlist ? "❤️" : "🤍" %></span>
    </button>
</form>



</div>


  

</div>
   
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("Error loading products: " + e.getMessage());
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

        // Save preference in cookie
        document.cookie = "darkMode=" + (darkModeEnabled ? "true" : "false") + "; path=/";
    }

    // Apply dark mode on page load if cookie is set
    window.onload = function () {
        if (document.cookie.includes("darkMode=true")) {
            document.body.classList.add("dark-mode");
            const modeIcon = document.getElementById("modeIcon");
            if (modeIcon) modeIcon.textContent = "☀️";
        }
    };
</script>




<script>
function addToWishlist(event, productId) {
    event.preventDefault(); // ✅ prevent form submit & scroll

    fetch('AddToWishlistServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + encodeURIComponent(productId)
    })
    .then(response => response.text()) // We're not returning JSON from servlet
    .then(() => {
        showWishlistToast("Added to your Wishlist ✅");
    })
    .catch(() => {
        showWishlistToast("Something went wrong ❌");
    });
}

function showWishlistToast(message) {
    const toast = document.createElement("div");
    toast.className = "wishlist-toast";
    toast.innerText = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.classList.add("fade-out");
        setTimeout(() => toast.remove(), 500);
    }, 2500);
}
</script>


<style>
.wishlist-toast {
    position: fixed;
    bottom: 30px;
    right: 30px;
    background-color: #28a745; /* Green success */
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
}

@keyframes slideIn {
    from {
        transform: translateY(20px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}
.fixed-icons {
    position: fixed;
    top: 20px;
    right: 20px;
    display: flex;
    gap: 16px;
    z-index: 999;
}

.fixed-icons .icon-btn {
    background: rgba(255, 255, 255, 0.15);
    border: 2px solid #2980b9;
    color: #2980b9;
    border-radius: 50%;
    font-size: 22px;
    padding: 10px 13px;
    backdrop-filter: blur(6px);
    box-shadow: 0 0 12px rgba(52, 152, 219, 0.4);
    cursor: pointer;
    transition: all 0.3s ease;
}

.dark-mode .fixed-icons .icon-btn {
    border-color: #f1c40f;
    color: #f1c40f;
    box-shadow: 0 0 12px rgba(241, 196, 15, 0.4);
}

.fixed-icons .icon-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 0 18px currentColor;
}

</style>
<script>
function highlightAndAddToWishlist(event, productId, form) {
    event.preventDefault(); // Prevent form submission scroll

    fetch('AddToWishlistServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + encodeURIComponent(productId)
    })
    .then(response => response.text())
    .then(() => {
        // ✅ Highlight the product card
        const productCard = form.closest(".product-card");
        if (productCard) {
            productCard.style.backgroundColor = "#ffe6e6";
        }

        // ✅ Update heart icon
        const heartIcon = form.querySelector(".heart-icon");
        if (heartIcon) {
            heartIcon.innerText = "❤️";
        }

        // ✅ Show toast
        showWishlistToast("Added to your Wishlist ✅");
    })
    .catch(() => {
        showWishlistToast("Something went wrong ❌");
    });
}

function showWishlistToast(message) {
    const toast = document.createElement("div");
    toast.innerText = message;
    toast.className = "wishlist-toast";
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.classList.add("fade-out");
        setTimeout(() => toast.remove(), 500);
    }, 2500);
}
</script>

<button id="scrollToTopBtn" onclick="scrollToTop()">⬆️</button>
<script>
function toggleDarkMode() {
    document.body.classList.toggle("dark-mode");
}

// Show floating icons only after scrolling 300px
window.addEventListener("scroll", function () {
    const floatingIcons = document.getElementById("floatingIcons");
    if (window.scrollY > 300) {
        floatingIcons.classList.add("show");
    } else {
        floatingIcons.classList.remove("show");
    }
});

</script>
<!-- Add Cash Modal -->
<%
    // customerId already declared above — don't redeclare
    double currentBalance = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

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


<!-- Overlay -->
<div id="overlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.5); z-index:999;" onclick="closeAddCashPopup()"></div>

<script>
    function openAddCashPopup() {
        document.getElementById('addCashModal').style.display = 'block';
        document.getElementById('overlay').style.display = 'block';
    }
    function closeAddCashPopup() {
        document.getElementById('addCashModal').style.display = 'none';
        document.getElementById('overlay').style.display = 'none';
    }
</script>

<% String cashAdded = request.getParameter("cashAdded"); %>
<% if ("true".equals(cashAdded)) { %>
    <div id="toast" style="position: fixed; bottom: 30px; right: 30px; background: #27ae60; color: white; padding: 16px 24px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.3); z-index: 9999;">
        💰 Cash added to your wallet!
    </div>
    <script>
        setTimeout(() => {
            const toast = document.getElementById("toast");
            if (toast) toast.style.display = "none";
        }, 3000);
    </script>
<% } %>
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


