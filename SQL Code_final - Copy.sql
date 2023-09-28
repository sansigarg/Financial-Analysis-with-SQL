USE H_Accounting;

DROP PROCEDURE IF EXISTS H_Accounting.sp_rajkevsan;

DELIMITER $$

CREATE PROCEDURE H_Accounting.sp_rajkevsan(IN FY SMALLINT)
	READS SQL DATA

BEGIN

-- ---------------------- Query for Profit and Loss --------------------------------------	

-- ----------------------Profit and Loss Variables-----------------------------------------
	-- Declaring Current Year varaibles
	-- Declaring variables for total revenue and Expense
	    DECLARE varTotalRevenue DOUBLE DEFAULT 0;
	    DECLARE varTotalExpense DOUBLE DEFAULT 0;
	    DECLARE varProfit_Loss DOUBLE DEFAULT 0;
		    
	-- Declaring variable for individual Revenue elements
	    DECLARE varRevenue DOUBLE DEFAULT 0;
	    DECLARE varOtherIncome DOUBLE DEFAULT 0;

	 -- Declaring Variable for COGs   
	    DECLARE varCOGS DOUBLE DEFAULT 0;
	    
	-- Declaring varaibles for Expenses
	    DECLARE varSellingexpense DOUBLE DEFAULT 0;
	    DECLARE varOtherExpenses DOUBLE DEFAULT 0;
	
	-- Declaring variable for Taxes
	   DECLARE varTaxes DOUBLE DEFAULT 0;
	
	-- Declaring additional variables 
	   DECLARE varEBITDA DOUBLE DEFAULT 0;
	   DECLARE varGPM DOUBLE DEFAULT 0;
       DECLARE varnetprofit DOUBLE DEFAULT 0;
	   DECLARE vargrossprofitmargin DOUBLE DEFAULT 0;
	
       
	-- Declaring Last Year varaibles
	
	-- Declaring variables for LY total revenue and Expense
	    DECLARE varTotalRevenueLY DOUBLE DEFAULT 0;
	    DECLARE varTotalExpenseLY DOUBLE DEFAULT 0;
	    DECLARE varProfit_LossLY DOUBLE DEFAULT 0;
	    
	-- Declaring variable for LY individual Revenue elements
	    DECLARE varRevenueLY DOUBLE DEFAULT 0;
	    DECLARE varOtherIncomeLY DOUBLE DEFAULT 0;

	 -- Declaring Variable for LY COGs   
	    DECLARE varCOGSLY DOUBLE DEFAULT 0;
	    
	-- Declaring varaibles for LY Expenses
	    DECLARE varSellingexpenseLY DOUBLE DEFAULT 0;
	    DECLARE varOtherExpensesLY DOUBLE DEFAULT 0;
	
	-- Declaring variable for LY Taxes
	   DECLARE varTaxesLY DOUBLE DEFAULT 0;
	
	-- Declaring additional variable for LY 
	   DECLARE varEBITDALY DOUBLE DEFAULT 0;   
	   DECLARE varGPMLY DOUBLE DEFAULT 0;
	

	--  Declaring variables for PNL change  
	    DECLARE varRevenuechange DOUBLE DEFAULT 0;
	    DECLARE varOtherIncomechange DOUBLE DEFAULT 0;
	    DECLARE varCOGSchange DOUBLE DEFAULT 0;
	    DECLARE varSellingexpensechange DOUBLE DEFAULT 0;
	    DECLARE varOtherExpenseschange DOUBLE DEFAULT 0;
	    DECLARE varTaxeschange DOUBLE DEFAULT 0;
	    DECLARE varEBITDAchange DOUBLE DEFAULT 0;   
	    DECLARE varGPMchange DOUBLE DEFAULT 0;
	    DECLARE varTotalRevenuechange DOUBLE DEFAULT 0;
	    DECLARE varTotalExpensechange DOUBLE DEFAULT 0;
	    DECLARE varProfit_losschange DOUBLE DEFAULT 0;

	-- --------------------Balance sheet varaibles-----------------------------   
	-- Variables for BS  data	
		    DECLARE varCurrent_Assets DOUBLE DEFAULT 0;
		    DECLARE varFixed_Assets DOUBLE DEFAULT 0;
		    DECLARE varCurrent_Liabilities DOUBLE DEFAULT 0;
		    DECLARE varEquity DOUBLE DEFAULT 0;
		    DECLARE varTotalAsset DOUBLE DEFAULT 0;
		    DECLARE varTotalLiabilities_Equity DOUBLE DEFAULT 0;

	-- Variables for BS last year data	
		DECLARE varCurrent_AssetsLY DOUBLE DEFAULT 0;
		DECLARE varFixed_AssetsLY DOUBLE DEFAULT 0;
		DECLARE varCurrent_LiabilitiesLY DOUBLE DEFAULT 0;
		DECLARE varEquityLY DOUBLE DEFAULT 0;
		DECLARE varTotalAssetLY DOUBLE DEFAULT 0;
		DECLARE varTotalLiabilities_EquityLY DOUBLE DEFAULT 0;
		
	-- Variables for BS change	
		DECLARE	varCurrent_Assetschange DOUBLE DEFAULT 0;
		DECLARE	varFixed_Assetschange DOUBLE DEFAULT 0;
		DECLARE	varCurrent_Liabilitiesschange DOUBLE DEFAULT 0;
		DECLARE varEquitychange DOUBLE DEFAULT 0;
		DECLARE varTotalAssetchange DOUBLE DEFAULT 0;
		DECLARE varTotalLiabilitieschange DOUBLE DEFAULT 0;
        
	-- Additional financial analysis
    /* 1. Working Capital
		  Working capital will us understand if we will be able to meet the
          current obligations like payrolls, bills and loan repayements
    */
	    DECLARE varworkingcapital DOUBLE DEFAULT 0;
      /* 2. Current Ratio
		 This tells us the liquidity of the company. 
         How easily can the company come up with cash to pay for expenses
         */
      
             DECLARE varcurrentratio DOUBLE DEFAULT 0;

