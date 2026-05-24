// Car Model
class Car {
  final String name;
  final String imageUrl;
  final double pricePerDay;
  final int seats;
  final String fuelType;
  final String transmission;
  final String average;
  final int mileage;
  final double condition;
  final double rating;
  final int totalTrips;
  final String location;
  final String status;


  Car({
    required this.name,
    required this.imageUrl,
    required this.pricePerDay,
    required this.seats,
    required this.fuelType,
    required this.transmission,
    required this.average,
    required this.mileage,
    required this.condition,
    required this.rating,
    required this.totalTrips,
    required this.location,
    this.status = 'available',

  });
}


// Car Data Provider - Contains all car data for each category
class CarDataProvider {
  static List<Car> getAllCars() {
    return [
      ...getLuxurySedans(),
      ...getMinivans(),
      ...getOpulenceCars(),
      ...getHatchbacks(),
      ...getElectricCars(),
      ...getCrossovers(),
      ...getConvertibles(),
      ...getSUVs(),
    ];
  }

  // LUXURY SEDANS (6 cars)
  static List<Car> getLuxurySedans() {
    return [
      Car(
        name: 'Audi A5',
        imageUrl: 'https://images.prismic.io/carwow/Z1CM8JbqstJ98CZJ_2024AudiA5Saloonfrontquarterdriving2.jpg?auto=format&cs=tinysrgb&fit=max&q=60',
        pricePerDay: 220000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Manual',
        average: '6-7 L/100 km',
        mileage: 50000,
        condition: 9.8,
        rating: 4.9,
        totalTrips: 87,
        location: 'Islamabad',
      ),
      Car(
        name: 'Toyota Crown',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-158-64c92955e93a7.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 200000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '11-14 km/L',
        mileage: 65000,
        condition: 8.0,
        rating: 4.7,
        totalTrips: 112,
        location: 'Karachi',
      ),
      Car(
        name: 'Elantra 2024',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-101-64ef85e1bb7aa.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 75000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '4-5 L/100 km',
        mileage: 43000,
        condition: 8.0,
        rating: 4.6,
        totalTrips: 95,
        location: 'Lahore',
      ),
      Car(
        name: 'Civic Hybrid 2025',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-106-66ba34ddaa207.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 64000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '8-12 km/L',
        mileage: 55000,
        condition: 10.0,
        rating: 5.0,
        totalTrips: 143,
        location: 'Rawalpindi',
      ),
      Car(
        name: '2022 Camry',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-115-1603151471.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 45000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '8-9 L/100 km',
        mileage: 77000,
        condition: 9.5,
        rating: 4.8,
        totalTrips: 156,
        location: 'Faisalabad',
      ),
      Car(
        name: 'Sonata 2023',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-111-66c64b89296bf.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 350000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '6-7 L/100 km',
        mileage: 33000,
        condition: 9.0,
        rating: 4.9,
        totalTrips: 68,
        location: 'Multan',
      ),
    ];
  }

