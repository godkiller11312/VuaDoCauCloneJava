package com.vuadocau.model;

import java.math.BigDecimal;

public class Product {
    private int id;
    private String name;
    private BigDecimal price;
    private String image;
    private double rating;
    private int purchased;
    private String tag;

    public int getId(){ return id; }
    public void setId(int id){ this.id = id; }
    public String getName(){ return name; }
    public void setName(String name){ this.name = name; }
    public BigDecimal getPrice(){ return price; }
    public void setPrice(BigDecimal price){ this.price = price; }
    public String getImage(){ return image; }
    public void setImage(String image){ this.image = image; }
    public double getRating(){ return rating; }
    public void setRating(double rating){ this.rating = rating; }
    public int getPurchased(){ return purchased; }
    public void setPurchased(int purchased){ this.purchased = purchased; }
    public String getTag(){ return tag; }
    public void setTag(String tag){ this.tag = tag; }
}
