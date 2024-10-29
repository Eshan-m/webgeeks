-- Insert five restaurant users
INSERT INTO [dbo].[Users] (UserName, Password, Email, UserType)
VALUES
    ('restaurant1', 'password123', 'restaurant1@example.com', 'restaurant'),
    ('restaurant2', 'password123', 'restaurant2@example.com', 'restaurant'),
    ('restaurant3', 'password123', 'restaurant3@example.com', 'restaurant'),
    ('restaurant4', 'password123', 'restaurant4@example.com', 'restaurant'),
    ('restaurant5', 'password123', 'restaurant5@example.com', 'restaurant');

-- Insert dummy food items for each restaurant user
INSERT INTO [dbo].[FoodItems] (RestaurantId, Name, Quantity, Condition, ExpiryDate, Status, Address)
VALUES
    -- Food items for restaurant1
    (1, 'Pizza Slice', 10, 'fresh', '2024-10-30', 'available', '123 Food St'),
    (1, 'Burger', 5, 'near-expiry', '2024-10-25', 'available', '123 Food St'),
    (1, 'Salad Bowl', 8, 'fresh', '2024-10-28', 'available', '123 Food St'),
    (1, 'Pasta Box', 12, 'near-expiry', '2024-10-27', 'available', '123 Food St'),
    (1, 'Bread Loaf', 15, 'fresh', '2024-10-29', 'available', '123 Food St'),

    -- Food items for restaurant2
    (2, 'Chicken Wrap', 6, 'fresh', '2024-10-30', 'available', '456 Eat Ave'),
    (2, 'Vegan Burrito', 7, 'near-expiry', '2024-10-25', 'available', '456 Eat Ave'),
    (2, 'Caesar Salad', 4, 'fresh', '2024-10-28', 'available', '456 Eat Ave'),
    (2, 'Fish Tacos', 10, 'near-expiry', '2024-10-27', 'available', '456 Eat Ave'),
    (2, 'Fruit Parfait', 9, 'fresh', '2024-10-29', 'available', '456 Eat Ave'),

    -- Food items for restaurant3
    (3, 'Grilled Cheese', 5, 'fresh', '2024-10-30', 'available', '789 Dine Blvd'),
    (3, 'Chicken Soup', 8, 'near-expiry', '2024-10-25', 'available', '789 Dine Blvd'),
    (3, 'Egg Salad', 7, 'fresh', '2024-10-28', 'available', '789 Dine Blvd'),
    (3, 'BLT Sandwich', 10, 'near-expiry', '2024-10-27', 'available', '789 Dine Blvd'),
    (3, 'Mac and Cheese', 12, 'fresh', '2024-10-29', 'available', '789 Dine Blvd'),

    -- Food items for restaurant4
    (4, 'Veggie Burger', 6, 'fresh', '2024-10-30', 'available', '321 Bite St'),
    (4, 'Potato Wedges', 10, 'near-expiry', '2024-10-25', 'available', '321 Bite St'),
    (4, 'Greek Salad', 4, 'fresh', '2024-10-28', 'available', '321 Bite St'),
    (4, 'Beef Stew', 8, 'near-expiry', '2024-10-27', 'available', '321 Bite St'),
    (4, 'Rice Bowl', 15, 'fresh', '2024-10-29', 'available', '321 Bite St'),

    -- Food items for restaurant5
    (5, 'Falafel Wrap', 9, 'fresh', '2024-10-30', 'available', '654 Snack Rd'),
    (5, 'Beet Salad', 11, 'near-expiry', '2024-10-25', 'available', '654 Snack Rd'),
    (5, 'Cheese Platter', 6, 'fresh', '2024-10-28', 'available', '654 Snack Rd'),
    (5, 'BBQ Chicken', 7, 'near-expiry', '2024-10-27', 'available', '654 Snack Rd'),
    (5, 'Fruit Salad', 14, 'fresh', '2024-10-29', 'available', '654 Snack Rd');
