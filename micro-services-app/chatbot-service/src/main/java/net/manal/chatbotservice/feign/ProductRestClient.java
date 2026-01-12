package net.manal.chatbotservice.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "INVENTORY-SERVICE", url = "http://localhost:8082")
public interface ProductRestClient {
    @GetMapping("/products")
    String getAllProducts();

    @GetMapping("/products/{id}")
    String getProductById(@PathVariable String id);
}
