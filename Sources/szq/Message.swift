import Foundation
import ZeroMQ

public class Message: @unchecked Sendable{

  var msg: zmq_msg_t

  public init() {
    msg = zmq_msg_t()
    zmq_msg_init(&msg)
  }

  deinit {
      zmq_msg_close(&msg)
  }

  public init(zmq_msg: zmq_msg_t) {
    self.msg = zmq_msg
  }

  public var data: UnsafeMutableRawPointer? {
    return zmq_msg_data(&msg)
  }

  public var size: Int {
    return zmq_msg_size(&msg)
  }

}

public func pack<T: ZmqStreamable>(value: T) -> Message? {
  return Message(zmq_msg: try! T.pack(value: value))
}
public func unpack<T: ZmqStreamable>(message: Message) -> T? {
  return T.unpack(from: &message.msg)
}
