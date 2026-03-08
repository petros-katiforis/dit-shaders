# Godot Shaders

## Absolute Basics

The shader is applied to individual
[fragments](https://en.wikipedia.org/wiki/Fragment_(computer_graphics)).
A fragment is nothing but a *potential* pixel, a candidate for the
current screen position. Uniforms are external tuning variables that
are provided straight from the editor (think of `@export`). The UV
coordinates are a normalized (0.0 to 1.0) floating point 2D range
representing the pixel's position within a texture. These normalized
coordinates are naturally stretched, so most shaders out there will
inevitably need some form of information regarding the *aspect ratio*
which is mathematically defined as `screen_width / screen_height`.

We must eliminate warp divergence. `step()` does so by being
implemented at the hardware level as a standalone 'GPU assembly'
instruction. `step()` is, essentially, an optimized version of
'subtract edge (1st parameter) from x (2nd parameter) and inspect the
sign bit'.

> Scale matters. Getting rid of the if-statement eliminates just *one*
> cycle. The shader, however, is executed for **millions** of fragments
> every single frame. The difference can be substantial.

### Affine Transformations

We'd like to support linear operations as well as transformations.
This can be done by designing an **affine transform**, typically
stored as a 4x4 matrix. Points and directions will be
represented in so-called homogeneous notation of four-element vectors
with an additional w component. The w components, coincidentally,
serves two purposes: It eliminates the fixed point `(0, 0)` and it
allows us to express translation (moving a shape around) in convenient
matrix form, as if it was a linear transformation.

Affine transformations preserve affine combinations (note: perhaps
more accurately, **convex** combinations), which include line segments
and convex polygons, the **building blocks** of our models.

> In geometry, a set of points is convex if it contains every line
> segment between two points in the set.

To perform an affine transformation on an affine combination, **internal
points of the affine combination need not be transformed**; it suffices
to transform the defining points. Thus, to perform an affine
transformation on a triangle, it is theoretically correct to transform
its three vertices, and it is not necessary to transform its
(infinite) interior points.
