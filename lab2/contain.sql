INSERT INTO Person(name, surname, DateOfBirth) values(
    'Nikita', 'Pankov', TO_DATE('17/12/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Andrew', 'Volkov', TO_DATE('17/11/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Vasilii', 'Vasiliev', TO_DATE('17/10/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Anna', 'Annavna', TO_DATE('17/9/1997', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Maria', 'Pankova', TO_DATE('17/8/1996', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Natasha', 'Konasheva', TO_DATE('17/7/2000', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Dmitri', 'Levi', TO_DATE('17/6/1998', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Islam', 'Asughievichanski', TO_DATE('17/5/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Nikola', 'Tesla', TO_DATE('17/4/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Ilon', 'Mask', TO_DATE('17/3/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Barak', 'Abema', TO_DATE('17/2/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'victor', 'Kirov', TO_DATE('17/1/1999', 'DD/MM/YYYY')
);
INSERT INTO Person(name, surname, DateOfBirth) values(
    'Ivan', 'Vasiliev', TO_DATE('17/6/1999', 'DD/MM/YYYY')
);


Insert INTO MARK(type) Values('Друзья');
Insert INTO MARK(type) Values('Семья');
Insert INTO MARK(type) Values('Коллеги');
Insert INTO MARK(type) Values('Соседи');


INSERT INTO MarkSet(PersonID, MarkID) VALUEs(1, 1);

INSERT INTO MarkSet(PersonID, MarkID) VALUEs('2' , '1');
INSERT INTO MarkSet(PersonID, MarkID) VALUEs('2' , '2');
INSERT INTO MarkSet(PersonID, MarkID) VALUEs('2' , '3');
INSERT INTO MarkSet(PersonID, MarkID) VALUEs('2' , '4');

INSERT INTO MarkSet(PersonID, MarkID) VALUEs('3' , '3');

INSERT INTO MarkSet(PersonID, MarkID) VALUEs('4' , '3');

INSERT INTO MarkSet(PersonID, MarkID) VALUEs('5' , '4');

INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('1', '89115480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('2', '89215480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('3', '89215480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('4', '89215480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('5', '89505480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('6', '89665480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('7', '89995480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('8', '89875480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('9', '89325480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('10', '89235480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('11', '89325480802');
INSERT INTO Phone(PersonID, PhoneNumber) VALUEs('12', '89675480802');