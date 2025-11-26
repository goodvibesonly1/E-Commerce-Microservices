package net.moaad.chatbotservice.service;

import net.moaad.chatbotservice.feign.BillRestClient;
import net.moaad.chatbotservice.feign.CustomerRestClient;
import net.moaad.chatbotservice.feign.ProductRestClient;
import org.springframework.ai.chat.ChatClient;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class RAGService {

    private final ChatClient chatClient;
    private final CustomerRestClient customerRestClient;
    private final ProductRestClient productRestClient;
    private final BillRestClient billRestClient;

    public RAGService(ChatClient chatClient, CustomerRestClient customerRestClient, ProductRestClient productRestClient, BillRestClient billRestClient) {
        this.chatClient = chatClient;
        this.customerRestClient = customerRestClient;
        this.productRestClient = productRestClient;
        this.billRestClient = billRestClient;
    }

    public String generateAnswer(String query) {
        // 1. Retrieve Context (Naive RAG: Fetch all data for now - in production use Vector Store)
        String customers = "Customers: " + customerRestClient.getAllCustomers();
        String products = "Products: " + productRestClient.getAllProducts();
        String bills = "Bills: " + billRestClient.getAllBills();

        String context = customers + "\n" + products + "\n" + bills;

        // 2. Construct Prompt
        String template = """
                You are an intelligent assistant for an E-Commerce system.
                Answer the user's question based ONLY on the following context:
                {context}
                
                Question: {query}
                """;
        
        PromptTemplate promptTemplate = new PromptTemplate(template);
        Prompt prompt = promptTemplate.create(Map.of("context", context, "query", query));

        // 3. Generate Response
        return chatClient.call(prompt).getResult().getOutput().getContent();
    }
}
