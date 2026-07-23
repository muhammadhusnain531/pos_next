import 'package:flutter/material.dart';
import '../../screns/payment_screens/card_payment_screen.dart';
import '../../screns/payment_screens/cash_payment_screen.dart';
import '../../screns/payment_screens/gift_card_screen.dart';
import '../../theme/colors.dart';

class ActionButtonsGrid extends StatelessWidget {
  const ActionButtonsGrid({Key? key}) : super(key: key);

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        PosButton(
          label: "Pay Cash",
          color: AppColors.mauve,
          onTap: () => _openScreen(context, const CashPaymentScreen()),
        ),
        PosButton(
          label: "Pay Card",
          color: AppColors.mauveDeep,
          onTap: () => _openScreen(context, const CardPaymentScreen()),
        ),
        PosButton(
          label: "Gift Card",
          color: AppColors.blushDeep,
          onTap: () => _openScreen(context, const GiftCardScreen()),
        ),
        PosButton(
          label: "Discount", 
          color: AppColors.blush,
        ),
        PosButton(
          label: "Stock Details", 
          color: AppColors.zinc,
        ),
        PosButton(
          label: "Day/Opening Closing", 
          color: AppColors.zincDark,
        ),
        PosButton(
          label: "Return", 
          color: AppColors.warn,
        ),
        PosButton(
          label: "Home Delay", 
          color: AppColors.zincLight,
        ),
        PosButton(
          label: "Issue Gift Card", 
          color: AppColors.blushDeep,
        ),
        PosButton(
          label: "Void Product", 
          color: AppColors.bad,
        ),
        PosButton(
          label: "Void Payment", 
          color: AppColors.bad,
        ),
        PosButton(
          label: "Clean Screen", 
          color: AppColors.zincPale,
          textColor: AppColors.text,
        ),
        PosButton(
          label: "Customer Details", 
          color: AppColors.mauve,
        ),
        PosButton(
          label: "Reports", 
          color: AppColors.text,
        ),
      ],
    );
  }
}

class PosButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback? onTap;

  const PosButton({
    Key? key,
    required this.label,
    required this.color,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: color == AppColors.zincPale 
              ? const BorderSide(color: AppColors.border, width: 1) 
              : BorderSide.none,
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      ),
      onPressed: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
