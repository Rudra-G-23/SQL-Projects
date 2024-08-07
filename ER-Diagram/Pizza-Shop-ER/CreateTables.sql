-- Customer table
CREATE TABLE Customer (
  cust_id INT PRIMARY KEY,
  cust_f_name VARCHAR(50) NOT NULL,
  cust_l_name VARCHAR(20) NOT NULL
);

-- Address table
CREATE TABLE Address (
  add_id INT PRIMARY KEY,
  street1 VARCHAR(200),
  street2 VARCHAR(200),
  city VARCHAR(50) NOT NULL,
  pincode VARCHAR(20) NOT NULL,
  customer_id INT,
  FOREIGN KEY (customer_id) REFERENCES Customer(cust_id)
);

-- Staff table
CREATE TABLE Staff (
  staff_id INT PRIMARY KEY,
  first_name VARCHAR(20) NOT NULL,
  last_name VARCHAR(20) NOT NULL,
  position VARCHAR(20) NOT NULL,
  hourly_rate DECIMAL(5, 2) NOT NULL
);

-- Shift table
CREATE TABLE Shift (
  shift_id INT PRIMARY KEY,
  day_of_week VARCHAR(20) NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  staff_id INT,
  FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Item table
CREATE TABLE Item (
  item_id INT PRIMARY KEY,
  sku VARCHAR(30) NOT NULL,
  item_name VARCHAR(50) NOT NULL,
  item_category VARCHAR(50) NOT NULL,
  item_size INT,
  item_price DECIMAL(5, 2) NOT NULL
);

-- Ingredient table
CREATE TABLE Ingredient (
  ing_id INT PRIMARY KEY,
  ing_name VARCHAR(200) NOT NULL,
  ing_wt INT,
  meas VARCHAR(50),
  price DECIMAL(5,2) NOT NULL,
  inv_id INT,
   
);

-- Inventory table
CREATE TABLE Inventory (
  inv_id INT PRIMARY KEY,
  item_id INT,
  qty INT NOT NULL,
  FOREIGN KEY (inv_id) REFERENCES Ingredient(ing_id)


);

-- Recipe table
CREATE TABLE Recipe (
  row_id INT PRIMARY KEY,
  recipe_id INT,
  ing_id INT,
  qty INT NOT NULL,
  FOREIGN KEY (ing_id) REFERENCES Item(ing_id),
  FOREIGN KEY (ing_id) REFERENCES Ingredient(ing_id)
);

-- Orders table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  cust_id INT,
  add_id INT,
  item_id INT,
  created_dt DATETIME NOT NULL,
  delivery_dt DATETIME,
  quantity INT,
  recipe_id INT,
  ing_id INT,
  FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
  FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Rotation table
CREATE TABLE Rotation (
  rota_id INT,
  date DATETIME NOT NULL,
  shift_id INT,
  staff_id INT,
  FOREIGN KEY (staff_id) REFERENCES Staff (staff_id),
  FOREIGN KEY (shift_id) REFERENCES Shift (shift_id)
);
