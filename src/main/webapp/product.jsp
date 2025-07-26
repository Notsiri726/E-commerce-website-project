<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Set, java.util.HashSet" %>


<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    Set<Integer> wishlistProductIds = new HashSet<>();

    if (customerId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            PreparedStatement ps = conn.prepareStatement("SELECT product_id FROM wishlist WHERE customer_id = ?");
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                wishlistProductIds.add(rs.getInt("product_id"));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<% String buyNowError = (String) session.getAttribute("buyNowError");
   if (buyNowError != null) { %>
   <div style="color: red; font-weight: bold;"><%= buyNowError %></div>
   <% session.removeAttribute("buyNowError");
} %>


<%
String method = request.getMethod();
int productId = -1;

if (method.equalsIgnoreCase("GET")) {
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("customer_dashboard.jsp");
        return;
    }
    productId = Integer.parseInt(idParam);
} else {
    String pid = request.getParameter("productId");
    if (pid != null && !pid.trim().isEmpty()) {
        productId = Integer.parseInt(pid);
    }
}



    String name = "", description = "", image1 = "", image2 = "", price = "", full_description = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
        stmt.setInt(1, productId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            image1 = rs.getString("image_url");
            image2 = rs.getString("image_url_2");
            price = rs.getString("price");
           full_description = rs.getString("full_description");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error fetching product: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= name %> | Product Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            padding: 40px;
            background-color: #f4f4f4;
            color: #000;
            transition: background-color 0.3s, color 0.3s;
        }
        body.dark-mode {
            background-color: #121212;
            color: #fff;
        }
        .theme-toggle {
            position: absolute;
            top: 20px;
            right: 30px;
            font-size: 24px;
            cursor: pointer;
        }
        .container {
            display: flex;
            max-width: 1000px;
            margin: auto;
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            flex-direction: column;
        }
        body.dark-mode .container {
            background-color: #1e1e1e;
        }
        .product-section {
            display: flex;
        }
        .product-image {
            flex: 1;
            padding-right: 30px;
            text-align: center;
        }
        .product-image img {
            width: 100%;
            max-height: 480px;
            object-fit: contain;
            border-radius: 12px;
            transition: opacity 0.3s;
        }
        .switcher-buttons {
            margin-top: 15px;
        }
        .switcher-buttons button {
            padding: 8px 14px;
            margin: 0 5px;
            border: none;
            border-radius: 50%;
            font-size: 14px;
            cursor: pointer;
            background-color: #ddd;
        }
        .switcher-buttons button.active {
            background-color: #2980b9;
            color: white;
        }
        .details {
            flex: 1;
        }
        .details h1 {
            font-size: 30px;
            margin-bottom: 20px;
        }
        .details p {
            font-size: 16px;
            margin-bottom: 20px;
        }
        .price {
            font-size: 22px;
            font-weight: bold;
            color: #27ae60;
            margin-bottom: 20px;
        }
        .buttons {
            display: flex;
            gap: 15px;
        }
        .buttons button {
            padding: 18px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
        }
        .add-cart {
            background-color: #2980b9;
            color: white;
        }
        .buy-now {
            background-color: #e67e22;
            color: white;
        }
        .buttons button:hover {
            opacity: 0.9;
        }
        body.dark-mode .add-cart {
            background-color: #3498db;
        }
        body.dark-mode .buy-now {
            background-color: #f39c12;
        }
        .ratings-section {
            margin-top: 40px;
        }
        .ratings-section h2 {
            font-size: 24px;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .dark-mode .ratings-section h2 {
            color: #f1f1f1;
        }
        .rating-summary {
            display: flex;
            gap: 40px;
            margin-bottom: 30px;
        }
        .avg-rating {
            font-size: 32px;
            font-weight: bold;
            color: #27ae60;
            margin-bottom: 10px;
        }
        .bar-graph .bar-row {
            display: flex;
            align-items: center;
            margin-bottom: 6px;
            font-size: 14px;
        }
        .bar-graph .bar {
            flex: 1;
            height: 10px;
            background-color: #ddd;
            margin: 0 10px;
            border-radius: 10px;
            overflow: hidden;
        }
        .bar-graph .fill {
            height: 100%;
            background-color: #3498db;
        }
        .user-reviews h3 {
            font-size: 20px;
            margin-bottom: 15px;
        }
        .review {
            background-color: #f9f9f9;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .dark-mode .review {
            background-color: #2d2d2d;
            color: #ddd;
        }
        .review-header {
            font-weight: bold;
            margin-bottom: 8px;
            color: #2c3e50;
        }
        .dark-mode .review-header {
            color: #fff;
        }
        .review-form {
            margin-top: 30px;
            background: #fafafa;
            padding: 20px;
            border-radius: 12px;
        }
        .dark-mode .review-form {
            background: #222;
        }
        .review-form textarea {
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-family: 'Poppins';
            margin-bottom: 10px;
        }
        .review-form select, .review-form button {
            padding: 10px 15px;
            margin-right: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .review-form button {
            background: #27ae60;
            color: white;
            font-weight: bold;
            border: none;
        }
        
        .product-description-container {
    max-width: 600px;
    line-height: 1.6;
    font-size: 16px;
    color: #444;
}

.product-description {
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 4; /* show only 4 lines */
    -webkit-box-orient: vertical;
    text-overflow: ellipsis;
}

.product-description.expanded {
    -webkit-line-clamp: unset;
    display: block;
}
.dark-mode .product-description {
    color: #f1f1f1; /* or any light color that fits your theme */
}

.read-more-btn {
    margin-top: 10px;
    background: none;
    border: none;
    color: #007bff;
    font-size: 14px;
    cursor: pointer;
    padding: 0;
}
        
        
        
        
        
    </style>


    </head>
<body>
<!-- 🧪 productId debug: <%= productId %> -->

<div class="theme-toggle" onclick="toggleDarkMode()" id="modeIcon">🌙</div>

<div class="container">
    <div class="product-section">
    <div class="product-image">
        <img id="mainImage" src="<%= request.getContextPath() %>/<%= image1 %>" alt="<%= name %>">
        <div class="switcher-buttons">
            <button class="active" onclick="switchImage(0)">1</button>
            <button onclick="switchImage(1)">2</button>
        </div>
    </div>
    <div class="details">
        <h1><%= name %></h1>
        <p><%= description %></p>
        
        <div class="price">₹<%= price %></div>
        <div class="buttons">
    <!-- Buy Now -->
    <form action="BuyNowServlet" method="post" style="display: inline;">
    <input type="hidden" name="productId" value="<%= productId %>">
    <button type="submit" class="buy-now">⚡ Buy Now</button>
</form>



    
   <form id="addToCartForm" method="post">
  <input type="hidden" name="productId" value="<%= productId %>">
  <button type="submit" class="add-cart">🛒 Add to Cart</button>
</form>

</div>

<div class="product-description-container" style="margin-top: 20px;">
    <p id="productDesc" class="product-description" style="max-height: 4.5em; overflow: hidden;">
        <%= full_description %>
    </p>
    <button id="readMoreBtn" class="read-more-btn" onclick="toggleReadMore()" style="margin-top: 8px; background: none; border: none; color: #007bff; cursor: pointer;">
        Read more...
    </button>
</div>


        </div>
    </div>
</div>


    <div class="ratings-section">
        <h2>Customer Ratings & Reviews ⭐</h2>
        <div class="rating-summary">
            <div class="stars">
                <%
    double avgRating = 0.0;
    int totalRatings = 0;
    int[] starCounts = new int[6]; // starCounts[1] = #1★, starCounts[5] = #5★

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

        PreparedStatement countStmt = conn3.prepareStatement("SELECT rating, COUNT(*) as count FROM reviews WHERE product_id = ? GROUP BY rating");
        countStmt.setInt(1, productId);
        ResultSet rsCount = countStmt.executeQuery();

        int ratingSum = 0;
        while (rsCount.next()) {
            int r = rsCount.getInt("rating");
            int count = rsCount.getInt("count");
            starCounts[r] = count;
            ratingSum += r * count;
            totalRatings += count;
        }

        if (totalRatings > 0) {
            avgRating = (double) ratingSum / totalRatings;
        }

        conn3.close();
    } catch (Exception e) {
        out.println("<!-- Error calculating ratings: " + e.getMessage() + " -->");
    }

    String avgText = (totalRatings > 0) ? String.format("%.1f ★", avgRating) : "No ratings yet";
%>
<div class="avg-rating"><%= avgText %></div>

                <div class="bar-graph">
                   <%
    for (int i = 5; i >= 1; i--) {
        int count = starCounts[i];
        int width = (totalRatings > 0) ? (int)(((double)count / totalRatings) * 100) : 0;
%>
    <div class="bar-row">
        <span><%= i %>★</span>
        <div class="bar"><div class="fill" style="width:<%= width %>%"></div></div>
        <span><%= count %></span>
    </div>
<%
    }
%>
                   
                </div>
            </div>
        </div>

       <div class="user-reviews">
    <h3>Top Reviews</h3>
    <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            PreparedStatement reviewStmt = conn2.prepareStatement("SELECT customer_name, rating, review_text FROM reviews WHERE product_id = ? ORDER BY id DESC");
            reviewStmt.setInt(1, productId);
            ResultSet reviewRs = reviewStmt.executeQuery();

            boolean hasReviews = false;

            while (reviewRs.next()) {
                hasReviews = true;
                String reviewer = reviewRs.getString("customer_name");
                int stars = reviewRs.getInt("rating");
                String reviewText = reviewRs.getString("review_text");

                String starIcons = "";
                for (int i = 1; i <= 5; i++) {
                    starIcons += (i <= stars) ? "★" : "☆";
                }
    %>
        <div class="review">
            <div class="review-header"><strong><%= reviewer %></strong> &bull; <%= starIcons %></div>
            <p><%= reviewText %></p>
        </div>
    <%
            }

            if (!hasReviews) {
    %>
        <div class="review">
            <p>No reviews yet. Be the first to write one!</p>
        </div>
    <%
            }

            conn2.close();
        } catch (Exception ex) {
            out.println("<div class='review'><p>Error loading reviews: " + ex.getMessage() + "</p></div>");
        }
    %>
