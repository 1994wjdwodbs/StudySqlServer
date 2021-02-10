use sqlDB;

-- �̸��� ���ȣ�� ����� ��ȸ
SELECT * FROM userTbl
WHERE userName = '���ȣ';

-- 1970�� ���� ����̰� Ű 182 �̻��� ������� ���̵�, �̸�, ���, Ű�� ��ȸ
SELECT userID, userName, birthYear, height FROM userTbl
WHERE birthYear >= 1970 AND height >= 182;
-- AND userName like '��%';
-- 1970�� ���� ����̰ų� Ű�� 182�̻��� ������� ���̵�,�̸�, ���, Ű�� ��ȸ
SELECT userID, userName, birthYear, height FROM userTbl
WHERE birthYear >= 1970 OR height >= 182;

-- Ű�� 180~183 ������ ����� ��ȸ (BETWEEN)
SELECT userID, userName, height FROM userTbl
WHERE height BETWEEN 180 AND 183;
-- ������ �泲, ����, ��� (IN)
SELECT userID, userName, addr FROM userTbl
WHERE addr IN ('�泲', '����', '���');
-- LIKE
SELECT userID, userName, addr FROM userTbl
WHERE userName like '��%';

SELECT userID, userName, addr FROM userTbl
WHERE userName like '_����';

-- SUBQUERY, ALL/ANY
SELECT userName, height FROM userTBL
WHERE height > 177;
SELECT userName, height FROM userTBL
WHERE height > (SELECT height FROM userTbl WHERE userName like '���ȣ');
SELECT userName, height FROM userTBL
WHERE height >= ALL (SELECT height from userTBL where addr = '�泲');
SELECT userName, height FROM userTBL
WHERE height >= ANY (SELECT height from userTBL where addr = '�泲');

-- ORDER BY, ASC(default)/DESC
SELECT userName, mDate FROM userTbl ORDER BY mDate  ASC;
SELECT userName, mDate FROM userTbl ORDER BY mDate DESC;

-- DISTINCT(�ߺ� ����)
SELECT addr FROM userTbl;
SELECT DISTINCT addr FROM userTbl;

-- ETC
SELECT TOP(5) * FROM userTbl ORDER BY mDate DESC;

-- SELECT INTO(����, �� ���纻�� Ű ������ ����)
SELECT * INTO buyTbl2 FROM buyTbl;
SELECT userID, prodName INTO buyTbl3 FROM buyTbl;

-- GROUP BY(���� �Լ�)
SELECT userID, amount FROM buyTbl ORDER BY userID;
SELECT userID, SUM(amount) AS Total_Amount FROM buyTbl GROUP BY userID;

-- ���� ������ GROUP BY ����
-- �߸��� ���
SELECT userID, MIN(height) as '����Ű', MAX(height) as 'ūŰ' FROM userTbl GROUP BY userID;
-- �������� ���
SELECT userID, height FROM userTbl
WHERE height = (SELECT MAX(height) FROM userTbl) 
   OR height = (SELECT MIN(height) FROM userTbl);
   
-- ������ ī��Ʈ
SELECT COUNT(*) FROM userTbl;
SELECT COUNT(*) FROM buyTbl;
SELECT COUNT(mobile1) AS '�ڵ��� ������' FROM userTbl;

-- HAVING
-- �߸��� ���(���� �Լ��� WHERE ���ǹ��� �� �� ����!)
SELECT userID, SUM(price * amount) AS '��ü ���űݾ�' FROM buyTbl 
WHERE sum(price * amount) > 1000
GROUP BY userID;
-- �������� ���
SELECT userID, SUM(price * amount) AS '��ü ���űݾ�' FROM buyTbl 
GROUP BY userID
HAVING SUM(price * amount) > 1000
ORDER BY SUM(price * amount) DESC;

-- ROLLUP
SELECT num, groupName, SUM(price * amount) as '���űݾ�' FROM buyTbl
GROUP BY num, groupName;
SELECT num, groupName, SUM(price * amount) as '���űݾ�' FROM buyTbl
GROUP BY ROLLUP(groupName, num)
ORDER BY groupName;

-- GROUPING_ID(0:������, 1:�հ踦 ���� �߰��� ��)
SELECT num, groupName, SUM(price * amount) as '���űݾ�', GROUPING_ID(groupName, num) AS ID FROM buyTbl
GROUP BY ROLLUP(groupName, num);
-- ORDER BY groupName;

-- Ex)
SELECT userID, SUM(price * amount) AS '���űݾ�' FROM buyTbl
GROUP BY (userID);
SELECT groupName, SUM(price * amount) AS '���űݾ�' FROM buyTbl
GROUP BY (groupName);
SELECT userID, SUM(price * amount) AS '���űݾ�' FROM buyTbl
GROUP BY ROLLUP(userID); -- �߰��հ�(NULL)�� ������ش�.
SELECT groupName, SUM(price * amount) AS '���űݾ�' FROM buyTbl
GROUP BY ROLLUP(groupName); -- �߰��հ�(NULL)�� ������ش�.

SELECT addr, MAX(userTbl.height) FROM userTbl GROUP BY (userTbl.addr);

-- ROLLUP vs CUBE
SELECT userID, groupName, SUM(price * amount) AS '���űݾ�' FROM buyTbl
GROUP BY ROLLUP(groupName, userID);
-- CUBE
SELECT userID, groupName, SUM(price * amount) AS '���űݾ�' FROM buyTbl
GROUP BY CUBE(groupName, userID);


-- CTE(COMMON TABLE EXPRESSION)
-- ������ ��, �Ļ� ���̺�, �ӽ� ���̺� ������ ���Ǵ� ���� ����� �� �ִ�.
-- Ex 2)
SELECT userID, sum(price * amount) AS 'total' FROM buyTbl
GROUP BY userID ORDER BY 'total' DESC;
-- CTE Ver
WITH cte_tmp(userID, total)
AS
(
	SELECT userID, sum(price * amount) AS 'total' FROM buyTbl
	GROUP BY userID
)
SELECT * FROM cte_tmp ORDER BY 'total' DESC;