  // MINIVANS (6 cars)
  static List<Car> getMinivans() {
    return [
      Car(
        name: 'KIA Grand Carnival',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-123-679407094c63f.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 33000,
        seats: 11,
        fuelType: 'Petrol',
        transmission: 'Manual',
        average: '8.6 L/100 km',
        mileage: 44000,
        condition: 9.7,
        rating: 4.8,
        totalTrips: 124,
        location: 'Islamabad',
      ),
      Car(
        name: 'Hyundai Staria',
        imageUrl: 'https://imgcdn.zigwheels.pk/large/gallery/color/18/457/hyundai-staria-color-442766.jpg',
        pricePerDay: 30000,
        seats: 7,
        fuelType: 'Gasoline/Diesel',
        transmission: '8-Speed Automatic',
        average: '9-12 L/100 km',
        mileage: 55300,
        condition: 8.0,
        rating: 4.7,
        totalTrips: 89,
        location: 'Lahore',
      ),
      Car(
        name: 'Toyota Hiace Luxury Wagon',
        imageUrl: 'https://global.toyota/pages/news/images/2019/11/25/1330/001.jpg',
        pricePerDay: 20000,
        seats: 10,
        fuelType: 'Diesel',
        transmission: '6-speed Automatic',
        average: '8-12 L/100 km',
        mileage: 68000,
        condition: 10.0,
        rating: 4.9,
        totalTrips: 178,
        location: 'Karachi',
      ),
      Car(
        name: 'Honda Odyssey',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-104-675b5a737b202.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 350000,
        seats: 8,
        fuelType: 'Gasoline',
        transmission: '10-speed automatic',
        average: '8.6 L/100 km',
        mileage: 99200,
        condition: 9.0,
        rating: 4.6,
        totalTrips: 54,
        location: 'Rawalpindi',
      ),
      Car(
        name: 'Mercedes-Benz V-Class',
        imageUrl: 'https://www.mercedes-benz.com.au/content/dam/australia/vans/models/v-class-fl/394379.ECE.MB.png/1740124001902.jpg?im=Crop,rect=(0,281,3000,1688);Resize=(1850,1041)',
        pricePerDay: 45000,
        seats: 7,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '7-11 L/100 km',
        mileage: 88000,
        condition: 9.0,
        rating: 4.8,
        totalTrips: 92,
        location: 'Peshawar',
      ),
      Car(
        name: 'Suzuki APV',
        imageUrl: 'https://media.drive.com.au/obj/tx_q:50,rs:auto:1920:1080:1/caradvice/private/d4c7f8bd2cb30fb59c4d3993189ea188',
        pricePerDay: 24000,
        seats: 7,
        fuelType: 'Petrol',
        transmission: 'Manual',
        average: '9-10 L/100 km',
        mileage: 59000,
        condition: 8.0,
        rating: 4.5,
        totalTrips: 134,
        location: 'Faisalabad',
      ),
    ];
  }

  // OPULENCE CARS (6 cars)
  static List<Car> getOpulenceCars() {
    return [
      Car(
        name: 'Rolls-Royce Wraith 2016',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/images/13q3/541018/2014-rolls-royce-wraith-photo-543220-s-986x603.jpg?fill=2:1&resize=1400:*',
        pricePerDay: 470000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '6-7 L/100 km',
        mileage: 23000,
        condition: 10.0,
        rating: 5.0,
        totalTrips: 45,
        location: 'Islamabad',
      ),
      Car(
        name: 'Bentley Flying Spur 2021',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-608-hdr-1594131894.jpg?crop=0.737xw:0.553xh;0,0.430xh&resize=1800:*',
        pricePerDay: 345500,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '8-12 km/L',
        mileage: 18500,
        condition: 10.0,
        rating: 5.0,
        totalTrips: 38,
        location: 'Karachi',
      ),
      Car(
        name: 'Mercedes-Benz S-Class 2021',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-172-edit-1631555006.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 216000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '9-speed automatic',
        average: '10-12 km/L',
        mileage: 32000,
        condition: 10.0,
        rating: 4.9,
        totalTrips: 76,
        location: 'Lahore',
      ),
      Car(
        name: 'Porsche Panamera 2021',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-243-edit-1622681872.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 180000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: '8-speed dual-clutch automatic',
        average: '8-12 km/L',
        mileage: 43000,
        condition: 10.0,
        rating: 4.9,
        totalTrips: 62,
        location: 'Islamabad',
      ),
      Car(
        name: 'Maserati Quattroporte 2021',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-104-1597067998.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 150000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: '8-speed Automatic',
        average: '8-10 L/100 km',
        mileage: 62000,
        condition: 9.5,
        rating: 4.8,
        totalTrips: 58,
        location: 'Karachi',
      ),
      Car(
        name: 'Audi A8L',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/a218143-medium-1635867809.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 200000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '8-10 km/L',
        mileage: 38000,
        condition: 9.0,
        rating: 4.7,
        totalTrips: 71,
        location: 'Lahore',
      ),
    ];
  }