-- ----------------Profit and Loss Statement-------------------


-- Storing Revenue

SELECT SUM(IFNULL(jeli.credit,0)) INTO varRevenue
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 68 )  
        AND YEAR(je.entry_date) = FY;

-- Storing Other Income
	
	SELECT SUM(IFNULL(jeli.credit,0)) INTO varOtherIncome
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 78  )  
        AND YEAR(je.entry_date) = FY;

-- Storing COGs

SELECT SUM(IFNULL(jeli.debit,0)) INTO varCOGS
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 74)
                AND YEAR(je.entry_date) = FY;


-- Storing Selling Expenses
	
	SELECT SUM(IFNULL(jeli.debit,0)) INTO varSellingexpense
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 76)
                AND YEAR(je.entry_date) = FY;


-- Storing Other Expenses
	
	SELECT SUM(IFNULL(jeli.debit,0)) INTO varOtherExpenses
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 77)
                AND YEAR(je.entry_date) = FY;

-- Storing Taxes        

	
	SELECT IFNULL((SUM(IFNULL(jeli.debit,0))),0) INTO varTaxes
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 7)
                AND YEAR(je.entry_date) = FY;


-- Calculating Total Revenue = Revenue + Other Income, Storing it in varTotalRevenue
	
	SELECT varRevenue + varOtherIncome INTO varTotalRevenue;
	
	
-- Calculating Total Expenses = Selling Expense + Other Expense, Storing it in varTotalExpense
	
	SELECT varSellingexpense + varOtherExpenses INTO varTotalExpense;

-- Calculating Gross Profit 
	
	SELECT varTotalRevenue - varCOGS INTO varGPM;

-- Calculating Gross Profit Margin

	SELECT varGPM/varRevenue INTO vargrossprofitmargin;

-- Calculating EBITDA

	SELECT  varGPM - varTotalExpense INTO varEBITDA;

-- Calculating Profit and Loss	
	
	SELECT varEBITDA - varTaxes INTO varProfit_Loss ;

-- Calculating Net Profit Margin

	SELECT varProfit_Loss/varRevenue INTO varnetprofit ;

