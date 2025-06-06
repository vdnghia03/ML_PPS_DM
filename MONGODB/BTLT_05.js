// Họ và tên: Võ Duy Nghĩa
// MSSV: 22280060

// BTLT số 5

/* Data
{
  "genres": [
    "Short",
    "Western"
  ],
  "runtime": 120,
  "title": "The Great Train Robbery",
  "languages": [
    "English"
  ],
  "directors": [
    "Edwin S. Porter"
  ],
  "year": 1903,
  "imdb": {
    "rating": 7.4,
    "votes": 9847,
    "id": 439
  },
  "countries": [
    "USA"
  ],
  "type": "movie"
}

*/


// a. Tìm tất cả các bộ phim trong collection "movies" được phát hành vào năm (year) 2024.

db.movies.find({ year: 2024 });

// b. Hãy tìm tất cả các bộ phim trong collection "movies" có hơn 10000 votes trên IMDB
db.movies.find({ "imdb.votes": { $gt: 10000 } });

// c. Tìm tất cả các bộ phim trong collection "movies" được phát hành tại quốc gia (country) Mỹ và có điểm rating trên IMDB lớn hơn hoặc bằng 8.
db.movies.find({
    "countries": "USA"
    , "imdb.rating": { $gte: 8 }
})

// d. Tìm các bộ phim được biên tập bởi đạo diễn (director) "Steven Spielberg" và có thời gian chiếu (runtime) hơn 120 phút.

db.movies.find({
    "directors": "Steven Spielberg",
    "runtime": { $gt: 120 }
});

// e. Tìm top 10 đạo diễn nhiều phim nhất
db.movies.aggregate([
    // Buoc 1 : Unwind các đạo diễn
    { $unwind: "$directors" },
    // Buoc 2 : Nhóm theo đạo diễn và đếm số lượng phim
    { $group: { _id: "$directors", count: { $sum: 1 } } },
    // Buoc 3 : Sắp xếp theo số lượng phim giảm dần
    { $sort: { count: -1 } },
    // Buoc 4 : Giới hạn kết quả chỉ lấy 10 đạo diễn
    { $limit: 10 }
])
