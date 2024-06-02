
CREATE TABLE customer (
custno VARCHAR(8) NOT NULL,
custname VARCHAR(30) NOT NULL,
address VARCHAR(30) NOT NULL,
internal BOOLEAN NOT NULL,
contact VARCHAR(30) NOT NULL,
phone VARCHAR(15) NOT NULL,
city VARCHAR(20) NOT NULL,
state CHAR(2) NOT NULL,
zip VARCHAR(10) NOT NULL,
CONSTRAINT pkCustNo PRIMARY KEY (custno)
);

CREATE TABLE facility (
	facno VARCHAR(8) NOT NULL,
	facname VARCHAR(30) NOT NULL,
	CONSTRAINT pkFacNo PRIMARY KEY (facno),
	CONSTRAINT ucFacName UNIQUE (facname)
	);

CREATE TABLE employee (
	empno VARCHAR(8) NOT NULL,
	empname VARCHAR(40) NOT NULL,
	department VARCHAR(30) NOT NULL,
	email VARCHAR(20) NOT NULL,
	phone VARCHAR(15) NOT NULL,
	mgrno VARCHAR(8),
	CONSTRAINT pkEmpNo PRIMARY KEY (empno),
	CONSTRAINT ucEmail UNIQUE (email),
	CONSTRAINT fkMgrNo FOREIGN KEY (mgrno) REFERENCES employee(empno)
	);

CREATE TABLE location (
	locno VARCHAR(8) NOT NULL,
	facno VARCHAR(8) NOT NULL,
	locname VARCHAR(30) NOT NULL,
	CONSTRAINT pkLocNo PRIMARY KEY (locno),
	CONSTRAINT fkFacNo FOREIGN KEY (facno) REFERENCES facility(facno)
);

CREATE TABLE resourcetbl (
	resno VARCHAR(8) NOT NULL,
	resname VARCHAR(40) NOT NULL,
	rate DECIMAL(4, 2) NOT NULL CHECK (rate > 0),
	CONSTRAINT pkResNo PRIMARY KEY (resno),
	CONSTRAINT ucResName UNIQUE (resname)
);

CREATE TABLE eventrequest (
	eventno VARCHAR(8) NOT NULL,
	dateheld DATE NOT NULL,
	datereq DATE NOT NULL,
	custno VARCHAR(8) NOT NULL,
	facno VARCHAR(8) NOT NULL,
	dateauth DATE,
	status VARCHAR(8) NOT NULL CHECK (status IN ('Pending', 'Denied', 'Approved')),
	estcost DECIMAL(10, 2) NOT NULL,
	estaudience INT NOT NULL CHECK (estaudience > 0),
	budno VARCHAR(8),
	CONSTRAINT pkEventNo PRIMARY KEY (eventno),
	CONSTRAINT fkCustNo FOREIGN KEY (custno) REFERENCES customer(custno),
	CONSTRAINT fkFacNo FOREIGN KEY (facno) REFERENCES facility(facno)
);

CREATE TABLE eventplan(
  planno VARCHAR(8) NOT NULL,
  eventno VARCHAR(8) NOT NULL,
  workdate DATE NOT NULL,
  notes VARCHAR(40),
  activity VARCHAR(20) NOT NULL,
  empno VARCHAR(8),
  CONSTRAINT pkPlanNo PRIMARY KEY (planno),
  CONSTRAINT fkEventNo FOREIGN KEY (eventno) REFERENCES eventrequest (eventno)
);

CREATE TABLE eventplanline(
  planno VARCHAR(8) NOT NULL,
  lineno INT NOT NULL,
  timestart DATE NOT NULL,
  timeend DATE NOT NULL,
  numberfld INT NOT NULL,
  locno VARCHAR(8) NOT NULL,
  resno VARCHAR(8) NOT NULL,
  CONSTRAINT pkPlanNoLineNo PRIMARY KEY (planno, lineno),
  CONSTRAINT fkPlanNo FOREIGN KEY (planno) REFERENCES eventplan (planno),
  CONSTRAINT cStartEnd CHECK (timestart < timeend)
);