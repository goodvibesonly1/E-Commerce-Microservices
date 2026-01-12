package net.manal.chatbotservice.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient(name = "CUSTOMER-SERVICE", url = "http://localhost:8081/api")
public interface CustomerRestClient {
    @GetMapping("/customers")
    String getAllCustomers(); // Returning String (JSON) for RAG context

    @GetMapping("/customers/{id}")
    String getCustomerById(@PathVariable Long id);
}
