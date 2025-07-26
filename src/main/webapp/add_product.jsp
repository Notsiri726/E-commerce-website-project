<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<style>
/* Global Dark Theme */
body.dark {
    background: linear-gradient(to right, #1c1c1c, #2a2a2a);
    color: #1a1a1a;
}

/* Heading & Label Styles */
body.dark h1,
body.dark h2,
body.dark label,
body.dark .form-label {
    color: #ffffff !important;
    font-weight: bold;
}

/* Make input fields light in dark mode */
body.dark input,
body.dark textarea,
body.dark select {
    background-color: #ffffff !important;
    color: #000000 !important;
    border: 1px solid #999;
}

/* Placeholder styling in dark mode */
body.dark input::placeholder,
body.dark textarea::placeholder {
    color: #555;
}
</style>

<script>
// Apply saved theme on page load
window.onload = function () {
    const savedTheme = localStorage.getItem("theme") || "light";
    document.body.classList.add(savedTheme);
};
</script>
<style>
/* Force black color on all label-related elements in dark mode */
body.dark label,
body.dark .form-label,
body.dark h2,
body.dark h3,
body.dark span,
body.dark legend,
body.dark p {
    color: #000 !important;
    font-weight: bold !important;
}

/* Keep input, textarea, and select fields white with dark text */
body.dark input,
body.dark textarea,
body.dark select {
    background-color: #fff !important;
    color: #000 !important;
    border: 1px solid #999 !important;
}

/* Optional: Placeholder styling */
body.dark input::placeholder,
body.dark textarea::placeholder {
    color: #555 !important;
}
</style>




<script>
// Apply saved theme on page load
window.onload = function () {
    const savedTheme = localStorage.getItem("theme") || "light";
    document.body.classList.add(savedTheme);
};
</script>

    <meta charset="UTF-8">
    <title>Add Product</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f1f1f1;
            padding: 30px;
        }

        .form-container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 14px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>


    <div class="form-container">
        <h2>➕ Add New Product</h2>
        <form action="AddProductServlet" method="post" enctype="multipart/form-data">
            <label>Product Name</label>
            <input type="text" name="name" required>

            <label>Price (₹)</label>
            <input type="number" name="price" step="0.01" required>

            <label>Short Description</label>
            <textarea name="description" rows="3" required></textarea>

            <label>Full Description</label>
            <textarea name="full_description" rows="4"></textarea>

            <label>Category</label>
            <select name="category" required>
                <option value="electronics">Electronics</option>
                <option value="fashion">Fashion</option>
                <option value="jewellery">Jewellery</option>
                <option value="general">General</option>
            </select>

            <label>Hot Deal?</label>
<select name="isHot">  <!-- FIXED -->
    <option value="0">No</option>
    <option value="1">Yes</option>
</select>

            <label>Image 1 (Primary)</label>
            <input type="file" name="image1" accept="image/*" required>

            <label>Image 2 (Optional)</label>
            <input type="file" name="image2" accept="image/*">

            <button type="submit">✅ Add Product</button>
        </form>
    </div>
    <script>
    // Apply saved theme on page load
    window.onload = function () {
        const savedTheme = localStorage.getItem("theme") || "light";
        document.body.classList.add(savedTheme);
    };
</script>
 <style>
/* Fix: Make labels & headings pure black in dark theme */
body.dark label,
body.dark h1,
body.dark h2,
body.dark h3,
body.dark h4,
body.dark h5,
body.dark h6,
body.dark span.title,
body.dark .form-label {
    color: #000000 !important;
    font-weight: bold;
}

/* Keep general text readable */
body.dark,
body.dark p,
body.dark td,
body.dark th {
    color: #1a1a1a !important;
}

/* Optional: Brighter placeholders */
body.dark input::placeholder,
body.dark textarea::placeholder {
    color: #555555 !important;
}
</style>


    
</body>
</html>
