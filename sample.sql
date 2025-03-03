CREATE DATABASE booking_hotel;
use booking_hotel;



-- bảng Accounts (unchanged - should be first as many tables reference it)
CREATE TABLE Accounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,           
    Username VARCHAR(50) UNIQUE NOT NULL,              
    PasswordHash VARCHAR(255) NOT NULL,                
    Role ENUM('Admin', 'Staff', 'Customer') NOT NULL,  
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP      
);

-- bảng Users để quản lý thông tin nhân viên (unchanged - references Accounts)
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,            
    AccountID INT UNIQUE NOT NULL,                     
    FullName VARCHAR(100) NOT NULL,                    
    Email VARCHAR(100) UNIQUE NOT NULL,                
    PhoneNumber VARCHAR(15),                           
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     
    LastLogin TIMESTAMP,                               
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE 
);

-- bảng Customers (unchanged - references Accounts)
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,         
    AccountID INT UNIQUE NOT NULL,                    
    FullName VARCHAR(100) NOT NULL,                    
    Email VARCHAR(100) UNIQUE NOT NULL,                
    PhoneNumber VARCHAR(15),                           
    DateOfBirth DATE,                                  
    Nation NVARCHAR(255),                              
    Gender ENUM('Male', 'Female', 'Other'),            
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

-- Bảng Hotels (moved earlier because Rooms references it)
CREATE TABLE Hotels (
    HotelID INT AUTO_INCREMENT PRIMARY KEY,
    HotelName VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng RoomTypes (unchanged)
CREATE TABLE RoomTypes (
    RoomTypeID INT AUTO_INCREMENT PRIMARY KEY,
    RoomTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Bảng Amenities (unchanged)
CREATE TABLE Amenities (
    AmenityID INT AUTO_INCREMENT PRIMARY KEY,
    AmenityName VARCHAR(100) NOT NULL
);

-- Bảng Rooms (now after Hotels table is created)
CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    RoomTypeID INT NOT NULL,
    HotelID INT NOT NULL,
    RoomName VARCHAR(100) NOT NULL,
    PricePerNight DECIMAL(10, 2) NOT NULL,
    Description TEXT,
    Capacity INT NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID) ON DELETE CASCADE,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE
);

-- Bảng RoomAmenities (unchanged - after Rooms and Amenities)
CREATE TABLE RoomAmenities (
    RoomID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (RoomID, AmenityID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE,
    FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID) ON DELETE CASCADE
);

-- Bảng địa chỉ chung (unchanged)
CREATE TABLE Addresses (
    AddressID INT AUTO_INCREMENT PRIMARY KEY,
    AddressType ENUM('Customer', 'Hotel') NOT NULL,  -- Phân loại địa chỉ
    EntityID INT NOT NULL,  -- ID của khách hàng hoặc khách sạn
    StreetAddress VARCHAR(255) NOT NULL,
    Ward VARCHAR(100),  
    District VARCHAR(100), 
    City VARCHAR(100) NOT NULL, 
    PostalCode VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Bookings (unchanged - after Customers and Rooms)
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    Status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    NumberOfGuests INT NOT NULL,
    EstimatedArrivalTime TIMESTAMP,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    BookingCode VARCHAR(20) UNIQUE NOT NULL,  -- Trường mã đặt phòng
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);

-- Bảng Payments (unchanged - after Bookings)
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer') NOT NULL,
    PaymentStatus ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

-- Bảng RoomImages (unchanged - after Rooms)
CREATE TABLE RoomImages (
    ImageID INT AUTO_INCREMENT PRIMARY KEY,
    RoomID INT NOT NULL,
    ImageURL VARCHAR(255) NOT NULL,
    IsPrimary BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);

-- Bảng Reviews (unchanged - after Accounts and Rooms)
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    RoomID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);

CREATE INDEX idx_room_availability ON Rooms(IsAvailable);
CREATE INDEX idx_booking_dates ON Bookings(CheckInDate, CheckOutDate);
CREATE INDEX idx_hotel_name ON Hotels(HotelName);


-- Use the booking_hotel database
USE booking_hotel;

