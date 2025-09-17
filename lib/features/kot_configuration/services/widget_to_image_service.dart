import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import '../../../core/utils/logger.dart';

/// Service for converting Flutter widgets to images for printing
class WidgetToImageService {
  static final _logger = Logger('WidgetToImageService');

  /// Captures a widget and converts it to image bytes suitable for printing
  /// 
  /// [widget] The widget to capture
  /// [width] Fixed width for the capture (default 576 for 80mm printer)
  /// [pixelRatio] Quality multiplier (higher = better quality but slower)
  static Future<Uint8List> captureWidget(
    Widget widget, {
    double width = 576,
    double pixelRatio = 2.0,
  }) async {
    try {
      _logger.info('Starting widget capture with width: $width, pixelRatio: $pixelRatio');
      
      // Capture the widget as PNG bytes
      final imageBytes = await _captureWidgetToImage(
        widget,
        width: width,
        pixelRatio: pixelRatio,
      );
      
      _logger.info('Widget captured successfully, size: ${imageBytes.length} bytes');
      return imageBytes;
    } catch (e, stackTrace) {
      _logger.error('Failed to capture widget', e, stackTrace);
      rethrow;
    }
  }

  /// Internal method to capture widget to image bytes
  static Future<Uint8List> _captureWidgetToImage(
    Widget widget, {
    required double width,
    required double pixelRatio,
  }) async {
    try {
      // Create a RenderRepaintBoundary to capture the widget
      final RenderRepaintBoundary boundary = RenderRepaintBoundary();

      // Wrap widget with necessary directionality and container
      final Container constrainedWidget = Container(
        width: width,
        color: Colors.white, // Ensure white background
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: widget,
        ),
      );

      // Create render view with proper configuration
      final RenderView renderView = RenderView(
        view: WidgetsBinding.instance.platformDispatcher.views.first,
        child: RenderPositionedBox(
          alignment: Alignment.topCenter,
          child: boundary,
        ),
        configuration: ViewConfiguration(
          physicalConstraints: BoxConstraints.tightFor(width: width * pixelRatio),
          logicalConstraints: BoxConstraints.tightFor(width: width),
          devicePixelRatio: pixelRatio,
        ),
      );

      // Set up the pipeline and build owners
      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();

      // Create adapter and attach to render tree
      final RenderObjectToWidgetAdapter<RenderBox> adapter =
          RenderObjectToWidgetAdapter<RenderBox>(
        container: boundary,
        child: constrainedWidget,
      );

      final RenderObjectToWidgetElement<RenderBox> rootElement =
          adapter.attachToRenderTree(buildOwner);

      // Build and layout the widget
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();

      // Flush the layout pipeline to compute actual height
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      // Get the calculated size after layout
      final Size size = boundary.size;
      final double height = size.height;

      _logger.debug('Widget size calculated: ${width}x$height');

      // Update configuration with calculated height
      renderView.configuration = ViewConfiguration(
        physicalConstraints: BoxConstraints.tight(Size(width, height) * pixelRatio),
        logicalConstraints: BoxConstraints.tight(Size(width, height)),
        devicePixelRatio: pixelRatio,
      );

      // Flush again with proper size
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      // Capture the widget as an image
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert widget to image bytes');
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      _logger.error('Error in widget capture process', e);
      throw Exception('Failed to capture widget to image: $e');
    }
  }

  /// Converts image bytes to ESC/POS compatible format
  /// 
  /// [imageBytes] PNG image bytes
  /// [printerWidth] Target printer width in pixels (default 576 for 80mm)
  static Future<img.Image> prepareImageForPrinter(
    Uint8List imageBytes, {
    int printerWidth = 576,
  }) async {
    try {
      _logger.info('Preparing image for printer, target width: $printerWidth');
      
      // Decode the PNG image
      final img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }

      _logger.debug('Original image size: ${decodedImage.width}x${decodedImage.height}');

      // Resize if needed
      final img.Image resizedImage = decodedImage.width != printerWidth
          ? img.copyResize(decodedImage, width: printerWidth)
          : decodedImage;

      _logger.debug('Resized image size: ${resizedImage.width}x${resizedImage.height}');

      // Convert to grayscale for better printing
      final img.Image grayscaleImage = img.grayscale(resizedImage);

      // Apply dithering for better thermal printer output
      // This converts the image to black and white with dithering
      for (int y = 0; y < grayscaleImage.height; y++) {
        for (int x = 0; x < grayscaleImage.width; x++) {
          final pixel = grayscaleImage.getPixel(x, y);
          final luminance = img.getLuminance(pixel);

          // Simple threshold (can be adjusted)
          final newValue = luminance > 128 ? 255 : 0;
          // In image >=4.x, use setPixelRgba instead of getColor
          grayscaleImage.setPixelRgba(x, y, newValue, newValue, newValue, 255);
        }
      }

      _logger.info('Image prepared successfully for printing');
      return grayscaleImage;
    } catch (e) {
      _logger.error('Failed to prepare image for printer', e);
      throw Exception('Failed to prepare image for printer: $e');
    }
  }
}
