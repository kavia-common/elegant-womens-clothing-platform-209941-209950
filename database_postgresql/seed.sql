-- Seed data for women's clothing platform
-- Note: The admin password_hash below is a placeholder bcrypt for 'Admin123!' and should be replaced by backend seeding/migration if needed.

-- Upsert admin user
INSERT INTO users (email, password_hash, role)
VALUES
  ('admin@shop.com', '$2b$10$3Yh3d1qGm9XqZ1u6cZbTzOyq2Y7b7f2Qq8v8t9x7HqVw9y2qW4m8e', 'admin') -- placeholder bcrypt for 'Admin123!'
ON CONFLICT (email) DO UPDATE SET role = EXCLUDED.role;

-- Optional customer
INSERT INTO users (email, password_hash, role)
VALUES
  ('customer@shop.com', '$2b$10$k7l3p2Zc9HjE1u2Tq3RsSuG0cY4dJ6kV8mN1bC3xD5fG7hJ9L2Qe', 'customer') -- placeholder bcrypt for 'Customer123!'
ON CONFLICT (email) DO NOTHING;

-- Products (about 10)
INSERT INTO products (name, description, price, currency, sku, images, category, tags, sizes, stock, is_active)
VALUES
  ('Classic White Blouse', 'A timeless white blouse for everyday elegance.', 39.99, 'USD', 'BL-CL-WH-001',
   '["/images/blouse_white_1.jpg","/images/blouse_white_2.jpg"]', 'Tops', ARRAY['blouse','white','classic','workwear'], ARRAY['XS','S','M','L','XL'], 120, TRUE),

  ('Silk Camisole', 'Luxurious silk camisole perfect for layering.', 59.00, 'USD', 'CM-SL-BG-002',
   '["/images/camisole_silk_1.jpg"]', 'Tops', ARRAY['silk','camisole','layering'], ARRAY['XS','S','M','L'], 80, TRUE),

  ('High-Waist Skinny Jeans', 'Figure-flattering high-waist skinny jeans.', 69.50, 'USD', 'JN-HW-BL-003',
   '["/images/jeans_skinny_1.jpg","/images/jeans_skinny_2.jpg"]', 'Bottoms', ARRAY['jeans','denim','skinny','high-waist'], ARRAY['24','25','26','27','28','29','30'], 150, TRUE),

  ('A-Line Midi Skirt', 'Elegant midi skirt with a flattering A-line cut.', 54.00, 'USD', 'SK-AL-NV-004',
   '["/images/skirt_midi_1.jpg"]', 'Bottoms', ARRAY['skirt','midi','a-line','navy'], ARRAY['XS','S','M','L'], 60, TRUE),

  ('Tailored Blazer', 'Polished tailored blazer for office and events.', 129.99, 'USD', 'BZ-TL-BK-005',
   '["/images/blazer_black_1.jpg","/images/blazer_black_2.jpg"]', 'Outerwear', ARRAY['blazer','tailored','black','formal'], ARRAY['XS','S','M','L','XL'], 45, TRUE),

  ('Wool Blend Coat', 'Warm wool blend coat with classic silhouette.', 189.00, 'USD', 'CT-WB-CM-006',
   '["/images/coat_wool_1.jpg"]', 'Outerwear', ARRAY['coat','wool','camel','winter'], ARRAY['XS','S','M','L'], 30, TRUE),

  ('Floral Wrap Dress', 'Flattering wrap dress with floral print.', 79.00, 'USD', 'DR-WR-FL-007',
   '["/images/dress_wrap_1.jpg","/images/dress_wrap_2.jpg"]', 'Dresses', ARRAY['dress','wrap','floral','spring'], ARRAY['XS','S','M','L','XL'], 75, TRUE),

  ('Pleated Maxi Dress', 'Elegant pleated maxi dress for special occasions.', 119.00, 'USD', 'DR-PM-BL-008',
   '["/images/dress_maxi_1.jpg"]', 'Dresses', ARRAY['dress','maxi','pleated','evening'], ARRAY['XS','S','M','L'], 40, TRUE),

  ('Cotton Crew Tee', 'Soft cotton crew-neck tee for everyday wear.', 19.99, 'USD', 'TE-CR-WH-009',
   '["/images/tee_cotton_1.jpg"]', 'Tops', ARRAY['tee','cotton','casual','basic'], ARRAY['XS','S','M','L','XL'], 200, TRUE),

  ('Athleisure Leggings', 'High-stretch leggings suitable for workouts and leisure.', 39.00, 'USD', 'LG-AT-BK-010',
   '["/images/leggings_athleisure_1.jpg"]', 'Activewear', ARRAY['leggings','athleisure','workout','black'], ARRAY['XS','S','M','L'], 180, TRUE);

-- Example orders (optional minimal)
-- Reference existing users by email
WITH c AS (SELECT id FROM users WHERE email='customer@shop.com' LIMIT 1)
INSERT INTO orders (user_id, items, total, status, shipping_address)
SELECT
  c.id,
  '[
     {"product_id": 1, "name": "Classic White Blouse", "price": 39.99, "qty": 1, "size":"M"},
     {"product_id": 3, "name": "High-Waist Skinny Jeans", "price": 69.50, "qty": 1, "size":"27"}
   ]'::jsonb,
  109.49,
  'paid',
  '{"full_name":"Jane Doe","line1":"123 Market St","city":"San Francisco","state":"CA","postal_code":"94103","country":"US"}'::jsonb
FROM c
ON CONFLICT DO NOTHING;
