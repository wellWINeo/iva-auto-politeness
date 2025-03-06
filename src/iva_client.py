import uuid
import requests

from config import Credentials


class IvaClient:
    def __init__(self, iva_host: str, credentials: Credentials) -> None:
        self.__host = iva_host
        self.__credentials = credentials

    def send_message(self, chat_id: str, message: str):
        auth_result = self.authenticate()

        if ("loginToken" not in auth_result) or ("sessionId" not in auth_result):
            return

        requests.post(f"{self.__host}/api/rest/chats/{chat_id}/send-message", cookies={
            "userSessionId": auth_result["sessionId"],
            "loginToke": auth_result["loginToken"],
        }, json={
            "clientMessageId": str(uuid.uuid4()),
            "message": message,
        })

    def authenticate(self) -> dict:
        response = requests.post(f"{self.__host}/api/rest/login", json={
            "login": self.__credentials.login,
            "password": self.__credentials.password,
            "rememberMe": False
        })

        response.raise_for_status()

        return response.json()
