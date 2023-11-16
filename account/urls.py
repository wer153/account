from django.contrib import admin
from django.urls import path

from account.apis import api


urlpatterns = [
    path("api/", api.urls),
    path("admin/", admin.site.urls),
]