-- ----------------------Calculation for LY---------------------------------
	        

-- Storing Revenue

SELECT SUM(IFNULL(jeli.credit,0)) INTO varRevenueLY
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 68 )  
        AND YEAR(je.entry_date) = (FY-1);

-- Storing Other Income
	
	SELECT SUM(IFNULL(jeli.credit,0)) INTO varOtherIncomeLY
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 78  )  
        AND YEAR(je.entry_date) = (FY-1);

-- Storing COGs

SELECT SUM(IFNULL(jeli.debit,0)) INTO varCOGSLY
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 74)
                AND YEAR(je.entry_date) = (FY-1);

-- Storing Selling Expenses
	
	SELECT SUM(IFNULL(jeli.debit,0)) INTO varSellingexpenseLY
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 76)
                AND YEAR(je.entry_date) = (FY-1);


-- Storing Other Expenses
	
	SELECT SUM(IFNULL(jeli.debit,0)) INTO varOtherExpensesLY
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 77)
                AND YEAR(je.entry_date) = (FY-1);

-- Storing Taxes        

	
	SELECT IFNULL(SUM(IFNULL(jeli.debit,0)),0) INTO varTaxesLY
		FROM account AS a
		INNER JOIN journal_entry_line_item AS jeli
		USING(account_id)
		INNER JOIN journal_entry AS je
		USING(journal_entry_id) 
        WHERE (a.profit_loss_section_id = 7)
                AND YEAR(je.entry_date) = (FY-1);

-- Calculating last year Total Revenue = Revenue + Other Income, Storing it in varTotalRevenue LY
	
	SELECT varRevenueLY + varOtherIncomeLY INTO varTotalRevenueLY;
	
	
-- Calculating last year Total Expenses = Selling Expense + Other Expense, Storing it in varTotalExpensesLY	
	
	SELECT varSellingexpenseLY + varOtherExpensesLY INTO varTotalExpenseLY;

-- Calculating last year's Gross Profit Margin
	
	SELECT varTotalRevenueLY - varCOGSLY INTO varGPMLY;

-- Calculating last year's EBITDA

	SELECT  varGPMLY - varTotalExpenseLY INTO varEBITDALY;

-- Calculating last year Profit and Loss	
	
	SELECT varEBITDALY - varTaxesLY INTO varProfit_LossLY;


-- ---------------------------Calculating elementwise change over last year----------------------------	

-- Calculating Revenue change
	
		SELECT ROUND((varRevenue/varRevenueLY-1)*100,2) INTO varRevenuechange;

/*-- Calculating Other Income change

		SELECT ROUND((varOtherIncome/varOtherIncomeLY-1)*100,2) INTO varOtherIncomechange;
*/
-- Calculating Total Revenue change

		SELECT ROUND((varTotalRevenue/varTotalRevenueLY-1)*100,2) INTO varTotalRevenuechange;

-- Calculating COGs change
	
		SELECT ROUND((varCOGS/varCOGSLY-1)*100,2) INTO varCOGSchange;

-- Calculating Selling Expense change

		SELECT ROUND((varSellingexpense/varSellingexpenseLY-1)*100,2) INTO varSellingexpensechange;

-- Calculating Other Expense change

		SELECT ROUND((varOtherExpenses/varOtherExpensesLY-1)*100,2) INTO varOtherExpenseschange;

-- Calculating EBITDA change

	SELECT ROUND((varEBITDA/varEBITDALY-1)*100,2) INTO varEBITDAchange;


/* -- Calculating Tax change

	SELECT ROUND((varTaxes/varTaxesLY-1)*100,2) INTO varTaxeschange ;	
*/

-- Calculating Profit/Loss change

	SELECT ROUND((varProfit_loss/varProfit_lossLY-1)*100,2) INTO varProfit_losschange ;