</div>



        <div class="review-form">
    <h3>Write a Review</h3>
    <form id="reviewForm" method="post">
        <%-- Hidden input with safe context --%>
        <% int pid = Integer.parseInt(request.getParameter("id")); %>
        <% String productIdParam = request.getParameter("id"); %>
<input type="hidden" name="productId" value="<%= productIdParam %>">

        <input type="text" name="name" placeholder="Your Name" required><br>
        <label>Rating: </label>
        <select name="rating" required>
            <option value="5">★★★★★</option>
            <option value="4">★★★★☆</option>
            <option value="3">★★★☆☆</option>
            <option value="2">★★☆☆☆</option>
            <option value="1">★☆☆☆☆</option>
        </select><br>
        <textarea name="review" rows="4" placeholder="Write your review..." required></textarea><br>
        <button type="submit">Submit Review</button>
    </form>
</div>



    </div>
</div>

<script>
document.getElementById("reviewForm").addEventListener("submit", function (e) {
    e.preventDefault();

    const form = this;
    const formData = new URLSearchParams(new FormData(form));

    fetch("submitReview", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formData
    })
    .then(res => res.text())
    .then(text => {
        console.log("RAW RESPONSE:", text);

        let data;
        try {
            data = JSON.parse(text);
        } catch (e) {
            alert("❌ Failed to parse server response.");
            console.error("JSON Parse Error:", e);
            return;
        }

        if (data.error) {
            alert("❌ " + data.error);
            return;
        }

        data.rating = parseInt(data.rating);
        if (isNaN(data.rating) || data.rating < 1 || data.rating > 5) {
            console.warn("⚠️ Invalid rating received:", data.rating);
            return;
        }

        const reviewsContainer = document.querySelector(".user-reviews");
        const stars = "★".repeat(data.rating) + "☆".repeat(5 - data.rating);

        const newReview = `
            <div class="review">
                <div class="review-header"><strong>${data.name}</strong> &bull; ${stars}</div>
                <p>${data.review}</p>
            </div>
        `;
        reviewsContainer.insertAdjacentHTML("beforeend", newReview);

        const starRowIndex = 6 - data.rating;
        const starRow = document.querySelector(`.bar-row:nth-child(${starRowIndex})`);
        if (!starRow) {
            console.warn("⚠️ Could not find star bar for rating:", data.rating);
            return;
        }

        const countSpan = starRow.querySelector("span:last-child");
        const fill = starRow.querySelector(".fill");

        let count = parseInt(countSpan.textContent);
        count++;
        countSpan.textContent = count;

        let total = 0;
        document.querySelectorAll(".bar-row span:last-child").forEach(span => {
            total += parseInt(span.textContent);
        });

        document.querySelectorAll(".bar-row").forEach(row => {
            const val = parseInt(row.querySelector("span:last-child").textContent);
            const percent = ((val / total) * 100).toFixed(1);
            row.querySelector(".fill").style.width = percent + "%";
        });

        form.reset();
    })
    .catch(err => {
        alert("Refresh page to load live reviews.");
        console.error("Fetch error:", err);
    });
});
</script>

