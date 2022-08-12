DROP TABLE breweries CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE distributors CASCADE CONSTRAINTS;
DROP TABLE dist_reps CASCADE CONSTRAINTS;
DROP TABLE brew_reps CASCADE CONSTRAINTS;
DROP TABLE del_days CASCADE CONSTRAINTS;
DROP TABLE days CASCADE CONSTRAINTS;
DROP TABLE invoices CASCADE CONSTRAINTS;
DROP TABLE inv_items CASCADE CONSTRAINTS;
DROP TABLE buyers CASCADE CONSTRAINTS;
DROP TABLE sales CASCADE CONSTRAINTS;
DROP TABLE saleitems CASCADE CONSTRAINTS;

DROP SEQUENCE distreps_repid_seq;
DROP SEQUENCE brewreps_brepid_seq;
DROP SEQUENCE tickets_ticket#_seq;


/* Define sequences */

CREATE SEQUENCE distreps_repid_seq
    START WITH 1
    INCREMENT BY 2
    MAXVALUE 99
    CYCLE
    NOCACHE;
    
CREATE SEQUENCE brewreps_brepid_seq
    START WITH 2
    INCREMENT BY 2
    MAXVALUE 98
    CYCLE
    NOCACHE;
    
CREATE SEQUENCE tickets_ticket#_seq
    START WITH 100000
    INCREMENT BY 1
    MAXVALUE 999999
    NOCYCLE
    NOCACHE;
   
   
/* Distributors table */

CREATE TABLE distributors (
    dist_id CHAR(1), 
    d_name VARCHAR2(30),
    acct_no VARCHAR2(15),
    order_min NUMBER(5, 2) DEFAULT 0,
    pp_disc NUMBER(3, 1),
      CONSTRAINT distributors_distid_pk PRIMARY KEY (dist_id)
);


INSERT INTO distributors VALUES ('0', 'CRAFT MASSACHUSETTS', '376219', '200', '');
INSERT INTO distributors VALUES ('1', 'CRAFT COLLECTIVE', 'G7843', '350', '1.5');
INSERT INTO distributors VALUES ('2', 'ATLANTIC BEVERAGE DISTRIBUTORS', '9930103', '250', '2');
INSERT INTO distributors VALUES ('3', 'BURKE DISTRIBUTING', '203B777', '400', '1');
INSERT INTO distributors VALUES ('4', 'HOMEGROWN DISTRIBUTION', '0045944', '150', '');


/* Distributor reps table */

CREATE TABLE dist_reps (
    rep_id VARCHAR2(2),
    dist_id CHAR(1) NOT NULL,
    rep_lname VARCHAR2(15),
    rep_fname VARCHAR2(15),
    phone CHAR(10),
    email VARCHAR2(35),
      CONSTRAINT distreps_distid_fk FOREIGN KEY (dist_id) REFERENCES distributors (dist_id),
      CONSTRAINT distreps_email_ck CHECK (email LIKE '%@%.%')
);


INSERT INTO dist_reps VALUES (distreps_repid_seq.NEXTVAL, '0', 'AUBUCHON', 'JEAN MARC', '6175555555', 'JMABUCHON@CRAFT-MA.COM');
INSERT INTO dist_reps VALUES (distreps_repid_seq.NEXTVAL, '1', 'MEUSE', 'ADAM', '6172225555', 'MEUSE@GETCRAFT.COM');
INSERT INTO dist_reps VALUES (distreps_repid_seq.NEXTVAL, '2', 'SHALIHAN', 'DREW', '7085554321', 'DREW@ATLANTICBEVERAGE.COM');
INSERT INTO dist_reps VALUES (distreps_repid_seq.NEXTVAL, '2', 'COHEN', 'SETH', '6176667777', 'SETH@ATLANTICBEVERAGE.COM');
INSERT INTO dist_reps VALUES (distreps_repid_seq.NEXTVAL, '3', 'CURRIER', 'CHRIS', '7088971234', 'CCURRIER@BURKEDIST.COM');


