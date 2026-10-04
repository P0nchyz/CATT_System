import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello() {
    return { message: 'Hello World!', status: 200, data: null, timestamp: new Date().toISOString() };
  }

  getHelloById(id: string) {
    return { message: `Hello World with ID: ${id}`, status: 200};
  }
}
