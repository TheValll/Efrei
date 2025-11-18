from django.shortcuts import render, get_object_or_404
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.core.paginator import Paginator
from .models import Product, UserPermission
from django.db.models import Max
from functools import wraps

def require_api_key(permission_required):
    def decorator(view_func):
        @wraps(view_func)
        def wrapped_view(request, *args, **kwargs):
            api_key = request.headers.get('X-API-Key')
            if not api_key:
                return JsonResponse({'error': 'API key is required'}, status=401)
            
            try:
                permission = UserPermission.objects.get(api_key=api_key, is_active=True)
                if permission.permission_type not in ['all', permission_required]:
                    return JsonResponse({'error': 'Insufficient permissions'}, status=403)
            except UserPermission.DoesNotExist:
                return JsonResponse({'error': 'Invalid API key'}, status=401)
            
            return view_func(request, *args, **kwargs)
        return wrapped_view
    return decorator

@require_api_key('read')
def get_products(request):
    page = int(request.GET.get('page', 1))
    products = Product.objects.all().order_by('id')
    paginator = Paginator(products, 3)  # Show 3 products per page
    
    try:
        products_page = paginator.page(page)
    except:
        return JsonResponse({'error': 'Invalid page number'}, status=400)
    
    data = {
        'products': list(products_page.object_list.values()),
        'total_pages': paginator.num_pages,
        'current_page': page,
        'has_next': products_page.has_next(),
        'has_previous': products_page.has_previous()
    }
    return JsonResponse(data)

@require_api_key('read')
def get_most_expensive(request):
    product = Product.objects.order_by('-price').first()
    if product:
        return JsonResponse({'product': {
            'name': product.name,
            'price': str(product.price),
            'description': product.description
        }})
    return JsonResponse({'error': 'No products found'}, status=404)

@csrf_exempt
@require_api_key('write')
def add_product(request):
    if request.method != 'POST':
        return JsonResponse({'error': 'Only POST method is allowed'}, status=405)
    
    try:
        data = json.loads(request.body)
        required_fields = ['name', 'price']
        if not all(field in data for field in required_fields):
            return JsonResponse({'error': 'Missing required fields'}, status=400)
        
        product = Product.objects.create(
            name=data['name'],
            price=data['price'],
            description=data.get('description', '')
        )
        return JsonResponse({
            'message': 'Product created successfully',
            'product': {
                'id': product.id,
                'name': product.name,
                'price': str(product.price),
                'description': product.description
            }
        }, status=201)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

@csrf_exempt
@require_api_key('write')
def update_product(request, product_id):
    if request.method != 'PUT':
        return JsonResponse({'error': 'Only PUT method is allowed'}, status=405)
    
    try:
        product = get_object_or_404(Product, id=product_id)
        data = json.loads(request.body)
        
        # Update fields if they are present in the request
        if 'name' in data:
            product.name = data['name']
        if 'price' in data:
            product.price = data['price']
        if 'description' in data:
            product.description = data['description']
        
        product.save()
        return JsonResponse({
            'message': 'Product updated successfully',
            'product': {
                'id': product.id,
                'name': product.name,
                'price': str(product.price),
                'description': product.description
            }
        })
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    return JsonResponse({'error': 'Only POST method is allowed'}, status=405)