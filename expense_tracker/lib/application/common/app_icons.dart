class AppIcons {
  static Map<String, List<String>> get categorizedIcons => {
        'bills': [
          'assets/icons/house.svg',
          'assets/icons/bill.svg',
          'assets/icons/flash.svg',
          'assets/icons/water_drop.svg',
          'assets/icons/gas-pump.svg',
          'assets/icons/tools.svg',
        ],
        'transportation': [
          'assets/icons/car.svg',
          'assets/icons/bus.svg',
          'assets/icons/scooter.svg',
          'assets/icons/travel.svg',
        ],
        'foodAndDining': [
          'assets/icons/food.svg',
          'assets/icons/hamburger.svg',
          'assets/icons/pizza-slice.svg',
          'assets/icons/popcorn.svg',
        ],
        'entertainment': [
          'assets/icons/cinema.svg',
          'assets/icons/netflix.svg',
          'assets/icons/twitch-logo.svg',
          'assets/icons/steam.svg',
          'assets/icons/gamepad.svg',
          'assets/icons/play.svg',
        ],
        'petExpenses': [
          'assets/icons/cow.svg',
          'assets/icons/boar.svg',
          'assets/icons/paw.svg',
          'assets/icons/cat.svg',
        ],
        'health': [
          'assets/icons/healthcare.svg',
          'assets/icons/doctor.svg',
          'assets/icons/tooth.svg',
        ],
        'sports': [
          'assets/icons/american-football.svg',
          'assets/icons/bodybuilding-muscles.svg',
          'assets/icons/table-tennis.svg',
          'assets/icons/tennis-ball.svg',
        ],
        'finance': [
          'assets/icons/credit-card.svg',
          'assets/icons/cash.svg',
          'assets/icons/visa.svg',
          'assets/icons/paypal.svg',
          'assets/icons/revolut.svg',
          'assets/icons/bitcoin_logo.svg',
          'assets/icons/savings.svg',
        ],
        'shopping': [
          'assets/icons/bag.svg',
          'assets/icons/shirt.svg',
          'assets/icons/present.svg',
          'assets/icons/amazon.svg',
        ],
        'work': [
          'assets/icons/calendar.svg',
          'assets/icons/phone.svg',
          'assets/icons/suitcase.svg',
        ],
        'education': [
          'assets/icons/graduate.svg',
          'assets/icons/university.svg',
          'assets/icons/book.svg',
        ],
        'other': [
          'assets/icons/box.svg',
        ],
      };

  static List<String> get iconPathList =>
      categorizedIcons.values.expand((element) => element).toList();
}