/* Days of the week lookup table */

CREATE TABLE days (
    day_key CHAR(1),
    day CHAR(3) NOT NULL,
      CONSTRAINT days_daykey_pk PRIMARY KEY (day_key)
);


INSERT INTO days VALUES (0, 'MON');
INSERT INTO days VALUES (1, 'TUE');
INSERT INTO days VALUES (2, 'WED');
INSERT INTO days VALUES (3, 'THU');
INSERT INTO days VALUES (4, 'FRI');


/* Delivery days bridge table */

CREATE TABLE del_days (
    dist_id CHAR(1),
    day_key CHAR(1),
      CONSTRAINT deldays_comp_pk PRIMARY KEY (dist_id, day_key), 
      CONSTRAINT deldays_distid_fk FOREIGN KEY (dist_id) REFERENCES distributors (dist_id),
      CONSTRAINT deldays_dayid_fk FOREIGN KEY (day_key) REFERENCES days (day_key)
);

                                      
INSERT INTO del_days VALUES ('0', '0');  
INSERT INTO del_days VALUES ('0', '1');
INSERT INTO del_days VALUES ('0', '2');
INSERT INTO del_days VALUES ('0', '4');
INSERT INTO del_days VALUES ('1', '1');  
INSERT INTO del_days VALUES ('1', '3');
INSERT INTO del_days VALUES ('2', '0'); 
INSERT INTO del_days VALUES ('2', '2');
INSERT INTO del_days VALUES ('2', '4');
INSERT INTO del_days VALUES ('3', '1');  
INSERT INTO del_days VALUES ('3', '3');
INSERT INTO del_days VALUES ('3', '4');
INSERT INTO del_days VALUES ('4', '0');  
INSERT INTO del_days VALUES ('4', '2');


/* Breweries table */ 

CREATE TABLE breweries (
    brewery_id CHAR(4),
    dist_id CHAR(1),
    b_name VARCHAR2(55) NOT NULL,
    street VARCHAR2(30),
    city VARCHAR2(15),
    state CHAR(2),
    zip CHAR(5),
      CONSTRAINT breweries_breweryid_pk PRIMARY KEY (brewery_id),
      CONSTRAINT breweries_distid_fk FOREIGN KEY (dist_id) REFERENCES distributors (dist_id)
);


INSERT INTO breweries VALUES ('AL01', '0','ALLAGASH BREWING CO.', '50 INDUSTRIAL WAY', 'PORTLAND', 'ME', '04103');
INSERT INTO breweries VALUES ('FI03', '1','FIDDLEHEAD BREWING CO.', '6305 SHELBURNE RD', 'SHELBURNE', 'VT', '05482');
INSERT INTO breweries VALUES ('JA11', '2','JACK''S ABBY CRAFT LAGERS', '100 CLINTON ST', 'FRAMINGHAM', 'MA', '01702');
INSERT INTO breweries VALUES ('WI21', '3','WINTER HILL BREWING CO.', '328 BROADWAY', 'SOMERVILLE', 'MA', '02145');
INSERT INTO breweries VALUES ('RE30', '3','REMNANT BREWING', '2 BOW MARKET WAY', 'SOMERVILLE', 'MA', '02143');
INSERT INTO breweries VALUES ('SM01', '0', 'SMUTTYNOSE BREWING CO.', '105 TOWLE FARM RD', 'HAMPTON', 'NH', '03842');
INSERT INTO breweries VALUES ('LO66', '4', 'LONE PINE BREWING CO.', '219 ANDERSON ST', 'PORTLAND', 'ME', '04101');


/* Brewery reps table */

