# from django.urls import path
# from . import views

# urlpatterns = [
#     # Authentication
#     path('login/', views.login_user, name='login'),
    
#     # Field Inspection endpoints
#     path('field-inspections/', views.get_field_inspections, name='get_field_inspections'),
#     path('field-inspections/<int:inspection_no>/', views.get_field_inspection_detail, name='get_field_inspection_detail'),
#     path('field-inspections/<int:inspection_no>/update-status/', views.update_inspection_status, name='update_inspection_status'),
# ]
from django.urls import path
from . import views

urlpatterns = [
    # Authentication
    path('login/', views.login_user, name='login'),
    
    # Field Inspection endpoints
    path('field-inspections/', views.get_field_inspections, name='get_field_inspections'),
    path('field-inspections/<int:inspection_no>/', views.get_field_inspection_detail, name='get_field_inspection_detail'),
    path('field-inspections/<int:inspection_no>/update-status/', views.update_inspection_status, name='update_inspection_status'),

    # ✅ Marked to me inspections
    path('marked-to-me/', views.get_marked_to_me_inspections, name='get_marked_to_me_inspections'),
]