  // HATCHBACKS (6 cars)
  static List<Car> getHatchbacks() {
    return [
      Car(
        name: 'Mercedes-Benz A-Class',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-108-1544471119.jpg?crop=0.879xw:0.808xh;0,0.169xh',
        pricePerDay: 50000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '7-speed dual-clutch automatic',
        average: '5.0-6.3 L/100 km',
        mileage: 55000,
        condition: 9.8,
        rating: 4.8,
        totalTrips: 103,
        location: 'Islamabad',
      ),
      Car(
        name: 'Audi A5 Sportback',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2020-audi-a5-coupe-201-1567778049.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 90000,
        seats: 5,
        fuelType: 'Gasoline',
        transmission: 'Automatic',
        average: '8.4-9.8 L/100 km',
        mileage: 75599,
        condition: 9.0,
        rating: 4.7,
        totalTrips: 84,
        location: 'Lahore',
      ),
      Car(
        name: 'BMW 4 Series Coupe',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-104-662804b591081.jpg?crop=1.00xw:0.881xh;0,0.119xh',
        pricePerDay: 100000,
        seats: 4,
        fuelType: 'Gasoline',
        transmission: '8-speed automatic',
        average: '8.4-9.4 L/100 km',
        mileage: 89300,
        condition: 9.2,
        rating: 4.9,
        totalTrips: 96,
        location: 'Karachi',
      ),
      Car(
        name: 'Porsche 718 Cayman',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-4l-159-1648783305.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 150000,
        seats: 2,
        fuelType: 'Gasoline',
        transmission: 'Manual/Automatic',
        average: '9.8-12.4 L/100 km',
        mileage: 100000,
        condition: 9.5,
        rating: 4.9,
        totalTrips: 67,
        location: 'Rawalpindi',
      ),
      Car(
        name: 'Mercedes-Benz EQS Sedan',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-132-1657599527.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 300000,
        seats: 5,
        fuelType: 'Electric',
        transmission: 'Single-speed automatic',
        average: 'Equivalent to 2.4-2.6 L/100 km',
        mileage: 45000,
        condition: 10.0,
        rating: 5.0,
        totalTrips: 52,
        location: 'Islamabad',
      ),
      Car(
        name: 'Audi S7',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s6-design-edition-103-1652282630.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 150000,
        seats: 5,
        fuelType: 'Gasoline',
        transmission: 'Automatic',
        average: '8.7-10.7 L/100 km',
        mileage: 60000,
        condition: 9.5,
        rating: 4.8,
        totalTrips: 88,
        location: 'Multan',
      ),
    ];
  }

  // ELECTRIC CARS (6 cars)
  static List<Car> getElectricCars() {
    return [
      Car(
        name: 'BMW i4',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-107-1659059089.jpg?crop=1.00xw:0.753xh;0,0.130xh&resize=1800:*',
        pricePerDay: 53000,
        seats: 5,
        fuelType: 'Electric (81.5 kWh battery)',
        transmission: 'Automatic',
        average: '2.25-2.47 L/100 km',
        mileage: 44000,
        condition: 9.8,
        rating: 4.9,
        totalTrips: 112,
        location: 'Lahore',
      ),
      Car(
        name: 'BYD Seal',
        imageUrl: 'https://stimg.cardekho.com/images/carexteriorimages/930x620/BYD/Seal/9561/1738385175958/front-left-side-47.jpg',
        pricePerDay: 60000,
        seats: 5,
        fuelType: 'Electric (61.4 kWh battery)',
        transmission: 'Automatic',
        average: '1.63-1.85 L/100 km',
        mileage: 77900,
        condition: 8.0,
        rating: 4.6,
        totalTrips: 89,
        location: 'Karachi',
      ),
      Car(
        name: 'Porsche Taycan',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-115-672385e70b435.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 70000,
        seats: 5,
        fuelType: 'Electric (93.4 kWh battery)',
        transmission: 'Automatic',
        average: '2.47-2.92 L/100 km',
        mileage: 33000,
        condition: 9.8,
        rating: 5.0,
        totalTrips: 73,
        location: 'Islamabad',
      ),
      Car(
        name: 'Audi Etron',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-1545086914.jpg?crop=0.904xw:0.830xh;0.0497xw,0.170xh&resize=2048:*',
        pricePerDay: 350000,
        seats: 5,
        fuelType: 'Electric (82 kWh battery)',
        transmission: 'Automatic',
        average: '2.02-2.47 L/100 km',
        mileage: 55800,
        condition: 8.0,
        rating: 4.7,
        totalTrips: 56,
        location: 'Rawalpindi',
      ),
      Car(
        name: 'KIA EV6',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/10best-trucks-suvs-2023-kia-ev6-107-1673299609.jpg?crop=0.644xw:0.546xh;0.125xw,0.332xh&resize=1200:*',
        pricePerDay: 45000,
        seats: 5,
        fuelType: 'Electric (77.4 kWh battery)',
        transmission: 'Automatic',
        average: '1.80-2.13 L/100 km',
        mileage: 44000,
        condition: 9.0,
        rating: 4.8,
        totalTrips: 98,
        location: 'Faisalabad',
      ),
      Car(
        name: 'Cadillac Lyriq',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-103-6463cff2277d1.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 54000,
        seats: 5,
        fuelType: 'Electric (190 kW battery)',
        transmission: 'Automatic',
        average: '2.02-2.47 L/100 km',
        mileage: 66000,
        condition: 7.8,
        rating: 4.5,
        totalTrips: 64,
        location: 'Multan',
      ),
    ];
  }

