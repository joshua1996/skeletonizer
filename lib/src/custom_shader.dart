import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
class ShaderMaskX extends SingleChildRenderObjectWidget {
  /// Creates a widget that applies a mask generated by a [Shader] to its child.
  ///
  /// The [shaderCallback] and [blendMode] arguments must not be null.
  const ShaderMaskX({
    super.key,
    required this.shaderCallback,
    this.blendMode = BlendMode.modulate,
    super.child,
  });

  /// Called to create the [dart:ui.Shader] that generates the mask.
  ///
  /// The shader callback is called with the current size of the child so that
  /// it can customize the shader to the size and location of the child.
  ///
  /// Typically this will use a [LinearGradient], [RadialGradient], or
  /// [SweepGradient] to create the [dart:ui.Shader], though the
  /// [dart:ui.ImageShader] class could also be used.
  final ShaderCallback shaderCallback;

  /// The [BlendMode] to use when applying the shader to the child.
  ///
  /// The default, [BlendMode.modulate], is useful for applying an alpha blend
  /// to the child. Other blend modes can be used to create other effects.
  final BlendMode blendMode;

  @override
  RenderShaderMaskX createRenderObject(BuildContext context) {
    return RenderShaderMaskX(
      shaderCallback: shaderCallback,
      blendMode: blendMode,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderShaderMaskX renderObject) {
    renderObject
      ..shaderCallback = shaderCallback
      ..blendMode = blendMode;
  }
}

class RenderShaderMaskX extends RenderProxyBox {
  /// Creates a render object that applies a mask generated by a [Shader] to its child.
  ///
  /// The [shaderCallback] and [blendMode] arguments must not be null.
  RenderShaderMaskX({
    RenderBox? child,
    required ShaderCallback shaderCallback,
    BlendMode blendMode = BlendMode.modulate,
  })  : assert(shaderCallback != null),
        assert(blendMode != null),
        _shaderCallback = shaderCallback,
        _blendMode = blendMode,
        super(child);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  /// Called to creates the [Shader] that generates the mask.
  ///
  /// The shader callback is called with the current size of the child so that
  /// it can customize the shader to the size and location of the child.
  ///
  /// The rectangle will always be at the origin when called by
  /// [RenderShaderMask].
  // TODO(abarth): Use the delegate pattern here to avoid generating spurious
  // repaints when the ShaderCallback changes identity.
  ShaderCallback get shaderCallback => _shaderCallback;
  ShaderCallback _shaderCallback;

  set shaderCallback(ShaderCallback value) {
    assert(value != null);
    if (_shaderCallback == value) {
      return;
    }
    _shaderCallback = value;
    markNeedsPaint();
  }

  /// The [BlendMode] to use when applying the shader to the child.
  ///
  /// The default, [BlendMode.modulate], is useful for applying an alpha blend
  /// to the child. Other blend modes can be used to create other effects.
  BlendMode get blendMode => _blendMode;
  BlendMode _blendMode;

  set blendMode(BlendMode value) {
    assert(value != null);
    if (_blendMode == value) {
      return;
    }
    _blendMode = value;
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);
      layer ??= ShaderMaskLayerX();
      layer!
        ..shader = _shaderCallback(Offset.zero & size)
        ..maskRect = offset & size
        ..blendMode = _blendMode;
      context.pushLayer(layer!, super.paint, offset);
      assert(() {
        layer!.debugCreator = debugCreator;
        return true;
      }());
    } else {
      layer = null;
    }
  }
}

class ShaderMaskLayerX extends ShaderMaskLayer{

 @override
  void addChildrenToScene(ui.SceneBuilder builder) {
    print(builder.hashCode);
    super.addChildrenToScene(builder);
  }

}