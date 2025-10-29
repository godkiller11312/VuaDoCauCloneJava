    package com.vuadocau.model;

    import java.math.BigDecimal;

    public class Product {
        private int id;
        private String name;
        private int categoryId;
        private String categoryName;
        private Integer brandId;
        private String brandName;
        private BigDecimal price;
        private String image;
        private String description;
        private int stock;
        private double rating;
        private int purchased;

        // getters/setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public int getCategoryId() { return categoryId; }
        public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

        public Integer getBrandId() { return brandId; }
        public void setBrandId(Integer brandId) { this.brandId = brandId; }

        public String getBrandName() { return brandName; }
        public void setBrandName(String brandName) { this.brandName = brandName; }

        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }

        public String getImage() { return image; }
        public void setImage(String image) { this.image = image; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public int getStock() { return stock; }
        public void setStock(int stock) { this.stock = stock; }

        public double getRating() { return rating; }
        public void setRating(double rating) { this.rating = rating; }

        public int getPurchased() { return purchased; }
        public void setPurchased(int purchased) { this.purchased = purchased; }

    }