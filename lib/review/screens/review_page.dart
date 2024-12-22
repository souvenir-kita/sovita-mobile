import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:sovita/review/screens/review_form.dart';

class ProductReviewPage extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductReviewPage({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  List<dynamic> reviews = [];
  String filter = "allstar";
  bool isLoading = true;
  bool isAdmin = false;
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _editReviewController = TextEditingController();

  String _getStarFilter(String filter) {
    switch (filter) {
      case "onestar":
        return "1";
      case "twostar":
        return "2";
      case "threestar":
        return "3";
      case "fourstar":
        return "4";
      case "fivestar":
        return "5";
      default:
        return "allstar";
    }
  }

  List<dynamic> getFilteredReviews() {
    if (filter == "allstar") return reviews;
    final starRating = int.parse(_getStarFilter(filter));
    return reviews.where((review) => review['rating'] == starRating).toList();
  }

  void showEditReviewDialog(
      String reviewId, String currentReview, int currentRating) {
    _editReviewController.text = currentReview;
    int editRating = currentRating;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Edit Review',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Rating Section
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => editRating = index + 1);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: editRating > index
                                ? Colors.amber.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            editRating > index ? Icons.star : Icons.star_border,
                            color:
                                editRating > index ? Colors.amber : Colors.grey,
                            size: 32,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (editRating > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Rating: ${_getRatingText(editRating)}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Review Text Section
                const Text(
                  'Deskripsi Ulasan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _editReviewController,
                  decoration: InputDecoration(
                    hintText: "Bagikan pengalaman Anda dengan produk ini...",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: const Color(0xFFF09027)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 5,
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF09027),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        if (_editReviewController.text.isNotEmpty) {
                          await editReview(
                              reviewId, _editReviewController.text, editRating);
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.save, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Simpan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Sangat Buruk";
      case 2:
        return "Buruk";
      case 3:
        return "Cukup";
      case 4:
        return "Baik";
      case 5:
        return "Sangat Baik";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductReviews();
    checkUserRole();
  }

  void checkUserRole() {
    final request = context.read<CookieRequest>();
    // Mengecek cookie isAdmin yang telah kita set saat login
    final adminCookie = request.cookies['isAdmin'];
    setState(() {
      isAdmin = adminCookie?.value == "1";
    });
  }

  Future<void> fetchProductReviews() async {
    setState(() => isLoading = true);
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          "http://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/review/product/${widget.productId}/reviews/");
      setState(() {
        reviews = response['reviews'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching reviews: $e')));
    }
  }

  void showAddReviewDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTambahUlasan(productId: widget.productId),
      ),
    ).then((_) => fetchProductReviews());
  }

  Future<void> editReview(
      String reviewId, String newReview, int newRating) async {
    final request = context.read<CookieRequest>();
    try {
      // Ubah format JSON yang dikirim
      final response = await request.postJson(
        "http://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/review/edit-flutter/$reviewId/",
        jsonEncode({
          "rating": newRating,
          "deskripsi": newReview,
        }),
      );

      if (response['status'] == 'success') {
        await fetchProductReviews();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Review updated successfully!')));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Error: ${response['message'] ?? "Unknown error"}')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error updating review: $e')));
      }
    }
  }

  Future<void> deleteReview(String reviewId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        "http://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/review/delete-flutter/$reviewId/",
        jsonEncode({}), // Kirim body kosong karena hanya perlu ID dari URL
      );

      if (response['status'] == 'success') {
        await fetchProductReviews();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Review deleted successfully!')));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Error: ${response['message'] ?? "Unknown error"}')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error deleting review: $e')));
      }
    }
  }

  Widget _buildStarRating(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => const Text(
          "⭐",
          style: TextStyle(color: Colors.amber, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReviews = getFilteredReviews();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Ulasan - ${widget.productName}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF09027),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: filter,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Color(0xFFF09027)),
                      items: [
                        const DropdownMenuItem(
                          value: "allstar",
                          child: Text("Semua Ulasan"),
                        ),
                        DropdownMenuItem(
                          value: "fivestar",
                          child: Row(
                            children: [
                              _buildStarRating(5),
                              const SizedBox(width: 4),
                              const Text("Sangat Baik"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "fourstar",
                          child: Row(
                            children: [
                              _buildStarRating(4),
                              const SizedBox(width: 4),
                              const Text("Baik"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "threestar",
                          child: Row(
                            children: [
                              _buildStarRating(3),
                              const SizedBox(width: 4),
                              const Text("Cukup"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "twostar",
                          child: Row(
                            children: [
                              _buildStarRating(2),
                              const SizedBox(width: 4),
                              const Text("Buruk"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "onestar",
                          child: Row(
                            children: [
                              _buildStarRating(1),
                              const SizedBox(width: 4),
                              const Text("Sangat Buruk"),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => filter = value!),
                    ),
                  ),
                  if (!isAdmin) // Hanya tampilkan jika bukan admin
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_comment, size: 20),
                      label: const Text("Tambah Ulasan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF09027),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      onPressed: showAddReviewDialog,
                    ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : filteredReviews.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rate_review_outlined,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.8)),
                              const SizedBox(height: 16),
                              Text(
                                "Belum ada ulasan produk.",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredReviews.length,
                          itemBuilder: (context, index) {
                            final review = filteredReviews[index];
                            final rating = review['rating'];
                            final isUserReview =
                                review['is_user_review'] ?? false;

                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.orange.shade50,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    const Color(0xFFF09027),
                                                child: Text(
                                                  review['username'][0]
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    review['username'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (index) => Icon(
                                                        index < rating
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if (isUserReview)
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  color: Colors.blue,
                                                  onPressed: () =>
                                                      showEditReviewDialog(
                                                    review['id'],
                                                    review['review'],
                                                    review['rating'],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  color: Colors.red,
                                                  onPressed: () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      title: const Text(
                                                          'Delete Review'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this review?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await deleteReview(
                                                                review['id']);
                                                            if (context
                                                                .mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Text(
                                          review['review'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Posted on ${review['date_created']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _editReviewController.dispose();
    super.dispose();
  }
}
