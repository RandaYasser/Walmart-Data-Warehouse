-- Insert seasonal and general promotions with accurate discount percentages for bundles
INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (1, 101, 'Year End Sale', 'Discount', 25.00, TO_DATE('2022-12-15', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (2, 102, 'Ramadan Offers', 'Discount', 30.00, TO_DATE('2022-03-20', 'YYYY-MM-DD'), TO_DATE('2022-04-02', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (3, 103, 'Eid al-Adha Deals', 'Bundle (Buy 2 Get 1)', 33.33, TO_DATE('2022-07-05', 'YYYY-MM-DD'), TO_DATE('2022-07-12', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (4, 104, 'Black Friday Sale', 'Discount', 50.00, TO_DATE('2022-11-25', 'YYYY-MM-DD'), TO_DATE('2022-11-25', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (5, 105, 'Back to School Discounts', 'Bundle (Buy 1 Get 1)', 50.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-01', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (6, 106, 'New Year Offers', 'Discount', 20.00, TO_DATE('2022-12-26', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (7, 107, 'Summer Sale', 'Discount', 35.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (8, 108, 'Clearance Sale', 'Bundle (Buy 3 Get 2)', 40.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-02-15', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (9, 109, 'Weekend Flash Sale', 'Discount', 10.00, TO_DATE('2022-09-17', 'YYYY-MM-DD'), TO_DATE('2022-09-18', 'YYYY-MM-DD'));

INSERT INTO dimPromotion (PromotionSK, PromotionBK, Promotion_name, Promotion_type, discount_percentage, Start_date, End_date) 
VALUES (10, 110, 'Special Loyalty Discounts', 'Discount', 5.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-03-31', 'YYYY-MM-DD'));
