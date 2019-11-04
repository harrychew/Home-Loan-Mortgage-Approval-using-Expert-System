;; Initialize
(defrule start-up
	(initial-fact)
	=>
	;; Welcome interface
	(printout t crlf crlf crlf "          Welcome to Home Loan Mortgage Approval Expert System" crlf)
	(printout t crlf crlf crlf "       Is the application received, scanned and approved by Custodian? " crlf)
	;; Description
	(printout t crlf crlf crlf "       ** Comparison of scanned document to actual document to confirm scan is" crlf)
	(printout t "       of sufficient quality (done for both initial and additional data). " crlf)
	(printout t crlf crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no) : ")
	;; Assert user input as fact
	(assert (custodiana (read))))
	

;; Custodian Stage
(defrule custodiana-yes
	(custodiana yes)
	=>
	(printout t  "       ==========================================================================" crlf)
	;; Instructions for bank staff
	(printout t crlf crlf crlf "       Perform Document Tagging..." crlf)
	(printout t  "       ** Marking of images on document scans for subsequent steps (done for both" crlf)
	(printout t  "       initial and additional data). " crlf)

	;; Instructions for bank staff
	(printout t crlf crlf "       Perform Application Capture..." crlf)
	(printout t  "       ** Data entry using applications (two separate steps each for initial and " crlf)
	(printout t  "       additional application capture)." crlf)

	;; Instructions for bank staff
	(printout t crlf crlf "       Perform Checking preliminary information ..." crlf)
	(printout t  "       ** Additional data entry from application forms (two separate steps inputting" crlf)
	(printout t  "       data from separate pages." crlf)

	(printout t crlf crlf "       Is the preliminary information FAILED to satisfy the bank policy?" crlf)
	(printout t crlf crlf"       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no) : ")
	(assert (policy-faila (read))))

