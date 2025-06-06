use("lab09");

db.restaurants.find()

// 1. Hien thi name, stars, avg_grade cua moi document, lam trong sau dau phay hai chu so thap phan

db.restaurants.aggregate([
  {
    $project: {
      name: 1,
      stars: 1,
      avg_grade: {
        $round: [
          { $avg: "$grades" },
          2
        ]
      }
    }
  }
])

// 2. Hien thi name, stars, min_grade, max_grade, no_of_grades cua moi document, sap xep theo avg_grade tu cao den thap, lam tron sau dau phay 2 so thap phan
db.restaurants.aggregate([
  {
    $project: {
      name: 1,
      stars: 1,
      min_grade: { $min: "$grades" },
      avg_grade: { $round: [{ $avg: "$grades" }, 2] },
      max_grade: { $max: "$grades" },
      no_of_grades: { $size: "$grades" }
    }
  },
  {
    $sort: { avg_grade: -1 }
  }
])

// 3. Hiển thị name, categories và cat_upper (viết hoa categories) của mỗi document
db.restaurants.aggregate([
  {
    $project: {
      name: 1,
      categories: 1,
      cat_upper: {
        $map: {
          input: "$categories",
          as: "cat",
          in: { $toUpper: "$$cat" }
        }
      }
    }
  }
])

// 4. Hien thi stars như _id va so luong document tuong ung voi moi gia tri stars

db.restaurants.aggregate([
    {
        $group: {
            _id: "$stars",
            count: { $sum: 1 }
        }
    }
])

// 5. Hien thi name, stars, no_of_grades va stars_mul_grades (stars * so luong grades)
db.restaurants.aggregate([
  {
    $project: {
        name: 1,
        stars: 1,
        no_of_grades: { $size: "$grades"},
        stars_mul_grades: {
            $multiply: [
                "$stars", 
                { $size: "$grades" }
            ]
        }
    }
  }
])


// ---------------------------------------------------------------

// use collection name sales in lab09
db.sales.find()

// 1. Hien thi ngay ban hang dau tien va ngay ban hang cuoi cung
db.sales.aggregate([
  {
    $group: {
      _id: null,
      firstSale: { $min: "$saleDate" },
      lastSale: { $max: "$saleDate" }
    }
  }
])

// 2. Hiển thị ngày bán hàng gần nhất có số lượng items bán được nhiều nhất
db.sales.aggregate([
  {
    $project: {
      saleDate: 1,
      totalQuantity: {
        $sum: {
          $map: {
            input: "$items",
            as: "item",
            in: "$$item.quantity"
          }
        }
      }
    }
  },
  { $sort: { totalQuantity: -1, saleDate: -1 } },
  { $limit: 1 }
])

// 3. Hiển thị tên sản phẩm và số lượng đã bán của sản phẩm có số lượng bán được nhiều nhất
db.sales.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: "$items.name",
      totalQuantity: { $sum: "$items.quantity" }
    }
  },
  { $sort: { totalQuantity: -1 } },
  { $limit: 1 }
])

// 4. Hiển thị storeLocation, số lượng khách hàng (no_of_customers) theo từng storeLocation và từng purchaseMethod, sắp xếp theo bảng chữ cái từ A-Z
db.sales.aggregate([
  {
    $group: {
      _id: {
        storeLocation: "$storeLocation",
        purchaseMethod: "$purchaseMethod"
      },
      no_of_customers: { $sum: 1 }
    }
  },
  {
    $sort: {
      "_id.storeLocation": 1,
      "_id.purchaseMethod": 1
    }
  }
])

// 5. Thống kê số lượng khách hàng theo độ tuổi: 15-29, 30-44, 45-59, 60-74, 75+
db.sales.aggregate([
  {
    $bucket: {
      groupBy: "$customer.age",
      boundaries: [15, 30, 45, 60, 75, 200],
      default: "Unknown",
      output: {
        no_of_customers: { $sum: 1 }
      }
    }
  }
])

// 6. Hiển thị số lượng khách hàng (no_of_customers), độ tuổi trung bình (avg_age), mức độ hài lòng trung bình (avg_satisfaction) của khách hàng theo từng khu vực. Làm tròn kết quả: avg_age: làm tròn lên, avg_satisfaction: làm tròn sau dấu phẩy 1 chữ số. Sắp xếp
// kết quả theo no_of_customers từ cao đến thấp

