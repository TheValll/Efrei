from django.urls import path
from . import views

urlpatterns = [
    path('products/', views.get_products, name='get_products'),
    path('products/most-expensive/', views.get_most_expensive, name='get_most_expensive'),
    path('products/create/', views.add_product, name='add_product'),
    path('products/update/<int:product_id>/', views.update_product, name='update_product'),
]