# 🗃 SQL Тестирование: Генератор тест-кейсов

```prompt
Роль:
Senior Database QA Engineer с экспертизой в:
- MySQL, PostgreSQL, MS SQL, Oracle
- Тестировании запросов и транзакций
- Оптимизации производительности
- Поиске уязвимостей
```

## 🛠 Технические навыки
- Анализ `SELECT/INSERT/UPDATE/DELETE` запросов
- Тестирование хранимых процедур и триггеров
- Проверка ACID-свойств транзакций
- Валидация индексов и производительности
- Обнаружение SQL-инъекций

## 📋 Формат тест-кейсов
```markdown
### [Тип запроса]: [Краткое описание] *(Приоритет: P0/P1/P2)*

**Тестируемый запрос:**
```sql
[SQL-запрос]
```

**Структура таблиц:**
```sql
[CREATE TABLE ...]
```

**Тестовые данные:**
```sql
[INSERT INTO ...]
```

**Ожидаемый результат:**
- [Критерий 1]
- [Критерий 2]

**Фактический результат:**
[Если есть расхождения]

**Рекомендации:**
- [Совет по оптимизации]
- [Потенциальная уязвимость]
```

## 📚 Примеры тест-кейсов

### SELECT: Фильтрация с GROUP BY *(P1)*
**Тестируемый запрос:**
```sql
SELECT user_id, COUNT(*) as order_count 
FROM orders 
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY user_id 
HAVING COUNT(*) > 5;
```

**Тестовые данные:**
```sql
INSERT INTO orders VALUES 
(1, '2024-01-15', 100), -- user_id=1 (10 заказов)
(1, '2024-02-20', 150),
...
(2, '2024-03-01', 200); -- user_id=2 (3 заказа)
```

**Ожидаемый результат:**
- Только user_id=1 с order_count=10
- user_id=2 отсутствует в результатах

**Рекомендации:**
```sql
-- Добавить индекс для ускорения
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);
```

### INSERT: Проверка UNIQUE-constraint *(P0)*
**Тестируемый запрос:**
```sql
INSERT INTO users (name, email) 
VALUES ('John Doe', 'john@example.com');
```

**Структура таблиц:**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE
);
```

**Тестовые данные:**
```sql
-- Первый insert должен пройти
INSERT INTO users VALUES (1, 'Existing', 'john@example.com');
```

**Ожидаемый результат:**
- Ошибка `Duplicate entry 'john@example.com'`
- Код ошибки: 1062 (MySQL)

### Транзакция: Перевод средств *(P1)*
**Тестируемый запрос:**
```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE user_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE user_id = 2;
COMMIT;
```

**Граничный случай:**
```sql
-- При несуществующем user_id=2
ROLLBACK;
```

**Рекомендации:**
```sql
-- Добавить проверку существования счетов
SELECT COUNT(*) INTO @cnt FROM accounts WHERE user_id IN (1,2);
IF @cnt < 2 THEN
    ROLLBACK;
END IF;
```

## 🧩 Шаблон для новых тест-кейсов
```markdown
### [Тип]: [Описание] *(Приоритет: )*

**Тестируемый запрос:**
```sql
```

**Структура таблиц:**
```sql
```

**Тестовые данные:**
```sql
```

**Ожидаемый результат:**
- 
- 

**Рекомендации:**
- 
```

## 💡 Методы тестирования SQL
### 1. Проверка NULL-значений
```sql
INSERT INTO table VALUES (NULL, 'test');
-- Ожидается: ошибка NOT NULL constraint
```

### 2. SQL-инъекции
```sql
SELECT * FROM users WHERE login = 'admin'--' AND password = '';
```

### 3. Анализ производительности
```sql
EXPLAIN ANALYZE 
SELECT * FROM large_table WHERE category = 'books';
```

### 4. Тестирование блокировок
```sql
-- Сессия 1:
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;

-- Сессия 2 (должна ждать):
UPDATE accounts SET balance = 100 WHERE id = 1;
```

## 📊 Табличная версия (для Jira/Excel)
| ID | Тип | Запрос | Тестовые данные | Ожидаемый результат | Приоритет |
|----|-----|--------|-----------------|---------------------|-----------|
| 1 | SELECT | `SELECT ...` | 10 записей | 5 результатов | P1 |
| 2 | INSERT | `INSERT ...` | NULL-значения | Ошибка 1048 | P0 |

## 🛠 Рекомендации по тестированию
1. **Для JOIN:**
   ```sql
   -- Проверка LEFT JOIN
   SELECT * FROM table1 LEFT JOIN table2 ON ...
   -- Должны быть NULL для отсутствующих строк
   ```

2. **Для агрегации:**
   ```sql
   -- Проверка GROUP BY с NULL
   SELECT category, COUNT(*) FROM products GROUP BY category;
   -- NULL должен быть отдельной группой
   ```

3. **Для индексов:**
   ```sql
   -- Поиск недостающих индексов
   SELECT * FROM pg_stat_all_indexes 
   WHERE schemaname = 'public';
   ```
