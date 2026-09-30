/// Auth feature route segments and names. Keeps navigation constants inside the feature.
enum ProductRoute {
  product,
  productDetail,
  addProduct,
  editProduct;

  String get path => switch (this) {
    ProductRoute.product => '/',
    ProductRoute.productDetail => '/:id',
    ProductRoute.addProduct => '/add',
    ProductRoute.editProduct => '/edit/:id',
  };

  String get routeName => switch (this) {
    ProductRoute.product => 'Product',
    ProductRoute.productDetail => 'ProductDetail',
    ProductRoute.addProduct => 'AddProduct',
    ProductRoute.editProduct => 'EditProduct',
  };
}
