from ninja import NinjaAPI


api = NinjaAPI()


@api.get("/healthcheck/")
def healthcheck(_):
    return "healthy"
