<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<style>
    .theme-toggle {
        position: fixed;
        top: 20px;
        right: 30px;
        z-index: 1000;
        padding: 10px 16px;
        background: #ffffffcc;
        color: #222;
        border: 2px solid #ccc;
        border-radius: 50%;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
        transition: all 0.3s ease;
        backdrop-filter: blur(8px);
    }

    .theme-toggle:hover {
        transform: scale(1.1);
        box-shadow: 0 0 12px rgba(0, 123, 255, 0.5);
    }

    body.light {
        background: linear-gradient(to right, #f8f9fa, #e0eafc);
        color: #111;
    }

    body.dark {
        background: linear-gradient(to right, #1c1c1c, #2a2a2a);
        color: #eee;
    }

    /* Ensure the dashboard container glow is always visible */
    .dashboard-container {
        background-color: white !important;
        color: #222;
    }
    .dashboard-container {
    position: relative;
    text-align: center;
    background-color: black;
    padding: 40px 50px;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    z-index: 1;
    overflow: hidden;
    box-shadow:
        0 0 30px rgba(0, 123, 255, 0.3), /* outer glow */
        0 0 60px rgba(0, 123, 255, 0.2), /* soft secondary glow */
        0 10px 30px rgba(0, 0, 0, 0.1);  /* base shadow */
    transition: box-shadow 0.4s ease;
}
    

    .dashboard-container::before {
        filter: blur(4px);
        z-index: -1;
        animation: borderGlowRotate 4s linear infinite;
    }

    @keyframes borderGlowRotate {
        0% {
            background-position: 0% 50%;
        }
        50% {
            background-position: 100% 50%;
        }
        100% {
            background-position: 0% 50%;
        }
    }
    .dashboard-container::before {
    content: '';
    position: absolute;
    top: -4px;
    left: -4px;
    width: calc(100% + 8px);
    height: calc(100% + 8px);
    background: linear-gradient(60deg, #00c3ff, #005bea, #00c3ff);
    background-size: 300% 300%;
    border-radius: 22px;
    z-index: -1;
    animation: borderGlowRotate 6s linear infinite;
    filter: blur(8px);
    opacity: 1;
    transition: opacity 0.4s ease;
    box-shadow: 0 0 30px rgba(0, 123, 255, 0.5),
                0 0 60px rgba(0, 123, 255, 0.3);
}
    
</style>



    <meta charset="UTF-8">
    <title>Seller Dashboard</title>
    <style>
    
    /* Always keep the container bright for glow to be visible */
.dashboard-container {
    background-color: white !important;
    color: #222;
    position: relative;
    padding: 40px 50px;
    border-radius: 20px;
    z-index: 1;
    overflow: hidden;
    box-shadow:
        0 0 30px rgba(0, 123, 255, 0.3),
        0 0 60px rgba(0, 123, 255, 0.2),
        0 10px 30px rgba(0, 0, 0, 0.1);
    transition: box-shadow 0.4s ease;


}

/* Glowing animated border */
.dashboard-container::before {
    content: '';
    position: absolute;
    top: -4px;
    left: -4px;
    width: calc(100% + 8px);
    height: calc(100% + 8px);
    background: linear-gradient(60deg, #00c3ff, #005bea, #00c3ff);
    background-size: 300% 300%;
    border-radius: 22px;
    z-index: -1;
    animation: borderGlowRotate 6s linear infinite;
    filter: blur(8px);
    opacity: 1;
    transition: opacity 0.4s ease;
    box-shadow: 0 0 30px rgba(0, 123, 255, 0.5),
                0 0 60px rgba(0, 123, 255, 0.3);
}



/* Glow animation */
@keyframes borderGlowRotate {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

/* Dark and light theme just affect body bg and text color */
body.light {
    background: linear-gradient(to right, #f8f9fa, #e0eafc);
    color: #111;
}

body.dark {
    background: linear-gradient(to right, #1c1c1c, #2a2a2a);
    color: #eee;
}
    
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f8f9fa, #e0eafc);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .dashboard-container {
    position: relative;
    text-align: center;
    background-color: white;
    padding: 40px 50px;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    z-index: 1;
    overflow: hidden;
 
}

.dashboard-container {
    position: relative;
    text-align: center;
    background-color: white;
    padding: 40px 50px;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    z-index: 1;
    overflow: hidden;
    box-shadow:
        0 0 30px rgba(0, 123, 255, 0.3), /* outer glow */
        0 0 60px rgba(0, 123, 255, 0.2), /* soft secondary glow */
        0 10px 30px rgba(0, 0, 0, 0.1);  /* base shadow */
    transition: box-shadow 0.4s ease;
  <div class="cart-animation">🛒</div>
     
}

.dashboard-container::before {
    content: '';
    position: absolute;
    top: -3px;
    left: -3px;
    width: calc(100% + 6px);
    height: calc(100% + 6px);
    background: linear-gradient(45deg, #f7b6d6, #ffffff, #f7b6d6);
    border-radius: 22px;
    z-index: -1;
    animation: borderGlowRotate 4s linear infinite;
    background-size: 400% 400%;
    filter: blur(4px);
    
}

@keyframes borderGlowRotate {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}


        .dashboard-container h1 {
            font-size: 32px;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .dashboard-buttons button {
            display: block;
            width: 250px;
            margin: 15px auto;
            padding: 15px 25px;
            font-size: 18px;
            border: none;
            border-radius: 30px;
            background-color:#6a8cb8  ;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .dashboard-buttons button:hover {
            background-color: #90b0d8;
            transform: scale(1.05);
        }

        .emoji {
            margin-right: 10px;
        }
 .cart-animation {
    position: absolute;
    top: calc(50% - 231px); /* your original position */
    left: calc(50% + 165px); /* your original position */
    transform: translateX(-50%);
    font-size: 36px;
    animation: cartSlideLeft 4s ease-out forwards;
    z-index: 5;
}

@keyframes cartSlideLeft {
    from { transform: translateX(-50%) translateX(0); }
    to   { transform: translateX(-50%) translateX(-325px); }
}
body.dark .dashboard-container {
    box-shadow:
        0 0 10px #0ff,     /* inner soft cyan */
        0 0 20px #0ff,     /* mid cyan */
        0 0 10px #0ff,     /* outer cyan */
        0 0 10px #0ff,     /* strong glow */
        0 0 30px #0ff inset; /* subtle inset glow */
}

        
    </style>
</head>
<body>
<button id="themeToggle" class="theme-toggle" onclick="toggleTheme()">🌙</button>


<div class="cart-animation">🛒</div>
    <div class="dashboard-container">
    
        <h1>Welcome Seller 🛒</h1>
        <div class="dashboard-buttons">
            <button onclick="location.href='add_product.jsp'"><span class="emoji">➕</span>Add New Product</button>
            <button onclick="location.href='manage_products.jsp'"><span class="emoji">📦</span>Manage Products</button>
            <button onclick="location.href='index.jsp'"><span class="emoji">🚪</span>Logout</button>
        </div>
    </div>
    <script>
    window.addEventListener("DOMContentLoaded", () => {
        const params = new URLSearchParams(window.location.search);
        if (params.get("added") === "true") {
            showToast("✅ Product added successfully!");
        }
    });

    function showToast(message) {
        const toast = document.createElement("div");
        toast.textContent = message;
        toast.style.position = "fixed";
        toast.style.top = "100px";
        toast.style.right = "20px";
        toast.style.background = "#27ae60";
        toast.style.color = "#fff";
        toast.style.padding = "12px 20px";
        toast.style.borderRadius = "8px";
        toast.style.fontSize = "16px";
        toast.style.fontWeight = "bold";
        toast.style.boxShadow = "0 4px 12px rgba(0,0,0,0.2)";
        toast.style.zIndex = 9999;
        toast.style.opacity = 1;
        toast.style.transition = "opacity 2s ease-out";

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = "0";
            setTimeout(() => toast.remove(), 2000);
        }, 3000);
    }
</script>
    <script>
    function toggleTheme() {
        const body = document.body;
        const isDark = body.classList.contains("dark");

        body.classList.toggle("dark");
        body.classList.toggle("light");

        // Save theme
        localStorage.setItem("theme", isDark ? "light" : "dark");

        // Update toggle icon
        document.getElementById("themeToggle").textContent = isDark ? "🌙" : "🌞";
    }

    // On page load
    window.onload = function () {
        const savedTheme = localStorage.getItem("theme") || "light";
        document.body.classList.add(savedTheme);
        document.getElementById("themeToggle").textContent = savedTheme === "dark" ? "🌞" : "🌙";
    };
</script>

    
</body>
</html>
