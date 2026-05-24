import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'car_data_provider.dart';
import'car_rental_form_screen.dart';
import 'home_screen.dart';  // This imports FavoritesManager

/// CAR DETAILS SCREEN
/// Shows complete details of a selected car
class CarDetailsScreen extends StatefulWidget {
  final Car car;

  const CarDetailsScreen({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {

  int _currentImageIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _getCarImages().length > 1) {
        int nextIndex = (_currentImageIndex + 1) % _getCarImages().length;
        _changeImage(nextIndex);
      }
    });
  }

  void _changeImage(int index) {
    if (mounted) {
      setState(() {
        _currentImageIndex = index;
      });
    }
  }

  // Get multiple images for the car
  List<String> _getCarImages() {
    final carName = widget.car.name.toLowerCase();

    // ========== LUXURY SEDANS ==========

    // Audi A5
    if (carName.contains('audi a5')) {
      return [
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-12.jpg&w=3840&q=75',
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-1.jpg&w=3840&q=75',
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-2.jpg&w=3840&q=75',
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-3.jpg&w=3840&q=75',
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-4.jpg&w=3840&q=75',
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-5.jpg&w=3840&q=75',
        'https://audiapproved.com/_next/image?url=https%3A%2F%2Fadmin.audiapproved.com%2Fuploads%2Fcars%2F98962%2Fupload-7.jpg&w=3840&q=75',
      ];
    }

    // Toyota Crown
    else if (carName.contains('toyota crown')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-158-64c92955e93a7.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-137-64c92958226c1.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-543-64c9295c93f7b.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-501-64c92958d8769.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-573-64c9295ca74a0.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-toyota-crown-platinum-637-64c929610dd33.jpg?crop=1xw:1xh;center,top ',
      ];
    }

    // Hyundai Elantra
    else if (carName.contains('elantra')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-101-64ef85e1bb7aa.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-104-64ef85e1f1d07.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-107-64ef85e2d8e75.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-122-64ef85e52c2fa.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-123-64ef85e5499a2.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-elantra-limited-125-64ef85e610963.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Honda Civic hybrid
    else if (carName.contains('civic hybrid')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-106-66ba34ddaa207.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-104-66ba34ddb0716.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-102-66ba34dd808e1.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-111-66ba34e040e5e.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-107-66ba34e036181.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-civic-sport-touring-hybrid-113-66ba34e263067.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Toyota Camry
    else if (carName.contains('camry')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-115-1603151471.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-151-1603151486.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-254-1603151490.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-191-1603151488.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-106-1603151471.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-toyota-camry-hybrid-xle-132-1603151481.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Hyundai Sonata
    else if (carName.contains('sonata')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-111-66c64b89296bf.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-112-66c64b89a99f6.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-109-66c64b869dbe7.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-113-66c64b88e5565.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-117-66c64b8ac3154.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-hyundai-sonata-hybrid-121-66c64b8b93c9d.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // ========== MINIVANS ==========

    // Kia Grand Carnival
    else if (carName.contains('grand carnival')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-123-679407094c63f.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-102-679407081776f.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-125-6794070945b61.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-113-67940780071fe.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-122-67940707e55be.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-124-67940708b5216.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Hyundai Staria
    else if (carName.contains('staria')) {
      return [
        'https://car-images.bauersecure.com/wp-images/156694/1752x1168/hyundai_staria_101.jpg?mode=max&quality=90&scale=down',
        'https://car-images.bauersecure.com/wp-images/156694/1752x1168/hyundai_staria_102.jpg?mode=max&quality=90&scale=down',
        'https://car-images.bauersecure.com/wp-images/156694/1752x1168/hyundai_staria_105.jpg?mode=max&quality=90&scale=down',
        'https://car-images.bauersecure.com/wp-images/156694/1752x1168/hyundai_staria_103.jpg?mode=max&quality=90&scale=down',
        'https://imgcdn.oto.com/large/gallery/exterior/15/2419/hyundai-staria-wheel-987315.jpg',
        'https://car-images.bauersecure.com/wp-images/156694/1752x1168/hyundai_staria_106.jpg?mode=max&quality=90&scale=down',
      ];
    }

    // Toyota Hiace
    else if (carName.contains('hiace')) {
      return [
        'https://www.everycar.jp/blog/wp-content/uploads/1-61.jpg',
        'https://www.everycar.jp/blog/wp-content/uploads/2-44.jpg',
        'https://www.everycar.jp/blog/wp-content/uploads/4-7.jpg',
        'https://www.gari.pk/images/new/vehicles/2020-04/105_1_96971.jpg',
        'https://www.toyota-central.com/Assets/images/Vehicle/HiaceDeluxe/Exterior/Exterior7.jpg',
      ];
    }

    // Honda Odyssey
    else if (carName.contains('odyssey')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-104-675b5a737b202.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-139-675b5a3cb257f.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-124-675b5ba1ed257.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-126-675b5ba2b1e5d.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-140-675b5a3d54f0e.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-honda-odyssey-135-675b5a3512d7b.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Mercedes V-Class
    else if (carName.contains('v-class')) {
      return [
        'https://m.atcdn.co.uk/vms/media/w1300/a04bc72df5f54b4a8d7cfa8c0d36715c.jpg',
        'https://m.atcdn.co.uk/vms/media/w1300/41800646acb44e18a3a36a9725c0ff49.jpg',
        'https://m.atcdn.co.uk/vms/media/w1300/33c035ccaf9c4d518eee05800601f638.jpg',
        'https://m.atcdn.co.uk/vms/media/w1300/19635ed9e8014a13826e733ddd34186e.jpg',
        'https://m.atcdn.co.uk/vms/media/w1300/e78871b11a6041689bd1b42b2240514a.jpg',
        'https://m.atcdn.co.uk/vms/media/w1300/8c7d9900c1be46bdb2340f4af84c5efd.jpg',
      ];
    }

    // Suzuki APV
    else if (carName.contains('apv')) {
      return [
        'https://www.globalsuzuki.com/automobile/lineup/apv/img/slide/key_img08.jpg',
        'https://www.globalsuzuki.com/automobile/lineup/apv/img/slide/key_img06.jpg',
        'https://www.globalsuzuki.com/automobile/lineup/apv/img/slide/key_img04.jpg',
        'https://imgcdn.oto.com/large/gallery/interior/37/324/suzuki-apv-luxury-dashboard-view-444307.jpg',
        'https://imgcdn.oto.com/large/gallery/interior/37/324/suzuki-apv-luxury-rear-seats-625288.jpg',
        'https://www.globalsuzuki.com/automobile/lineup/apv/img/slide/key_img01.jpg',
      ];
    }

    // ========== OPULENCE CARS ==========

    // Rolls-Royce Wraith
    else if (carName.contains('wraith')) {
      return [
        'https://www.exclusiveautomotivegroup.com/imagetag/2158/3/l/Used-2016-Rolls-Royce-Wraith-1597250794.jpg',
        'https://www.exclusiveautomotivegroup.com/imagetag/2158/5/l/Used-2016-Rolls-Royce-Wraith-1597250794.jpg',
        'https://www.exclusiveautomotivegroup.com/imagetag/2158/9/l/Used-2016-Rolls-Royce-Wraith-1597250794.jpg',
        'https://www.exclusiveautomotivegroup.com/imagetag/2158/11/l/Used-2016-Rolls-Royce-Wraith-1597250794.jpg',
        'https://www.exclusiveautomotivegroup.com/imagetag/2158/15/l/Used-2016-Rolls-Royce-Wraith-1597250794.jpg',
        'https://www.exclusiveautomotivegroup.com/imagetag/2158/17/l/Used-2016-Rolls-Royce-Wraith-1597250526.jpg',
      ];
    }

    // Bentley Flying Spur
    else if (carName.contains('flying spur')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-608-hdr-1594131894.jpg?crop=0.737xw:0.553xh;0,0.430xh&resize=1800:*',
        'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-506-hdr-1594131887.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-333-1594131880.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-533-hdr-1594131889.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-683-hdr-1594131901.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-521-hdr-1594131889.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Mercedes S-Class
    else if (carName.contains('s-class')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-172-edit-1631555006.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-113-1631555010.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-166-1631555011.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-895-1631555026.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-123-1631555006.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-mercedes-benz-s580-203-1631555012.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Porsche Panamera
    else if (carName.contains('panamera')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-243-edit-1622681872.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-192-edit-1622681863.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-484-1622687756.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-217-1622681874.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-151-1622681855.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2021-porsche-panamera-gts-207-1622681864.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Maserati Quattroporte
    else if (carName.contains('quattroporte')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-104-1597067998.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-105-1597067993.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-102-1597067993.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-107-1597067997.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-110-1597067993.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/maserati-quattroporte-trofeo-109-1597067998.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Audi A8L
    else if (carName.contains('a8l')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/a218143-medium-1635867809.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/a218142-medium-1635867801.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/a218152-medium-1635867797.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/a218136-medium-1635867820.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/a218140-medium-1635867820.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/a218146-medium-1635867798.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // ========== HATCHBACKS ==========

    // Mercedes A-Class
    else if (carName.contains('a-class')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-108-1544471119.jpg?crop=0.879xw:0.808xh;0,0.169xh',
        'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-116-1544471120.jpg?crop=0.884xw:0.813xh;0.0969xw,0.187xh',
        'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-153-1544471120.jpg?crop=0.673xw:0.619xh;0.153xw,0.212xh',
        'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-288-1544471127.jpg?crop=1.00xw:0.918xh;0,0.0818xh',
        'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-276-1544471126.jpg?crop=1.00xw:0.918xh;0,0.0512xh',
        'https://hips.hearstapps.com/hmg-prod/images/2019-mercedes-benz-a220-4matic-266-1544471123.jpg?crop=1.00xw:0.752xh;0,0.248xh&resize=1800:*',
      ];
    }

    // Audi A5 Sportback
    else if (carName.contains('audi sportback')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2020-audi-a5-coupe-201-1567778049.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // BMW 4 Series
    else if (carName.contains('4 series')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-104-662804b591081.jpg?crop=1.00xw:0.881xh;0,0.119xh',
        'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-101-662804b860a0b.jpg?crop=1xw:0.84375xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-107-662804b5e3d98.jpg?crop=1xw:0.84375xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-110-662804b78bb40.jpg?crop=1.00xw:0.377xh;0,0.221xh',
        'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-103-662804b8aa41d.jpg?crop=1.00xw:0.847xh;0,0.0893xh',
        'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m440i-xdrive-105-662804b588ccf.jpg?crop=1.00xw:0.847xh;0,0.0536xh',
      ];
    }

    // Porsche 718 Cayman
    else if (carName.contains('718 cayman')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-4l-159-1648783305.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-4l-134-1648783301.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-gts-4l-ltup-395-1661266887.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-4l-200-1648783312.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-4l-140-1648783304.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-porsche-718-cayman-4l-178-1648783307.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Mercedes EQS
    else if (carName.contains('eqs')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-132-1657599527.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-133-1657599527.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-105-1657599514.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-111-1657599515.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-138-1657599530.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-mercedes-benz-eqs580-4matic-tested-139-1657599531.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Audi S7
    else if (carName.contains('s7')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s6-design-edition-103-1652282630.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s6-design-edition-104-1652282630.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s7-design-edition-101-1652282683.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s6-design-edition-108-1652282633.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s6-design-edition-105-1652282630.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-audi-s7-design-edition-104-1652282683.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // ========== ELECTRIC CARS ==========

    // BMW i4
    else if (carName.contains('i4')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-107-1659059089.jpg?crop=1.00xw:0.753xh;0,0.130xh&resize=1800:*',
        'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-106-1659059091.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-103-1659059092.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-110-1659059090.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-129-1659059108.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2022-bmw-i4-edrive40-130-1659059109.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // BYD Seal
    else if (carName.contains('byd seal')) {
      return [
        'https://byd-mega.com/_next/image?url=%2Fimages%2Fbyd-seal-main.webp&w=3840&q=75',
        'https://byd-mega.com/_next/image?url=%2Fimages%2Fbyd-seal-right.webp&w=2048&q=75',
        'https://byd-mega.com/_next/image?url=%2Fimages%2Fbyd-seal-interior-main.webp&w=3840&q=75',
        'https://byd-mega.com/_next/image?url=%2Fimages%2Fbyd-seal-left-new-2.webp&w=2048&q=75',
        'https://dealers.virtualyard.com.au/vydata/75df63609809c7a2052fdffe5c00a84e/2c229a16a91c75765f5b75c0997baf31/models/seal/showcase-feature-2.jpg?v=1',
        'https://dealers.virtualyard.com.au/vydata/75df63609809c7a2052fdffe5c00a84e/2c229a16a91c75765f5b75c0997baf31/models/seal/banner-1.jpg?v=1',
      ];
    }

    // Porsche Taycan
    else if (carName.contains('taycan')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-115-672385e70b435.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-123-672385e636975.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-121-672385e01099c.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-117-672385ddf067f.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-114-6723870a96aaa.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-porsche-taycan-120-672385dfb1748.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Audi e-tron
    else if (carName.contains('etron')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-1545086914.jpg?crop=0.904xw:0.830xh;0.0497xw,0.170xh&resize=2048:*',
        'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-uae-117-1544638268.jpg?crop=0.799xw:0.799xh;0.201xw,0.201xh',
        'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-uae-118-1544638268.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-uae-119-1544638270.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-uae-127-1544638272.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-uae-121-1544638270.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Kia EV6
    else if (carName.contains('ev6')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/10best-trucks-suvs-2023-kia-ev6-107-1673299609.jpg?crop=0.644xw:0.546xh;0.125xw,0.332xh&resize=1200:*',
        'https://hips.hearstapps.com/hmg-prod/images/2023-kia-ev6-gt-3187-1669991289.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-kia-ev6-gt-4054-1669991287.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-kia-ev6-gt-4601-1669991300.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-kia-ev6-gt-3111-1669991271.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-kia-ev6-gt-4095-1669991270.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Cadillac Lyriq
    else if (carName.contains('lyriq')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-103-6463cff2277d1.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-101-6463cff1d1d2f.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-113-6463cff7ce854.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-131-6463d0007a819.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-102-6463cff2bdc25.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-cadillac-lyriq-luxury-awd-105-6463cff22c294.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // ========== CROSSOVERS ==========

    // BMW X5
    else if (carName.contains('x5')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-102-6602d48787fb7.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-107-6602d48370bf5.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-131-6602d48fab030.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-111-6602d486b4798.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-123-6602d48c66cfa.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-125-6602d48d4d329.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Porsche Macan Turbo
    else if (carName.contains('macan turbo')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2020-porsche-macan-turbo-114-1583847369.jpg?crop=1xw:1xh;center,top',
        'https://images.unsplash.com/photo-1614200187524-dc4b892acf16?w=800',
        'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800',
      ];
    }

    // Range Rover Velar
    else if (carName.contains('velar')) {
      return [
        'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800',
        'https://images.unsplash.com/photo-1617788138017-80ad40651399?w=800',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
      ];
    }

    // Lexus RX 350
    else if (carName.contains('rx 350')) {
      return [
        'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800',
        'https://images.unsplash.com/photo-1617788138017-80ad40651399?w=800',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
      ];
    }

    // Audi Q5
    else if (carName.contains('q5')) {
      return [
        'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=800',
        'https://images.unsplash.com/photo-1614200187524-dc4b892acf16?w=800',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
      ];
    }

    // Mercedes GLC
    else if (carName.contains('glc')) {
      return [
        'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800',
        'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800',
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
      ];
    }

    // ========== CONVERTIBLES ==========

    // Mazda MX-5 Miata
    else if (carName.contains('mx-5') || carName.contains('miata')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-117-6792b9e0a21da.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-120-6792b9e156023.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-124-6792b9e7438dc.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-110-6792ba6956958.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-102-6792b9da23a58.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mazda-mx-5-miata-35th-anniversary-pr-122-6792b9e744736.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Mercedes E-Class Cabriolet
    else if (carName.contains('e class cabriolet')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-122-1.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-125-1.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-121-1.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-155-1.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-152-1.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2017/06/2018-Mercedes-Benz-E-Class-Cabriolet-153-1.jpg',
      ];
    }

    // Mercedes C-Class Cabriolet
    else if (carName.contains('c class cabriolet')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-104.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-102.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-106.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-120.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-112.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2018/02/2018-Mercedes-Benz-C-class-116.jpg',
      ];
    }

    // Mini Cooper Convertible
    else if (carName.contains('mini cooper')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-0078-67f90a22c237d.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-0068-67f90a1607980.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-0070-67f90a18b95f3.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-2706-67f90b826d0e4.jpg?crop=1.00xw:0.752xh;0,0.180xh&resize=1800:*',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-9787-67f90a2860b10.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-mini-cooper-s-convertible-9784-67f90a279b9da.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // BMW 2 Series Convertible
    else if (carName.contains('2 series convertible')) {
      return [
        'https://cdn.images.autoexposure.co.uk/AETA40085/AETV25270976_1.jpg',
        'https://cdn.images.autoexposure.co.uk/AETA40085/AETV25270976_2.jpg',
        'https://cdn.images.autoexposure.co.uk/AETA40085/AETV25270976_43.jpg',
        'https://cdn.images.autoexposure.co.uk/AETA40085/AETV25270976_25.jpg',
        'https://cdn.images.autoexposure.co.uk/AETA40085/AETV25270976_19.jpg',
        'https://cdn.images.autoexposure.co.uk/AETA40085/AETV25270976_34.jpg',
      ];
    }

    // VW Beetle Convertible
    else if (carName.contains('beetle convertible')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-122.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-123.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-120.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-130.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-125.jpg',
        'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-127.jpg',
      ];
    }

    // ========== SUVs ==========

    // BMW X7
    else if (carName.contains('x7')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i134-641c5d0a51baf.jpg?crop=1.00xw:0.752xh;0,0.248xh&resize=1800:*',
        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i154-641c5b46471f2.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i153-641c5b44dac2d.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i102-641c5b2d5329c.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i138-641c5b3f92083.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-bmw-x7-xdrive-40i139-641c5b3f6df3e.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Toyota Land Cruiser 300
    else if (carName.contains('land cruiser 300')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-153-6616f44b314b3.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-154-6616f44b3ad3a.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-159-6616f44dc7088.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-133-6616f43f7f474.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-163-6616f44fdacec.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-toyota-land-cruiser-157-6616f44bf2787.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Lexus GX 550
    else if (carName.contains('gx 550')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-188-65f2fd266825d.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-160-65f2fd2698562.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-534-65f2fd340e4a1.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-383-65f2fd302ba11.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-240-65f2fd20e8209.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-lexus-gx-550-premium-177-65f2fd2057bdc.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Range Rover Sport
    else if (carName.contains('range rover sport')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-19-63fe16f5eecca.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-18-63fe16fc11379.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-25-63fe16fb7a8cd.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-16-63fe16f342cde.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-9-63fe16f0cd97e.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2023-land-rover-range-rover-sport-se-p360-23-63fe16fa2371c.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Mercedes GLE
    else if (carName.contains('gle')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-exterior-101-677eca5187357.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-exterior-103-677eca533971c.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-exterior-118-677eca55bb797.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-interior-104-677eca9d9bd00.jpg?crop=1.00xw:0.753xh;0,0.0671xh&resize=1800:*',
        'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-exterior-105-677eca51ed1e2.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2024-mercedes-benz-gle450-exterior-108-677eca51674bf.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Audi Q8
    else if (carName.contains('q8')) {
      return [
        'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-116-66b22cc8e490e.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-117-66b22cc95516b.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-122-66b22ccb588f2.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-105-66b22cc4e5dd7.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-115-66b22cc877ae7.jpg?crop=1xw:1xh;center,top',
        'https://hips.hearstapps.com/hmg-prod/images/2025-audi-q8-120-66b22ccab4e44.jpg?crop=1xw:1xh;center,top',
      ];
    }

    // Default: Return the main image multiple times
    return [
      widget.car.imageUrl,
      widget.car.imageUrl,
      widget.car.imageUrl,
    ];
  }

  // Get unique features based on car name
  List<String> _getCarFeatures() {
    final carName = widget.car.name.toLowerCase();

    // LUXURY SEDANS
    if (carName.contains('audi a5')) {
      return ['Quattro AWD', 'Virtual Cockpit', 'LED Matrix Headlights', 'Bang & Olufsen Sound', 'Adaptive Cruise Control', 'Lane Assist', 'Wireless Charging', 'Parking Sensors'];
    } else if (carName.contains('toyota crown')) {
      return ['Hybrid Synergy Drive', 'Toyota Safety Sense', 'JBL Premium Audio', 'Panoramic Moonroof', 'Power Rear Sunshade', 'Heated Seats', 'Smart Key Entry', 'Auto Climate Control'];
    } else if (carName.contains('elantra')) {
      return ['SmartSense Safety', 'Wireless CarPlay', 'Android Auto', 'Blind Spot Monitor', 'Digital Cluster', 'Ventilated Seats', 'Sunroof', 'Auto Emergency Braking'];
    } else if (carName.contains('civic rs')) {
      return ['Honda Sensing', 'Turbo Engine', 'Sport Suspension', 'LED Headlights', 'Apple CarPlay', 'Lane Keep Assist', 'Adaptive Dampers', 'Sport Seats'];
    } else if (carName.contains('camry')) {
      return ['Toyota Safety Sense 2.5', 'Entune Infotainment', 'Wireless Charging', 'Dual-Zone Climate', 'Power Driver Seat', 'Premium Audio', 'Blind Spot Monitor', 'Rear Cross Traffic Alert'];
    } else if (carName.contains('sonata')) {
      return ['Highway Driving Assist', 'Digital Key', 'Bose Premium Audio', 'Panoramic Sunroof', 'Wireless CarPlay', 'Smart Trunk', 'LED Interior Lighting', 'Surround View Monitor'];
    }

    // MINIVANS
    else if (carName.contains('grand carnival')) {
      return ['11-Seater Configuration', 'VIP Captain Seats', 'Dual Power Doors', 'Tri-Zone Climate', 'Entertainment System', 'Luggage Rack', 'Privacy Glass', 'USB Ports All Rows'];
    } else if (carName.contains('staria')) {
      return ['Lounge Seating', 'Relaxation Seats', 'Digital Side Mirrors', 'Smart Posture Care', 'Premium Ambient Lighting', 'Wireless Charging', 'ADAS Safety Suite', 'UV Air Purifier'];
    } else if (carName.contains('hiace')) {
      return ['10-Seater Luxury', 'Reclining Seats', 'Dual AC', 'Power Windows', 'Central Locking', 'Audio System', 'Luggage Space', 'Safety Airbags'];
    } else if (carName.contains('odyssey')) {
      return ['Magic Slide Seats', 'CabinWatch Camera', 'CabinTalk System', 'Tri-Zone Climate', 'Entertainment System', 'Power Tailgate', 'HondaVac Cleaner', 'Acoustic Glass'];
    } else if (carName.contains('v-class')) {
      return ['Executive Lounge Seating', 'AIRMATIC Suspension', 'Burmester Sound', 'Ambient Lighting', 'Dual Sunroof', 'Rear Entertainment', 'Power Sliding Doors', 'Mercedes-Benz User Experience'];
    } else if (carName.contains('apv')) {
      return ['7-Seater Layout', 'Air Conditioning', 'Power Steering', 'Central Locking', 'CD Player', 'Rear Parking Sensors', 'Dual Airbags', 'Spacious Cabin'];
    }

    // OPULENCE CARS
    else if (carName.contains('wraith')) {
      return ['Starlight Headliner', 'Suicide Doors', 'Spirit of Ecstasy', 'Bespoke Audio', 'Lamb\'s Wool Carpets', 'Rear Theatre Config', 'Aerospace Aluminum', 'Satellite Aided Transmission'];
    } else if (carName.contains('flying spur')) {
      return ['Rotating Display', 'Naim Audio', 'Massage Seats', 'Bentley Dynamic Ride', 'Night Vision', 'Adaptive Cruise', 'Mood Lighting', 'Handcrafted Veneer'];
    } else if (carName.contains('s-class')) {
      return ['ENERGIZING Comfort', 'Burmester 4D Sound', 'Rear Airbags', 'Active Multicontour Seats', 'MBUX Hyperscreen', 'E-ACTIVE Body Control', 'Digital Light', 'Executive Rear Seats'];
    } else if (carName.contains('panamera')) {
      return ['Sport Chrono Package', 'Porsche Communication', 'Adaptive Air Suspension', 'Matrix LED Headlights', 'Bose Sound', 'Rear-Axle Steering', '4-Zone Climate', 'Sport Exhaust'];
    } else if (carName.contains('quattroporte')) {
      return ['Maserati Touch Control', 'Harman Kardon Sound', 'Pieno Fiore Leather', 'Skyhook Suspension', 'Dual-Screen Display', 'Heated/Ventilated Seats', 'Power Rear Sunshade', 'Sport Mode'];
    } else if (carName.contains('a8l')) {
      return ['Matrix LED Headlights', 'MMI Touch Response', 'Bang & Olufsen 3D', 'Massage Seats', 'Predictive Suspension', 'Rear Seat Remote', 'Ambient Lighting Plus', 'Night Vision'];
    }

    // HATCHBACKS
    else if (carName.contains('a-class')) {
      return ['MBUX Infotainment', 'LED High Performance', 'Mercedes me Connect', 'Active Brake Assist', 'Attention Assist', 'Keyless Start', 'Dual-Zone Climate', 'Smartphone Integration'];
    } else if (carName.contains('a5 sportback')) {
      return ['Virtual Cockpit Plus', 'Matrix LED Lights', 'S line Package', 'Progressive Steering', 'Sport Suspension', 'MMI Navigation', 'Audi Connect', 'Parking System Plus'];
    } else if (carName.contains('4 series')) {
      return ['M Sport Package', 'Live Cockpit Pro', 'Adaptive LED Lights', 'Harman Kardon Audio', 'Driving Assistant Pro', 'Head-Up Display', 'Wireless Charging', 'Sport Seats'];
    } else if (carName.contains('718 cayman')) {
      return ['Mid-Engine Layout', 'Porsche Torque Vectoring', 'Sport Chrono', 'PASM Suspension', 'Porsche Communication', 'Sport Exhaust', 'Alcantara Interior', 'Launch Control'];
    } else if (carName.contains('eqs')) {
      return ['MBUX Hyperscreen', '100% Electric', 'AIRMATIC Suspension', 'Burmester 4D Sound', 'Augmented Reality HUD', 'HEPA Filter', 'Massage Seats', 'EQ Optimized Navigation'];
    } else if (carName.contains('s7')) {
      return ['Mild Hybrid Tech', 'Virtual Cockpit Plus', 'Matrix LED Lights', 'Sport Differential', 'Adaptive Air Suspension', 'Bang & Olufsen 3D', 'Quattro AWD', 'Dynamic All-Wheel Steering'];
    }

    // ELECTRIC CARS
    else if (carName.contains('i4')) {
      return ['Electric Drivetrain', 'BMW Curved Display', 'eDrive Technology', 'One-Pedal Driving', 'Heat Pump', 'Fast Charging', 'Parking Assistant Plus', 'BMW Intelligent Personal Assistant'];
    } else if (carName.contains('byd seal')) {
      return ['Blade Battery', 'e-Platform 3.0', 'DiPilot Assist', 'Rotating Display', 'OTA Updates', 'Vehicle-to-Load', 'Panoramic Glass Roof', 'Eco Mode'];
    } else if (carName.contains('taycan')) {
      return ['800V Architecture', 'Two-Speed Transmission', 'Porsche Electric Sport Sound', '93.4 kWh Battery', 'Adaptive Air Suspension', 'Porsche Communication', 'Launch Control', 'Regenerative Braking'];
    } else if (carName.contains('etron')) {
      return ['Electric Quattro', 'Virtual Cockpit', 'Regenerative Braking', 'Heat Pump', 'Matrix LED Lights', 'MMI Navigation Plus', 'Wireless Charging', 'E-tron Charging Service'];
    } else if (carName.contains('ev6')) {
      return ['Ultra-Fast Charging', 'Augmented Reality HUD', 'Remote Smart Parking', 'Vehicle-to-Load', 'Heat Pump', 'Meridian Sound', 'Digital Key 2.0', 'OTA Updates'];
    } else if (carName.contains('lyriq')) {
      return ['Ultium Platform', 'Super Cruise', 'AKG Studio Audio', '33-inch LED Display', 'One-Pedal Driving', 'Ultra Cruise', 'Fixed Glass Roof', 'Hands-Free Driving'];
    }

    // CROSSOVERS
    else if (carName.contains('x5')) {
      return ['xDrive AWD', 'Live Cockpit Pro', 'Adaptive M Suspension', 'Panoramic Sky Lounge', 'Harman Kardon Sound', 'Parking Assistant Plus', 'Gesture Control', 'Wireless Charging'];
    } else if (carName.contains('macan turbo')) {
      return ['PDK Transmission', 'Porsche Traction Management', 'Sport Chrono', 'PASM Suspension', 'Adaptive Cruise', 'Lane Keep Assist', 'Bose Sound', 'Power Tailgate'];
    } else if (carName.contains('velar')) {
      return ['Touch Pro Duo', 'Meridian Sound', 'Terrain Response 2', 'Adaptive Dynamics', 'Matrix LED Headlights', 'ClearSight Mirror', 'Cabin Air Ionization', 'Wade Sensing'];
    } else if (carName.contains('rx 350')) {
      return ['Lexus Safety System+', 'Mark Levinson Audio', 'Panoramic View Monitor', 'Head-Up Display', 'Adaptive Variable Suspension', 'Triple-Beam LED', 'Touchpad Remote', 'Climate Concierge'];
    } else if (carName.contains('q5')) {
      return ['Quattro AWD', 'Virtual Cockpit Plus', 'MMI Navigation', 'Adaptive Air Suspension', 'Matrix LED Headlights', 'Bang & Olufsen Sound', 'Wireless Charging', 'Parking System Plus'];
    } else if (carName.contains('glc')) {
      return ['4MATIC AWD', 'MBUX Infotainment', 'Burmester Sound', 'AIRMATIC Suspension', 'Active Brake Assist', 'Blind Spot Assist', 'Panoramic Sunroof', 'Wireless Charging'];
    }

    // CONVERTIBLES
    else if (carName.contains('mx-5') || carName.contains('miata')) {
      return ['Soft-Top Convertible', 'SKYACTIV Technology', 'Bose Audio', 'Apple CarPlay', 'Blind Spot Monitor', 'Lane Departure Warning', 'Adaptive Front Lighting', 'Sport Mode'];
    } else if (carName.contains('e class cabriolet')) {
      return ['AIRCAP Wind Deflector', 'AIRSCARF Neck Warmer', 'Burmester Sound', 'MBUX Infotainment', 'Multicontour Seats', 'Adaptive Highbeam Assist', 'Acoustic Soft Top', 'Memory Package'];
    } else if (carName.contains('c class cabriolet')) {
      return ['Soft-Top Roof', 'AIRSCARF', 'Burmester Sound', 'MBUX System', 'LED Intelligent Light', 'Keyless Go', 'Memory Seats', 'Wind Deflector'];
    } else if (carName.contains('mini cooper')) {
      return ['Union Jack Taillights', 'John Cooper Works Trim', 'Harman Kardon Sound', 'Head-Up Display', 'Driving Modes', 'Connected Navigation', 'LED Lights', 'Sport Seats'];
    } else if (carName.contains('2 series convertible')) {
      return ['Power Soft-Top', 'M Sport Package', 'BMW Live Cockpit', 'Harman Kardon Audio', 'Adaptive LED Lights', 'Parking Assistant', 'Driving Assistant', 'Connected Services'];
    } else if (carName.contains('beetle convertible')) {
      return ['Power Soft-Top', 'Fender Premium Audio', 'App-Connect', 'Rear Camera', 'Heated Seats', 'Keyless Access', 'Climatronic AC', 'Multi-Function Steering'];
    }

    // SUVs
    else if (carName.contains('x7')) {
      return ['xDrive AWD', 'Sky Lounge Panoramic', 'Bowers & Wilkins Sound', 'Executive Drive Pro', 'Gesture Control', 'Crystal Lights', 'Rear Entertainment', 'Massaging Seats'];
    } else if (carName.contains('land cruiser 300')) {
      return ['Multi-Terrain Select', 'Crawl Control', 'Kinetic Dynamic Suspension', 'JBL Audio', 'Multi-Terrain Monitor', 'Downhill Assist', 'Center Diff Lock', 'Toyota Safety Sense'];
    } else if (carName.contains('gx 550')) {
      return ['Torsen LSD', 'Kinetic Dynamic Suspension', 'Mark Levinson Audio', 'Panoramic View Monitor', 'Multi-Terrain Select', 'Crawl Control', 'Triple-Beam LED', 'Lexus Safety System+'];
    } else if (carName.contains('range rover sport')) {
      return ['Terrain Response 2', 'Dynamic Air Suspension', 'Meridian Sound', 'ClearSight Mirror', 'Wade Sensing', 'Adaptive Dynamics', 'Matrix LED Lights', 'Pivi Pro Infotainment'];
    } else if (carName.contains('gle')) {
      return ['4MATIC AWD', 'MBUX Hyperscreen', 'Burmester 3D Sound', 'E-ACTIVE Body Control', 'AIRMATIC Suspension', 'Off-Road Package', 'Augmented Video', 'Energizing Comfort'];
    } else if (carName.contains('q8')) {
      return ['Quattro AWD', 'Dual Touchscreens', 'Bang & Olufsen 3D', 'Adaptive Air Suspension', 'Matrix LED Headlights', 'HD Matrix Design', 'Predictive Efficiency', 'Wireless Charging'];
    }

    // Default features
    return ['Air Conditioning', 'Bluetooth', 'GPS Navigation', 'Backup Camera', 'Power Windows', 'Keyless Entry', 'Airbags', 'ABS Brakes'];
  }

  // Get unique description based on car name
  String _getCarDescription() {
    final carName = widget.car.name.toLowerCase();

    // LUXURY SEDANS
    if (carName.contains('audi a5')) {
      return 'The ${widget.car.name} combines elegant design with Audi\'s renowned Quattro AWD technology. '
          'Experience the Virtual Cockpit digital display, premium Bang & Olufsen sound system, and Matrix LED headlights. '
          'Perfect for executives who demand both style and performance. Ideal for business trips, special occasions, and comfortable highway cruising.';
    } else if (carName.contains('toyota crown')) {
      return 'Experience Japanese luxury with the ${widget.car.name}. This premium sedan features Toyota\'s advanced Hybrid Synergy Drive '
          'for exceptional fuel efficiency paired with refined performance. The spacious cabin offers premium materials, JBL audio, and '
          'comprehensive safety features. Perfect for those seeking reliable luxury with eco-friendly technology.';
    } else if (carName.contains('elantra')) {
      return 'The ${widget.car.name} represents modern Korean engineering at its finest. Packed with Hyundai SmartSense safety technology, '
          'wireless smartphone integration, and a stunning digital cockpit. The ventilated seats and sunroof add premium comfort. '
          'Ideal for city commutes, business meetings, and weekend getaways with style and efficiency.';
    } else if (carName.contains('civic rs')) {
      return 'The ${widget.car.name} is a sporty sedan that delivers thrilling performance with Honda\'s turbocharged engine. '
          'Features Honda Sensing safety suite, sport-tuned suspension, and aggressive styling. Apple CarPlay and premium materials '
          'create a connected, comfortable experience. Perfect for driving enthusiasts who want daily practicality with weekend excitement.';
    } else if (carName.contains('camry')) {
      return 'The ${widget.car.name} is Toyota\'s legendary midsize sedan known for bulletproof reliability and comfort. '
          'Equipped with Toyota Safety Sense 2.5, premium audio, and refined interior materials. The smooth V6 or efficient hybrid '
          'powertrain offers versatile performance. Ideal for long-distance travel, family trips, and business use with peace of mind.';
    } else if (carName.contains('sonata')) {
      return 'The ${widget.car.name} showcases Hyundai\'s cutting-edge design and technology. Features Highway Driving Assist, '
          'digital key convenience, and Bose premium audio for audiophile-quality sound. The panoramic sunroof and spacious cabin '
          'create an airy, luxurious atmosphere. Perfect for tech-savvy drivers seeking modern luxury at competitive rates.';
    }

    // MINIVANS
    else if (carName.contains('grand carnival')) {
      return 'The ${widget.car.name} is the ultimate people mover with 11-seater configuration. VIP captain seats, dual power sliding doors, '
          'and tri-zone climate control ensure every passenger travels in comfort. Entertainment system keeps everyone engaged on long trips. '
          'Perfect for large families, group tours, airport transfers, and corporate events requiring spacious, comfortable transportation.';
    } else if (carName.contains('staria')) {
      return 'Experience the future of luxury MPVs with the ${widget.car.name}. Revolutionary lounge-style seating with relaxation mode, '
          'digital side mirrors, and UV air purification create a first-class cabin. Smart posture care and ambient lighting enhance wellness. '
          'Ideal for executive transport, VIP transfers, and families who refuse to compromise on comfort and innovation.';
    } else if (carName.contains('hiace')) {
      return 'The ${widget.car.name} is Toyota\'s trusted workhorse reimagined as a luxury transporter. With 10-seater capacity, '
          'reclining seats, dual AC, and spacious luggage area, it handles any journey with ease. Renowned Toyota reliability means '
          'worry-free operation. Perfect for wedding parties, pilgrimage groups, corporate shuttles, and extended family road trips.';
    } else if (carName.contains('odyssey')) {
      return 'The ${widget.car.name} revolutionizes family travel with Magic Slide seats, built-in HondaVac, and tri-zone climate control. '
          'CabinWatch and CabinTalk systems keep the family connected. Acoustic glass ensures a serene cabin. '
          'Ideal for modern families seeking versatility, practicality, and premium features in a stylish, tech-forward package.';
    } else if (carName.contains('v-class')) {
      return 'The ${widget.car.name} delivers Mercedes-Benz luxury in MPV form. Executive lounge seating, AIRMATIC suspension, '
          'and Burmester sound system rival S-Class comfort. Ambient lighting and dual sunroof create an opulent atmosphere. '
          'Perfect for VIP transport, luxury airport transfers, business delegations, and those who demand the finest in group travel.';
    } else if (carName.contains('apv')) {
      return 'The ${widget.car.name} offers affordable, practical 7-seater transportation. Features air conditioning, power steering, '
          'and spacious cabin make it ideal for budget-conscious families and small groups. Suzuki\'s fuel efficiency and reliability '
          'ensure low running costs. Perfect for daily errands, school runs, family outings, and economical group transportation.';
    }

    // OPULENCE CARS
    else if (carName.contains('wraith')) {
      return 'The ${widget.car.name} is Rolls-Royce\'s powerful GT with the iconic Starlight Headliner and suicide doors. '
          'Hand-crafted with lamb\'s wool carpets, bespoke audio, and aerospace aluminum body, every detail screams excellence. '
          'This is automotive art for grand entrances, luxury weddings, VIP events, and those who accept nothing less than perfection. '
          'Experience British luxury at its most dramatic and powerful.';
    } else if (carName.contains('flying spur')) {
      return 'The ${widget.car.name} represents Bentley\'s ultimate luxury sedan. Handcrafted veneer, rotating display, '
          'and Naim audio system create a cocoon of refinement. Bentley Dynamic Ride ensures both comfort and agility. '
          'Perfect for executives, special celebrations, and connoisseurs who appreciate British craftsmanship, understated elegance, '
          'and performance wrapped in timeless luxury.';
    } else if (carName.contains('s-class')) {
      return 'The ${widget.car.name} is the automotive benchmark for luxury and technology. MBUX Hyperscreen, Burmester 4D sound, '
          'and E-ACTIVE Body Control create an otherworldly experience. Executive rear seats rival first-class air travel. '
          'Ideal for CEOs, diplomatic transport, luxury events, and discerning clients expecting German engineering excellence '
          'combined with uncompromising comfort.';
    } else if (carName.contains('panamera')) {
      return 'The ${widget.car.name} fuses Porsche sports car DNA with executive sedan luxury. Sport Chrono package, '
          'adaptive air suspension, and rear-axle steering deliver thrilling dynamics. Premium materials and Bose audio ensure refinement. '
          'Perfect for driving enthusiasts who need practicality, executives who demand performance, and those seeking a uniquely '
          'sporty luxury experience.';
    } else if (carName.contains('quattroporte')) {
      return 'The ${widget.car.name} is Maserati\'s Italian masterpiece combining opera house elegance with racing pedigree. '
          'Pieno Fiore leather, Skyhook suspension, and Harman Kardon audio create sensory delight. The signature Maserati exhaust note '
          'announces your arrival. Perfect for style-conscious executives, romantic getaways, luxury events, and those who crave '
          'Italian passion in automotive form.';
    } else if (carName.contains('a8l')) {
      return 'The ${widget.car.name} showcases Audi\'s technological prowess with predictive suspension, Matrix LED lights, '
          'and Bang & Olufsen 3D audio. The extended wheelbase provides limousine-like rear legroom with massage seats. '
          'Perfect for business leaders, tech enthusiasts, and those seeking German precision engineering combined with forward-thinking '
          'technology and refined luxury.';
    }

    // HATCHBACKS
    else if (carName.contains('a-class')) {
      return 'The ${widget.car.name} brings Mercedes luxury to a compact, agile package. MBUX infotainment with "Hey Mercedes" voice control, '
          'LED High Performance lights, and premium interior materials defy its size. Mercedes me Connect keeps you connected. '
          'Perfect for urban professionals, young executives, and those seeking premium German engineering in a nimble city car.';
    } else if (carName.contains('a5 sportback')) {
      return 'The ${widget.car.name} combines coupe elegance with practical five-door versatility. Virtual Cockpit Plus, '
          'Matrix LED headlights, and S line package deliver Audi\'s signature sophistication. Progressive steering enhances agility. '
          'Ideal for style-conscious drivers wanting sports car looks with everyday practicality, premium commuting, and weekend adventures.';
    } else if (carName.contains('4 series')) {
      return 'The ${widget.car.name} is BMW\'s athletic gran coupe blending performance with luxury. M Sport package, '
          'Live Cockpit Pro, and Harman Kardon audio create a driver-focused cockpit. Adaptive LED lights and sporty dynamics thrill. '
          'Perfect for driving enthusiasts seeking practical luxury, corporate professionals wanting style, and those who love spirited drives.';
    } else if (carName.contains('718 cayman')) {
      return 'The ${widget.car.name} is Porsche\'s mid-engine sports car masterpiece. Perfectly balanced chassis, Sport Chrono package, '
          'and PASM suspension deliver pure driving bliss. The iconic Porsche design and alcantara interior scream performance. '
          'Ideal for track days, spirited weekend drives, special occasions, and automotive purists seeking the ultimate sports car experience.';
    } else if (carName.contains('eqs')) {
      return 'The ${widget.car.name} represents Mercedes-Benz\'s electric luxury future. The massive MBUX Hyperscreen, '
          '100% electric drivetrain, and AIRMATIC suspension create a silent, smooth sanctuary. Burmester 4D sound and augmented reality HUD '
          'dazzle. Perfect for eco-conscious luxury buyers, tech enthusiasts, and those embracing zero-emission executive transportation.';
    } else if (carName.contains('s7')) {
      return 'The ${widget.car.name} is Audi\'s performance luxury sportback with mild hybrid technology. Sport differential, '
          'adaptive air suspension, and Quattro AWD deliver exhilarating dynamics. Bang & Olufsen 3D audio and Virtual Cockpit Plus '
          'create a high-tech cabin. Perfect for executives wanting performance, families needing space, and enthusiasts craving style.';
    }

    // ELECTRIC CARS
    else if (carName.contains('i4')) {
      return 'The ${widget.car.name} is BMW\'s electric gran coupe merging performance with sustainability. eDrive technology, '
          'BMW Curved Display, and one-pedal driving create an engaging experience. Heat pump ensures efficiency. Fast charging minimizes downtime. '
          'Perfect for eco-conscious drivers, tech enthusiasts, and those seeking BMW driving dynamics without emissions.';
    } else if (carName.contains('byd seal')) {
      return 'The ${widget.car.name} showcases Chinese innovation with BYD\'s revolutionary Blade Battery and e-Platform 3.0. '
          'Rotating display, DiPilot assist, and OTA updates keep it cutting-edge. Vehicle-to-Load powers your devices. '
          'Ideal for early adopters, budget-conscious EV buyers, and those wanting advanced electric technology at accessible prices.';
    } else if (carName.contains('taycan')) {
      return 'The ${widget.car.name} is Porsche\'s electric sports sedan with 800V architecture enabling ultra-fast charging. '
          'Two-speed transmission and launch control deliver supercar acceleration. Adaptive air suspension balances comfort and sport. '
          'Perfect for performance enthusiasts going electric, tech lovers, and those refusing to compromise driving excitement for sustainability.';
    } else if (carName.contains('etron')) {
      return 'The ${widget.car.name} is Audi\'s sophisticated electric SUV with electric Quattro AWD. Virtual Cockpit, '
          'regenerative braking, and Matrix LED lights showcase German engineering excellence. Heat pump maximizes range. '
          'Ideal for families wanting premium electric mobility, luxury SUV buyers going green, and Audi enthusiasts embracing the future.';
    } else if (carName.contains('ev6')) {
      return 'The ${widget.car.name} is Kia\'s game-changing electric crossover with ultra-fast charging reaching 80% in 18 minutes. '
          'Augmented reality HUD, vehicle-to-load, and remote smart parking wow tech enthusiasts. Digital Key 2.0 enables phone-as-key. '
          'Perfect for modern families, tech-savvy buyers, and those wanting cutting-edge EV technology at competitive pricing.';
    } else if (carName.contains('lyriq')) {
      return 'The ${widget.car.name} showcases Cadillac\'s electric luxury future with the Ultium platform. 33-inch LED display, '
          'AKG Studio audio, and Super Cruise hands-free driving create a premium experience. One-pedal driving simplifies city navigation. '
          'Perfect for American luxury enthusiasts, tech lovers, and those seeking distinctive electric sophistication with Cadillac heritage.';
    }

    // CROSSOVERS
    else if (carName.contains('x5')) {
      return 'The ${widget.car.name} is BMW\'s luxury SUV combining xDrive AWD with sophisticated comfort. Panoramic Sky Lounge, '
          'Harman Kardon sound, and adaptive M suspension deliver premium experiences. Gesture control and wireless charging add convenience. '
          'Perfect for active families, executives needing versatility, and those wanting BMW driving dynamics in SUV form with space.';
    } else if (carName.contains('macan turbo')) {
      return 'The ${widget.car.name} is Porsche\'s compact performance SUV that drives like a sports car. PDK transmission, '
          'Porsche Traction Management, and PASM suspension deliver thrilling handling. Sport Chrono ensures track-ready performance. '
          'Ideal for driving enthusiasts needing practicality, families wanting excitement, and those refusing to sacrifice performance.';
    } else if (carName.contains('velar')) {
      return 'The ${widget.car.name} showcases Range Rover\'s design-forward luxury crossover. Touch Pro Duo displays, '
          'Meridian audio, and Terrain Response 2 blend technology with capability. ClearSight mirror and adaptive dynamics enhance versatility. '
          'Perfect for style-conscious adventurers, design enthusiasts, and those wanting British luxury with genuine off-road ability.';
    } else if (carName.contains('rx 350')) {
      return 'The ${widget.car.name} is Lexus\'s refined luxury crossover prioritizing comfort and reliability. Mark Levinson audio, '
          'panoramic view monitor, and adaptive suspension create a serene cabin. Triple-beam LED lights and climate concierge add luxury. '
          'Ideal for families valuing reliability, executives seeking comfort, and those wanting Japanese quality with premium amenities.';
    } else if (carName.contains('q5')) {
      return 'The ${widget.car.name} is Audi\'s versatile luxury crossover with Quattro AWD for all-weather confidence. '
          'Virtual Cockpit Plus, adaptive air suspension, and Bang & Olufsen sound create premium comfort. Matrix LED headlights '
          'illuminate the path ahead. Perfect for families needing space, professionals wanting refinement, and adventurers seeking '
          'Audi quality with practical versatility for urban and outdoor lifestyles.';
    } else if (carName.contains('glc')) {
      return 'The ${widget.car.name} represents Mercedes-Benz luxury in compact SUV form. 4MATIC AWD, MBUX infotainment, '
          'and Burmester audio create a premium cabin. AIRMATIC suspension balances comfort and control. Panoramic sunroof adds airiness. '
          'Ideal for urban professionals, small families, and those wanting Mercedes prestige with manageable size and premium features.';
    }

    // CONVERTIBLES
    else if (carName.contains('mx-5') || carName.contains('miata')) {
      return 'The ${widget.car.name} is the world\'s best-selling roadster offering pure driving joy. Lightweight SKYACTIV technology, '
          'perfectly balanced chassis, and responsive steering create an engaging experience. Soft-top operation is effortless. Bose audio '
          'enhances top-down cruising. Perfect for driving purists, weekend enthusiasts, coastal drives, and those seeking affordable '
          'sports car thrills with legendary Mazda reliability.';
    } else if (carName.contains('e class cabriolet')) {
      return 'The ${widget.car.name} delivers open-air luxury with AIRCAP wind deflector and AIRSCARF neck warmer extending '
          'the top-down season. Burmester sound, multicontour seats, and acoustic soft top create refined comfort. MBUX keeps you connected. '
          'Perfect for luxury touring, special occasions, romantic getaways, and those wanting Mercedes elegance with wind-in-hair freedom.';
    } else if (carName.contains('c class cabriolet')) {
      return 'The ${widget.car.name} combines sporty dynamics with open-top luxury. Soft-top roof operates while driving, '
          'AIRSCARF neck heating extends usability, and Burmester audio delivers concert-quality sound. LED Intelligent Light ensures safety. '
          'Ideal for style-conscious drivers, weekend cruises, coastal escapes, and those seeking Mercedes prestige in a compact convertible.';
    } else if (carName.contains('mini cooper')) {
      return 'The ${widget.car.name} is the ultimate fun convertible with iconic Union Jack taillights and John Cooper Works trim. '
          'Harman Kardon audio, head-up display, and driving modes enhance the experience. Connected navigation keeps you on track. '
          'Perfect for city adventures, beach runs, style enthusiasts, and those wanting British character with go-kart handling and charm.';
    } else if (carName.contains('2 series convertible')) {
      return 'The ${widget.car.name} delivers BMW\'s signature driving dynamics with open-air freedom. Power soft-top, '
          'M Sport package, and Harman Kardon audio create an engaging experience. Live Cockpit and adaptive LED lights add modernity. '
          'Ideal for driving enthusiasts, weekend escapes, coastal drives, and those wanting BMW performance with convertible versatility.';
    } else if (carName.contains('beetle convertible')) {
      return 'The ${widget.car.name} is an iconic design statement offering retro charm with modern features. Power soft-top, '
          'Fender Premium audio, and App-Connect blend nostalgia with technology. Heated seats and keyless access add convenience. '
          'Perfect for style lovers, nostalgic drivers, city cruising, and those wanting a unique, cheerful convertible with character.';
    }

    // SUVs
    else if (carName.contains('x7')) {
      return 'The ${widget.car.name} is BMW\'s flagship luxury SUV with xDrive AWD and Sky Lounge panoramic roof. '
          'Bowers & Wilkins sound, Executive Drive Pro, and massaging seats rival luxury sedans. Crystal lights and gesture control '
          'add sophistication. Perfect for large families, executives needing space, and those demanding BMW driving dynamics with '
          'three-row luxury and commanding presence.';
    } else if (carName.contains('land cruiser 300')) {
      return 'The ${widget.car.name} is Toyota\'s legendary off-road icon reimagined. Multi-terrain select, kinetic dynamic suspension, '
          'and crawl control conquer any terrain. 7-seater capacity and JBL audio add comfort. Center diff lock ensures capability. '
          'Perfect for adventurers, off-road enthusiasts, large families, and those demanding bulletproof reliability with luxury and '
          'unstoppable capability.';
    } else if (carName.contains('gx 550')) {
      return 'The ${widget.car.name} combines Lexus luxury with serious off-road capability. Torsen LSD, kinetic dynamic suspension, '
          'and multi-terrain select handle tough trails. Mark Levinson audio and panoramic monitor add refinement. Triple-beam LED lights '
          'illuminate adventures. Ideal for luxury adventurers, families wanting versatility, and those seeking Japanese quality with '
          'genuine trail-rated capability.';
    } else if (carName.contains('range rover sport')) {
      return 'The ${widget.car.name} is Land Rover\'s performance luxury SUV blending on-road dynamics with off-road prowess. '
          'Terrain Response 2, dynamic air suspension, and Meridian sound create versatile luxury. Wade sensing enables water crossings. '
          'Perfect for active lifestyles, luxury adventurers, and those wanting British refinement with genuine capability and '
          'commanding road presence.';
    } else if (carName.contains('gle')) {
      return 'The ${widget.car.name} showcases Mercedes-Benz innovation with 4MATIC AWD and optional MBUX Hyperscreen. '
          'Burmester 3D sound, E-ACTIVE Body Control, and AIRMATIC suspension deliver exceptional comfort. Off-Road package adds capability. '
          'Ideal for families needing space, executives wanting luxury, and those seeking Mercedes technology with 7-seater practicality.';
    } else if (carName.contains('q8')) {
      return 'The ${widget.car.name} is Audi\'s flagship SUV combining coupe styling with Quattro capability. Dual touchscreens, '
          'Bang & Olufsen 3D audio, and adaptive air suspension create a premium cockpit. Matrix LED headlights with HD design dazzle. '
          'Perfect for executives wanting presence, tech enthusiasts, and those seeking Audi sophistication in a bold, stylish SUV package.';
    }

    // Default description
    return 'Experience the ultimate driving pleasure with the ${widget.car.name}. '
        'This well-maintained vehicle offers excellent performance, comfort, '
        'and reliability. Perfect for both city drives and long road trips. '
        'Book now and enjoy a smooth, hassle-free rental experience.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App Bar with Full Image
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      FavoritesManager().isFavorite(widget.car) ? Icons.favorite : Icons.favorite_border,
                      color: FavoritesManager().isFavorite(widget.car) ? Colors.red : Colors.black,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        FavoritesManager().toggleFavorite(widget.car);
                      });
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [

              // Image with Fade Transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: CachedNetworkImage(  // ✅ NEW
                  key: ValueKey<int>(_currentImageIndex),
                  imageUrl: _getCarImages()[_currentImageIndex],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,

                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0066FF),
                        strokeWidth: 3,
                      ),
                    ),
                  ),

                  errorWidget: (context, url, error) {
                    print('Failed to load image: $url');
                    return Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.directions_car, size: 80, color: Colors.grey),
                    );
                  },

                  memCacheWidth: 1200,
                  memCacheHeight: 900,
                ),
              ),
                  // Manual Navigation Arrows
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 100,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _changeImage(_currentImageIndex > 0
                                ? _currentImageIndex - 1
                                : _getCarImages().length - 1);
                          },
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 100,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _changeImage(_currentImageIndex < _getCarImages().length - 1
                                ? _currentImageIndex + 1
                                : 0);
                          },
                        ),
                      ),
                    ),
                  ),

                  // Circle Indicators at Bottom
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _getCarImages().length,
                            (index) => GestureDetector(
                          onTap: () {
                            _changeImage(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Car Details Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Name and Price Section
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.car.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            widget.car.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.car.rating}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ' (${widget.car.totalTrips} trips)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rs ${widget.car.pricePerDay.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF010745),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '/day',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Specifications Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12), // Add margin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSpecRow(
                        icon: Icons.event_seat,
                        label: 'Seats',
                        value: '${widget.car.seats} Persons',
                      ),
                      _buildDivider(),
                      _buildSpecRow(
                        icon: Icons.local_gas_station,
                        label: 'Fuel Type',
                        value: widget.car.fuelType,
                      ),
                      _buildDivider(),
                      _buildSpecRow(
                        icon: Icons.settings,
                        label: 'Transmission',
                        value: widget.car.transmission,
                      ),
                      _buildDivider(),
                      _buildSpecRow(
                        icon: Icons.speed,
                        label: 'Mileage',
                        value: '${(widget.car.mileage / 1000).toStringAsFixed(1)}k km',
                      ),
                      _buildDivider(),
                      _buildSpecRow(
                        icon: Icons.water_drop,
                        label: 'Fuel Average',
                        value: widget.car.average,
                      ),
                      _buildDivider(),
                      _buildSpecRow(
                        icon: Icons.verified,
                        label: 'Condition',
                        value: '${widget.car.condition.toStringAsFixed(1)}/10',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Features Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12), // Add margin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Features',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 23,
                        runSpacing: 10,
                        children: _getCarFeatures().map((feature) => _buildFeatureChip(feature)).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Description Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12), // Add margin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getCarDescription(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Rental Terms Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12), // Add margin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rental Terms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTermItem('Minimum rental period: 1 day'),
                      _buildTermItem('Valid driving license required'),
                      _buildTermItem('Security deposit applicable'),
                      _buildTermItem('Fuel policy: Full to Full'),
                      _buildTermItem('Cancellation allowed up to 24 hours'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),

      // Bottom Book Now Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rs ${widget.car.pricePerDay.toStringAsFixed(0)}/day',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarRentalFormScreen(
                          carName: widget.car.name,
                          carImage: widget.car.imageUrl,
                          carPrice: 'Rs ${widget.car.pricePerDay.toStringAsFixed(0)}/day',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'RENT NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF010745).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF010745),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      height: 1,
      thickness: 1,
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green[600],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF010745),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}