-- ----------------------------------- Inserting results in Temp table -------------------------
	DROP TABLE IF EXISTS H_Accounting.sgarg1_tmp;
  
	-- Now we are certain that the table does not exist, we create with the columns that we need
	CREATE TABLE H_Accounting.sgarg1_tmp
		(line_number INT, 
		 label VARCHAR(50), 
	     amount VARCHAR(50),
	     `change` VARCHAR (50)
		);
  
  -- Now we insert the a header for the report
  INSERT INTO H_Accounting.sgarg1_tmp 
		   (line_number, label, amount,`change`)
	VALUES (1, 'PROFIT AND LOSS STATEMENT', "In 1000s of USD", 'Percent Change');
  
  
	-- Next we insert an empty line to create some space between the header and the line items
	INSERT INTO H_Accounting.sgarg1_tmp
				 (line_number, label, amount, `change`)
		VALUES 	(0, '', '', '');
    
	-- Insert Revenue
	INSERT INTO H_Accounting.sgarg1_tmp
				 (line_number, label, amount, `change`)
		VALUES 	(2, 'Revenue', round(varRevenue/1000,2), varRevenuechange);

	-- Insert Other Income
	INSERT INTO H_Accounting.sgarg1_tmp
				 (line_number, label, amount, `change`)
		VALUES 	(3, 'Other Income', round(varOtherIncome/1000,2) , '');

	-- Insert the Total Revenues
	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(4, 'TOTAL REVENUE', round(varTotalRevenue/1000,2), varTotalRevenuechange);
    
    INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

	-- Insert COGs
		
	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(5, 'Cost Of Goods Sold', round(varCOGS/1000,2), varCOGSchange);

 INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

	-- Insert Gross Margin

	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(6, 'GROSS PROFIT', round(varGPM/1000,2), varGPMchange);

	
	INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (7, 'GROSS PROFIT MARGIN', ROUND(vargrossprofitmargin*100,2), '');


	INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

	-- Insert Selling Expenses

	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(8, 'Selling Expense ', round(varSellingexpense/1000,2), varSellingexpensechange);

	-- Insert Other Expenses

	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(9, 'Other Expense ', round(varOtherExpenses/1000,2), varOtherExpenseschange);

	-- Insert Total Expense
	
	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(10, 'TOTAL EXPENSE ', round(varTotalExpense/1000,2), varTotalExpensechange);	

	INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

	-- Insert EBITDA


	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(11, 'EBITDA', round(varEBITDA/1000,2), varEBITDAchange);	


	-- Insert Income Tax

	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(12, 'Tax', round(varTaxes/1000,2), '');	

	INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

	-- Net Profit/loss

	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(13, 'NET PROFIT', round(varProfit_Loss/1000,2), varProfit_losschange);

	-- Net Profit/loss percentage

	INSERT INTO H_Accounting.sgarg1_tmp
			 (line_number, label, amount, `change`)
	VALUES 	(14, 'NET PROFIT PERCENTAGE', ROUND(varnetprofit*100,2) , '');

-- -----------------Query for balance sheet-------------------------
	
-- Calculating current assets
	
	SELECT
		   SUM(IFNULL(jeli.debit,0))-SUM(IFNULL(jeli.credit,0))  INTO varCurrent_Assets
	FROM `account` as a
	LEFT JOIN statement_section as ss
	ON a.balance_sheet_section_id = ss.statement_section_id
	INNER JOIN journal_entry_line_item AS jeli
	USING(account_id)
	LEFT JOIN journal_entry AS je
	ON jeli.journal_entry_id = je.journal_entry_id
	LEFT JOIN journal_type AS  jt
	ON je.journal_type_id = jt.journal_type_id
	WHERE YEAR(je.entry_date) =FY AND ss.statement_section = 'CURRENT ASSETS' AND je.cancelled = 0
;

-- Calculating Fixed Assets

	SELECT
		
        IFNULL(((SUM(IFNULL(jeli.debit,0)))-SUM(IFNULL(jeli.credit,0))),0) INTO varFixed_Assets
	FROM `account` as a
	LEFT JOIN statement_section as ss
	ON a.balance_sheet_section_id = ss.statement_section_id
	INNER JOIN journal_entry_line_item AS jeli
	USING(account_id)
	LEFT JOIN journal_entry AS je
	ON jeli.journal_entry_id = je.journal_entry_id
	LEFT JOIN journal_type AS  jt
	ON je.journal_type_id = jt.journal_type_id
	WHERE YEAR(je.entry_date) =FY AND ss.statement_section = 'FIXED ASSETS' AND je.cancelled = 0

