import 'package:essumin_mix/data/models/simbologia/rigger.dart';
import 'package:flutter/material.dart';

class ImagesGridView extends StatelessWidget {
  final List<RSimbologia> data;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const ImagesGridView(
      {required this.data,
      required this.selectedIndex,
      required this.onItemSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2),
      ),
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onItemSelected(index);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedIndex == index
                    ? Colors.blue
                    : const Color.fromRGBO(113, 128, 150, 0.25),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                data[index].imgUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
