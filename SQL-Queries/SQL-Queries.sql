CREATE TABLE bank_cards (
    card_id int auto_increment primary key,-- ИД карты
    card_number varchar (19) CHECK (card_number REGEXP '^[0-9]{4} [0-9]{4} [0-9]{4} [0-9]{4}$'),-- Номер карты
    card_name varchar(50),-- Название карты
    card_holder_name varchar(100),-- Имя держателя карты
    card_holder_date date,-- День рождение держателя карты
    card_type char (10),-- Тип карты МИР VISA MasterCard
    card_balance decimal(10,2),-- Баланс карты
    card_last_four char(4) GENERATED ALWAYS AS (RIGHT(REPLACE(card_number, ' ', ''), 4)) STORED,-- Последние 4 цифры номера карты
    card_CVV char(3) CHECK (card_CVV REGEXP '^[0-9]{3}$'),-- CVV код
    srok_date char(5) CHECK (srok_date REGEXP '^(0[1-9]|1[0-2])/[0-9]{2}$'),-- Срок годности карты месяц/год
    sms_notification_enabled boolean,-- СМС уведомления 1-вкл,0-выкл
    email_notification_enabled boolean,-- email  уведомления 1-вкл,0-выкл
    card_block_enabled boolean-- Cостояние карты 1-активный или 0-Заблокированый
);
insert into bank_cards (card_number,
card_name,
card_holder_name,
card_holder_date,
card_type,
card_balance,
card_CVV,
srok_date,
sms_notification_enabled,
email_notification_enabled,
card_block_enabled)
values ('4797 2987 0472 6192','Travel','OLGA KOROLEVA', '1991-12-31','VISA',123654.76,'768','12/30',TRUE,TRUE,TRUE),
('4797 7222 2222 2224','Золотая','OLGA KOROLEVA', '1991-08-11','MIR',316301.00,'232','09/25',FAlSE,FAlSE,FAlSE),
('5178 8585 3841 9074','Яркая','OLGA KOROLEVA', '1995-06-12','MasterCard',1316301.00,'032','05/25',FAlSE,FAlSE,TRUE),
('4797 6977 5500 0504','Детская','MARIA KOROLEVA', '2010-12-31','VISA',3654.76,'045','08/30',TRUE,FAlSE,TRUE),
('4797 6933 5500 0556','Виртуальная','IVAN MOTROSOV', '1991-12-12','MIR',516301.00,'856','12/30',FAlSE,TRUE,TRUE),
('5416 0049 1216 1111','Standard КХЛ','AIRAT MARDANOV', '1978-01-01','MasterCard',4568979.00,'876','12/27',FAlSE,TRUE,FAlSE),
('4321 4321 4321 4321','Единая карта петербуржца','MAXIM MAXIMOV', '1987-06-09','VISA',3654.76,'777','04/26',FALSE,TRUE,TRUE);
select card_id as 'Идентификатор', 
card_number as 'Номер карты', 
card_name as 'Название карты', 
card_holder_name as 'ФИО держателя',
date_format(card_holder_date, '%d.%m.%Y') as 'Дата рождения', 
card_type as 'Тип карты', 
card_balance as 'Баланс карты',
card_last_four as 'Последние 4 цифры',
card_CVV as 'CVV код',
srok_date as 'Срок действия карты мм/гг',
CASE 
        WHEN sms_notification_enabled THEN 'ВКЛ' 
        ELSE 'ВЫКЛ' 
    END AS 'SMS уведомления',
CASE 
        WHEN email_notification_enabled THEN 'ВКЛ' 
        ELSE 'ВЫКЛ' 
    END AS 'Email уведомления',
CASE 
        WHEN card_block_enabled THEN 'Активна' 
        ELSE 'Заблокирована' 
    END AS 'Статус карты' from bank_cards order by card_balance;
