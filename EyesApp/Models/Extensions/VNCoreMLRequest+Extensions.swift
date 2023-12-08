//
//  VNCoreMLRequest+Extensions.swift
//  EyesApp
//
//  Created by Leo Ho on 2023/12/9.
//

import Vision

public extension VNCoreMLRequest {
    
    typealias VNRequestResult = (Result<VNRequest, Error>) -> Void
    
    convenience init(model: VNCoreMLModel, finish: @escaping VNRequestResult) {
        self.init(model: model) { request, error in
            if error != nil {
                finish(.failure(error!))
            } else {
                finish(.success(request))
            }
        }
    }
}
