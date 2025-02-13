import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/cart/helper/cart_action.dart';
import 'package:sovita/cart/helper/converter.dart';
import 'package:sovita/cart/helper/fetching.dart';
import 'package:sovita/adminview/models/product.dart';
import 'package:sovita/cart/models/cart_product.dart';
import 'package:sovita/cart/widgets/other.dart';
import 'package:sovita/promo/helper/fetch_promo.dart';
import 'package:sovita/promo/models/promo.dart';
import 'package:sovita/promo/widgets/promo_card.dart';
import 'package:sovita/promo/helper/fetch_promo.dart';
import 'package:sovita/promo/models/promo.dart';
import 'package:sovita/promo/widgets/promo_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<String, bool> _selectedProducts = {};
  final Map<String, double> _productPrices = {};
  double _totalPrice = 0.0;
  Promo? _appliedPromo;
  bool _isAscending = true;
  Map<String, Product> _productCache = {};

  void _applyPromo(Promo promo) {
    setState(() {
      _appliedPromo = promo;
      _calculateTotalPrice();
    });
  }

  void _cancelPromo() {
    setState(() {
      _appliedPromo = null;
      _calculateTotalPrice();
    });
  }

  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  void _calculateTotalPrice() {
    _totalPrice = 0.0;
    _selectedProducts.forEach((cartProductId, isSelected) {
      if (isSelected) {
        _totalPrice += _productPrices[cartProductId] ?? 0.0;
      }
    });

    if (_appliedPromo != null) {
      _totalPrice -= (_totalPrice * (_appliedPromo!.fields.potongan / 100));
    }

    setState(() {
      _totalPrice = _totalPrice;
    });
  }

  List<CartProduct> _sortCartProducts(List<CartProduct> cartProducts) {
    return List.from(cartProducts)
      ..sort((a, b) {
        final productA = _productCache[a.fields.product.toString()];
        final productB = _productCache[b.fields.product.toString()];

        if (productA == null || productB == null) return 0;

        return _isAscending
            ? productA.fields.name.compareTo(productB.fields.name)
            : productB.fields.name.compareTo(productA.fields.name);
      });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: FutureBuilder<List<CartProduct>>(
          future: fetchCartProduct(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Your cart is empty!"));
            } else {
              final cartProducts = snapshot.data!;
              return Column(
                children: [
                  // Sort button
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _toggleSort,
                          icon: Icon(_isAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                          label: Text(_isAscending ? 'Sort A-Z' : 'Sort Z-A'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: Future.wait<Product>([
                        for (var cp in cartProducts)
                          fetchProductDetail(request, cp.fields.product)
                      ]),
                      builder: (context, productsSnapshot) {
                        if (productsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Cache the products
                        if (productsSnapshot.hasData) {
                          final products =
                              productsSnapshot.data as List<Product>;
                          for (var i = 0; i < cartProducts.length; i++) {
                            _productCache[cartProducts[i]
                                .fields
                                .product
                                .toString()] = products[i];
                          }
                        }

                        final sortedCartProducts =
                            _sortCartProducts(cartProducts);

                        return ListView.builder(
                          itemCount: sortedCartProducts.length,
                          itemBuilder: (context, index) {
                            final cartProduct = sortedCartProducts[index];
                            final product = _productCache[
                                cartProduct.fields.product.toString()]!;
                            final double totalProductPrice =
                                product.fields.priceAsDouble *
                                    cartProduct.fields.amount;

                            _productPrices[cartProduct.pk] = totalProductPrice;

                            return Card(
                              color: Colors.white70,
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Image.network(
                                  "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/media/${product.fields.picture}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.fields.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          rp(totalProductPrice),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 6, 50, 101),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rp(product.fields.priceAsDouble),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 119, 119, 120),
                                      ),
                                    ),
                                    Text(
                                      "Note: ${cartProduct.fields.note ?? '-'}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => {
                                                updateAmount(
                                                    request,
                                                    cartProduct.pk,
                                                    false,
                                                    context,
                                                    setState),
                                                setState(() {
                                                  _calculateTotalPrice();
                                                }),
                                                _productPrices[cartProduct.pk] =
                                                    (_productPrices[
                                                            cartProduct.pk]! -
                                                        product.fields
                                                            .priceAsDouble),
                                                setState(() {
                                                  _calculateTotalPrice();
                                                })
                                              },
                                              child: const Icon(Icons.remove),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(cartProduct
                                                  .fields.amount
                                                  .toString()),
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                updateAmount(
                                                    request,
                                                    cartProduct.pk,
                                                    true,
                                                    context,
                                                    setState),
                                                _productPrices[cartProduct.pk] =
                                                    (_productPrices[
                                                            cartProduct.pk]! +
                                                        product.fields
                                                            .priceAsDouble),
                                                setState(() {
                                                  _calculateTotalPrice();
                                                })
                                              },
                                              child: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => {
                                                deleteCartProduct(
                                                    request,
                                                    cartProduct.pk,
                                                    context,
                                                    setState),
                                                _productPrices[cartProduct.pk] =
                                                    0,
                                                setState(() {
                                                  _calculateTotalPrice();
                                                }),
                                              },
                                              child: const Text(
                                                "Hapus",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: () => {
                                                editNote(
                                                    request,
                                                    cartProduct.pk,
                                                    cartProduct.fields.note ??
                                                        '',
                                                    context,
                                                    setState),
                                              },
                                              child: const Text(
                                                "Edit note",
                                                style: TextStyle(
                                                    color: Colors.teal),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: _selectedProducts[cartProduct.pk] ??
                                      false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _selectedProducts[cartProduct.pk] =
                                          value ?? false;
                                      _calculateTotalPrice();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_appliedPromo != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bagian teks promo yang fleksibel
                              Expanded(
                                child: Text(
                                  "Promo Applied: ${_appliedPromo!.fields.nama} (${_appliedPromo!.fields.potongan}%) ",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _cancelPromo,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          "Harga Barang: ${rp(_totalPrice)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "PPN 12%: ${rp(_totalPrice * 0.12)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        if (_appliedPromo != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bagian teks promo yang fleksibel
                              Expanded(
                                child: Text(
                                  "Promo Applied: ${_appliedPromo!.fields.nama} (${_appliedPromo!.fields.potongan}%) ",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _cancelPromo,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          "Harga Barang: ${rp(_totalPrice)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "PPN 12%: ${rp(_totalPrice * 0.12)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Total: ${rp(_totalPrice + _totalPrice * 0.12)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        PromoBottomSheet(onPromoApplied: _applyPromo),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _totalPrice > 0 ||
                                  _appliedPromo?.fields.potongan == 100
                              ? () {
                                  // Handle pseudo-checkout logic here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Ter-check out!"),
                                    ),
                                  );
                                }
                              : null,
                          child: const Text("Checkout"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PromoBottomSheet extends StatelessWidget {
  final Function(Promo) onPromoApplied;

  const PromoBottomSheet({super.key, required this.onPromoApplied});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.local_offer),
      label: const Text("Lihat Promo yang Tersedia"),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => _PromoList(
              scrollController: scrollController,
              onPromoApplied: onPromoApplied,
            ),
          ),
        );
      },
    );
  }
}

class _PromoList extends StatelessWidget {
  final ScrollController scrollController;
  final Function(Promo) onPromoApplied;

  const _PromoList({
    required this.scrollController,
    required this.onPromoApplied,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Promo",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Promo>>(
              future: fetchPromo(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No promos available'));
                }

                final validPromos = snapshot.data!
                    .where((promo) =>
                        !kadaluarsa(promo.fields.tanggalAkhirBerlaku))
                    .toList();

                if (validPromos.isEmpty) {
                  return const Center(child: Text('No valid promos available'));
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: validPromos.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final promo = validPromos[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          onPromoApplied(promo); // Apply the selected promo
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Promo Card (Left side)
                            Expanded(
                              flex: 3,
                              child: PromoCard(promo: promo),
                            ),
                            const SizedBox(width: 16),
                            // Description (Right side)
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promo.fields.nama,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${promo.fields.deskripsi}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}