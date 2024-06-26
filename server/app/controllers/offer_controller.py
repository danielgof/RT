import base64
import os
from werkzeug.utils import secure_filename
from datetime import datetime
from models.db_offer import *
from create import *


def all_offers() -> list:
    """extract all offers from database"""
    offers = session.query(Offer).all()
    responce = []
    for offer in offers:
        responce.append(
            {
                "id": offer.id,
                "tool_name": offer.tool_name,
                "tool_description": offer.tool_description,
                "lat": offer.lat,
                "lng": offer.lng,
                "price": offer.price,
                "date_start": offer.date_start,
                "date_finish": offer.date_finish,
                "owner_name": offer.owner_name,
                "phone_number": offer.phone_number,
                "img": offer.img,
            }
        )
    return responce


def add_offer_to_user(username: str, data: dict) -> None:
    """add new offer to a user"""
    user: User = session.query(User).filter(User.username == username).first()
    user_offers: list = user.offers
    offer = Offer(
        tool_name=data["tool_name"],
        tool_description=data["tool_description"],
        price=data["price"],
        date_start=datetime.strptime(data["date_start"], "%d/%m/%Y"),
        date_finish=datetime.strptime(data["date_finish"], "%d/%m/%Y"),
        lat=data["lat"],
        lng=data["lng"],
        owner_name=data["owner_name"],
        phone_number=data["phone_number"],
        img=data["img"],
    )
    user_offers.append(offer)
    session.add(offer)
    session.commit()


def delete_offer_by_id(data: dict) -> bool:
    """delete user's offer"""
    offer: Offer = session.query(Offer).filter(Offer.id == data["id"]).first()
    # offer: Offer = session.query(Offer).filter(Offer.id == data["id"]).delete()
    if offer:
        session.query(Offer).filter(Offer.id == data["id"]).delete()
        session.commit()
        return True
    else:
        return False


def upd_offer_by_id(data: dict) -> bool:
    """upd offer by its id"""
    offer: Offer = session.query(Offer).filter(Offer.id == data["id"]).first()
    if offer:
        session.query(Offer).filter(Offer.id == data["id"]).update(
            {
                Offer.tool_name: data["tool_name"],
                Offer.tool_description: data["tool_description"],
                Offer.lng: data["lng"],
                Offer.lat: data["lat"],
                Offer.price: data["price"],
                Offer.date_start: datetime.strptime(data["date_start"], "%d/%m/%Y"),
                Offer.date_finish: datetime.strptime(data["date_finish"], "%d/%m/%Y"),
                Offer.owner_name: data["owner_name"],
                Offer.phone_number: data["phone_number"],
            },
            synchronize_session=False,
        )
        session.commit()
        return True
    else:
        return False


def all_offers_user(user_info: dict) -> list:
    """get all offers for particular user"""
    user = session.query(User).filter(User.username == user_info).first()
    user_offers = user.offers
    responce = []
    for offer in user_offers:
        responce.append(
            {
                "id": offer.id,
                "tool_name": offer.tool_name,
                "tool_description": offer.tool_description,
                "lat": offer.lat,
                "lng": offer.lng,
                "price": offer.price,
                "date_start": offer.date_start,
                "date_finish": offer.date_finish,
                "owner_name": offer.owner_name,
                "phone_number": offer.phone_number,
                "img": offer.img,
            }
        )
    return responce


def offers_by_query(query: str) -> list:
    """searches offers by give @code{query}"""
    offers: list = list()
    res: list = list()
    offers = session.query(Offer).filter(
        Offer.tool_name.like(f"%{query}%")).all()
    for offer in offers:
        res.append(
            {
                "id": offer.id,
                "tool_name": offer.tool_name,
                "tool_description": offer.tool_description,
                "lat": offer.lat,
                "lng": offer.lng,
                "price": offer.price,
                "date_start": offer.date_start,
                "date_finish": offer.date_finish,
                "owner_name": offer.owner_name,
                "phone_number": offer.phone_number,
                "img": offer.img,
            }
        )
    return res
