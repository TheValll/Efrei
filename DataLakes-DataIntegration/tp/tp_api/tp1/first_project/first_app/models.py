from django.db import models
from django.contrib.auth.models import User

class Product(models.Model):
    name = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class UserPermission(models.Model):
    PERMISSION_TYPES = [
        ('read', 'Can Read Products'),
        ('write', 'Can Create/Update Products'),
        ('all', 'Full Access')
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    permission_type = models.CharField(max_length=10, choices=PERMISSION_TYPES, default='read')
    api_key = models.CharField(max_length=64, unique=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.permission_type}"