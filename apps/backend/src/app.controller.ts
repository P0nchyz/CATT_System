import { Controller, Get, Param } from '@nestjs/common';
import { AppService } from './app.service.js';

@Controller('hello')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello() {
    return this.appService.getHello();
  }

  @Get(':id')
  getHelloById(@Param('id') id: string) {
    return this.appService.getHelloById(id)
  }
}
