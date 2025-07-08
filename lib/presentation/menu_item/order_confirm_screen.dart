// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:graduation_project/domain/entities/order.dart';
import 'package:graduation_project/presentation/menu_item/order/cubit/order_cubit.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/menu_grid.dart';
import 'package:graduation_project/presentation/owner/order_robot/thanking_scree.dart';
import 'package:graduation_project/utils/image_utils.dart';
import 'package:graduation_project/utils/services/flages.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<OrderItem> items;
  final double total;
  final String restaurantId;
  const OrderConfirmationScreen({
    super.key,
    required this.items,
    required this.total,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          if (GlobalFlags.isFromTablet) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ThankYouScreen(
                        restaurantId: restaurantId,
                      )),
            );
          } else {
            Navigator.pop(
                context,
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order successfully created!'))));
          }
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Review Your Order')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: ImageUtils.imageFromBase64String(
                      item.image,
                    ),
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing:
                        Text((item.price * item.quantity).toStringAsFixed(2)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:', style: TextStyle(fontSize: 18)),
                      Text((total).toStringAsFixed(2)), // 10% tax
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax (14%):', style: TextStyle(fontSize: 18)),
                      Text((total * 0.14).toStringAsFixed(2)),
                    ],
                  ),
                  Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(total.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final order = Order(
                        customerName: user?.displayName ?? 'Guest',
                        restaurantId: restaurantId,
                        customerId: user?.uid ?? '',
                        items: items,
                        subtotal: total,
                        tax: total * 0.14,
                        total: total + (total * 0.14),
                        createdAt: DateTime.now(),
                      );
                      context.read<OrderCubit>().createOrder(order);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child:
                        Text('Confirm Order', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