-- Insert data into Accounts table
INSERT INTO Accounts (Username, PasswordHash, Role) VALUES
('admin1', '123456', 'Admin'),
('staff1', '123456', 'Staff'), 
('staff2', '123456', 'Staff'),
('customer1', '123456', 'Customer'),
('customer2', '123456', 'Customer'),
('customer3', '123456', 'Customer');

-- Insert data into Users table (Staff)
INSERT INTO Users (AccountID, FullName, Email, PhoneNumber) VALUES
(1, 'Admin User', 'admin@hotel.com', '0901234567'),
(2, 'Staff One', 'staff1@hotel.com', '0912345678'),
(3, 'Staff Two', 'staff2@hotel.com', '0923456789');

-- Insert data into Customers table
INSERT INTO Customers (AccountID, FullName, Email, PhoneNumber, DateOfBirth, Nation, Gender) VALUES
(4, 'Nguyen Van A', 'customera@example.com', '0934567890', '1990-05-15', 'Vietnam', 'Male'),
(5, 'Tran Thi B', 'customerb@example.com', '0945678901', '1985-10-20', 'Vietnam', 'Female'),
(6, 'Le Van C', 'customerc@example.com', '0956789012', '1995-02-25', 'Vietnam', 'Male');

-- Insert data into Hotels table
INSERT INTO Hotels (HotelName, PhoneNumber, Email, Description) VALUES
('Luxury Hotel Da Nang', '0284123456', 'luxury@hotel.com', 'A 5-star hotel with ocean view in Da Nang'),
('Boutique Hotel Hanoi', '0243456789', 'boutique@hotel.com', 'Charming boutique hotel in Hanoi Old Quarter'),
('Resort Hotel Phu Quoc', '0297891234', 'resort@hotel.com', 'Beachfront resort with private villas');

-- Insert data into Addresses table for Hotels
INSERT INTO Addresses (AddressType, EntityID, StreetAddress, Ward, District, City, PostalCode) VALUES
('Hotel', 1, '123 Beach Boulevard', 'My An', 'Ngu Hanh Son', 'Da Nang', '550000'),
('Hotel', 2, '45 Hang Bac Street', 'Hang Bac', 'Hoan Kiem', 'Hanoi', '100000'),
('Hotel', 3, '78 Beach Road', 'Duong Dong', 'Phu Quoc', 'Kien Giang', '920000');

-- Insert data into Addresses table for Customers
INSERT INTO Addresses (AddressType, EntityID, StreetAddress, Ward, District, City, PostalCode) VALUES
('Customer', 1, '456 Nguyen Hue Boulevard', 'Ben Nghe', 'District 1', 'Ho Chi Minh', '700000'),
('Customer', 2, '789 Le Loi Street', 'Phan Chu Trinh', 'Hoan Kiem', 'Hanoi', '100000'),
('Customer', 3, '321 Tran Phu Street', 'Hai Chau', 'Hai Chau', 'Da Nang', '550000');

-- Insert data into RoomTypes table
INSERT INTO RoomTypes (RoomTypeName) VALUES
('Standard'),
('Deluxe'),
('Suite'),
('Executive'),
('Family');

-- Insert data into Amenities table
INSERT INTO Amenities (AmenityName) VALUES
('Wi-Fi'),
('Air Conditioning'),
('Mini Bar'),
('Flat-screen TV'),
('Private Bathroom'),
('Bathtub'),
('Ocean View'),
('Mountain View'),
('Balcony'),
('Coffee Maker');

-- Insert data into Rooms table (using the HotelID values from Hotels table)
INSERT INTO Rooms (RoomTypeID, HotelID, RoomName, PricePerNight, Description, Capacity, IsAvailable) VALUES
(1, 1, 'Standard Room 101', 1200000, 'Comfortable standard room with city view', 2, TRUE),
(2, 1, 'Deluxe Room 201', 1800000, 'Spacious deluxe room with ocean view', 2, TRUE),
(3, 1, 'Suite 301', 2500000, 'Luxury suite with separate living area', 4, TRUE),
(1, 2, 'Standard Room A1', 900000, 'Cozy standard room in Hanoi Old Quarter', 2, TRUE),
(2, 2, 'Deluxe Room B1', 1400000, 'Deluxe room with traditional decor', 2, TRUE),
(4, 2, 'Executive Room C1', 1900000, 'Executive room with business amenities', 2, TRUE),
(3, 3, 'Beach Suite V1', 3200000, 'Beach front suite with private terrace', 2, TRUE),
(5, 3, 'Family Villa F1', 4500000, 'Two-bedroom family villa near the beach', 6, TRUE),
(2, 3, 'Deluxe Bungalow B1', 2800000, 'Private bungalow with garden view', 3, TRUE);

