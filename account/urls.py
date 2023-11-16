from django.contrib import admin
from django.urls import path
from ninja import NinjaAPI

api = NinjaAPI()


@api.get("/healthcheck/")
def healthcheck(_):
    return "healthy"


urlpatterns = [
    path("api/", api.urls),
    path("admin/", admin.site.urls),
]
