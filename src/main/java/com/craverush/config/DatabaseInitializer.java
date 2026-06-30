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
            long dominosCount = restaurantRepository.findAll().stream()
                .filter(r -> r.getName().contains("Domino's"))
                .count();
            if (dominosCount == 0) {
                needsReseed = true;
            }
        }
        if (needsReseed) {
            try {
                entityManager.createNativeQuery("SET REFERENTIAL_INTEGRITY FALSE").executeUpdate();
            } catch (Exception e) {
                try {
                    entityManager.createNativeQuery("SET FOREIGN_KEY_CHECKS = 0").executeUpdate();
                } catch (Exception ex) {
                    System.err.println("Could not disable foreign key checks: " + ex.getMessage());
                }
            }
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
            try {
                entityManager.createNativeQuery("SET REFERENTIAL_INTEGRITY TRUE").executeUpdate();
            } catch (Exception e) {
                try {
                    entityManager.createNativeQuery("SET FOREIGN_KEY_CHECKS = 1").executeUpdate();
                } catch (Exception ex) {
                    System.err.println("Could not enable foreign key checks: " + ex.getMessage());
                }
            }
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
            String[] catNames = {
                "South Indian", "North Indian", "Chinese", "Pizza", "Burger", 
                "Desserts", "Beverages", "Breakfast", "Italian", "Healthy Food", 
                "Rolls", "Sandwiches", "Momos", "Coffee"
            };
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
            Category italian = categories.stream().filter(c -> c.getCategoryName().equals("Italian")).findFirst().get();
            Category healthy = categories.stream().filter(c -> c.getCategoryName().equals("Healthy Food")).findFirst().get();
            Category rolls = categories.stream().filter(c -> c.getCategoryName().equals("Rolls")).findFirst().get();
            Category sandwiches = categories.stream().filter(c -> c.getCategoryName().equals("Sandwiches")).findFirst().get();
            Category momos = categories.stream().filter(c -> c.getCategoryName().equals("Momos")).findFirst().get();
            Category coffee = categories.stream().filter(c -> c.getCategoryName().equals("Coffee")).findFirst().get();

            List<RestaurantProfile> profiles = new ArrayList<>();

            // 1. Domino's Pizza
            RestaurantProfile dominos = new RestaurantProfile("Domino's Pizza", "Pizza, Italian, Fast Food", 
                "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80", 4.3, 400, false, "Koramangala", "Chef Marco");
            dominos.foods.add(new FoodTemplate("Peppy Paneer Pizza", "Chunky paneer, crisp capsicum, and spicy red pepper with mozzarella cheese.", 299, "https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=400&q=80", true, true, pizza));
            dominos.foods.add(new FoodTemplate("Pepper Pepperoni Pizza", "Classic sliced pepperoni, tomato sauce, and extra mozzarella cheese.", 449, "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=400&q=80", false, true, pizza));
            profiles.add(dominos);

            // 2. Meghana Foods
            RestaurantProfile meghana = new RestaurantProfile("Meghana Foods", "Biryani, Andhra, Spicy", 
                "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80", 4.5, 450, false, "Koramangala", "Chef Prasad");
            meghana.foods.add(new FoodTemplate("Meghana Chicken Biryani", "Fragrant basmati rice layered with spicy chicken chunks cooked in Andhra style spices.", 340, "https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            meghana.foods.add(new FoodTemplate("Andhra Paneer Biryani", "Spicy cottage cheese chunks layered with premium basmati rice & herbs.", 290, "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=400&q=80", true, false, northIndian));
            profiles.add(meghana);

            // 3. KFC
            RestaurantProfile kfc = new RestaurantProfile("KFC", "Fried Chicken, Fast Food, Burgers", 
                "https://images.unsplash.com/photo-1513639776629-7b61b0ac2313?auto=format&fit=crop&w=600&q=80", 4.1, 500, false, "Indiranagar", "Chef Sanders");
            kfc.foods.add(new FoodTemplate("KFC Fried Chicken Bucket", "Original recipe crispy golden chicken pieces, served with dip.", 399, "https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?auto=format&fit=crop&w=400&q=80", false, true, burger));
            kfc.foods.add(new FoodTemplate("KFC Zinger Burger", "Crispy chicken fillet with lettuce and creamy mayonnaise in a toasted bun.", 180, "https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?auto=format&fit=crop&w=400&q=80", false, true, burger));
            profiles.add(kfc);

            // 4. Udupi Upachar
            RestaurantProfile udupi = new RestaurantProfile("Udupi Upachar", "South Indian, Breakfast", 
                "https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=600&q=80", 4.6, 250, true, "Jayanagar", "Chef Subramanya");
            udupi.foods.add(new FoodTemplate("Ghee Masala Dosa", "Traditional crispy dosa roasted in pure ghee, served with potato sagu and coconut chutney.", 110, "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=400&q=80", true, true, southIndian));
            udupi.foods.add(new FoodTemplate("Steamed Idli Vada Combo", "Two soft button idlis and one crispy medu vada served with hot sambar.", 90, "https://images.unsplash.com/photo-1591814468924-fca5fbd59b04?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            profiles.add(udupi);

            // 5. Beijing Bites
            RestaurantProfile beijing = new RestaurantProfile("Beijing Bites", "Chinese, Asian", 
                "https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=600&q=80", 4.2, 500, false, "Jayanagar", "Manager Lin");
            beijing.foods.add(new FoodTemplate("Veg Hakka Noodles", "Classic wok-tossed noodles with colorful peppers, carrot strips, and spring onions.", 210, "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=400&q=80", true, false, chinese));
            beijing.foods.add(new FoodTemplate("Chilli Chicken Dry", "Diced chicken cubes cooked in red hot Indo-Chinese style soy-chilli sauce.", 250, "https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=400&q=80", false, true, chinese));
            profiles.add(beijing);

            // 6. California Burrito
            RestaurantProfile calBurrito = new RestaurantProfile("California Burrito", "Mexican, Healthy Food, Salad, Bowls", 
                "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80", 4.4, 500, false, "JP Nagar", "Chef Sofia");
            calBurrito.foods.add(new FoodTemplate("Guacamole Rice Bowl", "Brown rice, black beans, pico de gallo, fresh guacamole, and sour cream.", 260, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&q=80", true, true, healthy));
            calBurrito.foods.add(new FoodTemplate("Chicken Burrito Wrap", "Flour tortilla rolled with grilled chicken, Mexican rice, cheese, and salsa.", 280, "https://images.unsplash.com/photo-1626700051175-6518c4793f4f?auto=format&fit=crop&w=400&q=80", false, true, healthy));
            profiles.add(calBurrito);

            // 7. Starbucks
            RestaurantProfile starbucks = new RestaurantProfile("Starbucks", "Coffee, Beverages, Desserts, Cafe", 
                "https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=600&q=80", 4.5, 700, false, "Indiranagar", "Manager Shruti");
            starbucks.foods.add(new FoodTemplate("Java Chip Frappuccino", "Rich mocha-flavored sauce blended with milk, chocolate chips, and espresso.", 340, "https://images.unsplash.com/photo-1576092768241-dec231879fc3?auto=format&fit=crop&w=400&q=80", true, true, beverages));
            starbucks.foods.add(new FoodTemplate("Blueberry Muffin", "A moist muffin loaded with plump sweet blueberries, served warm.", 190, "https://images.unsplash.com/photo-1607958996333-41aef7caefaa?auto=format&fit=crop&w=400&q=80", true, false, desserts));
            profiles.add(starbucks);

            // 8. Empire Restaurant
            RestaurantProfile empire = new RestaurantProfile("Empire Restaurant", "North Indian, Mughlai, Kebabs", 
                "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?auto=format&fit=crop&w=600&q=80", 4.0, 600, false, "BTM Layout", "Chef Jaleel");
            empire.foods.add(new FoodTemplate("Empire Special Chicken Kabab", "Crispy, deep-fried spiced chicken starters, a midnight favorite.", 260, "https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            empire.foods.add(new FoodTemplate("Butter Chicken Masala", "Tender chicken tikka cooked in rich tomato, butter, and cashew gravy.", 320, "https://images.unsplash.com/photo-1585937421612-70e008356fbe?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            profiles.add(empire);

            // 9. Pizza Hut
            RestaurantProfile pizzaHut = new RestaurantProfile("Pizza Hut", "Pizza, Italian, Fast Food", 
                "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=600&q=80", 4.2, 500, false, "Indiranagar", "Chef Aldo");
            pizzaHut.foods.add(new FoodTemplate("Tandoori Paneer Pizza", "Paneer tikka slices, red onions, capsicum, and tandoori sauce on a thick pan crust.", 350, "https://images.unsplash.com/photo-1593504049359-74330189a345?auto=format&fit=crop&w=400&q=80", true, false, pizza));
            pizzaHut.foods.add(new FoodTemplate("Garlic Breadsticks", "Freshly baked bread seasoned with garlic, butter, and Italian herbs.", 180, "https://images.unsplash.com/photo-1544982503-9f984c14501a?auto=format&fit=crop&w=400&q=80", true, false, pizza));
            profiles.add(pizzaHut);

            // 10. Truffles
            RestaurantProfile truffles = new RestaurantProfile("Truffles", "Burgers, American, Desserts", 
                "https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=600&q=80", 4.4, 550, false, "Koramangala", "Manager Albert");
            truffles.foods.add(new FoodTemplate("All American Cheese Burger", "Juicy minced chicken patty with melted cheddar, lettuce, and signature sauce.", 240, "https://images.unsplash.com/photo-1594212755726-8019ae9ebb5a?auto=format&fit=crop&w=400&q=80", false, true, burger));
            truffles.foods.add(new FoodTemplate("Warm Choco Lava Cake", "Hot chocolate cake with a rich liquid molten center, served fresh.", 130, "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            profiles.add(truffles);

            // 11. Paradise Biryani
            RestaurantProfile paradise = new RestaurantProfile("Paradise Biryani", "Biryani, Mughlai, North Indian", 
                "https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?auto=format&fit=crop&w=600&q=80", 4.3, 600, false, "BTM Layout", "Chef Ahmed");
            paradise.foods.add(new FoodTemplate("Paradise Chicken Biryani", "Premium long grain basmati rice cooked with tender spiced chicken under dum pressure.", 350, "https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=400&q=80", false, true, northIndian));
            paradise.foods.add(new FoodTemplate("Paneer Tikka Kabab", "Grilled cottage cheese cubes skewered with bell peppers and tandoori spices.", 280, "https://images.unsplash.com/photo-1642825488432-841f3e792f33?auto=format&fit=crop&w=400&q=80", true, false, northIndian));
            profiles.add(paradise);

            // 12. McDonald's
            RestaurantProfile mcd = new RestaurantProfile("McDonald's", "Burgers, Fast Food, Desserts", 
                "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80", 4.2, 450, false, "Jayanagar", "Chef David");
            mcd.foods.add(new FoodTemplate("McSpicy Chicken Burger", "Crispy coated chicken breast fillet with shredded lettuce and spicy sauce.", 210, "https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80", false, true, burger));
            mcd.foods.add(new FoodTemplate("Crispy French Fries", "World famous golden thin potato fries, perfectly salted.", 110, "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=400&q=80", true, false, burger));
            profiles.add(mcd);

            // 13. Subway Sandwiches
            RestaurantProfile subway = new RestaurantProfile("Subway Sandwiches", "Sandwiches, Healthy Food, Fast Food", 
                "https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=600&q=80", 4.3, 400, false, "Koramangala", "Chef Robert");
            subway.foods.add(new FoodTemplate("Subway Club Sandwich", "Turkey slices, chicken ham, roast beef, and fresh veggies on freshly baked bread.", 250, "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=400&q=80", false, true, sandwiches));
            subway.foods.add(new FoodTemplate("Veggie Delite Sub", "Fresh cucumber, tomato, green pepper, onions, and lettuce with sweet onion sauce.", 190, "https://images.unsplash.com/photo-1554433607-66b5eed9d304?auto=format&fit=crop&w=400&q=80", true, false, sandwiches));
            profiles.add(subway);

            // 14. Leon Grill
            RestaurantProfile leon = new RestaurantProfile("Leon Grill", "Burgers, Grilled Chicken, Healthy Food", 
                "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80", 4.3, 500, false, "HSR Layout", "Chef Harris");
            leon.foods.add(new FoodTemplate("Leon's Peri Peri Wings", "Crispy flame-grilled chicken wings tossed in hot peri peri glaze.", 210, "https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=400&q=80", false, true, burger));
            leon.foods.add(new FoodTemplate("Leon's Classic Chicken Burger", "Grilled juicy chicken breast fillet with dynamic garlic sauce and melted cheese.", 220, "https://images.unsplash.com/photo-1594212755726-8019ae9ebb5a?auto=format&fit=crop&w=400&q=80", false, true, burger));
            profiles.add(leon);

            // 15. Third Wave Coffee
            RestaurantProfile twc = new RestaurantProfile("Third Wave Coffee", "Coffee, Beverages, Cafe, Breakfast", 
                "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=600&q=80", 4.4, 600, false, "Koramangala", "Manager Shruti");
            twc.foods.add(new FoodTemplate("TWC Cold Brew Coffee", "Premium single origin cold brew steeped slowly for 18 hours.", 180, "https://images.unsplash.com/photo-1484723091786-b489d89260d8?auto=format&fit=crop&w=400&q=80", true, true, coffee));
            twc.foods.add(new FoodTemplate("Paneer Tikka Sandwich", "Spiced cottage cheese slices, grilled with green chutney in artisanal sourdough.", 240, "https://images.unsplash.com/photo-1541532713592-79a0317b6b77?auto=format&fit=crop&w=400&q=80", true, true, breakfast));
            profiles.add(twc);

            // 16. Burger King
            RestaurantProfile bk = new RestaurantProfile("Burger King", "Burgers, Fast Food", 
                "https://images.unsplash.com/photo-1534790566985-aaeecb2cbb1e?auto=format&fit=crop&w=600&q=80", 4.1, 400, false, "HSR Layout", "Chef Steve");
            bk.foods.add(new FoodTemplate("Veg Whopper Burger", "Big and crispy double veg patty burger loaded with fresh tomatoes and cheese.", 179, "https://images.unsplash.com/photo-1521305916504-4a1121188589?auto=format&fit=crop&w=400&q=80", true, true, burger));
            bk.foods.add(new FoodTemplate("Crispy Onion Rings", "Golden seasoned whole onion rings served hot and crunchy.", 99, "https://images.unsplash.com/photo-1639024471283-2bc7b3c6a267?auto=format&fit=crop&w=400&q=80", true, false, burger));
            profiles.add(bk);

            // 17. Wow! Momo
            RestaurantProfile momo = new RestaurantProfile("Wow! Momo", "Chinese, Momos, Asian", 
                "https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=600&q=80", 4.3, 300, false, "JP Nagar", "Chef Singson");
            momo.foods.add(new FoodTemplate("Steamed Chicken Momos", "Soft wheat dumplings stuffed with juicy minced chicken and green onions, served with spicy red sauce.", 199, "https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=400&q=80", false, true, momos));
            momo.foods.add(new FoodTemplate("Fried Vegetable Momos", "Crisp fried outer crust with a delicious mixed vegetable core.", 169, "https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&w=400&q=80", true, false, momos));
            profiles.add(momo);

            // 18. Kaati Zone Rolls
            RestaurantProfile rollsShop = new RestaurantProfile("Kaati Zone Rolls", "Rolls, Wraps, Fast Food", 
                "https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&w=600&q=80", 4.2, 350, false, "HSR Layout", "Chef Deepak");
            rollsShop.foods.add(new FoodTemplate("Kaati Chicken Tikka Roll", "Flaky flatbread wrapped around chargrilled spicy chicken tikka and sliced onions.", 180, "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=400&q=80", false, true, rolls));
            rollsShop.foods.add(new FoodTemplate("Kaati Double Egg Roll", "Egg washed layered flatbread rolled with sliced green peppers and chili sauce.", 140, "https://images.unsplash.com/photo-1606755962773-d324e0a13086?auto=format&fit=crop&w=400&q=80", false, true, rolls));
            profiles.add(rollsShop);

            // 19. Krispy Kreme
            RestaurantProfile krispy = new RestaurantProfile("Krispy Kreme", "Desserts, Bakery", 
                "https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=600&q=80", 4.7, 300, true, "Koramangala", "Manager Preeti");
            krispy.foods.add(new FoodTemplate("Original Glazed Donut", "Our signature fluffy ring donut with a glossy sugary glaze.", 95, "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            krispy.foods.add(new FoodTemplate("Krispy Chocolate Donut", "Ring donut topped with a rich dark chocolate fudge frosting.", 110, "https://images.unsplash.com/photo-1614088680112-0a97b51b1a02?auto=format&fit=crop&w=400&q=80", true, false, desserts));
            profiles.add(krispy);

            // 20. Corner House Ice Cream
            RestaurantProfile cornerHouse = new RestaurantProfile("Corner House Ice Cream", "Desserts, Ice Cream", 
                "https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=600&q=80", 4.8, 400, true, "Koramangala", "Manager Prema");
            cornerHouse.foods.add(new FoodTemplate("Signature Death by Chocolate", "Vanilla ice cream combined with fresh chocolate cake, rich fudge, cherries, and peanuts.", 270, "https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            cornerHouse.foods.add(new FoodTemplate("Classic Hot Chocolate Fudge", "Hot fudge poured over vanilla scoops topped with roasted peanuts.", 200, "https://images.unsplash.com/photo-1501443762994-82bd5dace89a?auto=format&fit=crop&w=400&q=80", true, true, desserts));
            profiles.add(cornerHouse);

            int phoneIndex = 1000;
            for (int i = 0; i < profiles.size(); i++) {
                RestaurantProfile profile = profiles.get(i);
                Restaurant r = new Restaurant();
                r.setName(profile.name);
                r.setOwnerName(profile.owner);
                r.setEmail(profile.name.toLowerCase().replaceAll("[^a-z0-9]", "") + "@craverush.com");
                r.setPhone("99887" + (phoneIndex++));
                r.setAddress("12th Main Road, " + profile.area);
                r.setCity("Bangalore");
                r.setState("Karnataka");
                r.setPincode("5600" + (phoneIndex / 100));
                r.setArea(profile.area);
                r.setRating(BigDecimal.valueOf(profile.rating));
                r.setStatus("ACTIVE");
                r.setCuisineType(profile.cuisine);
                r.setDeliveryTime(15 + (i * 2) % 25);
                r.setMinOrder(BigDecimal.valueOf(100.00));
                r.setPriceForTwo(profile.priceForTwo);
                r.setVeg(profile.isVeg);
                r.setOpeningTime(LocalTime.of(8, 0));
                r.setClosingTime(LocalTime.of(23, 0));

                double[] coords = com.craverush.service.DeliveryService.getCoordsForArea(profile.area);
                r.setLatitude(BigDecimal.valueOf(coords[0] + (i % 2 == 0 ? -0.002 : 0.002)));
                r.setLongitude(BigDecimal.valueOf(coords[1] + (i % 2 == 0 ? -0.002 : 0.002)));

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
        String area;
        String owner;
        List<FoodTemplate> foods = new ArrayList<>();
        RestaurantProfile(String name, String cuisine, String image, double rating, int priceForTwo, boolean isVeg, String area, String owner) {
            this.name = name; this.cuisine = cuisine; this.image = image; this.rating = rating; this.priceForTwo = priceForTwo; this.isVeg = isVeg; this.area = area; this.owner = owner;
        }
    }

    private static class FoodTemplate {
        String name; String desc; double price; String image; boolean isVeg; boolean isBestseller; Category category;
        FoodTemplate(String name, String desc, double price, String image, boolean isVeg, boolean isBestseller, Category category) {
            this.name = name; this.desc = desc; this.price = price; this.image = image; this.isVeg = isVeg; this.isBestseller = isBestseller; this.category = category;
        }
    }
}
