
from django.db import models


class MyUser(models.Model):
    id = models.AutoField(primary_key=True)
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(null=True, blank=True)
    username = models.CharField(max_length=150, null=True, blank=True)
    email = models.CharField(max_length=255, null=True, blank=True)
    user_role = models.CharField(max_length=255)
    is_active = models.BooleanField()
    is_admin = models.BooleanField()
    last_update = models.DateTimeField()
    date_joined = models.DateTimeField()
    phase_type = models.CharField(max_length=255, null=True, blank=True)
    otp = models.IntegerField(null=True, blank=True)
    otp_created_on = models.DateTimeField(null=True, blank=True)
    guest_to_id = models.IntegerField(null=True, blank=True)  # Keeping raw since not linked
    guest_email = models.CharField(max_length=255, null=True, blank=True)

    class Meta:
        db_table = 'inspects_myuser'
        managed = False

    def __str__(self):
        return self.username or f"User {self.id}"


class InspectionDetails(models.Model):
    inspection_no = models.BigAutoField(primary_key=True)
    created_on = models.DateTimeField(null=True, blank=True)
    modified_by = models.CharField(max_length=255, null=True, blank=True)
    report_path = models.CharField(max_length=500, null=True, blank=True)
    created_by = models.CharField(max_length=255, null=True, blank=True)
    modified_on = models.DateTimeField(null=True, blank=True)
    inspection_officer_id = models.IntegerField(null=True, blank=True)  # Keeping as int
    inspection_title = models.CharField(max_length=500, null=True, blank=True)
    target_date = models.DateField(null=True, blank=True)
    status_flag = models.IntegerField()
    inspection_note_no = models.CharField(max_length=255, null=True, blank=True)
    send_to = models.CharField(max_length=255, null=True, blank=True)
    item_type = models.CharField(max_length=255, null=True, blank=True)
    status = models.CharField(max_length=255, null=True, blank=True)
    insp_last = models.IntegerField(null=True, blank=True)
    inspected_on = models.DateField(null=True, blank=True)
    start_date = models.DateField(null=True, blank=True)
    final_submit_on = models.DateField(null=True, blank=True)
    officer_desig = models.CharField(max_length=255, null=True, blank=True)
    officer_name = models.CharField(max_length=255, null=True, blank=True)
    station_name = models.CharField(max_length=255, null=True, blank=True)
    insp_type = models.IntegerField()
    item_sections = models.IntegerField(null=True, blank=True)
    good_work = models.BooleanField()

    class Meta:
        db_table = 'inspects_inspection_details'
        managed = False

    def __str__(self):
        return f"{self.inspection_note_no} - {self.inspection_title}"


class InspectItemDetails(models.Model):
    item_no = models.BigAutoField(primary_key=True)
    inspection_no = models.ForeignKey(
        InspectionDetails,
        on_delete=models.DO_NOTHING,
        db_column="inspection_no_id",
        related_name="items"
    )
    item_title = models.CharField(max_length=500, null=True, blank=True)
    status = models.CharField(max_length=255, null=True, blank=True)

    class Meta:
        db_table = 'inspects_item_details'
        managed = False

    def __str__(self):
        return self.item_title or f"Item {self.item_no}"


class InspectMarkedOfficer(models.Model):
    marked_no = models.BigAutoField(primary_key=True)
    marked_to_id = models.IntegerField()  # Keeping as int (since points to desig table not defined here)
    item_no = models.ForeignKey(
        InspectItemDetails,
        on_delete=models.DO_NOTHING,
        db_column="item_no_id",
        related_name="marked_officers"
    )
    marked_on = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'inspects_marked_officers'
        managed = False

    def __str__(self):
        return f"Marked {self.marked_no} -> Item {self.item_no_id}"