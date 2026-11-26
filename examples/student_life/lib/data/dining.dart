/// A dining hall and today's hours (mock data).
class DiningHall {
  const DiningHall({
    required this.name,
    required this.hours,
    required this.isOpen,
  });

  final String name;
  final String hours;
  final bool isOpen;
}

const diningHalls = [
  DiningHall(name: '64 Degrees', hours: '7 AM – 9 PM', isOpen: true),
  DiningHall(name: 'Pines', hours: '7 AM – 8 PM', isOpen: true),
  DiningHall(name: 'Club Med', hours: '11 AM – 2 PM', isOpen: false),
];
