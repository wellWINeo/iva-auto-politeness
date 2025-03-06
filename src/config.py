from dataclasses import dataclass
import json
import random

@dataclass
class Profile:
    chat_id: str
    messages: list[str]

    def pick_message(self) -> str:
        return random.choice(self.messages)

@dataclass
class JitterRange:
    min: int
    max: int

    def randomize_jitter(self) -> int:
        return random.randint(self.min*60, self.max*60)

@dataclass
class Credentials:
    login: str
    password: str


@dataclass
class Config:
    iva_host: str
    credentials: Credentials
    jitter: JitterRange
    profiles: dict[str, Profile]

    @classmethod
    def from_json(cls, json_payload: str) -> "Config":
        data = json.loads(json_payload)

        return cls(
            iva_host=data["iva_host"],
            credentials=Credentials(**data["credentials"]),
            jitter=JitterRange(**data["jitter"]),
            profiles={key: Profile(**value) for key, value in data["profiles"].items()}
        )
    
    @classmethod
    def from_path(cls, path: str) -> "Config":
        with open(path, "r") as f:
            return cls.from_json(f.read())