  // CROSSOVERS (6 cars)
  static List<Car> getCrossovers() {
    return [
      Car(
        name: 'BMW X5',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-102-6602d48787fb7.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 35000,
        seats: 5,
        fuelType: 'Petrol/Diesel',
        transmission: '8-speed automatic',
        average: '9.0 L/100 km (Petrol), 7.0 L/100 km (Diesel)',
        mileage: 75000,
        condition: 9.8,
        rating: 4.9,
        totalTrips: 145,
        location: 'Islamabad',
      ),
      Car(
        name: 'Porsche Macan Turbo 2021',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2020-porsche-macan-turbo-114-1583847369.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 30000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '7-speed dual clutch automatic',
        average: '9.5 L/100 km',
        mileage: 48990,
        condition: 9.5,
        rating: 4.9,
        totalTrips: 102,
        location: 'Karachi',
      ),
      Car(
        name: 'Range Rover Velar',
        imageUrl: 'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202309/whatsapp_image_2023-09-15_at_12-sixteen_nine.jpeg',
        pricePerDay: 45000,
        seats: 5,
        fuelType: 'Petrol/Diesel',
        transmission: '8-speed automatic',
        average: '9.4 L/100 km (Petrol), 7.5 L/100 km (Diesel)',
        mileage: 150000,
        condition: 9.2,
        rating: 4.8,
        totalTrips: 123,
        location: 'Lahore',
      ),
      Car(
        name: 'Lexus RX 350',
        imageUrl: 'https://www.metrolexus.com/static/dealer-17081/videos/2311-Lexus-RX.gif',
        pricePerDay: 28000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '8-speed automatic',
        average: '10 L/100 km',
        mileage: 78000,
        condition: 9.0,
        rating: 4.7,
        totalTrips: 134,
        location: 'Rawalpindi',
      ),
      Car(
        name: 'Audi Q5',
        imageUrl: 'https://stimg.cardekho.com/images/carexteriorimages/930x620/Audi/Q5/10556/1757140951323/front-left-side-47.jpg',
        pricePerDay: 20000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '7-speed dual clutch automatic',
        average: '7.5 L/100 km',
        mileage: 65000,
        condition: 9.5,
        rating: 4.8,
        totalTrips: 167,
        location: 'Peshawar',
      ),
      Car(
        name: 'Mercedes-Benz GLC',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-172-edit-1631555006.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 32000,
        seats: 5,
        fuelType: 'Petrol/Diesel',
        transmission: '9-speed Automatic',
        average: '8.1 L/100 km (Petrol), 6.3 L/100 km (Diesel)',
        mileage: 99700,
        condition: 9.0,
        rating: 4.7,
        totalTrips: 118,
        location: 'Faisalabad',
      ),
    ];
  }

