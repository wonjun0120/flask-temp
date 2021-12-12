"""
template
"""

from flask import Flask, jsonify
from flask_restx import Api
# from flask_sqlalchemy import SQLAlchemy
# from flask_migrate import Migrate
from flask_cors import CORS
import uuid

# db = SQLAlchemy()
# migrate = Migrate()

def create_app(config=None):
    """
    flask 실행 구문, restx, migration 연결
    """
    # pylint: disable=invalid-name
    app = Flask(__name__)
    CORS(app)

    if app.config["ENV"] == 'production':
        app.config.from_object('config.ProductionConfig')
    else:
        app.config.from_object('config.DevelopmentConfig')

    if config is not None:
        app.config.update(config)

    # db.init_app(app)
    # migrate.init_app(app, db)

    api = Api(
        app=app,
        version='0.1',
        title="flask tmp 프로젝트입니다.",
        description="TEST",
        terms_url="/",
        contact="wonjundero@gmail.com",
        license="MIT"
    )

    # from src.controllers.auth import api as auth_ns
    # api.add_namespace(auth_ns, '/auth')

    @app.route('/test', methods=['GET'])
    def test():
        """ test api """
        resp = {
            "msg" : "test success"
        }
        return jsonify(resp)

    @app.route('/ping', methods=['GET'])
    def ping():
        """ Liveness probe """
        resp = {
            "status" : "pass"
        }
        return jsonify(resp)


    @app.route('/health', methods=['GET'])
    def health():
        """ readiness probe """
        resp = {
            "status" : "pass"
        }
        return jsonify(resp)

    return app


# if __name__ == "__main__":
#     app = create_app()
#     app.run(host='0.0.0.0')
uuid.uuid1()
app = create_app()
