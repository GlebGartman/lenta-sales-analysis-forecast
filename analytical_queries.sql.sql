-- Формируем Таблицы:

CREATE TABLE Journals (
    JournalID INT PRIMARY KEY,
    Date DATE,
    Shop INT,
    TotalQty INT,
    TotalAmount INT
);

INSERT INTO Journals (JournalID, Date, Shop, TotalQty, TotalAmount) VALUES
(1, '2011-01-01', 943, 55, 500),
(2, '2011-01-02', 1543, 45, 450),
(3, '2011-01-01', 234, 30, 300),
(4, '2011-01-03', 876, 30, 300);

CREATE TABLE Lines (
    JournalID INT,
    Itemid INT,
    Qty INT,
    Amount INT,
    FOREIGN KEY (JournalID) REFERENCES Journals(JournalID)
);

INSERT INTO Lines (JournalID, Itemid, Qty, Amount) VALUES
(1, 1, 10, 100),
(1, 6, 15, 300),
(1, 8, 20, 100),
(2, 1, 30, 300),
(2, 6, 5, 100),
(2, 8, 10, 50),
(3, 1, 10, 100),
(3, 6, 10, 200);

CREATE TABLE Goods (
    Itemid INT PRIMARY KEY,
    itemname VARCHAR(50)
);

INSERT INTO Goods (Itemid, itemname) VALUES
(1, 'Рис'),
(5, 'Пшено'),
(7, 'Соль'),
(6, 'Сода'),
(8, 'Масло');


CREATE TABLE Forecast (
    Date DATE,
    Itemid INT,
    Shop INT,
    fcst INT,
    FOREIGN KEY (Itemid) REFERENCES Goods(Itemid)
);

INSERT INTO Forecast (Date, Itemid, Shop, fcst) VALUES
('2011-01-02', 1, 1543, 26),
('2011-01-02', 6, 1543, 6),
('2011-01-02', 8, 1543, 10);


-- 1 Задача:

SELECT Itemid,
1.0 * SUM(Amount) / SUM(Qty) as avg_price
FROM Lines as l
join Journals as j on j.JournalID = l.JournalID
where Shop = 943
group by Itemid;

-- 2 Задача:

SELECT Itemid, 
SUM(Qty)
FROM Lines as l
join Journals as j on j.JournalID = l.JournalID
where Date = '2011-01-01'
group by Itemid;

-- 3 Задача:

SELECT 
itemname,
l.Itemid as Itemid,
SUM(Amount) as total_sum,
DENSE_RANK() OVER(order by SUM(Amount) desc) as rnk
FROM Lines as l 
join Goods as g on g.Itemid = l.Itemid
group by itemname, l.Itemid;

-- 4 Задача:

SELECT l.Itemid as Itemid, 
itemname, 
MAX(fcst) as prognoz,
SUM(Qty) as fact
FROM Lines as l 
JOIN Journals as j on j.JournalID = l.JournalID
JOIN Goods as g on g.Itemid = l.Itemid
LEFT JOIN Forecast as f on f.Itemid  = l.Itemid AND f.Shop = j.Shop AND f.Date = j.Date
WHERE j.Shop = 1543 AND j.Date = '2011-01-02'
GROUP BY l.Itemid, itemname;