;; Continue option
(defrule custodiana-no
	(custodiana no)
	=>
	(printout t  "       ==========================================================================" crlf)
	(printout t crlf crlf crlf "       Revert back to checking application....." crlf)
	(printout t "       Do you wish to continue? "crlf)
	(printout t crlf crlf"       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (continuea (read))))

;; Continue check the application
(defrule continuea-yes
	(continuea yes)
	=>
	(reset)
	(printout t  "       ==========================================================================" crlf)
	
	(printout t crlf crlf crlf "       Is the application received, scanned and approved by Custodian? " crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (custodiana (read))))

;; Not continue, quit the system
(defrule continuea-no
	(continuea no)
	=>
	;; clear all the facts
	(reset)
	;; remove the initial fact
	(retract 0)
	(printout t  "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))

;; first policy fail, reject and quit the system
(defrule policy-faila-yes
	(policy-faila yes)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Send Automatic rejection letter!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))

;; Application completeness checking stage
(defrule policy-faila-no
	(policy-faila no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Is the application COMPLETE? " crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (application-completea (read))))

;; Credit check stage
(defrule credit-check
	(application-completea yes)
	=>
	(printout t "       ==========================================================================" crlf)
	;; Instruction for staff
	(printout t crlf crlf crlf"       Credit checking......." crlf)
	(printout t  "       ** Step 1 a credit check is requested." crlf)
	(printout t  "       ** Step 2 the data is entered from the check." crlf)
	(printout t crlf crlf "       Please rate applicant credit...." crlf)
	;; Rating options
	(printout t crlf "        1----Worst (Credit Score less than 300)" crlf)
	(printout t "        2----Bad (Credit Score 300-579)" crlf)
	(printout t "        3----Average (Credit Score 580-669)" crlf)
	(printout t "        4----Good (Credit Score 670-739)" crlf)
	(printout t "        5----Excellent (Credit Score above 740)" crlf)
	(printout t crlf "       ==========================================================================" crlf)
	(printout t "       Enter number: ")

	;; Store the input as a variable
	(bind ?ans (read))

	;; if ans greater or equal to 3
	(if (>= ?ans 3) then (assert (credit-check-fail no)))
	;; if ans less than 3
	(if (< ?ans 3) then (assert (credit-check-fail yes))))

;; Cannot proceed if incomplete application, provide option to continue
(defrule incomplete-application
	(application-completea no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf "       Send Automatic Incomplete Application letter!" crlf)
	(printout t crlf crlf "       Revert back to checking application....." crlf)
	(printout t crlf crlf "       Do you wish to continue? "crlf)
	(printout t crlf crlf"       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (continuea (read))))

;; Credit fail, reject and quit the system
(defrule credit-check-fail-yes
	(credit-check-fail yes)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Send Automatic rejection letter!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))

;; Credit eligible, proceed checking additional materials
(defrule credit-check-fail-no
	(credit-check-fail no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Credit check success!" crlf)
	(printout t crlf crlf "       Automatic request for additional materials..." crlf)
	(printout t crlf crlf "       Is the additional materials received, scanned and approved by Custodian? " crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (custodianb (read))))

;; Custodian stage 2
(defrule custodianb-yes
	(custodianb yes)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Additional document is tagged.....done!" crlf)
	(printout t crlf crlf "       Additional application is capture....done!"crlf)
	(printout t crlf crlf "       Is the application complete? (yes/no)" crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice: ")
	(assert (application-completeb (read))))

;; Cannot proceed if additional materials incomplete
(defrule custodianb-no
	(custodianb no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Revert back to checking additional materials....." crlf)
	(printout t crlf crlf "       Do you wish to continue? (yes/no)"crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice: ")
	(assert (continueb (read))))

;; Continue checking additional materials
(defrule continueb-yes
	(continueb yes)
	=>
	(reset)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf "       Is the additional materials received, scanned and approved by Custodian? (yes/no)" crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice: ")
	(assert (custodianb (read))))

;; Not continue and quit
(defrule continueb-no
	(continueb no)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))

;; Check the additional material fulfill policy
(defrule policy-failb-checking1
	(application-completeb yes)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Is the additional information FAILED to satisfy the bank policy?" crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (policy-failb (read))))

;; Send Incomplete application letter
(defrule policy-failb-checking2
	(application-completeb no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Send Automatic Incomplete Application letter!" crlf)
	(printout t crlf crlf "       Revert back to checking additional application....." crlf)
	(printout t crlf crlf "       Do you wish to continue?"crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (continueb (read))))

;; materials not eligible, reject and quit the system
(defrule policy-failb-yes
	(policy-failb yes)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Send Automatic rejection letter!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))

;; Income tax stage
(defrule policy-failb-no
	(policy-failb no)
	=>
	(printout t "       ==========================================================================" crlf)
	;; Instructions for staff
	(printout t crlf crlf crlf"       Checking Income tax......" crlf)
	(printout t  "       ** Step 1 tax verification is requested" crlf)
	(printout t  "       ** Step 2 the data is entered from the verification." crlf)

	;; Rating status
	(printout t crlf crlf "       Please rate Applicant Income Tax Status...." crlf)
	(printout t crlf "        1----Worst" crlf)
	(printout t "        2----Bad" crlf)
	(printout t "        3----Average" crlf)
	(printout t "        4----Good" crlf)
	(printout t "        5----Excellent" crlf)
	(printout t crlf "       ==========================================================================" crlf)
	(printout t "       Enter number: ")
	(bind ?ans (read))
	(if (>= ?ans 3) then (assert (incometax-fail no)))
	(if (< ?ans 3) then (assert (incometax-fail yes))))

;; Bad income tax status, reject and quit system
(defrule incometax-fail-yes
	(incometax-fail yes)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf "       Send Automatic rejection letter!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf))

;; Check appraisal of the home
(defrule incometax-fail-no
	(incometax-fail no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Income tax status...Success!" crlf)
	(printout t crlf crlf "       Is the Real Estate evaluated by bank's estate agent?(yes/no)"crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice:")
	(assert (realestate-check (read))))

;; Evaluate Appraisal stage
(defrule realestate-check-yes
	(realestate-check yes)
	=>
	(printout t "       ==========================================================================" crlf)
	;; Instructions for staff
	(printout t crlf crlf crlf "       Evaluating real estate appraisal......" crlf)
	(printout t  "       ** Step 1 a real estate appraisal is requested" crlf)
	(printout t  "       ** Step 2 the data is entered from the appraisal." crlf)
	
	;; Ranking
	(printout t crlf crlf "       Please Rank Real Estate evaluated by bank's estate agent...."crlf)
	(printout t crlf "        1----Worst (Not recommend as collateral)" crlf)
	(printout t "        2----Bad (Required extensive renovation)" crlf)
	(printout t "        3----Average (Required average renovation)" crlf)
	(printout t "        4----Good (In Good Condition, recommend as collateral)" crlf)
	(printout t "        5----Excellent (In Excellent Condition, recommend as collateral)" crlf)
	(printout t crlf "       ==========================================================================" crlf)
	(printout t "       Enter number: ")
	(bind ?ans (read))
	(if (> ?ans 3) then (assert (approve-credit yes)))
	(if (= ?ans 3) then (assert (approve-credit marginal)))
	(if (< ?ans 3) then (assert (approve-credit no))))

;; Cannot proceed if no appraisal, provide option to continue
(defrule realestate-check-no
	(realestate-check no)
	=>
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf "       Revert back to checking real estate....." crlf)
	(printout t crlf crlf "       Do you wish to continue?"crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (continuec (read))))

;; continue checking appraisal
(defrule continuec-yes
	(continuec yes)
	=>
	(reset)
	(printout t crlf crlf crlf "       Real Estate evaluated by bank's estate agent?" crlf)
	(printout t crlf crlf "       ==========================================================================" crlf)
	(printout t "       Enter choice (yes/no): ")
	(assert (realestate-check (read))))

;; Not continue, quit
(defrule continuec-no
	(continuec no)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf))

;; Good appraisal credit, approve loan
(defrule approve-credit-yes
	(approve-credit yes)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Action: Sent Automatic Approval letter!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))
	
;; Bad appraisal credit, reject
(defrule approve-credit-no
	(approve-credit no)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Action: Sent Automatic Rejection letter!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))

;; average credit, send to negotiation with credit expert
(defrule approve-credit-marginal
	(approve-credit marginal)
	=>
	(reset)
	(retract 0)
	(printout t "       ==========================================================================" crlf)
	(printout t crlf crlf crlf"       Action: Route to credit expert for negotiation!" crlf)
	(printout t crlf crlf "       Thank you for using Home Loan Mortgage Approval System! Bye!" crlf crlf crlf))