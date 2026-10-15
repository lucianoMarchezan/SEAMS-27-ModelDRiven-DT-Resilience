import random

class MessageBroker:
    def __init__(self, env, latency=0.2, loss_probability=0.05, seed=1):
        self.env = env
        self.latency = latency
        self.loss_probability = loss_probability
        self.random = random.Random(seed)
        self.subscribers = {}
        self.log = []
    def subscribe(self, topic, callback):
        self.subscribers.setdefault(topic, []).append(callback)
    def publish(self, topic, payload, source):
        self.log.append({"time": self.env.now, "type": "published", "topic": topic, "source": source, "payload": dict(payload)})
        self.env.process(self._deliver(topic, payload, source))
    def _deliver(self, topic, payload, source):
        yield self.env.timeout(self.latency)
        if self.random.random() < self.loss_probability:
            self.log.append({"time": self.env.now, "type": "lost", "topic": topic, "source": source, "payload": dict(payload)})
            return
        for callback in self.subscribers.get(topic, []):
            callback(dict(payload), source)
        for callback in self.subscribers.get("*", []):
            callback(dict(payload), source)
        self.log.append({"time": self.env.now, "type": "delivered", "topic": topic, "source": source, "payload": dict(payload)})