  // CONVERTIBLES (6 cars)
  static List<Car> getConvertibles() {
    return [
      Car(
        name: 'Mazda MX-5 Miata',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-117-6792b9e0a21da.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 72000,
        seats: 2,
        fuelType: 'Petrol',
        transmission: 'Manual',
        average: '12-14 km/L',
        mileage: 50000,
        condition: 9.8,
        rating: 4.9,
        totalTrips: 78,
        location: 'Islamabad',
      ),
      Car(
        name: 'Benz E Class Cabriolet',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-122-1.jpg',
        pricePerDay: 80000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '10-12 km/L',
        mileage: 65000,
        condition: 8.0,
        rating: 4.6,
        totalTrips: 92,
        location: 'Karachi',
      ),
      Car(
        name: 'Mercedes Benz C Class Cabriolet',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-104.jpg',
        pricePerDay: 95000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '11-14 km/L',
        mileage: 43000,
        condition: 8.0,
        rating: 4.7,
        totalTrips: 85,
        location: 'Lahore',
      ),
      Car(
        name: 'Mini Cooper S Convertible',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-0078-67f90a22c237d.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 750000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Manual',
        average: '12-15 km/L',
        mileage: 43000,
        condition: 9.0,
        rating: 4.8,
        totalTrips: 61,
        location: 'Rawalpindi',
      ),
      Car(
        name: 'BMW 2 Series Convertible',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-125-1.jpg',
        pricePerDay: 55000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '11-14 km/L',
        mileage: 77000,
        condition: 9.5,
        rating: 4.8,
        totalTrips: 104,
        location: 'Multan',
      ),
      Car(
        name: 'Volkswagen Beetle Convertible',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-122.jpg',
        pricePerDay: 34000,
        seats: 4,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        average: '11-14 km/L',
        mileage: 55000,
        condition: 10.0,
        rating: 4.9,
        totalTrips: 127,
        location: 'Peshawar',
      ),
    ];
  }

  // SUVs (6 cars)
  static List<Car> getSUVs() {
    return [
      Car(
        name: '2024 BMW X7',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i134-641c5d0a51baf.jpg?crop=1.00xw:0.752xh;0,0.248xh&resize=1800:*',
        pricePerDay: 250000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '8-speed automatic',
        average: '10.7 L/100 km',
        mileage: 50000,
        condition: 9.8,
        rating: 5.0,
        totalTrips: 89,
        location: 'Islamabad',
      ),
      Car(
        name: 'Toyota Land Cruiser 300',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-153-6616f44b314b3.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 68000,
        seats: 7,
        fuelType: 'Diesel',
        transmission: '10-speed automatic',
        average: '8.9 L/100 km',
        mileage: 75599,
        condition: 9.0,
        rating: 4.8,
        totalTrips: 156,
        location: 'Karachi',
      ),
      Car(
        name: '2024 Lexus GX 550',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-188-65f2fd266825d.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 80000,
        seats: 7,
        fuelType: 'Petrol',
        transmission: '10-speed automatic',
        average: '13.5 L/100 km',
        mileage: 55300,
        condition: 9.0,
        rating: 4.7,
        totalTrips: 112,
        location: 'Lahore',
      ),
      Car(
        name: 'Range Rover Sport',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-19-63fe16f5eecca.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 175000,
        seats: 5,
        fuelType: 'Petrol/PHEV',
        transmission: '8-speed automatic',
        average: '10-11 L/100 km (Petrol), 2-3 L/100 km (PHEV)',
        mileage: 100000,
        condition: 9.5,
        rating: 4.9,
        totalTrips: 98,
        location: 'Rawalpindi',
      ),
      Car(
        name: 'Mercedes-Benz GLE',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-exterior-101-677eca5187357.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 200000,
        seats: 7,
        fuelType: 'Petrol/Diesel',
        transmission: '9-speed automatic',
        average: '9.1-9.5 L/100 km (Petrol), 6.6 L/100 km (Diesel)',
        mileage: 65000,
        condition: 9.5,
        rating: 4.9,
        totalTrips: 124,
        location: 'Faisalabad',
      ),
      Car(
        name: 'Audi Q8',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-116-66b22cc8e490e.jpg?crop=1xw:1xh;center,top',
        pricePerDay: 150000,
        seats: 5,
        fuelType: 'Petrol',
        transmission: '8-speed Automatic',
        average: '11 L/100 km',
        mileage: 89000,
        condition: 9.0,
        rating: 4.8,
        totalTrips: 107,
        location: 'Multan',
      ),
    ];
  }

