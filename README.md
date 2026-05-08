# 🛒 ShopWave – E-Commerce Project (Intermediate Level)

A full-stack mini e-commerce website built with **Spring MVC + Spring JDBC + HTML/CSS/JS**.

---

## 📁 Project Structure

```
ecommerce-project/
├── pom.xml                          ← Maven dependencies
└── src/main/
    ├── java/com/ecommerce/
    │   ├── config/
    │   │   └── DatabaseInitializer.java    ← Creates tables + seeds 12 products
    │   ├── controller/
    │   │   ├── ProductController.java      ← Product listing, search, detail
    │   │   └── CartController.java         ← Cart page, checkout API
    │   ├── model/
    │   │   ├── Product.java
    │   │   ├── Order.java
    │   │   └── OrderItem.java
    │   ├── repository/
    │   │   ├── ProductRepository.java      ← Spring JDBC queries
    │   │   └── OrderRepository.java
    │   └── service/
    │       ├── ProductService.java
    │       └── OrderService.java
    ├── resources/                          ← (empty, using XML config)
    └── webapp/
        ├── WEB-INF/
        │   ├── web.xml                     ← Servlet config
        │   ├── spring-mvc.xml              ← Spring config + DataSource
        │   └── views/
        │       ├── products.jsp            ← Product listing + search + filter
        │       ├── product-detail.jsp      ← Product detail + related products
        │       ├── cart.jsp                ← Cart page (LocalStorage)
        │       ├── checkout.jsp            ← Checkout form + validation
        │       └── order-confirmation.jsp  ← Order success page
        └── static/
            ├── css/style.css              ← Complete responsive stylesheet
            └── js/cart.js                 ← Cart logic (LocalStorage)
```

---

## 🚀 How to Run in AntiGravity IDE

### Step 1 – Import Project
1. Open AntiGravity IDE
2. Go to **File → Open Project** (or **Import Maven Project**)
3. Select the `ecommerce-project` folder
4. Wait for Maven to download dependencies

### Step 2 – Build Project
```bash
mvn clean install -DskipTests
```
Or use the IDE's Maven panel → `Lifecycle → install`

### Step 3 – Run with Tomcat Plugin
```bash
mvn tomcat7:run
```
OR configure a **Tomcat server** in the IDE:
1. Add Tomcat 10+ server in IDE settings
2. Deploy the WAR artifact
3. Start the server

### Step 4 – Open in Browser
```
http://localhost:8080/
```

---

## ✅ Features Implemented

### Phase 1 – Setup ✅
- Spring MVC folder structure (Controllers, Models, Repositories, Services)
- H2 in-memory database (no setup needed!)
- 12 sample products auto-seeded on startup

### Phase 2 – Product Listing ✅
- Beautiful product grid with images, prices, ratings
- Category badges and quick-add buttons

### Phase 3 – Cart System ✅
- Add to cart from listing and detail pages
- Cart persisted in LocalStorage (survives page refresh)
- Update quantities, remove items
- Real-time total calculation with tax + shipping

### Phase 4 – Checkout Simulation ✅
- Full checkout form
- Client-side validation (name, email, card, ZIP, etc.)
- Submits order to Spring backend via REST API
- Order saved to H2 database
- Order confirmation page with order ID

### Phase 5 – Enhancements ✅
- Search products (keyword search across name + description)
- Filter by category (Electronics, Books, Clothing, Home)
- Sort by price (asc/desc) and rating
- Responsive design (works on mobile)
- Toast notifications

---

## 🗃️ Database

Using **H2 In-Memory Database** — zero setup required!
- Resets on every restart (data is re-seeded automatically)
- Tables: `products`, `orders`, `order_items`

To switch to MySQL, update `spring-mvc.xml`:
```xml
<property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
<property name="url" value="jdbc:mysql://localhost:3306/ecommercedb"/>
<property name="username" value="root"/>
<property name="password" value="yourpassword"/>
```
And add MySQL dependency to `pom.xml`.

---

## 🎯 Stretch Goals (To Do)
- [ ] User authentication (Spring Security or mock session)
- [ ] Wishlist feature
- [ ] Admin panel to manage products
- [ ] Payment API integration (Stripe test mode)

---

## 🧠 What You'll Learn
- Spring MVC architecture (Controllers, Views, Models)
- Spring JDBC for database operations
- JSP + JSTL for server-side rendering
- JavaScript DOM manipulation + LocalStorage
- REST APIs with `@ResponseBody`
- Form validation (client + server side)
- Responsive CSS with Flexbox + Grid
