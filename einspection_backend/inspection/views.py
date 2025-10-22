

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import check_password
from .models import MyUser, InspectionDetails
from .models import InspectionDetails, InspectMarkedOfficer, InspectItemDetails

import json


@api_view(['POST'])
def login_user(request):
    """
    Login endpoint with proper hashed password checking
    """
    try:
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')

        if not username or not password:
            return Response({
                'success': False,
                'message': 'Username and password are required'
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = MyUser.objects.get(username=username)
            
            # Check hashed password using Django's check_password
            if check_password(password, user.password):
                return Response({
                    'success': True,
                    'message': 'Login successful',
                    'user': {
                        'id': user.id,
                        'username': user.username,
                        'email': user.email,
                        'user_role': user.user_role,
                        'is_active': user.is_active
                    }
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    'success': False,
                    'message': 'Invalid credentials'
                }, status=status.HTTP_401_UNAUTHORIZED)

        except MyUser.DoesNotExist:
            return Response({
                'success': False,
                'message': 'User not found'
            }, status=status.HTTP_404_NOT_FOUND)

    except json.JSONDecodeError:
        return Response({
            'success': False,
            'message': 'Invalid JSON format'
        }, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({
            'success': False,
            'message': f'Server error: {str(e)}'
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
def get_field_inspections(request):
    """
    Get field inspections for the logged-in user with enhanced filtering
    """
    try:
        user_id = request.GET.get('user_id')
        status_category = request.GET.get('status_category', None)
        status_flag_filter = request.GET.get('status_flag', None)
        item_type_filter = request.GET.get('item_type', None)
        insp_type_filter = request.GET.get('insp_type', None)
        
        if not user_id:
            return Response({
                'success': False,
                'message': 'user_id is required'
            }, status=status.HTTP_400_BAD_REQUEST)

        # Verify user exists
        try:
            user = MyUser.objects.get(id=user_id)
        except MyUser.DoesNotExist:
            return Response({
                'success': False,
                'message': 'User not found'
            }, status=status.HTTP_404_NOT_FOUND)

        # Base query
        inspections_query = InspectionDetails.objects.filter(inspection_officer_id=user_id)
        
        # Apply status category filter
        if status_category:
            status_mapping = {
                'draft': [0],
                'pending': [1],
                'partly_complied': [2],
                'complied': [4],
                'rejected': []
            }
            
            if status_category in status_mapping:
                if status_category == 'rejected':
                    inspections_query = inspections_query.filter(status='R')
                else:
                    inspections_query = inspections_query.filter(status_flag__in=status_mapping[status_category])
        
        # Apply specific status_flag filter
        if status_flag_filter is not None:
            try:
                status_flag_value = int(status_flag_filter)
                inspections_query = inspections_query.filter(status_flag=status_flag_value)
            except ValueError:
                return Response({'success': False, 'message': 'status_flag must be a valid integer'},
                                status=status.HTTP_400_BAD_REQUEST)

        # Apply item_type filter
        if item_type_filter is not None:
            try:
                item_type_value = int(item_type_filter)
                inspections_query = inspections_query.filter(item_type=item_type_value)
            except ValueError:
                return Response({'success': False, 'message': 'item_type must be a valid integer'},
                                status=status.HTTP_400_BAD_REQUEST)

        # Apply insp_type filter
        if insp_type_filter is not None:
            try:
                insp_type_value = int(insp_type_filter)
                inspections_query = inspections_query.filter(insp_type=insp_type_value)
            except ValueError:
                return Response({'success': False, 'message': 'insp_type must be a valid integer'},
                                status=status.HTTP_400_BAD_REQUEST)

        inspections = inspections_query.order_by('-created_on')

        # Response formatting
        inspection_data = []
        for inspection in inspections:
            inspection_data.append({
                'inspection_no': inspection.inspection_no,
                'start_date': inspection.start_date.isoformat() if inspection.start_date else None,
                'inspection_note_no': inspection.inspection_note_no,
                'inspection_title': inspection.inspection_title,
                'status': inspection.status,
                'status_flag': inspection.status_flag,
                'status_category': get_status_category_readable(inspection.status_flag, inspection.status),
                'officer_name': inspection.officer_name,
                'station_name': inspection.station_name,
                'target_date': inspection.target_date.isoformat() if inspection.target_date else None,
                'created_on': inspection.created_on.isoformat() if inspection.created_on else None,
                'item_type': inspection.item_type,
                'item_type_readable': get_item_type_readable(inspection.item_type),
                'insp_type': inspection.insp_type,
                'insp_type_readable': get_insp_type_readable(inspection.insp_type),
                'final_submit_on': inspection.final_submit_on.isoformat() if inspection.final_submit_on else None,
                'inspected_on': inspection.inspected_on.isoformat() if inspection.inspected_on else None
            })

        status_counts = get_status_counts(user_id)

        return Response({
            'success': True,
            'message': f'Field inspections retrieved successfully',
            'data': {
                'user_info': {
                    'id': user.id,
                    'username': user.username,
                    'user_role': user.user_role
                },
                'filters_applied': {
                    'status_category': status_category,
                    'status_flag': status_flag_filter,
                    'item_type': item_type_filter,
                    'insp_type': insp_type_filter
                },
                'status_counts': status_counts,
                'total_count': len(inspection_data),
                'inspections': inspection_data
            }
        }, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({'success': False, 'message': f'Server error: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
def get_field_inspection_detail(request, inspection_no):
    """
    Get detailed information about a specific field inspection
    """
    try:
        user_id = request.GET.get('user_id')
        
        if not user_id:
            return Response({'success': False, 'message': 'user_id is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            inspection = InspectionDetails.objects.get(
                inspection_no=inspection_no, 
                inspection_officer_id=user_id
            )
        except InspectionDetails.DoesNotExist:
            return Response({'success': False, 'message': 'Inspection not found or you do not have access to it'},
                            status=status.HTTP_404_NOT_FOUND)

        inspection_detail = {
            'inspection_no': inspection.inspection_no,
            'start_date': inspection.start_date.isoformat() if inspection.start_date else None,
            'inspection_note_no': inspection.inspection_note_no,
            'inspection_title': inspection.inspection_title,
            'status': inspection.status,
            'status_flag': inspection.status_flag,
            'status_category': get_status_category_readable(inspection.status_flag, inspection.status),
            'inspection_officer_id': inspection.inspection_officer_id,
            'officer_name': inspection.officer_name,
            'officer_desig': inspection.officer_desig,
            'station_name': inspection.station_name,
            'target_date': inspection.target_date.isoformat() if inspection.target_date else None,
            'inspected_on': inspection.inspected_on.isoformat() if inspection.inspected_on else None,
            'created_on': inspection.created_on.isoformat() if inspection.created_on else None,
            'modified_on': inspection.modified_on.isoformat() if inspection.modified_on else None,
            'final_submit_on': inspection.final_submit_on.isoformat() if inspection.final_submit_on else None,
            'item_type': inspection.item_type,
            'item_type_readable': get_item_type_readable(inspection.item_type),
            'insp_type': inspection.insp_type,
            'insp_type_readable': get_insp_type_readable(inspection.insp_type),
            'send_to': inspection.send_to,
            'report_path': inspection.report_path,
            'item_sections': inspection.item_sections,
            'good_work': inspection.good_work
        }

        return Response({'success': True, 'message': 'Inspection details retrieved successfully', 'data': inspection_detail},
                        status=status.HTTP_200_OK)

    except Exception as e:
        return Response({'success': False, 'message': f'Server error: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def update_inspection_status(request, inspection_no):
    """
    Update the status and status_flag of a field inspection
    """
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        new_status = data.get('status')
        new_status_flag = data.get('status_flag')
        
        valid_statuses = ['pending', 'complied', 'rejected', 'reverted', 'forwarded', 'R']
        valid_status_flags = [0, 1, 2, 3, 4]
        
        if not user_id:
            return Response({'success': False, 'message': 'user_id is required'}, status=status.HTTP_400_BAD_REQUEST)

        if new_status and new_status not in valid_statuses:
            return Response({'success': False, 'message': f'Invalid status. Must be one of: {", ".join(valid_statuses)}'},
                            status=status.HTTP_400_BAD_REQUEST)

        if new_status_flag is not None and new_status_flag not in valid_status_flags:
            return Response({'success': False, 'message': f'Invalid status_flag. Must be one of: {", ".join(map(str, valid_status_flags))}'},
                            status=status.HTTP_400_BAD_REQUEST)

        try:
            inspection = InspectionDetails.objects.get(
                inspection_no=inspection_no, 
                inspection_officer_id=user_id
            )
            
            old_status = inspection.status
            old_status_flag = inspection.status_flag
            
            if new_status:
                inspection.status = new_status
            if new_status_flag is not None:
                inspection.status_flag = new_status_flag
                
            inspection.save()
            
            return Response({
                'success': True,
                'message': f'Inspection updated successfully',
                'data': {
                    'inspection_no': inspection.inspection_no,
                    'inspection_note_no': inspection.inspection_note_no,
                    'old_status': old_status,
                    'new_status': inspection.status,
                    'old_status_flag': old_status_flag,
                    'new_status_flag': inspection.status_flag,
                    'status_category': get_status_category_readable(inspection.status_flag, inspection.status)
                }
            }, status=status.HTTP_200_OK)
            
        except InspectionDetails.DoesNotExist:
            return Response({'success': False, 'message': 'Inspection not found or you do not have access to it'},
                            status=status.HTTP_404_NOT_FOUND)

    except json.JSONDecodeError:
        return Response({'success': False, 'message': 'Invalid JSON format'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'success': False, 'message': f'Server error: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


def get_status_category_readable(status_flag, status_field):
    if status_field == 'R':
        return 'rejected'
    
    status_mapping = {
        0: 'draft',
        1: 'pending',
        2: 'partly_complied',
        3: 'unknown',
        4: 'complied'
    }
    
    return status_mapping.get(status_flag, 'unknown')


def get_item_type_readable(item_type):
    item_type_mapping = {
        0: 'others',
        1: 'passenger_safety',
        2: 'employee_safety'
    }
    return item_type_mapping.get(item_type, 'unknown')


def get_insp_type_readable(insp_type):
    insp_type_mapping = {
        0: 'regular',
        1: 'drive',
        2: 'night',
        3: 'surprise'
    }
    return insp_type_mapping.get(insp_type, 'unknown')


def get_status_counts(user_id):
    try:
        from django.db.models import Count, Q
        
        counts = InspectionDetails.objects.filter(inspection_officer_id=user_id).aggregate(
            draft_count=Count('id', filter=Q(status_flag=0)),
            pending_count=Count('id', filter=Q(status_flag=1)),
            partly_complied_count=Count('id', filter=Q(status_flag=2)),
            complied_count=Count('id', filter=Q(status_flag=4)),
            rejected_count=Count('id', filter=Q(status='R')),
            total_count=Count('id')
        )
        
        return counts
    except Exception:
        return {
            'draft_count': 0,
            'pending_count': 0,
            'partly_complied_count': 0,
            'complied_count': 0,
            'rejected_count': 0,
            'total_count': 0
        }




# # ✅ NEW FUNCTION (replaces the old one)



@api_view(['GET'])
def get_marked_to_me_inspections(request):
    try:
        # ✅ Step 1: Validate user_id
        user_id = request.GET.get('user_id')
        if not user_id:
            return Response({'success': False, 'message': 'user_id is required'}, status=400)

        # ✅ Step 2: Get logged-in user
        try:
            user = MyUser.objects.get(id=user_id)
        except MyUser.DoesNotExist:
            return Response({'success': False, 'message': 'User not found'}, status=404)

        # ✅ Step 3: Use user.id (not user_role text) to match marked_to_id
        marked_records = InspectMarkedOfficer.objects.filter(marked_to_id=user.id)
        if not marked_records.exists():
            return Response({'success': True, 'total_count': 0, 'inspections': []}, status=200)

        inspections_data = []

        # ✅ Step 4: Loop through records and fetch all info
        for mo in marked_records:
            try:
                item = InspectItemDetails.objects.get(item_no=mo.item_no_id)
                inspection = InspectionDetails.objects.get(inspection_no=item.inspection_no_id)
            except (InspectItemDetails.DoesNotExist, InspectionDetails.DoesNotExist):
                continue  # Skip broken references

            inspections_data.append({
                # 🔹 Inspection details
                'inspection_no': inspection.inspection_no,
                'inspection_note_no': inspection.inspection_note_no,
                'inspection_title': inspection.inspection_title,
                'created_on': inspection.created_on,
                'modified_on': inspection.modified_on,
                'created_by': inspection.created_by,
                'modified_by': inspection.modified_by,
                'inspection_officer_id': inspection.inspection_officer_id,
                'officer_name': inspection.officer_name,
                'officer_desig': inspection.officer_desig,
                'station_name': inspection.station_name,
                'target_date': inspection.target_date,
                'status_flag': inspection.status_flag,
                'status': inspection.status,
                'final_submit_on': inspection.final_submit_on,
                'inspected_on': inspection.inspected_on,

                # 🔹 Item details
                'item_no': item.item_no,
                'item_title': item.item_title,
                'item_status': item.status,

                # 🔹 Marked officer details
                'marked_no': mo.marked_no,
                'marked_to_id': mo.marked_to_id,
                'marked_on': mo.marked_on,
            })

        # ✅ Step 5: Group by status_category if filter provided
        status_category = request.GET.get('status_category', 'all').lower()
        category_map = {
            'draft': 0,
            'pending': 1,
            'partially_completed': 2,
            'complied': 3,
            'rejected': 4,
        }

        if status_category in category_map:
            inspections_data = [i for i in inspections_data if i['status_flag'] == category_map[status_category]]

        return Response({
            'success': True,
            'total_count': len(inspections_data),
            'status_category': status_category,
            'inspections': inspections_data
        }, status=200)

    except Exception as e:
        return Response({'success': False, 'message': f'Server error: {str(e)}'}, status=500)

   