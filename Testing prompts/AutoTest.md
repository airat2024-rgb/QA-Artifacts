# 🚀 QA Automation Prompts Collection

Роль:
**Senior QA Automation Engineer** с 7+ годами опыта в создании надежных и поддерживаемых автотестов.

## 🛠 Технический стек
- **UI Automation**: Selenium WebDriver (Python/Java/JavaScript)
- **API Testing**: RestAssured, Requests, Postman
- **Mobile**: Appium, Espresso, XCUITest
- **BDD**: Cucumber, Behave, pytest-bdd
- **CI/CD**: Jenkins, GitLab CI, GitHub Actions

## 💡 Что умеют эти промпты
1. Генерация кода автотестов под конкретный фреймворк
2. Помощь с архитектурой (Page Object, Screenplay)
3. Советы по стабильности тестов
4. Оптимизация тестовых сценариев
5. Работа с тестовыми данными

## 📋 Формат работы
Пришлите:
1. Описание функционала для тестирования
2. Стек технологий (например: Java + TestNG + Selenium)
3. Особые требования (например: интеграция с Allure)

Получите:
✔ Готовый код теста с пояснениями  
✔ Рекомендации по архитектуре  
✔ Примеры валидаций  
✔ Советы по флакки-тестам

---

## 🖥 Пример 1: UI-тест авторизации
**Запрос:**
"Нужен автотест на авторизацию через логин/пароль (Python + pytest + Selenium). Проверить успешный вход и ошибку при неверном пароле."

**Решение:**
```python
import pytest
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class TestLogin:
    @pytest.fixture(autouse=True)
    def setup(self, browser):
        self.browser = browser
        self.browser.get("https://example.com/login")
    
    def test_successful_login(self):
        # Arrange
        login_field = self.browser.find_element(By.ID, "username")
        password_field = self.browser.find_element(By.ID, "password")
        submit_btn = self.browser.find_element(By.XPATH, "//button[@type='submit']")
        
        # Act
        login_field.send_keys("valid_user")
        password_field.send_keys("correct_password")
        submit_btn.click()
        
        # Assert
        welcome_msg = WebDriverWait(self.browser, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, ".welcome-message")))
        assert "Добро пожаловать" in welcome_msg.text

    def test_invalid_password(self):
        # Act
        self.browser.find_element(By.ID, "username").send_keys("valid_user")
        self.browser.find_element(By.ID, "password").send_keys("wrong_pass")
        self.browser.find_element(By.XPATH, "//button[@type='submit']").click()
        
        # Assert
        error = WebDriverWait(self.browser, 5).until(
            EC.visibility_of_element_located((By.CLASS_NAME, "error-message")))
        assert "Неверный пароль" in error.text

---

## 🌐 Пример 2: API-тест для GET /users
**Запрос:**
"Напиши тест на GET-эндпоинт /users (Python + Requests). Проверить статус-код и структуру ответа."

**Решение:**
```python
import requests
import pytest

BASE_URL = "https://api.example.com"

def test_get_users():
    # Act
    response = requests.get(f"{BASE_URL}/users", 
                          headers={"Authorization": "Bearer valid_token"})
    
    # Assert
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    
    first_user = response.json()[0]
    assert "id" in first_user
    assert "email" in first_user
    assert "@" in first_user["email"]

@pytest.mark.parametrize("user_id, expected_status", [
    (1, 200),
    (999, 404),
    ("invalid", 400)
])
def test_get_user_by_id(user_id, expected_status):
    response = requests.get(f"{BASE_URL}/users/{user_id}")
    assert response.status_code == expected_status

---

## 📱 Пример 3: Mobile-тест поиска (iOS)
**Запрос:**
"Нужен тест для iOS-приложения (Swift + XCTest): проверка поиска товаров."

**Решение:**
```swift
import XCTest

class SearchTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testSuccessfulSearch() {
        // Arrange
        let searchField = app.searchFields["Поиск товаров"]
        
        // Act
        searchField.tap()
        searchField.typeText("iPhone 15")
        app.buttons["Найти"].tap()
        
        // Assert
        XCTAssertTrue(app.staticTexts["Результаты поиска"].waitForExistence(timeout: 5))
        let cells = app.cells.matching(identifier: "product_cell")
        XCTAssertGreaterThan(cells.count, 0)
    }
}


---

## 🚀 Дополнительные возможности
### Генерация отчетов
```python
# Пример интеграции с Allure
import allure

@allure.title("Проверка корзины")
def test_cart_functionality():
    with allure.step("Добавление товара"):
        # тестовый код
```

### Параллельный запуск
```bash
# Для pytest
pytest -n auto

# Для TestNG
<suite thread-count="4">
```

### Docker-интеграция
```dockerfile
FROM selenium/standalone-chrome
COPY tests /home/seluser/tests
CMD ["pytest", "/home/seluser/tests"]
```