  // Helper method to get category by name - supports partial matching
  static List<Car> getCategoryByName(String categoryName) {
    String searchTerm = categoryName.toLowerCase().trim();

    // Direct exact matches first
    switch (searchTerm) {
      case 'luxury sedans':
      case 'luxury':
      case 'sedan':
      case 'sedans':
        return getLuxurySedans();
      case 'minivans':
      case 'minivan':
      case 'van':
      case 'vans':
        return getMinivans();
      case 'opulence cars':
      case 'opulence':
      case 'luxury cars':
        return getOpulenceCars();
      case 'hatchbacks':
      case 'hatchback':
      case 'hatch':
        return getHatchbacks();
      case 'electric cars':
      case 'electric':
      case 'ev':
      case 'electric vehicles':
        return getElectricCars();
      case 'crossovers':
      case 'crossover':
      case 'cross':
        return getCrossovers();
      case 'convertibles':
      case 'convertible':
      case 'convert':
        return getConvertibles();
      case 'suvs':
      case 'suv':
        return getSUVs();
    }

    // Partial matching - checks if category name contains search term
    if ('luxury sedans'.contains(searchTerm) || 'sedan'.contains(searchTerm)) {
      return getLuxurySedans();
    }
    if ('minivans'.contains(searchTerm) || 'van'.contains(searchTerm)) {
      return getMinivans();
    }
    if ('opulence cars'.contains(searchTerm) || 'opulence'.contains(searchTerm)) {
      return getOpulenceCars();
    }
    if ('hatchbacks'.contains(searchTerm) || 'hatch'.contains(searchTerm)) {
      return getHatchbacks();
    }
    if ('electric cars'.contains(searchTerm) || 'electric'.contains(searchTerm)) {
      return getElectricCars();
    }
    if ('crossovers'.contains(searchTerm) || 'crossover'.contains(searchTerm)) {
      return getCrossovers();
    }
    if ('convertibles'.contains(searchTerm) || 'convertible'.contains(searchTerm)) {
      return getConvertibles();
    }
    if ('suvs'.contains(searchTerm) || 'suv'.contains(searchTerm)) {
      return getSUVs();
    }

    return [];
  }

  // Search categories with fuzzy matching
  static String? findMatchingCategory(String searchQuery) {
    String query = searchQuery.toLowerCase().trim();

    // Map of search terms to official category names
    Map<String, String> categoryMap = {
      'luxury sedans': 'luxury sedans',
      'luxury': 'luxury sedans',
      'sedan': 'luxury sedans',
      'sedans': 'luxury sedans',
      'minivans': 'minivans',
      'minivan': 'minivans',
      'van': 'minivans',
      'vans': 'minivans',
      'opulence cars': 'opulence cars',
      'opulence': 'opulence cars',
      'luxury cars': 'opulence cars',
      'hatchbacks': 'hatchbacks',
      'hatchback': 'hatchbacks',
      'hatch': 'hatchbacks',
      'electric cars': 'electric cars',
      'electric': 'electric cars',
      'ev': 'electric cars',
      'electric vehicles': 'electric cars',
      'crossovers': 'crossovers',
      'crossover': 'crossovers',
      'cross': 'crossovers',
      'convertibles': 'convertibles',
      'convertible': 'convertibles',
      'convert': 'convertibles',
      'suvs': 'suvs',
      'suv': 'suvs',
    };

    // Check exact match first
    if (categoryMap.containsKey(query)) {
      return categoryMap[query];
    }

    // Check partial matches
    for (var entry in categoryMap.entries) {
      if (entry.key.contains(query) || query.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  // Get all category names
  static List<String> getAllCategoryNames() {
    return [
      'luxury sedans',
      'opulence cars',
      'suvs',
      'convertibles',
      'electric cars',
      'minivans',
      'hatchbacks',
      'crossovers',
    ];
  }
}