<script>
function applyDarkMode() {
    const body = document.body;
    const modeIcon = document.getElementById("modeIcon");
    const dark = localStorage.getItem("darkMode") === "true";

    if (dark) {
        body.classList.add("dark-mode");
        modeIcon.textContent = "☀️";
    } else {
        body.classList.remove("dark-mode");
        modeIcon.textContent = "🌙";
    }
}

function toggleDarkMode() {
    const dark = localStorage.getItem("darkMode") === "true";
    localStorage.setItem("darkMode", (!dark).toString());
    applyDarkMode();
}

// This ensures dark mode applies on page load
window.addEventListener("DOMContentLoaded", applyDarkMode);
</script>



<script>
const form = document.getElementById("addToCartForm");
if (form) {
    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const formData = new FormData(form);
        const productId = formData.get("productId");
        console.log("📦 Sending productId:", productId);

        fetch("<%= request.getContextPath() %>/AddToCartServlet", {
            method: "POST",
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                showToast("✅ Added to your cart!");
                const cartCountEl = document.getElementById("cartCount");
                if (cartCountEl) {
                    let current = parseInt(cartCountEl.textContent) || 0;
                    cartCountEl.textContent = current + 1;
                }
            } else {
                showToast("⚠️ " + (data.message || "Failed to add to cart."));
            }
        })
        .catch(err => {
            console.error("🚨 Fetch error:", err);
            showToast("❌ Error adding to cart.");
        });
    });
}

