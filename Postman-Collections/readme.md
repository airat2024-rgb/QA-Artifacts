# Postman Коллекции

## Описание коллекций
1. содержит:
   - GET
   - POST
   - PATCH
   - DELETE
   - Скрипты
### Пример запроса

POST {{users}}
Content-Type: application/json
Authorization: Bearer {{api_key}}

{
    "name": "Airat",
    "job": "TraineeQA"
}

### Пример скрипта
pm.test("Имя и должность ответа совпадают с данными запроса", () => {
    const requestData = JSON.parse(pm.request.body.raw);
    const responseData = pm.response.json();
    pm.expect(responseData.name).to.eql(requestData.name);
    pm.expect(responseData.job).to.eql(requestData.job);
});
