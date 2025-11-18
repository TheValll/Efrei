from django.contrib import admin
from .models import Product, UserPermission

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'price', 'created_at', 'updated_at']
    search_fields = ['name', 'description']
    list_filter = ['created_at', 'updated_at']

@admin.register(UserPermission)
class UserPermissionAdmin(admin.ModelAdmin):
    list_display = ['user', 'permission_type', 'api_key', 'is_active', 'created_at']
    search_fields = ['user__username', 'api_key']
    list_filter = ['permission_type', 'is_active', 'created_at']
