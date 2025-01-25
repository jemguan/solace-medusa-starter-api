import { Request, Response } from "express"
import type { 
  ICacheService 
} from "@medusajs/types"

export const OPTIONS = {
  requireApiKey: false,
  authenticate: false
}

export const GET = async (
  req: Request,
  res: Response
) => {
  const cacheService = req.scope.resolve<ICacheService>("cacheService");

  try {
    // 测试设置缓存
    await cacheService.set("test-key", "test-value", 30);
    
    // 测试获取缓存
    const value = await cacheService.get("test-key");
    
    return res.json({
      success: true,
      cache_test: {
        key: "test-key",
        value: value,
        connection: "Redis connection successful"
      },
      server_time: new Date().toISOString(),
      environment: process.env.NODE_ENV
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: error.message,
      details: "Redis connection failed",
      server_time: new Date().toISOString(),
      environment: process.env.NODE_ENV
    });
  }
} 