-- Insert data into RoomAmenities table
INSERT INTO RoomAmenities (RoomID, AmenityID) VALUES
(1, 1), (1, 2), (1, 4), (1, 5), -- Standard Room 101
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 7), (2, 9), -- Deluxe Room 201
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 9), (3, 10), -- Suite 301
(4, 1), (4, 2), (4, 4), (4, 5), -- Standard Room A1
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 8), -- Deluxe Room B1
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), (6, 8), (6, 10), -- Executive Room C1
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7), (7, 9), (7, 10), -- Beach Suite V1
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 6), (8, 7), (8, 9), (8, 10), -- Family Villa F1
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5), (9, 10); -- Deluxe Bungalow B1

-- Insert data into Bookings table
INSERT INTO Bookings (CustomerID, RoomID, CheckInDate, CheckOutDate, TotalPrice, Status, NumberOfGuests, BookingCode) VALUES
(1, 2, '2024-03-15', '2024-03-20', 9000000, 'Confirmed', 2, 'BK-20240315-001'),
(2, 5, '2024-03-10', '2024-03-12', 2800000, 'Confirmed', 2, 'BK-20240310-002'),
(3, 8, '2024-04-01', '2024-04-07', 27000000, 'Pending', 5, 'BK-20240401-003'),
(1, 9, '2024-05-10', '2024-05-15', 14000000, 'Confirmed', 3, 'BK-20240510-004'),
(2, 3, '2024-06-20', '2024-06-25', 12500000, 'Pending', 2, 'BK-20240620-005');

-- Insert data into Payments table
INSERT INTO Payments (BookingID, PaymentMethod, PaymentStatus, Amount) VALUES
(1, 'Credit Card', 'Completed', 9000000),
(2, 'PayPal', 'Completed', 2800000),
(3, 'Bank Transfer', 'Pending', 27000000),
(4, 'Credit Card', 'Completed', 14000000),
(5, 'Debit Card', 'Pending', 12500000);

-- Insert data into RoomImages table
INSERT INTO RoomImages (RoomID, ImageURL, IsPrimary) VALUES
(1, 'https://hotel-images.com/luxury/standard101-1.jpg', TRUE),
(1, 'https://hotel-images.com/luxury/standard101-2.jpg', FALSE),
(2, 'https://hotel-images.com/luxury/deluxe201-1.jpg', TRUE),
(2, 'https://hotel-images.com/luxury/deluxe201-2.jpg', FALSE),
(3, 'https://hotel-images.com/luxury/suite301-1.jpg', TRUE),
(4, 'https://hotel-images.com/boutique/standarda1-1.jpg', TRUE),
(5, 'https://hotel-images.com/boutique/deluxeb1-1.jpg', TRUE),
(6, 'https://hotel-images.com/boutique/executivec1-1.jpg', TRUE),
(7, 'https://hotel-images.com/resort/beachv1-1.jpg', TRUE),
(8, 'https://hotel-images.com/resort/familyf1-1.jpg', TRUE),
(9, 'https://hotel-images.com/resort/bungalowb1-1.jpg', TRUE);

-- Insert data into Reviews table
INSERT INTO Reviews (AccountID, RoomID, Rating, Comment) VALUES
(4, 2, 5, 'Amazing room with beautiful ocean view. Service was excellent.'),
(5, 5, 4, 'Very comfortable room with nice traditional touches. Would recommend!'),
(6, 7, 5, 'Perfect getaway. The beach suite was luxurious and private.'),
(4, 9, 4, 'Lovely bungalow with great amenities. Just a short walk to the beach.'),
(5, 3, 5, 'The suite exceeded our expectations. Spacious and beautifully decorated.');