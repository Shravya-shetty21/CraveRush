package com.craverush.config;

import com.craverush.entity.*;
import com.craverush.repository.*;
import com.craverush.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Component
@org.springframework.transaction.annotation.Transactional
public class DatabaseInitializer implements CommandLineRunner {

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private FoodItemRepository foodItemRepository;

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    @Override
    public void run(String... args) throws Exception {
        // 0. Check for generic data or missing profiles and clean up
        boolean needsReseed = false;
        if (restaurantRepository.count() == 0) {
            needsReseed = true;
        } else {
            Restaurant first = restaurantRepository.findAll().get(0);
            if (first.getName().contains("Kitchen") || first.getName().contains("Cafe Delights")) {
                needsReseed = true;
            } else {
                long eatFitCount = restaurantRepository.findAll().stream()
                    .filter(r -> r.getName().contains("EatFit"))
                    .count();
                if (eatFitCount == 0) {
                    needsReseed = true;
                }
            }
        }
        if (needsReseed) {
            entityManager.createNativeQuery("SET FOREIGN_KEY_CHECKS = 0").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE chatbot_logs").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE delivery_assignments").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE delivery_tracking").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE payments").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE order_items").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE orders").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE favorites").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE cart_items").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE carts").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE food_items").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE restaurant_images").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE restaurants").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE categories").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE users").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE admins").executeUpdate();
            entityManager.createNativeQuery("SET FOREIGN_KEY_CHECKS = 1").executeUpdate();
            entityManager.clear();
        }

        // 1. Initialize Admin
        if (adminRepository.count() == 0) {
            Admin admin = new Admin();
            admin.setUsername("admin");
            admin.setEmail("admin@craverush.com");
            admin.setPassword(PasswordUtil.hashPassword("admin123"));
            admin.setRole("SUPER_ADMIN");
            adminRepository.save(admin);
        }

        // 2. Initialize User
        if (userRepository.count() == 0) {
            User user = new User();
            user.setFullName("Rohan Sharma");
            user.setEmail("user@craverush.com");
            user.setPhone("9876543222");
            user.setPassword(PasswordUtil.hashPassword("user123"));
            user.setStatus("ACTIVE");
            userRepository.save(user);
        }

        // 3. Initialize Categories
        if (categoryRepository.count() == 0) {
            String[] catNames = {"South Indian", "North Indian", "Chinese", "Pizza", "Burger", "Desserts", "Beverages", "Breakfast"};
            for (String name : catNames) {
                Category cat = new Category();
                cat.setCategoryName(name);
                categoryRepository.save(cat);
            }
        }

        // 4. Initialize Delivery Partners
        if (deliveryPartnerRepository.count() == 0) {
            String[][] partners = {
                {"Rahul Kumar", "9876543210", "KA-03-HA-1234", "Two-Wheeler"},
                {"Joynul Rahman", "9876543211", "KA-03-HA-5678", "Two-Wheeler"},
                {"Amit Patel", "9876543212", "KA-03-HA-9012", "Two-Wheeler"}
            };
            for (String[] p : partners) {
                DeliveryPartner dp = new DeliveryPartner();
                dp.setFullName(p[0]);
                dp.setPhone(p[1]);
                dp.setVehicleNumber(p[2]);
                dp.setVehicleType(p[3]);
                dp.setStatus("AVAILABLE");
                deliveryPartnerRepository.save(dp);
            }
        }

        // 5. Initialize Bangalore Restaurants & Menus (if restaurants count is 0)
        if (restaurantRepository.count() == 0) {
            List<Category> categories = categoryRepository.findAll();
            Category southIndian = categories.stream().filter(c -> c.getCategoryName().equals("South Indian")).findFirst().get();
            Category northIndian = categories.stream().filter(c -> c.getCategoryName().equals("North Indian")).findFirst().get();
            Category chinese = categories.stream().filter(c -> c.getCategoryName().equals("Chinese")).findFirst().get();
            Category pizza = categories.stream().filter(c -> c.getCategoryName().equals("Pizza")).findFirst().get();
            Category burger = categories.stream().filter(c -> c.getCategoryName().equals("Burger")).findFirst().get();
            Category desserts = categories.stream().filter(c -> c.getCategoryName().equals("Desserts")).findFirst().get();
            Category beverages = categories.stream().filter(c -> c.getCategoryName().equals("Beverages")).findFirst().get();
            Category breakfast = categories.stream().filter(c -> c.getCategoryName().equals("Breakfast")).findFirst().get();

            List<RestaurantProfile> profiles = new ArrayList<>();

            // 1. MTR
            RestaurantProfile mtr = new RestaurantProfile("MTR (Mavalli Tiffin Room)", "South Indian, Breakfast", 
                "https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?auto=format&fit=crop&w=600&q=80", 4.6, 250, true, "Chef Ramesh");
            mtr.branches = new String[]{"Basavanagudi", "Jayanagar", "Indiranagar", "Whitefield", "MG Road"};
            mtr.foods.add(new FoodTemplate("MTR Masala Dosa", "Golden brown crispy rice crepe stuffed with spiced potato mash and laced with pure ghee.", 120, "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            mtr.foods.add(new FoodTemplate("MTR Rava Idli", "Invented by MTR. Steamed semolina cakes tempered with mustard seeds, cashews, and yogurt.", 100, "https://images.unsplash.com/photo-1589302168068-944d154d816a?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            mtr.foods.add(new FoodTemplate("Signature Filter Coffee", "Traditional hot milk coffee brewed with premium fresh chicory.", 60, "https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=400&q=80", true, false, beverages));
            profiles.add(mtr);

            // 2. Vidyarthi Bhavan
            RestaurantProfile vb = new RestaurantProfile("Vidyarthi Bhavan", "South Indian, Breakfast", 
                "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80", 4.7, 180, true, "Chef Sridhar");
            vb.branches = new String[]{"Basavanagudi", "Malleshwaram"};
            vb.foods.add(new FoodTemplate("VB Special Masala Dosa", "Thick and crispy butter-laden dosa, a Basavanagudi heritage legend.", 120, "https://images.unsplash.com/photo-1515516969-d4008cc6241a?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            vb.foods.add(new FoodTemplate("VB Idli Vada Combo", "Two soft steamed idlis and one crispy urad dal vada served with sambar.", 95, "https://images.unsplash.com/photo-1565557612662-38435d0705a2?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            vb.foods.add(new FoodTemplate("Traditional Filter Coffee", "Classic decoction coffee served in brass tumbler and dabarah.", 50, "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80", true, false, beverages));
            profiles.add(vb);

            // 3. Meghana Foods
            RestaurantProfile mf = new RestaurantProfile("Meghana Foods", "Biryani, Andhra, North Indian", 
                "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80", 4.5, 450, false, "Chef Prasad");
            mf.branches = new String[]{"Koramangala", "Jayanagar", "Indiranagar", "Marathahalli"};
            mf.foods.add(new FoodTemplate("Meghana Chicken Biryani", "Fragrant basmati rice layered with spicy chicken chunks cooked in Andhra style spices.", 340, "https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            mf.foods.add(new FoodTemplate("Andhra Paneer Biryani", "Spicy cottage cheese chunks layered with premium basmati rice & herbs.", 290, "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=400&q=80", true, false, northIndian));
            mf.foods.add(new FoodTemplate("Meghana Special Chicken", "Boneless chicken marinated in secret spices and deep-fried to perfection.", 320, "https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            profiles.add(mf);

            // 4. Truffles Cafe
            RestaurantProfile tr = new RestaurantProfile("Truffles Cafe", "Burgers, American, Desserts", 
                "https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80", 4.4, 400, false, "Manager Albert");
            tr.branches = new String[]{"Koramangala", "Indiranagar", "Jayanagar", "MG Road", "HSR Layout"};
            tr.foods.add(new FoodTemplate("All American Cheese Burger", "Juicy minced chicken patty with melted cheddar, lettuce, and signature sauce.", 240, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80", false, true, burger));
            tr.foods.add(new FoodTemplate("Crunchy Veg Burger", "Crispy golden vegetable patty topped with crunchy lettuce, onions, and mayo.", 190, "https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=400&q=80", true, false, burger));
            tr.foods.add(new FoodTemplate("Warm Choco Lava Cake", "Hot chocolate cake with a rich liquid molten center, served fresh.", 130, "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            profiles.add(tr);

            // 5. Empire Restaurant
            RestaurantProfile em = new RestaurantProfile("Empire Restaurant", "North Indian, Mughlai, Chinese", 
                "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=600&q=80", 4.1, 420, false, "Chef Jaleel");
            em.branches = new String[]{"BTM Layout", "Koramangala", "HSR Layout", "Indiranagar", "Jayanagar", "MG Road"};
            em.foods.add(new FoodTemplate("Empire Special Chicken Kabab", "Crispy, deep-fried spiced chicken starters, a midnight favorite.", 260, "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            em.foods.add(new FoodTemplate("Gobi Manchurian", "Stir-fried baby cauliflower florets in sweet & spicy soy garlic gravy.", 190, "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=80", true, false, chinese));
            em.foods.add(new FoodTemplate("Butter Chicken Masala", "Tender chicken tikka cooked in rich tomato, butter, and cashew gravy.", 320, "https://images.unsplash.com/photo-1585937421612-70e008356fbe?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            profiles.add(em);

            // 6. Corner House Ice Cream
            RestaurantProfile ch = new RestaurantProfile("Corner House Ice Cream", "Desserts, Ice Cream", 
                "https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=600&q=80", 4.8, 300, true, "Manager Prema");
            ch.branches = new String[]{"Jayanagar", "Koramangala", "Indiranagar", "JP Nagar", "HSR Layout"};
            ch.foods.add(new FoodTemplate("Death by Chocolate", "Vanilla ice cream combined with fresh chocolate cake, hot fudge, cherries, and nuts.", 270, "https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            ch.foods.add(new FoodTemplate("Hot Chocolate Fudge", "Classic HCF with premium vanilla scoop, chocolate sauce, and peanuts.", 200, "https://images.unsplash.com/photo-1501443762994-82bd5dace89a?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            ch.foods.add(new FoodTemplate("Mango Thick Shake", "A thick, creamy milkshake made from pure Alphonso mango pulp.", 160, "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=400&q=80", true, false, beverages));
            profiles.add(ch);

            // 7. Toit Pizzeria
            RestaurantProfile toit = new RestaurantProfile("Toit Pizzeria", "Italian, Pizza", 
                "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80", 4.5, 650, false, "Manager Thomas");
            toit.branches = new String[]{"Indiranagar"};
            toit.foods.add(new FoodTemplate("Toit Pepperoni Pizza", "Authentic sliced pork pepperoni with fresh mozzarella and tomato sauce.", 499, "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=400&q=80", false, true, pizza));
            toit.foods.add(new FoodTemplate("Classic Margherita Pizza", "Fresh roma tomatoes, basil leaves, and premium mozzarella on a wood-fired crust.", 350, "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=400&q=80", true, false, pizza));
            toit.foods.add(new FoodTemplate("Garlic Breadsticks", "Crisp garlic bread seasoned with rosemary and parmesan cheese, served with dip.", 180, "https://images.unsplash.com/photo-1544982503-9f984c14501a?auto=format&fit=crop&w=400&q=80", true, false, pizza));
            profiles.add(toit);

            // 8. CTR - Shri Sagar
            RestaurantProfile ctr = new RestaurantProfile("CTR - Shri Sagar", "South Indian, Breakfast", 
                "/images/ctr_main.png", 4.7, 160, true, "Chef Santhosh");
            ctr.branches = new String[]{"Malleshwaram"};
            ctr.foods.add(new FoodTemplate("CTR Benne Masala Dosa", "Legendary butter-crisped golden dosa served with potato saagu and coconut chutney.", 120, "https://images.unsplash.com/photo-1583226462-81788c0350d2?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            ctr.foods.add(new FoodTemplate("CTR Poori Sagu", "Three puffed wheat pooris served with flavorful spiced potato mash.", 95, "https://images.unsplash.com/photo-1605381144070-6ec9697d268d?auto=format&fit=crop&w=400&q=80", true, false, breakfast));
            ctr.foods.add(new FoodTemplate("CTR Maddur Vada", "Deep fried crispy snack made from semolina, flour, sliced onions, and green chillies.", 80, "https://images.unsplash.com/photo-1568227494-061f52d00f60?auto=format&fit=crop&w=400&q=80", true, false, breakfast));
            profiles.add(ctr);

            // 9. Leon's Burgers & Wings
            RestaurantProfile leons = new RestaurantProfile("Leon's Burgers & Wings", "Burger, Fast Food, Desserts", 
                "https://images.unsplash.com/photo-1553979459-d2229ba7433b?auto=format&fit=crop&w=600&q=80", 4.3, 380, false, "Chef David");
            leons.branches = new String[]{"Koramangala", "HSR Layout", "Indiranagar", "JP Nagar", "Whitefield"};
            leons.foods.add(new FoodTemplate("Leon's Classic Chicken Burger", "Juicy flame-grilled chicken breast, melted cheese, and garlic mayonnaise.", 220, "https://images.unsplash.com/photo-1594212755726-8019ae9ebb5a?auto=format&fit=crop&w=400&q=80", false, true, burger));
            leons.foods.add(new FoodTemplate("Leon's Peri Peri Wings", "Crispy chicken wings tossed in hot and spicy African bird's eye pepper sauce.", 210, "https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=400&q=80", false, true, burger));
            leons.foods.add(new FoodTemplate("Fudgy Choco Brownie", "Rich chocolate fudge brownie served warm and fresh.", 110, "https://images.unsplash.com/photo-1488477181943-685b8fb3f330?auto=format&fit=crop&w=400&q=80", true, false, desserts));
            profiles.add(leons);

            // 10. Beijing Bites
            RestaurantProfile bb = new RestaurantProfile("Beijing Bites", "Chinese", 
                "https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=600&q=80", 4.2, 400, false, "Manager Lin");
            bb.branches = new String[]{"Koramangala", "Jayanagar", "HSR Layout", "Indiranagar"};
            bb.foods.add(new FoodTemplate("Veg Hakka Noodles", "Classic wok-tossed noodles with colorful peppers, carrot strips, and spring onions.", 210, "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=400&q=80", true, false, chinese));
            bb.foods.add(new FoodTemplate("Chilli Chicken Dry", "Diced chicken cubes cooked in red hot Indo-Chinese style soy-chilli sauce.", 250, "https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=400&q=80", false, true, chinese));
            bb.foods.add(new FoodTemplate("Crispy Veg Spring Rolls", "Deep fried rolls stuffed with minced vegetables, served with sweet chilli sauce.", 180, "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=400&q=80", true, false, chinese));
            profiles.add(bb);

            // 11. EatFit (Healthy Kitchen)
            RestaurantProfile eatfit = new RestaurantProfile("EatFit (Healthy Kitchen)", "Healthy, Salad, Bowls, Beverages", 
                "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80", 4.5, 350, true, "Chef Ananya");
            eatfit.branches = new String[]{"HSR Layout", "Koramangala", "Indiranagar", "JP Nagar", "Bellandur"};
            eatfit.foods.add(new FoodTemplate("Fruit and Nut Salad Bowl", "Fresh seasonal chopped fruits, mixed nuts, dried berries, and honey-yogurt dressing.", 210, "https://images.unsplash.com/photo-1494390248404-3083163fbaf6?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            eatfit.foods.add(new FoodTemplate("Quinoa Salad Bowl", "Healthy boiled quinoa tossed with fresh avocados, cucumbers, and lemon dressing.", 240, "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            eatfit.foods.add(new FoodTemplate("Green Detox Smoothie", "Nutritious raw blend of spinach, green apples, celery, ginger, and fresh lemon juice.", 130, "https://images.unsplash.com/photo-1610970881699-44a5587caaec?auto=format&fit=crop&w=400&q=80", true, false, beverages));
            profiles.add(eatfit);

            // 12. Sri Udupi Sagar
            RestaurantProfile udupi = new RestaurantProfile("Sri Udupi Sagar", "South Indian, Breakfast", 
                "https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=600&q=80", 4.3, 160, true, "Chef Subramanya");
            udupi.branches = new String[]{"JP Nagar", "Bellandur", "Hebbal", "Banashankari", "Rajajinagar"};
            udupi.foods.add(new FoodTemplate("Udupi Rava Dosa", "Crispy and flaky rava dosa roasted with cashew pieces and black pepper.", 110, "https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            udupi.foods.add(new FoodTemplate("Steamed Idli Vada Combo", "Two soft button idlis and one crispy vada served with hot sambar and coconut chutney.", 90, "https://images.unsplash.com/photo-1591814468924-fca5fbd59b04?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            udupi.foods.add(new FoodTemplate("Special Kesari Bhath", "Sweet semolina dessert loaded with saffron, pure ghee, and roasted raisins.", 80, "https://images.unsplash.com/photo-1604153965682-123497e64357?auto=format&fit=crop&w=400&q=80", true, false, breakfast));
            profiles.add(udupi);

            // 13. Third Wave Coffee
            RestaurantProfile twc = new RestaurantProfile("Third Wave Coffee", "Beverages, Cafe, Breakfast", 
                "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=600&q=80", 4.4, 380, true, "Manager Shruti");
            twc.branches = new String[]{"Koramangala", "Indiranagar", "Jayanagar", "HSR Layout", "Whitefield", "Hebbal"};
            twc.foods.add(new FoodTemplate("Cold Brew Coffee", "Our classic cold brew steeped slowly for 18 hours for a smooth flavor.", 180, "https://images.unsplash.com/photo-1484723091786-b489d89260d8?auto=format&fit=crop&w=400&q=80", true, true, beverages));
            twc.foods.add(new FoodTemplate("Classic Hummus & Pita", "Creamy hummus served with warm whole-wheat pita bread pockets.", 220, "https://images.unsplash.com/photo-1577906096429-f73c2c312435?auto=format&fit=crop&w=400&q=80", true, false, breakfast));
            twc.foods.add(new FoodTemplate("Paneer Tikka Sandwich", "Spiced cottage cheese chunks grilled with mint chutney in artisanal sourdough.", 240, "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            profiles.add(twc);

            // 14. A2B - Adyar Ananda Bhavan
            RestaurantProfile a2b = new RestaurantProfile("A2B - Adyar Ananda Bhavan", "South Indian, Sweets, Breakfast", 
                "https://images.unsplash.com/photo-1505253716362-af1f26e32dcd?auto=format&fit=crop&w=600&q=80", 4.3, 260, true, "Chef Srinivasan");
            a2b.branches = new String[]{"BTM Layout", "Jayanagar", "HSR Layout", "Koramangala", "Banashankari", "Marathahalli", "Bellandur", "Yelahanka", "Guruguntepalya"};
            a2b.foods.add(new FoodTemplate("Special Ghee Roast Dosa", "Thin and crispy large dosa cooked with premium clarified butter (ghee).", 130, "https://images.unsplash.com/photo-1631515243349-e0d7c4b14b20?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            a2b.foods.add(new FoodTemplate("A2B Special Thali", "A wholesome lunch comprising variety rice, sambar, rasam, kootu, poriyal, curd, and sweet.", 250, "https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            a2b.foods.add(new FoodTemplate("Assorted Sweets Box", "A handpicked selection of our top ghee sweets including Kaju Katli and Mysore Pak.", 280, "https://images.unsplash.com/photo-1579954115545-d8123da62137?auto=format&fit=crop&w=400&q=80", true, false, desserts));
            profiles.add(a2b);

            // 15. Barbeque Nation
            RestaurantProfile bbq = new RestaurantProfile("Barbeque Nation", "North Indian, Mughlai, Barbeque", 
                "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80", 4.5, 800, false, "Chef Harish");
            bbq.branches = new String[]{"JP Nagar", "Indiranagar", "Koramangala", "MG Road", "Whitefield"};
            bbq.foods.add(new FoodTemplate("BBQ Tandoori Chicken Skewers", "Succulent chicken thighs marinated in yogurt spices, grilled on live coals.", 399, "https://images.unsplash.com/photo-1618161102928-17a4778af36d?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            bbq.foods.add(new FoodTemplate("Cajun Spiced Potatoes", "Crispy baby potatoes fried and topped with a creamy, spicy Cajun mayo dressing.", 250, "https://images.unsplash.com/photo-1518013006361-7fc58e04b08d?auto=format&fit=crop&w=400&q=80", true, true, northIndian));
            bbq.foods.add(new FoodTemplate("Barbeque Paneer Tikka", "Spiced cottage cheese cubes skewered with bell peppers and onions, slow grilled.", 320, "https://images.unsplash.com/photo-1642825488432-841f3e792f33?auto=format&fit=crop&w=400&q=80", true, false, northIndian));
            profiles.add(bbq);

            int phoneIndex = 1000;
            // Iterate over each profile and create a restaurant for each of its specified branches
            for (RestaurantProfile profile : profiles) {
                if (profile.branches == null) continue;
                for (int b = 0; b < profile.branches.length; b++) {
                    String branchLocation = profile.branches[b];

                    Restaurant r = new Restaurant();
                    // Example: "Meghana Foods - Koramangala"
                    r.setName(profile.name.replace(" (Mavalli Tiffin Room)", "").replace(" Cafe", "").replace(" Ice Cream", "") + " - " + branchLocation);
                    r.setOwnerName(profile.owner);
                    r.setEmail(profile.name.toLowerCase().replaceAll("[^a-z0-9]", "") + "." + b + "." + branchLocation.toLowerCase().replaceAll("[^a-z0-9]", "") + "@craverush.com");
                    r.setPhone("99887" + (phoneIndex++));
                    r.setAddress("12th Main Road, " + branchLocation);
                    r.setCity("Bangalore");
                    r.setState("Karnataka");
                    r.setPincode("5600" + (phoneIndex / 100));
                    r.setArea(branchLocation);
                    r.setRating(BigDecimal.valueOf(profile.rating));
                    r.setStatus("ACTIVE");
                    r.setCuisineType(profile.cuisine);
                    // Realistic delivery time based on indexing
                    r.setDeliveryTime(25 + (phoneIndex % 15));
                    r.setMinOrder(BigDecimal.valueOf(100.00));
                    r.setPriceForTwo(profile.priceForTwo);
                    r.setVeg(profile.isVeg);
                    r.setOpeningTime(LocalTime.of(8, 0));
                    r.setClosingTime(LocalTime.of(23, 0));

                    // Retrieve coordinates
                    double[] coords = com.craverush.service.DeliveryService.getCoordsForArea(branchLocation);
                    double offsetLat = (b % 2 == 0 ? -0.0025 : 0.0025);
                    double offsetLng = (b % 2 == 0 ? -0.0025 : 0.0025);
                    r.setLatitude(BigDecimal.valueOf(coords[0] + offsetLat));
                    r.setLongitude(BigDecimal.valueOf(coords[1] + offsetLng));

                    // Add image
                    RestaurantImage img = new RestaurantImage(r, profile.image);
                    r.getImages().add(img);

                    // Add food items
                    for (FoodTemplate ft : profile.foods) {
                        FoodItem item = new FoodItem();
                        item.setRestaurant(r);
                        item.setName(ft.name);
                        item.setDescription(ft.desc);
                        item.setPrice(BigDecimal.valueOf(ft.price));
                        item.setCategory(ft.category);
                        item.setImageUrl(ft.image);
                        item.setVeg(ft.isVeg);
                        item.setAvailable(true);
                        item.setRating(BigDecimal.valueOf(ft.isBestseller ? 4.7 : 4.2));
                        r.getFoodItems().add(item);
                    }

                    restaurantRepository.save(r);
                }
            }
        }
    }

    private void createFoodItem(Restaurant r, String name, String desc, double price, Category cat, String img, boolean isVeg, boolean isBestseller) {
        FoodItem item = new FoodItem();
        item.setRestaurant(r);
        item.setName(name);
        item.setDescription(desc);
        item.setPrice(BigDecimal.valueOf(price));
        item.setCategory(cat);
        item.setImageUrl(img);
        item.setVeg(isVeg);
        item.setAvailable(true);
        item.setRating(BigDecimal.valueOf(isBestseller ? 4.7 : 4.0));
        foodItemRepository.save(item);
    }

    // Static helper classes for seeding
    private static class RestaurantProfile {
        String name;
        String cuisine;
        String image;
        double rating;
        int priceForTwo;
        boolean isVeg;
        String owner;
        String[] branches;
        List<FoodTemplate> foods = new ArrayList<>();
        RestaurantProfile(String name, String cuisine, String image, double rating, int priceForTwo, boolean isVeg, String owner) {
            this.name = name; this.cuisine = cuisine; this.image = image; this.rating = rating; this.priceForTwo = priceForTwo; this.isVeg = isVeg; this.owner = owner;
        }
    }

    private static class FoodTemplate {
        String name; String desc; double price; String image; boolean isVeg; boolean isBestseller; Category category;
        FoodTemplate(String name, String desc, double price, String image, boolean isVeg, boolean isBestseller, Category category) {
            this.name = name; this.desc = desc; this.price = price; this.image = image; this.isVeg = isVeg; this.isBestseller = isBestseller; this.category = category;
        }
    }
}
