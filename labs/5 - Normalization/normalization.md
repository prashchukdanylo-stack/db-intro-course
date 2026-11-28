# Lab 5 -- нормалізація наших таблиць

## 1. Функціональні залежності початкової схеми
1. Passenger (PK: passenger_id, UK: phone_number, UK: email)
* passenger_id -> first_name, last_name, phone_number,email, rating, created_at
* phone_number -> passenger_id
* email -> passenger_id

2. Driver (PK: driver_id, UK: phone_number, UK:email, UK: license_number)
* driver_id -> first_name, last_name, phone_number, email, license_number, rating, status, created_at
* phone_number -> driver_id
* email -> driver_id
* license_number -> driver_id

3. Car_class (PK: car_class_id, UK: car_class_name)
* car_class_id -> car_class_name, base_fare, price_per_km, price_per_minute
* car_class_name -> car_class_id

4. Car (PK: car_id, UK: license_plate, FK: car_class_id -> Car_class.car_class_id)
* car_id -> car_class_id, license_plate, make, model, color
* license_plate -> car_id
* model -> make (кожна модель належить одному виробнику, напр. Corolla -> Toyota)

5. Ride (PK: ride_id, FK: passenger_id -> Passenger.passenger_id, FK: requested_car_class_id -> Car_class.car_class_id, FK: driver_id -> Driver.driver_id, FK: car_id -> Car.car_id)
* ride_id -> passenger_id, requested_car_class_id, driver_id, car_id, pickup_location, dropoff_location, status, distance_km, price, created_at, accepted_at, started_at, finished_at, cancelled_at

6. Payment (PK: payment_id, FK: ride_id -> Ride.ride_id)
* payment_id -> ride_id, amount, payment_method, status, transaction_reference, transaction_time

7. Review (PK: review_id, UK: (ride_id, author_type), FK: ride_id -> Ride.ride_id)
* review_id -> ride_id, author_type, rating, review_comment, created_at
* (ride_id, author_type) -> review_id, rating, review_comment, created_at

## 2. Поточна нормальна форма
Найвища нормальна форма початкової схеми -- 2NF.

* **1NF виконано:** усі стовпці атомарні, повторюваних груп немає, у кожної таблиці є PK.
* **2NF виконано:** усі первинні ключі прості, тому часткових залежностей немає.
* **3NF порушено в таблиці Car:** існує транзитивна залежність car_id -> model -> make, де model і make — неключові атрибути. Через це make дублюється (Toyota та Skoda повторюються по два рази), а зміна написання виробника в одному рядку призводить до суперечливих даних.
* Решта таблиць (Passenger, Driver, Car_class, Ride, Payment, Review) уже в 3NF (фактично в BCNF), бо всі детермінанти в них є ключами.

## 3. Перевірка на 1NF
Усі таблиці мають лише атомарні значення, адже немає жодної таблиці з якимось списком, масивом або декількох значень через кому. Немає повторюваних груп стовпців по типу phone1, phone2, phone3.У кожної таблиці є свій первинний ключ. Якщо проходитись по кожній таблиці, то:
1. Passenger: ім'я та прізвище в окремих стовпцях, один телефон, один email; повторюваних груп немає, PK -- passenger_id.
2. Driver: атомарність аналогічно до Passenger; повторюваних груп немає, PK -- driver_id.
3. Car_class: всі значення атомарні; повторюваних груп немає, PK -- car_class_id.
4. Car: всі значення атомарні; повторюваних груп немає, PK -- car_id.
5. Ride: в теорії, значення pickup_location і dropoff_location можна вважати не атомарними, тому що наприклад в "вул. Васильківська, 100" можна окремо сприймати назву вулиці та номер будинку. Але, для нашого проєкту ми вважаємо адресу єдиним значенням, тому формально 1NF не порушується; повторюваних груп немає; PK -- ride_id.
6. Payment: всі значення атомарні; повторюваних груп немає; PK -- payment_id.
7. Review: всі значення атомарні; повторюваних груп немає; PK -- review_id.

## 4. Перевірка на 2NF
Таблиця знаходиться в 2NF, якщо вона знаходиться в 1NF і жоден неключовий атрибут не залежить лише від частини складеного ключа. Наші таблиці усі вже в 1NF, а первинні ключі усі прості, тому часткова залежність неможлива. Тому, Passenger, Driver, Car_class, Car, Ride, Payment, Review автоматично задовольняють 2NF. 
Лише варто окремо розглянути Review, у якої є складений ключ-кандидат '(ride_id, author_type)':
- 'rating', 'review_comment', 'created_at' залежать від пари '(ride_id, author_type)' повністю: оцінка та коментар належать конкретному відгуку конкретного автора до конкретної поїздки.
- жоден із цих атрибутів не визначається самим 'ride_id' або самим 'author_type'.
- первинним ключем обрано review_id, тому часткових залежностей бути не може. 