CREATE TABLE brew_reps (
    brep_id VARCHAR2(2),
    brewery_id CHAR(4),
    brep_fname VARCHAR2(15),
    brep_lname VARCHAR(15),
    bphone CHAR(10),
    bemail VARCHAR2(35),
      CONSTRAINT brewreps_brepid_pk PRIMARY KEY (brep_id),
      CONSTRAINT brewreps_breweryid_fk FOREIGN KEY (brewery_id) REFERENCES breweries (brewery_id),
      CONSTRAINT brewreps_bemail_ck CHECK (bemail LIKE '%@%.%')
);


INSERT INTO brew_reps VALUES (brewreps_brepid_seq.NEXTVAL, 'AL01', 'JACOBS', 'MARISSA', '2075558585', 'MJACOBS@ALLAGASH.COM');
INSERT INTO brew_reps VALUES (brewreps_brepid_seq.NEXTVAL, 'FI03', 'LANG', 'ARTIE', '8026072121', 'ARTIE@FIDDLEHEADBREWING.COM');
INSERT INTO brew_reps VALUES (brewreps_brepid_seq.NEXTVAL, 'JA11', 'O''CONNOR', 'MANDY', '5085556868', 'OCONNORM@JACKSABBY.COM');
INSERT INTO brew_reps VALUES (brewreps_brepid_seq.NEXTVAL, 'WI21', 'HOLDREDGE', 'BERT', '6178761234', 'BHOLDREDGE@WINTER-HILL.COM');
INSERT INTO brew_reps VALUES (brewreps_brepid_seq.NEXTVAL, 'RE30', 'LAJOIE', 'BRITTANY', '6177772345', 'BRITLAJOIE@REMNANT.COM');
INSERT INTO brew_reps VALUES (brewreps_brepid_seq.NEXTVAL, 'SM01', 'GRANT', 'DOMINIQUE', '6178889999', 'DOMINIQUE@FINESTKINDBREWING.COM');


/* Buyers table */ 

CREATE TABLE buyers (
    emp_no VARCHAR2(2),
    emp_fname VARCHAR2(15) NOT NULL,
    emp_lname VARCHAR(15) NOT NULL,
      CONSTRAINT buyers_empno_pk PRIMARY KEY (emp_no)
);


INSERT INTO buyers VALUES ('01', 'FLYNN', 'DANIEL');
INSERT INTO buyers VALUES ('02', 'DEE', 'SARAH');
INSERT INTO buyers VALUES ('03', 'JACKSON', 'VALERIE');


/* Products table */

CREATE TABLE products (
    sku VARCHAR2(18),
    brewery_id CHAR(4),
    prod_name VARCHAR2(45) NOT NULL,
    style VARCHAR2(15) NOT NULL,
    abv NUMBER(3, 1) NOT NULL,
    descrip VARCHAR2(120),
    seasonal CHAR(1),
      CONSTRAINT products_sku_pk PRIMARY KEY (sku),
      CONSTRAINT products_breweryid_fk FOREIGN KEY (brewery_id) REFERENCES breweries (brewery_id),
      CONSTRAINT products_seasonal_ck CHECK (seasonal IN ('Y', 'N'))
);


