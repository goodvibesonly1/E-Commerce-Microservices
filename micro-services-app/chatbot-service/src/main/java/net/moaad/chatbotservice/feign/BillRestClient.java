package net.moaad.chatbotservice.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "BILLING-SERVICE")
public interface BillRestClient {
    @GetMapping("/bills")
    String getAllBills();

    @GetMapping("/bills/{id}")
    String getBillById(@PathVariable Long id);
}
