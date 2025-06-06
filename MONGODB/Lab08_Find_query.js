use("lab08");


// 1. Hien thi tat ca documents trong restaurants
db.restaurants.find({});


// 2. Dem so luong documents trong restaurants
db.restaurants.countDocuments({});

// 3. Hien thi id, name, phone va categories cua tat ca cac documents trong restaurants

db.restaurants.find(
  {}, 
  {
    name: 1, 
    "contact.phone": 1, 
    categories: 1
  }
)

// 4. Hien thi 5 hang dau tien co stars > 3, sort theo thu tu tu cao den thap
db.restaurants.find({ stars: { $gt: 3}})
    .sort({stars: -1})
    .limit(5);

// 5. Hien thi 5 nha hang tiep theo sau skip 5 nha hang dau tien co stars > 3, sort theo thu tu tu cao den thap
db.restaurants.find({ stars: { $gt: 3 } })
  .sort({ stars: -1 })
  .skip(5)
  .limit(5)



// 6. Tìm các nhà hàng có vị trí latitude < -95.754168
db.restaurants.find({
    $expr: {$lt: [{$arrayElemAt: ["$contact.location", 0]}, -95.754168]}
})


// 7. Tìm các nhà hàng khong có món ăn Californian, điểm stars >= 4, và latitude < -65.754168, sắp xếp theo thứ tự stars giảm dần
db.restaurants.find({
  categories: { $ne: "Californian" },
  stars: { $gte: 4 },
  $expr: { $lt: [ { $arrayElemAt: ["$contact.location", 0] }, -65.754168 ] }
})
.sort({ stars: -1 })

// 8. Hien thi _id, name, stars, categories, phone va email cua cac nha hang co ten bat dau bang 'Wil

db.restaurants.find(
  { name: { $regex: /^Wil/ } },
  {
    _id: 1,
    name: 1,
    stars: 1,
    categories: 1,
    "contact.phone": 1,
    "contact.email": 1
  }
)

// 9. Hien thi id_, name, stars, categories, phone va email cua cac nha hang co ten ket thuc bang 'ces
db.restaurants.find(
  { name: { $regex: /ces$/ } },
  {
    _id: 1,
    name: 1,
    stars: 1,
    categories: 1,
    "contact.phone": 1,
    "contact.email": 1
  }
)


// 10. Hien thi id_, name, stars, categories, phone va email cua cac nha hang co chua ky tu "Reg"
db.restaurants.find(
    { name: { $regex: /Reg/ } },
    {
        _id: 1,
        name: 1,
        stars: 1,
        categories: 1,
        "contact.phone": 1,
        "contact.email": 1
    }
)

// 11. Tim cac nha hang co ba mon Russian, Chinese, Vietnamese
db.restaurants.find({
    categories: { $all: ["Russian", "Chinese", "Vietnamese"] }
})

// 12. Tim cac nha hang co so luong phan tu trong grade bang 5
db.restaurants.find(
    { "grades": { $size : 5}}
)


// 13. Tìm các nhà hàng có ít nhất một phần tử trong grades lớn hơn hoặc bằng 20 và nhỏ hơn 30
db.restaurants.find(
    { grades: { $elemMatch: { $gte: 20, $lt: 30 } } }
)

// 14. Tim nha hang co so dien thoai bat dau bang 770 va email ket thuc bang '.com'

db.restaurants.find({
  "contact.phone": { $regex: /^770/ },
  "contact.email": { $regex: /\.com$/ }
})
