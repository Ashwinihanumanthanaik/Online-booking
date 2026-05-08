package com.ecommerce.controller;

import com.ecommerce.model.Product;
import com.ecommerce.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class ProductController {

    @Autowired
    private ProductService productService;

    // Home / Product Listing Page
    @GetMapping({"/", "/products"})
    public String listProducts(
            @RequestParam(value = "search", required = false, defaultValue = "") String search,
            @RequestParam(value = "category", required = false, defaultValue = "") String category,
            @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
            Model model) {

        List<Product> products = productService.searchAndFilter(search, category, sort);
        List<String> categories = productService.getAllCategories();

        model.addAttribute("products", products);
        model.addAttribute("categories", categories);
        model.addAttribute("search", search);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("totalProducts", products.size());

        return "products";
    }

    // Product Detail Page
    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable("id") int id, Model model) {
        Product product = productService.getProductById(id);
        if (product == null) {
            return "redirect:/products";
        }
        model.addAttribute("product", product);

        // Get related products (same category)
        List<Product> allProducts = productService.searchAndFilter(null, product.getCategory(), null);
        allProducts.removeIf(p -> p.getId() == id);
        if (allProducts.size() > 4) allProducts = allProducts.subList(0, 4);
        model.addAttribute("relatedProducts", allProducts);

        return "product-detail";
    }

    // REST API endpoint for products (JSON)
    @GetMapping("/api/products")
    @ResponseBody
    public List<Product> apiProducts(
            @RequestParam(value = "search", required = false, defaultValue = "") String search,
            @RequestParam(value = "category", required = false, defaultValue = "") String category,
            @RequestParam(value = "sort", required = false, defaultValue = "") String sort) {
        return productService.searchAndFilter(search, category, sort);
    }

    // REST API endpoint for single product (JSON)
    @GetMapping("/api/products/{id}")
    @ResponseBody
    public Product apiProductById(@PathVariable("id") int id) {
        return productService.getProductById(id);
    }
}
