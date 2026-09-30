-- ==============================================================================
-- SUNSET DELI & ARTISAN MELTS - SUPABASE DATABASE SCHEMA
-- ==============================================================================
-- วิธีใช้งาน:
-- 1. เข้าไปที่ Dashboard ของ Supabase (https://app.supabase.com)
-- 2. ไปที่เมนู "SQL Editor" ด้านซ้ายมือ
-- 3. คลิก "+ New Query" แล้วนำโค้ดด้านล่างนี้ทั้งหมดไปวาง
-- 4. กดปุ่ม "Run" เพื่อสร้างตารางและใส่ข้อมูลเมนูแซนวิชตัวอย่างทั้งหมด
-- ==============================================================================

-- 1. Categories Table (หมวดหมู่สินค้า)
CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_th TEXT NOT NULL,
  icon TEXT DEFAULT '🥪',
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Menu Items Table (รายการแซนวิชและอาหาร)
CREATE TABLE IF NOT EXISTS menu_items (
  id TEXT PRIMARY KEY,
  category_id TEXT REFERENCES categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  name_th TEXT NOT NULL,
  description TEXT,
  description_th TEXT,
  price NUMERIC NOT NULL DEFAULT 0,
  original_price NUMERIC,
  image_url TEXT,
  badge TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  calories INT,
  customization_options JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Orders Table (ออเดอร์และการสั่งซื้อ)
CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  order_number TEXT NOT NULL,
  order_type TEXT NOT NULL DEFAULT 'dine_in', -- 'dine_in', 'takeaway', 'delivery'
  table_number TEXT,
  customer_name TEXT,
  customer_phone TEXT,
  delivery_address TEXT,
  status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'preparing', 'ready', 'completed', 'cancelled'
  subtotal NUMERIC NOT NULL DEFAULT 0,
  discount NUMERIC NOT NULL DEFAULT 0,
  vat NUMERIC NOT NULL DEFAULT 0,
  total_amount NUMERIC NOT NULL DEFAULT 0,
  payment_method TEXT NOT NULL DEFAULT 'promptpay', -- 'promptpay', 'cash', 'credit_card'
  payment_status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'paid'
  cash_tendered NUMERIC,
  cash_change NUMERIC,
  items JSONB NOT NULL DEFAULT '[]'::jsonb,
  notes TEXT,
  channel TEXT NOT NULL DEFAULT 'online', -- 'online', 'pos'
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Store Settings Table (การตั้งค่าร้านและพร้อมเพย์)
CREATE TABLE IF NOT EXISTS store_settings (
  id TEXT PRIMARY KEY DEFAULT 'primary',
  store_name TEXT NOT NULL DEFAULT 'Sunset Deli & Artisan Melts',
  store_name_th TEXT NOT NULL DEFAULT 'ซันเซ็ท เดลี่ แอนด์ แซนวิช คราฟท์',
  tagline TEXT DEFAULT 'Gourmet Handcrafted Sandwiches & Modern Cafe',
  phone TEXT DEFAULT '089-123-4567',
  address TEXT DEFAULT '88/1 Sukhumvit Soi 55 (Thonglor), Bangkok 10110',
  promptpay_id TEXT DEFAULT '0891234567',
  tax_rate NUMERIC DEFAULT 7,
  currency TEXT DEFAULT '฿',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- เปิดการเข้าถึง Row Level Security (RLS) แบบ Anon ให้อ่านและเขียนได้สำหรับระบบ POS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Allow public all categories" ON categories FOR ALL USING (true);

CREATE POLICY "Allow public read menu_items" ON menu_items FOR SELECT USING (true);
CREATE POLICY "Allow public all menu_items" ON menu_items FOR ALL USING (true);

CREATE POLICY "Allow public read orders" ON orders FOR SELECT USING (true);
CREATE POLICY "Allow public insert orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update orders" ON orders FOR UPDATE USING (true);

CREATE POLICY "Allow public read store_settings" ON store_settings FOR SELECT USING (true);
CREATE POLICY "Allow public all store_settings" ON store_settings FOR ALL USING (true);

-- ==============================================================================
-- 5. SEED DATA (ข้อมูลหมวดหมู่และเมนูแซนวิชตัวอย่าง)
-- ==============================================================================
INSERT INTO categories (id, name, name_th, icon, sort_order) VALUES
  ('all', 'All Sandwiches', 'ทั้งหมด', '🥪', 1),
  ('signature-melts', 'Signature Melts', 'ซิกเนเจอร์เมลท์ชีสเยิ้ม', '🧀', 2),
  ('bagels-artisan', 'Bagels & Artisan', 'เบเกิล & คราฟท์เบรด', '🥯', 3),
  ('club-toast', 'Club & Crispy Toast', 'คลับแซนวิช & โทสต์', '🍞', 4),
  ('healthy-wraps', 'Healthy & Veggie', 'เพื่อสุขภาพ & มังสวิรัติ', '🥗', 5),
  ('drinks-sides', 'Sides & Drinks', 'ของทานเล่น & เครื่องดื่ม', '☕', 6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO menu_items (id, category_id, name, name_th, description, description_th, price, original_price, image_url, badge, is_available, calories) VALUES
  ('snd-001', 'signature-melts', 'Truffle Roast Beef Melt', 'แซนวิชเนื้ออบเห็ดทรัฟเฟิล & กรูแยร์ชีสเยิ้ม', 
   'Slow-roasted beef sirloin, double melted Swiss Gruyere cheese, caramelized onions on grilled sourdough.',
   'เนื้อสันในอบสไตล์ช้า นุ่มละมุน ผสานกรูแยร์ชีสและเชดด้าชีสเยิ้มทะลัก หอมผัดคาราเมล และซอสทรัฟเฟิลมาโยบนซาวโดว์ปิ้งกรอบทอง',
   249, 280, '/hero-sandwich.jpg', 'Best Seller', true, 680),

  ('snd-002', 'bagels-artisan', 'Smoked Salmon Cream Cheese Bagel', 'เบเกิลแซลมอนรมควันครีมชีส & อโวคาโด',
   'Norwegian cold-smoked salmon, Philadelphia cream cheese, sliced Hass avocado, capers and fresh dill on a toasted bagel.',
   'แซลมอนรมควันนอร์เวย์แท้ ครีมชีสเนียนนุ่ม สไลซ์อโวคาโดแฮสส์สด เคเปอร์ดอง และผักชีลาวสด บนเบเกิลงาขาวหอมกรุ่น',
   229, null, '/salmon-bagel.jpg', 'Chef Pick', true, 520),

  ('snd-003', 'club-toast', 'Artisan Truffle Chicken & Bacon Club', 'ทริปเปิ้ลคลับแซนวิชไก่ย่าง & เบคอนกรอบซอสทรัฟเฟิล',
   'Triple-decker grilled herb chicken breast, crispy smoked bacon, aged cheddar, crisp butterhead lettuce and garlic truffle mayo.',
   'คลับแซนวิช 3 ชั้น อัดแน่นด้วยอกไก่ย่างหมักสมุนไพร เบคอนเมเปิ้ลกรอบ เชดด้าชีส ผักคอสสดฉ่ำ มะเขือเทศ และซอสทรัฟเฟิลการ์ลิค',
   199, 220, '/chicken-club.jpg', 'Best Seller', true, 640),

  ('snd-004', 'healthy-wraps', 'Mediterranean Avocado & Buffalo Mozzarella', 'ฟอกาเซียอโวคาโด & มอสซาเรลล่าสดซอสเพสโต้ (Veggie)',
   'Fresh buffalo mozzarella, sliced Hass avocado, sun-dried tomatoes, baby spinach, and basil pesto on rosemary focaccia.',
   'ชีสมอสซาเรลล่าสดเนื้อนุ่ม อโวคาโดสด มะเขือเทศตากแห้ง ผักโขมอ่อน มะกอกคาลามาทา และเพสโต้โหระพาสด บนขนมปังฟอกาเซียโรสแมรี่อบอุ่น',
   189, null, '/veggie-focaccia.jpg', 'Healthy', true, 490),

  ('snd-005', 'signature-melts', 'Pulled Pork & Jalapeno Cheddar Melt', 'แซนวิชหมูตุ๋นฉีกสไตล์อเมริกันบาร์บีคิว & ฮาลาพิโน่',
   '12-hour slow braised pulled pork drenched in smoky hickory BBQ sauce, spicy jalapenos, and melted Monterey Jack.',
   'หมูคุโรบูตะตุ๋น 12 ชั่วโมง คลุกเคล้าซอสบาร์บีคิวรมควัน พริกฮาลาพิโน่ดองตัดเลี่ยน โคลสลอว์กรุบกรอบ และมอสซาเรลล่าชีส',
   219, null, 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=800&auto=format&fit=crop&q=80', 'Spicy', true, 660),

  ('snd-008', 'drinks-sides', 'Truffle Parmesan Hand-cut Fries', 'เฟรนช์ฟรายส์สดทอดคลุกทรัฟเฟิล & พาร์มีซานชีส',
   'Golden crispy russet potato fries tossed in black truffle oil, freshly grated Grana Padano parmesan and sea salt.',
   'มันฝรั่งทอดกรอบทอง คลุกน้ำมันทรัฟเฟิลแท้ โรยพาร์มีซานชีสขูดสด เสิร์ฟพร้อมซอสทรัฟเฟิลดิป',
   119, null, 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=800&auto=format&fit=crop&q=80', 'Best Seller', true, 380),

  ('snd-009', 'drinks-sides', 'Artisan Iced Caramel Latte', 'กาแฟคาราเมลลาเต้เย็นคราฟท์ (Specialty Blend)',
   'House espresso roast with fresh organic milk and homemade salted vanilla caramel syrup.',
   'ช็อตเอสเพรสโซ่คั่วกลาง-เข้ม หอมกรุ่น นมสดแท้ และซอสซอลท์เท็ดคาราเมลเคี่ยวเองสูตรพิเศษ',
   95, null, 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=800&auto=format&fit=crop&q=80', null, true, 190),

  ('snd-010', 'drinks-sides', 'Yuzu Honey Sparkling Soda', 'ยูซุฮันนี่โซดาแท้จากญี่ปุ่น (สดชื่น ดับเลี่ยน)',
   'Natural Japanese Yuzu citrus puree infused with wild blossom honey and sparkling soda water.',
   'ส้มยูซุแท้นำเข้าจากญี่ปุ่น เปรี้ยวอมหวานหอมสดชื่น ผสมน้ำผึ้งป่าเดือนห้าและโซดาซ่าเย็นชื่นใจ',
   85, null, 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&auto=format&fit=crop&q=80', null, true, 110)
ON CONFLICT (id) DO NOTHING;
