/// Auth feature route segments and names. Keeps navigation constants inside the feature.
enum ProductRoute {
  product,
  productDetail,
  addProduct,
  editProduct;

  String get path => switch (this) {
    ProductRoute.product => '/',
    ProductRoute.productDetail => '/product/:id',
    ProductRoute.addProduct => '/product/add',
    ProductRoute.editProduct => '/product/edit/:id',
  };

  String get routeName => switch (this) {
    ProductRoute.product => 'Product',
    ProductRoute.productDetail => 'ProductDetail',
    ProductRoute.addProduct => 'AddProduct',
    ProductRoute.editProduct => 'EditProduct',
  };
}
