from flask import Blueprint, request, jsonify, abort
from datetime import date
from flask import current_app
import os
import jwt
from functools import wraps
import logging
from create import session
from models.db_offer import *
from models.db_auth import *
from create import *
from config import *
from setup import *
from security import *


offer = Blueprint("offer", __name__, url_prefix="/api/v1/offer")
"""
api offer
"""
@offer.route("/all_all", methods=["GET"])
@token_required
def get_all_offers(current_user):
    try:
        offers = session.query(Offer).all()
        responce = []
        for offer in offers:
            responce.append({
                "id":offer.id,
                "tool_name": offer.tool_name ,
                "tool_description": offer.tool_description ,
                "location": offer.location ,
                "price": offer.price ,
                "date_start": offer.date_start ,
                "date_finish": offer.date_finish,
                "owner_name": offer.owner_name,
                "phone_number": offer.phone_number
            })
        return responce
    except Exception as e:
        current_app.logger.info("exception: ", e)
        return {"message": "error"}, 500


@offer.route("/save", methods=["POST"])
@token_required
def save_offer(current_user):
    try:
        if not request.json:
            abort(400)
        token = request.headers["Authorization"]
        data = request.json
        user_info = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])["username"]
        user = session.query(User).filter(User.username == user_info).first()
        user_offers = user.offers
        offer = Offer(
            data["tool_name"], data["tool_description"], 
            data["location"], data["price"], data["date_start"],
            data["date_finish"], data["owner_name"], data["phone_number"]
        )
        user_offers.append(offer)
        session.add(offer)
        session.commit()
        return {"status": "success"}
    except Exception as e:
        current_app.logger.info(f"exeption {e}")
        return {"message": "error"}, 500


@offer.route("/all", methods=["GET"])
@token_required
def get_all_user_offers(current_user):
    try:
        token = request.headers["Authorization"]
        user_info = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])["username"]
        user = session.query(User).filter(User.username == user_info).first()
        user_offers = user.offers
        responce  = []
        for offer in user_offers:
            responce.append({
                "id": offer.id,
                "tool_name": offer.tool_name,
                "tool_description": offer.tool_description,
                "location": offer.location,
                "price": offer.price,
                "date_start": offer.date_start,
                "date_finish": offer.date_finish,
                "owner_name": offer.owner_name,
                "phone_number": offer.phone_number
            })
        return {"result": responce}
    except Exception as e:
        current_app.logger.info("%s failed to log in", user.username)
        return {"message": "error"}, 500