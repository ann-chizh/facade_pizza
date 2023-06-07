import 'dart:math';

enum MenuType {vegan, notVegan, mixed}

abstract class IMenu{
  String getMenuName();
}

class VeganMenu implements IMenu{
  @override
  String getMenuName() => 'Vegan menu';
}

class NotVeganMenu implements IMenu{
  @override
  String getMenuName() => 'Not Vegan menu';
}

class MixedMenu implements IMenu{
  @override
  String getMenuName() => 'Mixed menu';
}

abstract class IClient{
  void requestMenu(IMenu menu);
  Map<int, String> formOrder();
  void eatingFood();
  String getName();
}

class Kitchen {
  void prepareFood() {
    print('The ordered food is beeing prepared');
  }

  void callWaiter() {
    print('Food at the waiter');
  }
}

class Waiter{
  void takeOrder(IClient client){
    print ('Waiter accepted the order from ${client.getName()}');
  }

  void sendToKitchen(){
    print ('Ordering in the kitchen');
  }

  void serveClient(IClient client){
    print ('Dishes are ready, we bring them to the client with name ${client.getName()}');
  }
}


class Client implements IClient{
  final String name;
  Client(this.name);
  @override
  void requestMenu(IMenu menu){

    print('Client $name familiarizes with ${menu.getMenuName()}');

  }

  @override
  void eatingFood() {
    print('Client $name starts eating');
  }

  @override
  Map<int, String> formOrder() {
    print('Client $name makes an order');
    return <int, String>{1: 'Something'};
  }

  @override
  String getName() => name;
}


class PizzeriaFacade{
  late Kitchen _kitchen;
  late Waiter _waiter;
  late Map<MenuType, IMenu> _menu;

  PizzeriaFacade(){
    _kitchen = Kitchen();
    _waiter = Waiter();
    _menu = <MenuType, IMenu>{
      MenuType.vegan: VeganMenu(),
      MenuType.notVegan: NotVeganMenu(),
      MenuType.mixed : MixedMenu()
    };
  }

  IMenu getMenu(MenuType type){
   // if (_menu.containsKey(type)) {
    if (_menu[type] != null) {
      return _menu[type]!;
    } else {
      throw ArgumentError('Invalid menu type');
      // return NotVeganMenu(); // default
    }

  }

  void takeOrder(IClient client){
    _waiter.takeOrder(client);
    _waiter.sendToKitchen();
    _kitchenWork();
    _waiter.serveClient(client);
  }

  void _kitchenWork() {
    _kitchen.prepareFood();
    _kitchen.callWaiter();
  }
}

void main(){
  var pizzeria = PizzeriaFacade();
  var client1 = Client('Ivan');
  var client2 = Client('Alex');

  client1.requestMenu(pizzeria.getMenu(MenuType.mixed));
  pizzeria.takeOrder(client1);
  client2.requestMenu(pizzeria.getMenu(MenuType.vegan));
  pizzeria.takeOrder(client2);
  client1.eatingFood();
  client2.eatingFood();
}