function showToast(message) {
    const toast = document.createElement("div");
    toast.className = "toast success";
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}
</script>



<script>
    const images = [
        "<%= request.getContextPath() %>/<%= image1 %>",
        "<%= request.getContextPath() %>/<%= image2 %>"
    ];

    function switchImage(index) {
        const mainImage = document.getElementById("mainImage");
        const buttons = document.querySelectorAll(".switcher-buttons button");

        if (index >= 0 && index < images.length) {
            mainImage.src = images[index];
        }

        // Toggle active class
        buttons.forEach(btn => btn.classList.remove("active"));
        if (buttons[index]) {
            buttons[index].classList.add("active");
        }
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
    const form = document.getElementById("addToCartForm");
    if (!form) {
        console.error("🚨 Form not found");
        return;
    }

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const productId = form.querySelector("input[name='productId']").value;
        console.log("📦 Sending productId:", productId);

        fetch("<%= request.getContextPath() %>/AddToCartServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "productId=" + encodeURIComponent(productId)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                showToast("✅ Added to your cart!");
                updateCartCountFromServer();  // ✅ live update here
            } else {
                showToast("⚠️ " + (data.message || "Failed to add to cart."));
            }
        })
        .catch(err => {
            console.error("❌ Fetch error:", err);
            showToast("❌ Error adding to cart.");
        });
    });

    function showToast(message) {
        const existing = document.querySelector(".toast");
        if (existing) existing.remove();

        const toast = document.createElement("div");
        toast.className = "toast success";
        toast.textContent = message;
        toast.style.position = "fixed";
        toast.style.bottom = "20px";
        toast.style.right = "30px";
        toast.style.backgroundColor = "#27ae60";
        toast.style.color = "white";
        toast.style.padding = "12px 18px";
        toast.style.borderRadius = "8px";
        toast.style.zIndex = 9999;
        toast.style.boxShadow = "0 4px 8px rgba(0,0,0,0.2)";
        toast.style.fontWeight = "bold";
        document.body.appendChild(toast);
        setTimeout(() => toast.remove(), 3000);
    }
});
</script>

<script>
function toggleReadMore() {
    const desc = document.getElementById("productDesc");
    const btn = document.getElementById("readMoreBtn");

    if (desc.style.maxHeight === "none") {
        desc.style.maxHeight = "4.5em";
        btn.textContent = "Read more...";
    } else {
        desc.style.maxHeight = "none";
        btn.textContent = "Show less";
    }
}
</script>

<script>
function updateCartCount() {
    fetch('CartCountServlet')
        .then(response => response.json())
        .then(data => {
            const count = data.count;
            const cartCountSpan = document.getElementById("cartCount");
            if (cartCountSpan) {
                cartCountSpan.textContent = count;
            }
        })
        .catch(error => console.error('Error fetching cart count:', error));
}

// Call on page load
document.addEventListener("DOMContentLoaded", updateCartCount);
</script>


</body>
</html>

