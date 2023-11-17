from re import fullmatch

from django.contrib.auth import get_user_model
from django.contrib.auth.models import User
from ninja import NinjaAPI, ModelSchema
from ninja.errors import ValidationError


class UserSchema(ModelSchema):
    class Config:
        model = User
        model_fields = ['id', 'username', 'first_name', 'last_name']


api = NinjaAPI()
User = get_user_model()
EMAIL_REGEX = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'


@api.get("/healthcheck/")
def healthcheck(request):
    return "healthy"


@api.get("/users/", response=list[UserSchema])
def get_user_list(request):
    return list(User.objects.all())


@api.post("/users/", response=UserSchema)
def create_user(request, email: str):
    if not fullmatch(EMAIL_REGEX, email):
        raise ValidationError("invalid email format")
    return User.objects.create(username=email)