;


-- Calculating Liabilities
SELECT
        ((SUM(IFNULL(jeli.credit,0)))-(SUM(IFNULL(jeli.debit,0)))) INTO varCurrent_Liabilities
FROM `account` as a
LEFT JOIN statement_section as ss
ON a.balance_sheet_section_id = ss.statement_section_id
INNER JOIN journal_entry_line_item AS jeli
USING(account_id)
LEFT JOIN journal_entry AS je
ON jeli.journal_entry_id = je.journal_entry_id
LEFT JOIN journal_type AS  jt
ON je.journal_type_id = jt.journal_type_id
WHERE YEAR(je.entry_date) =FY AND ss.statement_section = 'CURRENT LIABILITIES' AND je.cancelled = 0
;

-- Calculating Equity
SELECT
	    IFNULL((SUM(IFNULL(jeli.credit,0))-SUM(IFNULL(jeli.debit,0))),0) INTO	varEquity
FROM `account` as a
LEFT JOIN statement_section as ss
ON a.balance_sheet_section_id = ss.statement_section_id
INNER JOIN journal_entry_line_item AS jeli
USING(account_id)
LEFT JOIN journal_entry AS je
ON jeli.journal_entry_id = je.journal_entry_id
LEFT JOIN journal_type AS  jt
ON je.journal_type_id = jt.journal_type_id
WHERE YEAR(je.entry_date) =FY AND ss.statement_section = 'EQUITY' AND je.cancelled = 0
;


-- Calculating Total Assets

SELECT varCurrent_Assets + varFixed_Assets INTO varTotalAsset;

-- Calculating Liabilities + Equity

SELECT varCurrent_Liabilities  + varEquity INTO varTotalLiabilities_Equity;

-- Calculating wokring capital
 
SELECT varCurrent_Assets - varCurrent_Liabilities  INTO varworkingcapital;

-- Calculating Current Ratio

SELECT varCurrent_Assets/varCurrent_Liabilities  INTO varcurrentratio;


-- ----------------------LY Data------------------------------

-- Calculating LY current assets
	
	SELECT
		   (SUM(IFNULL(jeli.debit,0))-SUM(IFNULL(jeli.credit,0)))  INTO varCurrent_AssetsLY
	FROM `account` as a
	LEFT JOIN statement_section as ss
	ON a.balance_sheet_section_id = ss.statement_section_id
	INNER JOIN journal_entry_line_item AS jeli
	USING(account_id)
	LEFT JOIN journal_entry AS je
	ON jeli.journal_entry_id = je.journal_entry_id
	LEFT JOIN journal_type AS  jt
	ON je.journal_type_id = jt.journal_type_id
	WHERE YEAR(je.entry_date) =(FY -1) AND ss.statement_section = 'CURRENT ASSETS' AND je.cancelled = 0
;

-- Calculating LY Fixed Assets

	SELECT
		IFNULL((SUM(IFNULL(jeli.debit,0))-SUM(IFNULL(jeli.credit,0))),0) INTO varFixed_AssetsLY
	FROM `account` as a
	LEFT JOIN statement_section as ss
	ON a.balance_sheet_section_id = ss.statement_section_id
	INNER JOIN journal_entry_line_item AS jeli
	USING(account_id)
	LEFT JOIN journal_entry AS je
	ON jeli.journal_entry_id = je.journal_entry_id
	LEFT JOIN journal_type AS  jt
	ON je.journal_type_id = jt.journal_type_id
	WHERE YEAR(je.entry_date) =(FY-1) AND ss.statement_section = 'FIXED ASSETS' AND je.cancelled = 0

;


-- Calculating LY Liabilities
SELECT
        (SUM(IFNULL(jeli.credit,0))-SUM(IFNULL(jeli.debit,0))) INTO varCurrent_LiabilitiesLY