INSERT INTO products VALUES ('1163528', 'AL01', 'ALLAGASH WHITE', 'WITBIER', '6', '', 'N');
INSERT INTO products VALUES ('1163530', 'AL01', 'CURIEUX', 'TRIPEL', '10.2', 'GOLDEN TRIPEL AGED IN BOURBON BARRELS', 'Y');
INSERT INTO products VALUES ('10987523', 'JA11', 'HOUSE LAGER', 'LAGER', '5', '', 'N');
INSERT INTO products VALUES ('10389743', 'JA11', 'POST SHIFT PILS', 'PILSNER', '4', '', 'N');
INSERT INTO products VALUES ('19287194', 'JA11', 'HOPONIUS UNION', 'IPL', '6.2', 'BOLD HOPPINESS OF IPA MEETS REFRESHING DRINKABILITY OF LAGER', 'N');
INSERT INTO products VALUES ('23545', 'FI03', 'FIDDLEHEAD IPA', 'IPA', '7', 'THE FLAGSHIP', 'N');
INSERT INTO products VALUES ('34238', 'FI03', 'RARIFIED AIR', 'PALE ALE', '5.4', 'DDH HAZY PALE. LIMITED AVAILIBILITY', 'Y');
INSERT INTO products VALUES ('250379', 'WI21', 'THREE THREADS', 'PORTER', '6.5', 'ROBUST AND SMOKEY MALT', 'N');
INSERT INTO products VALUES ('8888122', 'RE30', 'DREAM POP', 'APA', '5.2', 'FIRST OFF-SITE DRAFT OFFERING FROM REMNANT', 'N');
INSERT INTO products VALUES ('0987987', 'SM01', 'FINESTKIND IPA', 'IPA', '6.7', '', 'N');
INSERT INTO products VALUES ('1266243', 'SM01', 'OLD BROWN DOG', 'BROWN ALE', '6', 'ROASTED MALT BACKBONE WITH A COMPLEMENTARY HOP BALANCE', 'N');
INSERT INTO products VALUES ('8888', 'LO66', 'OH-J', 'IPA', '8', '', 'N');


/* Invoices table */

CREATE TABLE invoices (
    invoice# VARCHAR2(20),
    dist_id CHAR(1),
    order_date DATE DEFAULT SYSDATE,
    del_date DATE DEFAULT SYSDATE+1,
    emp_no VARCHAR2(2),
    paid CHAR(1) DEFAULT 'N',
      CONSTRAINT invoices_invoice#_pk PRIMARY KEY (invoice#),
      CONSTRAINT invoices_distid_fk FOREIGN KEY (dist_id) REFERENCES distributors (dist_id),
      CONSTRAINT invoices_empno_fk FOREIGN KEY (emp_no) REFERENCES buyers (emp_no),
      CONSTRAINT invoices_paid_ck CHECK (paid IN ('Y', 'N'))
);


INSERT INTO invoices VALUES ('51078140-3578', '0', '02-AUG-2021', '03-AUG-2021', '01', 'Y'); 
INSERT INTO invoices VALUES ('0752490023458', '2', '02-AUG-2021', '04-AUG-2021', '01', 'Y'); 
INSERT INTO invoices VALUES ('172048-1123', '3', '05-AUG-2021', '06-AUG-2021', '03', 'Y'); 
INSERT INTO invoices VALUES ('45310705-4237', '0', '09-AUG-2021', '10-AUG-2021', '01', 'Y'); 
INSERT INTO invoices VALUES ('41079278901', '1', '09-AUG-2021', '10-AUG-2021', '01', 'Y'); 
INSERT INTO invoices VALUES ('753240-0234', '3', '09-AUG-2021', '10-AUG-2021', '01','Y'); 
INSERT INTO invoices VALUES ('0275983402207', '2', '16-AUG-2021', '17-AUG-2021', '01', 'Y');
INSERT INTO invoices VALUES ('57238490523', '1', '17-AUG-2021', '19-AUG-2021', '02', 'Y'); 
INSERT INTO invoices VALUES ('41079225461', '1', '23-AUG-2021', '24-AUG-2021', '01', 'N'); 


/* Invoice items bridge table */

