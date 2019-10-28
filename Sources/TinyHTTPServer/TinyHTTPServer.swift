// Copyright 2019 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import NIO
import NIOHTTP1

public typealias TinyHTTPHandler =
  (TinyHTTPServer, HTTPRequestHead) -> (String, HTTPResponseStatus)

public class TinyHTTPServer {
  
  private final class HTTPHandler: ChannelInboundHandler {
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart
    
    private var server : TinyHTTPServer
    private var handler : TinyHTTPHandler
    
    init(server : TinyHTTPServer, handler: @escaping TinyHTTPHandler) {
      self.server = server
      self.handler = handler
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
      switch self.unwrapInboundIn(data) {
      case .head(let request):
        let (response, code) = self.handler(self.server, request)
        // write header of response
        context.writeAndFlush(self.wrapOutboundOut(
          .head(HTTPResponseHead(version: request.version,
                                 status: code,
                                 headers: HTTPHeaders()))),
          promise:nil)
        // write body of response
        var buf = context.channel.allocator.buffer(capacity: response.utf8.count)
        buf.writeString(response)
        context.writeAndFlush(self.wrapOutboundOut(.body(.byteBuffer(buf))), promise: nil)
        // write end of response
        let promise : EventLoopPromise<Void> = context.eventLoop.makePromise()
        promise.futureResult.whenComplete {
          (_: Result<Void, Error>) in context.close(promise: nil) }

        context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: promise)
      default:
        break
      }
    }
  }
  
  var channel : Channel!
  var group : MultiThreadedEventLoopGroup!
  var threadPool : NIOThreadPool!

  public init() {
  }

  public func start(handler: @escaping TinyHTTPHandler) throws {
    let host = "::1"
    let port = 8080
    self.group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    self.threadPool = NIOThreadPool(numberOfThreads: 1)
    threadPool.start()
    let bootstrap = ServerBootstrap(group: group)
      .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
      .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
      .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
      .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
          channel.pipeline.addHandler(HTTPHandler(server: self, handler: handler))
        }
    }

    channel = try bootstrap.bind(host: host, port: port).wait()
    if let localAddress = channel.localAddress {
      print("TinyHTTPServer started and listening on \(localAddress).")
    }
  }
  
  public func stop() {
    MultiThreadedEventLoopGroup.currentEventLoop!.scheduleTask(in: .seconds(0)) {
      _ = self.channel.close()
      print("TinyHTTPServer stopped.")
    }
  }
}