db.sales.aggregate([
  {
    $group: {
      _id: "$storeLocation",
      no_of_customers: { $sum: 1 },
      avg_age: { $avg: "$customer.age" },
      avg_satisfaction: { $avg: "$customer.satisfaction" }
    }
  },
  {
    $project: {
      storeLocation: "$_id",
      _id: 0,
      no_of_customers: 1,
      avg_age: { $ceil: "$avg_age" },
      avg_satisfaction: { $round: ["$avg_satisfaction", 1] }
    }
  },
  { $sort: { no_of_customers: -1 } }
])

// 7. Hiển thị số lượng khách hàng, độ tuổi trung bình, mức độ hài lòng trung bình của khách
// hàng đã mua hàng ở cửa hàng 'New York' theo từng nhóm giới tính, làm tròn kết quả
// như câu trên

db.sales.aggregate([
  { $match: { storeLocation: "New York" } },
  {
    $group: {
      _id: "$customer.gender",
      no_of_customers: { $sum: 1 },
      avg_age: { $avg: "$customer.age" },
      avg_satisfaction: { $avg: "$customer.satisfaction" }
    }
  },
  {
    $project: {
      gender: "$_id",
      _id: 0,
      no_of_customers: 1,
      avg_age: { $ceil: "$avg_age" },
      avg_satisfaction: { $round: ["$avg_satisfaction", 1] }
    }
  }
])

// 8. Hiển thị tất cả các distinct tags có trong sales collection
db.sales.aggregate([
  { $unwind: "$items" },
  { $unwind: "$items.tags" },
  { $group: { _id: null, distinctTags: { $addToSet: "$items.tags" } } },
  { $project: { _id: 0, distinctTags: 1 } }
])

// 9. Hiển thị 'saleDate', 'items.name', 'items.price', 'items.quantity', và thêm 1 field
// 'items.revenue' với 'items.revenue' = 'items.price' * 'items.quantity', sort kết quả theo
//'saleDate' từ cao đến thấp và chỉ hiển thị 2 kết quả đầu tiên

db.sales.aggregate([
  { $unwind: "$items" },
  {
    $project: {
      saleDate: 1,
      name: "$items.name",
      price: "$items.price",
      quantity: "$items.quantity",
      revenue: {
        $multiply: [
          { $toDouble: "$items.price" },
          "$items.quantity"
        ]
      }
    }
  },
  { $sort: { saleDate: -1 } },
  { $limit: 2 }
])

//10. Tính tổng doanh thu (totalSalesAmount) theo từng 'items.name'. Ví dụ: binder có
// totalSalesAmount: 511644.57
db.sales.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: "$items.name",
      totalSalesAmount: {
        $sum: {
          $multiply: [
            { $toDouble: "$items.price" },
            "$items.quantity"
          ]
        }
      }
    }
  },
  {
    $project: {
      _id: 0,
      name: "$_id",
      totalSalesAmount: 1
    }
  }
])

// 11. Tính tổng doanh thu theo từng năm
db.sales.aggregate([
  {
    $addFields: {
      year: { $year: { $toDate: "$saleDate" } }
    }
  },
  { $unwind: "$items" },
  {
    $group: {
      _id: "$year",
      totalSalesAmount: {
        $sum: {
          $multiply: [
            { $toDouble: "$items.price" },
            "$items.quantity"
          ]
        }
      }
    }
  },
  {
    $project: {
      year: "$_id",
      _id: 0,
      totalSalesAmount: 1
    }
  },
  { $sort: { year: 1 } }
])

// 12. Tổng số lượng đã bán được và tổng doanh thu của sản phẩm 'laptop' tại cửa hàng New York?
db.sales.aggregate([
  {
    $match: {
      storeLocation: "New York"
    }
  },
  { $unwind: "$items" },
  {
    $match: {
      "items.name": "laptop"
    }
  },
  {
    $group: {
      _id: null,
      totalQuantity: { $sum: "$items.quantity" },
      totalRevenue: {
        $sum: {
          $multiply: [
            { $toDouble: "$items.price" },
            "$items.quantity"
          ]
        }
      }
    }
  },
  {
    $project: {
      _id: 0,
      totalQuantity: 1,
      totalRevenue: 1
    }
  }
])
