// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart'; // Importa mockito para crear mocks de objetos
// import 'package:tg_frontend/widgets/travel_card.dart';
// import 'package:tg_frontend/models/travel_model.dart'; // Importa el modelo Travel
// import 'package:tg_frontend/datasource/travel_data.dart';

// // Crea una clase mock para simular la fuente de datos de viaje
// class MockTravelDatasource extends Mock implements TravelDatasource {}

// void main() {
//   testWidgets('TravelCard muestra la información de la tarjeta correctamente',
//       (WidgetTester tester) async {
//     // Crea un objeto mock de la fuente de datos de viaje
//     final mockTravelDatasource = MockTravelDatasource();

//     // Define los datos que se utilizarán en la prueba
//     final travel = Travel(
//         id: 1,
//         startingPointLat: 0.0,
//         startingPointLong: 0.0,
//         arrivalPointLat: 1.0,
//         arrivalPointLong: 1.0,
//         date: '2024-05-12',
//         hour: '12:00',
//         driver: 0,
//         price: 3000,
//         seats: 1,
//         currentTrip: 0);

//     // Simula la respuesta de la API
//     when(mockTravelDatasource.getTextDirection(
//             lat: travel.arrivalPointLat, long: travel.arrivalPointLong))
//         .thenAnswer((_) async => 'Desde');
//     // when(mockTravelDatasource.getTextDirection(
//     //         lat: travel.startingPointLat, long: travel.startingPointLong))
//     //     .thenAnswer((_) async => 'Hacia');

//     // Construye el widget bajo prueba
//     await tester.pumpWidget(MaterialApp(
//       home: TravelCard(travel: travel),
//     ));

//     // Verifica que el texto del destino se muestra correctamente
//     expect(find.text('Desde'), findsOneWidget);
//     // expect(find.text('Hacia'), findsOneWidget);
//   });
// }
