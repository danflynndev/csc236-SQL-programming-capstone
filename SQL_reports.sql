-- Daniel Flynn
-- Final Project Queries
-- CSC-236-WB SM21

/* ___ CHAPTER 8: SORTING DATA AND RESTRICTING ROWS ___ */

-- Q1
-- Verify all invoices from the week ending 8/8 have been paid. Include in the report the invoice number, date ordered and paid status. List most recent invoices first.

SELECT invoice#, order_date, paid 
FROM invoices 
WHERE order_date BETWEEN '2-AUG-2021' AND '8-AUG-2021'
ORDER BY order_date DESC;

-- Q2
-- List invoices from Craft Collective that contain an order for two or more of the same keg. 

SELECT DISTINCT i.invoice#, ii.quantity
FROM invoices i, inv_items ii
WHERE i.invoice# = ii.invoice#
AND (ii.quantity >= 2 AND ii.volume IN (1984, 1690))
AND i.dist_id = 1;


/* ___ CHAPTER 9: JOINING DATA ___ */

-- Q3
-- A rep from Smuttynose Brewing hosted an event on August 13th and wants to know if it was a success. List sales tickets from the 13th which contain a Smuttynose product. Include the name of the product purchased as well as the rep's email for convenient viewing.

SELECT UNIQUE ticket#, prod_name, bemail
FROM brew_reps JOIN breweries USING(brewery_id) JOIN products USING(brewery_id) JOIN saleitems USING(sku)
WHERE b_name LIKE '%SMUTTYNOSE%';

-- Q4
-- List all product names as well as the associated brewery and distributor. Include a sales ticket number if the product has been ordered, but do not omit the product if it has not been ordered. Organize by brewery and distributor.

SELECT p.prod_name product, b.b_name brewery, d.d_name distributor, s.ticket# sale_no
FROM sales s RIGHT OUTER JOIN saleitems si ON s.ticket# = si.ticket#
RIGHT OUTER JOIN products p ON si.sku = p.sku
RIGHT OUTER JOIN breweries b ON p.brewery_id = b.brewery_id
RIGHT OUTER JOIN distributors d ON b.dist_id = d.dist_id
ORDER BY b.b_name, d.d_name;


Chapter 10: Single-row Functions

-- Q5
-- List all product names and descriptions. If no description exists, the report should indicate that fact, rather than simply show null. 

SELECT INITCAP(prod_name) product, NVL2(descrip, LOWER(descrip), '-no description provided-') description
FROM products;

-- Q6
-- Management wants to see the order minimums and prompt pay discounts for all distributors. They plan to contact the distributor reps to verify so include first and last names. Make sure the report is easy for this manager to read understanding that they expect proper number formatting, dislike caps-lock, and need full names contained in one field. 

SELECT INITCAP(d_name) "Distributor", 
  TO_CHAR(order_min, '$999.99') "Minimum", 
  NVL2(pp_disc, CONCAT(pp_disc, '%'), 'No Discount') "Discount",
  CONCAT(INITCAP(rep_fname), 
  CONCAT(' ', INITCAP(rep_lname))) "Representative"
FROM distributors d LEFT OUTER JOIN dist_reps dr ON d.dist_id = dr.dist_id;


/* ___ CHAPTER 11: GROUP FUNCTIONS ___ */

-- Q7
-- Craft Brewers guild offers a monthly discount if a certain number of items are ordered. Generate a report displaying the total number of items purchased from this supplier.

SELECT d_name distributor, SUM(quantity) kegs_ordered
FROM distributors d, invoices i, inv_items ii
WHERE d.dist_id = i.dist_id 
AND i.invoice# = ii.invoice#
AND volume IN (1984, 1690)
AND order_date BETWEEN '01-AUG-2021' AND '31-AUG-2021'
GROUP BY d_name
HAVING d_name = 'CRAFT MASSACHUSETTS';

-- Q8
-- Display the total amount due for each invoice as well as the distributor. Include a sum of invoices for each distributor. 

SELECT NVL2(invoice#, invoice#, 'Sum of invoices') invoice, 
  NVL2(d_name, d_name, 'Repeat record') distributor, 
  TO_CHAR(SUM(quantity * cost), '$99999.99') total
FROM inv_items JOIN invoices USING(invoice#) JOIN distributors USING(dist_id)
GROUP BY GROUPING SETS (invoice#, d_name, (invoice#, d_name), ())
ORDER BY d_name, total;


/* ___ CHAPTER 12: SUBQUERIES ___ */ 

-- Q9
-- List all products that share a style with the most purchased style. 

SELECT prod_name, style 
FROM products
WHERE style = (

    SELECT style 
    FROM saleitems JOIN products USING(sku) 
    GROUP BY style HAVING SUM(si_quant) = (

        SELECT MAX(SUM(si_quant)) 
        FROM saleitems JOIN products USING(sku) 
        GROUP BY style
    )
);

-- Q10
-- Management wants to analyze sales trends by looking at days and purchases with higher than average profitability. Generate a report showing the ticket number and date of sales with a higher average profit-per-ounce than the overall total average. 

SELECT ticket#, t_date sale_date
FROM sales JOIN saleitems USING(ticket#) JOIN products USING(sku) JOIN inv_items USING(sku) JOIN invoices USING(invoice#)
GROUP BY ticket#, t_date
HAVING AVG((paid_per / si_vol) - (cost / volume)) > (
    SELECT AVG((paid_per / si_vol) - (cost / volume))
    FROM saleitems JOIN products USING(sku) JOIN inv_items USING(sku) JOIN invoices USING(invoice#)
);

