from django.contrib.auth import get_user_model
from django.contrib.auth.models import User
from ninja import NinjaAPI, ModelSchema


class UserSchema(ModelSchema):
    class Config:
        model = User
        model_fields = ['id', 'username', 'first_name', 'last_name']


api = NinjaAPI()
User = get_user_model()


@api.get("/healthcheck/")
def healthcheck(_):
    return "healthy"


@api.get("/users/", response=list[UserSchema])
def get_users(request):
    return list(User.objects.all())
