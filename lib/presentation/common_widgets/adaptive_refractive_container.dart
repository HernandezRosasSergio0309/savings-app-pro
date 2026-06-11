// ignore_for_file: unused_import

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:galaxy_savings/presentation/common_widgets/adaptive_background.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';

// VISUALIZADOR DE SHADER
class _ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final ui.Image backgroundCapture;
  final Size size;
  final double refractionStrength;

  _ShaderPainter({
    required this.shader,
    required this.backgroundCapture,
    required this.size,
    required this.refractionStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Pasamos el tamaño al shader
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    // Pasamos la fuerza
    shader.setFloat(2, refractionStrength);
    // Pasamos la imagen
    shader.setImageSampler(0, backgroundCapture);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _ShaderPainter oldDelegate) {
    // Repintar si la imagen capturada del fondo cambia o el tamaño cambia
    return oldDelegate.backgroundCapture != backgroundCapture ||
        oldDelegate.size != size ||
        oldDelegate.refractionStrength != refractionStrength;
  }
}

// WIDGET PRINCIPAL ADAPTATIVO
class AdaptiveRefractiveContainer extends StatefulWidget {
  final Widget child;
  final double refractionStrength;
  const AdaptiveRefractiveContainer({
    super.key,
    required this.child,
    this.refractionStrength = 0.3,
  });

  @override
  State<AdaptiveRefractiveContainer> createState() =>
      _AdaptiveRefractiveContainerState();
}

class _AdaptiveRefractiveContainerState
    extends State<AdaptiveRefractiveContainer> {
  ui.FragmentShader? _shader;
  ui.Image?
      _backgroundCapture; // Estado local para guardar la captura de la GPU
  final GlobalKey _boundaryKey =
      GlobalKey(); // Key para el RepaintBoundary de fondo
  bool _isShaderLoading = true;

  @override
  void initState() {
    super.initState();
    // Cargar el programa shader compilado de forma asíncrona
    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('assets/refraction.frag');
      if (mounted) {
        setState(() {
          _shader = program.fragmentShader();
          _isShaderLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando Refraction Shader: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // MAQUETACIÓN ESTRUCTURAL
    return Stack(
      children: [
        // CAPA DE FONDO
        Positioned.fill(
          child: RepaintBoundary(
            key: _boundaryKey, // Key para capturar ESTA sección
            child: const AdaptiveBackground(
              child: SizedBox.shrink(),
            ),
          ),
        ),

        // CAPA DE CRISTAL
        if (!context.isApple)
          Positioned.fill(
            child: Scaffold(
              backgroundColor:
                  AppColors.getBackgroundColor(Theme.of(context).brightness),
              body: Stack(children: [
                Positioned.fill(
                    child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: widget.child,
                ))
              ]),
            ),
          )
        else
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      size.width * 0.06),
              child: Column(
                children: [
                  SizedBox(
                      height:
                          size.height * 0.17),
                  // Contenedor de cristal
                  Expanded(
                    child: Builder(builder: (builderContext) {
                      // Usamos LayoutBuilder para obtener el tamaño final tras el espaciado
                      return LayoutBuilder(builder: (ctx, constraints) {
                        final containerSize = constraints.biggest;

                        // Solo renderizar el shader si se ha cargado y hemos capturado el fondo
                        final Widget shaderVisualizer =
                            (_backgroundCapture == null || _shader == null)
                                ? Container(
                                    color: isDark
                                        ? Colors.black26
                                        : Colors.white.withOpacity(0.26),
                                  ) // Carga placeholder
                                : CustomPaint(
                                    painter: _ShaderPainter(
                                      shader: _shader!,
                                      backgroundCapture: _backgroundCapture!,
                                      size: containerSize,
                                      refractionStrength:
                                          widget.refractionStrength,
                                    ),
                                  );

                        // CAPTURA DEL FONDO POST-RENDERIZADO
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _captureBackground(builderContext);
                        });

                        return Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardDark.withOpacity(0.05)
                                : AppColors.cardLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.12)
                                  : AppColors.cardLight.withOpacity(0.6),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                // El shader distorsionado
                                Positioned.fill(child: shaderVisualizer),
                                // Contenido frontal
                                Positioned.fill(child: widget.child),
                              ],
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                  SizedBox(
                      height:
                          size.height * 0.04),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Capturar la textura de fondo en tiempo real de la GPU
  Future<void> _captureBackground(BuildContext context) async {
    // Solo capturar si el shader está listo y estamos en iOS
    if (_isShaderLoading || !context.isApple) return;

    try {
      final RenderRepaintBoundary boundary = _boundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      final ui.Image? image = await boundary.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);

      if (image != null && mounted) {
        setState(() {
          _backgroundCapture = image;
        });
      }
    } catch (e) {
    }
  }
}