FROM `account` as a
LEFT JOIN statement_section as ss
ON a.balance_sheet_section_id = ss.statement_section_id
INNER JOIN journal_entry_line_item AS jeli
USING(account_id)
LEFT JOIN journal_entry AS je
ON jeli.journal_entry_id = je.journal_entry_id
LEFT JOIN journal_type AS  jt
ON je.journal_type_id = jt.journal_type_id
WHERE YEAR(je.entry_date) =(FY-1) AND ss.statement_section = 'CURRENT LIABILITIES' AND je.cancelled = 0
;

-- Calculating LY Equity
SELECT
	    IFNULL((SUM(IFNULL(jeli.credit,0))-SUM(IFNULL(jeli.debit,0))),0)  INTO	varEquityLY
FROM `account` as a
LEFT JOIN statement_section as ss
ON a.balance_sheet_section_id = ss.statement_section_id
INNER JOIN journal_entry_line_item AS jeli
USING(account_id)
LEFT JOIN journal_entry AS je
ON jeli.journal_entry_id = je.journal_entry_id
LEFT JOIN journal_type AS  jt
ON je.journal_type_id = jt.journal_type_id
WHERE YEAR(je.entry_date) =(FY-1) AND ss.statement_section = 'EQUITY' AND je.cancelled = 0
;


-- Calculating LY Total Assets

SELECT varCurrent_AssetsLY + varFixed_AssetsLY INTO varTotalAssetLY;

-- Calculating LY Liabilities + Equity

SELECT varCurrent_LiabilitiesLY  + varEquityLY INTO varTotalLiabilities_EquityLY;
 


-- ----------------- %change in elements --------------------

-- Change in Current Assets

SELECT ROUND(((varCurrent_Assets/varCurrent_AssetsLY)-1)*100,1) INTO varCurrent_Assetschange;

-- Change in Total Assets

SELECT ROUND(((varTotalAsset/varTotalAssetLY)-1)*100,1) INTO varTotalAssetchange;

/*-- Change in Fixed Assets

SELECT ROUND(((varFixed_Assets/varFixed_AssetsLY)-1)*100,1) INTO varFixed_Assetschange;
*/
-- Change in Current Liabilities

SELECT ROUND(((varCurrent_Liabilities/varCurrent_LiabilitiesLY)-1)*100,1) INTO varCurrent_Liabilitiesschange;

-- Change in Equity

SELECT ROUND(((varEquity/varEquityLY)-1)*100,1) INTO varEquitychange;

-- Change in Total Liabilitie + Equity

SELECT ROUND(((varTotalLiabilities_Equity/varTotalLiabilities_EquityLY)-1)*100,1) INTO varTotalLiabilitieschange;

-- --------------------------------- Inserting in Temp table ----------------------------------------------

  INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount, `change`)
	VALUES (0, '', '', '');

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount, `change`)
	VALUES (0, '', '', '');
 
 INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (1, 'BALANCE SHEET STATEMENT', "In 1000s of USD", 'Percent Change');

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (2, 'Current Assets',round(varCurrent_Assets/1000,2),varCurrent_Assetschange);

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (3, 'Fixed Assets',round(varFixed_Assets/1000,2),0);

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (4, 'TOTAL ASSETS',round(varTotalAsset/1000,2),varTotalAssetchange);

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (5, 'Current Liabilities',round(varCurrent_Liabilities/1000,2),varCurrent_Liabilitiesschange);


INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (6, 'Equity',round(varEquity/1000,2),varEquitychange);

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (7, 'LIABILITIES + EQUITY',round(varTotalLiabilities_Equity/1000,2),varTotalLiabilitieschange);

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, '', '', '');
    
INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (0, 'ADDITIONAL FINANCIAL RATIOS','','');

INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (1, 'Working Capital',round(varworkingcapital/1000,2),'');
    
 INSERT INTO H_Accounting.sgarg1_tmp 
		    (line_number, label, amount,`change`)
	VALUES (2, 'Current Ratio',round(varcurrentratio,2),'');   

END $$
DELIMITER ;
-- THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;

CALL H_Accounting.sp_rajkevsan(2018);

SELECT * FROM H_Accounting.sgarg1_tmp;
