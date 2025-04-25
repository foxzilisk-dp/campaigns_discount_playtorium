# 🛍️ Flutter Discount Module

## 💻 Developer Info

- Full Name: [ Ms. Pichaya Deachpol ]
- Experience: 4 years for flutter
- Using GetX for state management and data control
- Built with Dart/Flutter

---

## 📋 Features

- Load products and campaigns from a JSON file
- Calculate discount prices in order: Coupon > OnTop > Seasonal
- Support multiple discount types: Coupon, Points, Seasonal
- Fully managed using GetX (Reactive State, Controller, Logic)
- Includes unit tests for both success and error cases

---

## 🚀 How to Use

1. Install Flutter and clone the project
2. Run the following commands in terminal:

```bash
flutter pub get
flutter run
```

3. Sample JSON file is located at `assets/sample_data.json`

---

## 🧪 Unit Tests

Run tests in the `test/` folder:

```bash
flutter test
```

- ✅ Success case for valid discount calculations
- ❌ Error case for invalid or excessive discounts

---

## 📂 Sample JSON (`assets/sample_data.json`)

```json
{
  "cartItems": [
    { "name": "Shirt", "price": 350, "category": "Clothing" },
    { "name": "Hat", "price": 250, "category": "Accessories" }
  ],
  "campaigns": [
    { "type": "coupon", "subType": "Fixed Amount", "amount": 50 },
    { "type": "onTop", "subType": "Discount by Points", "points": 80 },
    {
      "type": "seasonal",
      "subType": "Threshold Discount",
      "thresholdAmount": 300,
      "thresholdDiscount": 40
    }
  ]
}
```

---

## 🧠 Campaign Logic Summary

| Type     | SubType                              | Description                                                          |
| -------- | ------------------------------------ | -------------------------------------------------------------------- |
| Coupon   | Fixed Amount                         | Subtract fixed amount from total price (`amount`)                    |
| Coupon   | Percentage Discount                  | Subtract a percentage from total price (`percentage`)                |
| OnTop    | Discount by Points                   | Spend points to get discount (1 point = 1 THB, max 20% of total)     |
| OnTop    | Percentage Discount by Item Category | Discount specific category by percentage (`category`, `percentage`)  |
| Seasonal | Threshold Discount                   | Every X THB, subtract Y THB (`thresholdAmount`, `thresholdDiscount`) |

### 🔄 Discount Order

1. ✅ Only one campaign per type (Coupon, OnTop, Seasonal)
2. ✅ Discount application order: `Coupon` ➜ `OnTop` ➜ `Seasonal`