CREATE TABLE inv_items (
    line_item NUMBER(2,0),
    invoice# VARCHAR2(20),
    sku VARCHAR2(15),
    cost NUMBER(5,2) NOT NULL,
    quantity NUMBER(2,0) NOT NULL,
    volume NUMBER(6,2) NOT NULL,
      CONSTRAINT invitems_comp_pk PRIMARY KEY (line_item, invoice#, sku),
      CONSTRAINT invitems_invoice#_fk FOREIGN KEY (invoice#) REFERENCES invoices (invoice#),
      CONSTRAINT invitems_sku_fk FOREIGN KEY (sku) REFERENCES products (sku)
);

INSERT INTO inv_items VALUES ('1', '51078140-3578', '1163528', '180', '1', '1984');
INSERT INTO inv_items VALUES ('2', '51078140-3578', '0987987', '165', '2', '1984');
INSERT INTO inv_items VALUES ('1', '0752490023458', '10987523', '155', '2', '1984');
INSERT INTO inv_items VALUES ('2', '0752490023458', '19287194', '55', '2', '384');
INSERT INTO inv_items VALUES ('1', '41079278901', '23545', '140', '4', '1690');
INSERT INTO inv_items VALUES ('1', '45310705-4237', '1163528', '180', '1', '1984');
INSERT INTO inv_items VALUES ('2', '45310705-4237', '0987987', '165', '2', '1984');
INSERT INTO inv_items VALUES ('1', '753240-0234', '250379', '200', '1', '1984');
INSERT INTO inv_items VALUES ('2', '753240-0234', '8888122', '95', '3', '660');
INSERT INTO inv_items VALUES ('1', '0275983402207', '10987523', '155', '2', '1984');
INSERT INTO inv_items VALUES ('2', '0275983402207', '10389743', '33', '4', '288');
INSERT INTO inv_items VALUES ('3', '0275983402207', '19287194', '55', '2', '384');
INSERT INTO inv_items VALUES ('1', '57238490523', '23545', '140', '4', '1690');
INSERT INTO inv_items VALUES ('1', '41079225461', '23545', '140', '2', '1690');
INSERT INTO inv_items VALUES ('2', '41079225461', '34238', '140', '2', '1690');


/* Sales table */

CREATE TABLE sales (
    ticket# CHAR(6),
    t_date DATE DEFAULT SYSDATE,
    cc_last_4 CHAR(4) NOT NULL,
    cc_type VARCHAR2(4),
      CONSTRAINT sales_ticket#_pk PRIMARY KEY (ticket#),
      CONSTRAINT sales_cctype_ck CHECK (cc_type IN ('VISA', 'MC', 'AMEX', 'DISC'))
);


/* Sale items bridge table */

CREATE TABLE saleitems (
    ticket# CHAR(6),
    sku VARCHAR2(15),
    si_quant NUMBER(2,0) DEFAULT 1,
    si_vol NUMBER(2,0) NOT NULL,
    paid_per NUMBER(5,2) NOT NULL,
      CONSTRAINT saleitems_ticket#_sku_pk PRIMARY KEY (ticket#, sku),
      CONSTRAINT saleitems_ticket#_fk FOREIGN KEY (ticket#) REFERENCES sales (ticket#),
      CONSTRAINT saleitems_sku_fk FOREIGN KEY (sku) REFERENCES products (sku)
);

/* Insert sales - uses sequencing */

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '13-AUG-2021', '4567', 'VISA');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '0987987', '4', '16', '6.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '13-AUG-2021', '2455', 'MC');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '0987987', '1', '16', '6.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '13-AUG-2021', '3855', 'MC');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '1266243', '2', '16', '6.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '13-AUG-2021', '2455', 'DISC');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '0987987', '1', '16', '6.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '13-AUG-2021', '1111', 'MC'); 
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '8888122', '2', '16', '7.5');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '1163528', '2', '16', '6.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '15-AUG-2021', '4567', 'VISA');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '23545', '1', '16', '7');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '0987987', '3', '16', '6.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '15-AUG-2021', '4567', 'VISA');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '23545', '2', '16', '7');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '15-AUG-2021', '4567', 'VISA');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '1163530', '1', '10', '10');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '18-AUG-2021', '9801', 'AMEX');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '8888122', '1', '16', '7.5');

INSERT INTO sales VALUES (tickets_ticket#_seq.NEXTVAL, '21-AUG-2021', '1678', 'VISA');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '1163530', '1', '10', '10');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '250379', '1', '16', '7');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '34238', '1', '16', '8');
INSERT INTO saleitems VALUES (tickets_ticket#_seq.CURRVAL, '10389743', '1', '12', '5.5');