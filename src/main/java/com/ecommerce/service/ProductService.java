package com.ecommerce.service;

import com.ecommerce.model.Product;
import com.ecommerce.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public Product getProductById(int id) {
        return productRepository.findById(id);
    }

    public List<Product> searchAndFilter(String keyword, String category, String sortBy) {
        return productRepository.searchAndFilter(keyword, category, sortBy);
    }

    public List<String> getAllCategories() {
        return productRepository.findAllCategories();
    }
}
